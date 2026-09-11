#!/bin/bash
# Hook: Context Watch -- UserPromptSubmit
# Two jobs, both quiet by default:
# 1. External change detection -- another session saved this walnut's
#    state files; tell the model to re-read before relying on them.
# 2. Cross-session awareness -- another active session has unsaved stash
#    (detailed when it's on the same walnut, a one-line count otherwise).
#
# Walnut resolution reads .alive/_index.json (name -> path) and caches
# the answer per session; a pruned find is the fallback for walnuts
# created since the index was generated. The previous implementation
# walked the whole world with find on every prompt -- measured ~14s on a
# 46GB world against the 5s hook timeout (issue #87).
#
# This hook injects no context percentages and no repeated rules (#86).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/alive-common.sh"

read_hook_input

# fn-15-la5.6: bridge fan-out -- helper is the SOLE emitter on the
# no-world-found path. find_world_or_warn emits hook-shaped JSON on
# stdout (or {} when the SessionStart sentinel is already taken /
# event isn't message-bearing) and returns 1 in-bash so we exit 0
# cleanly without printing JSON ourselves.
# // TODO(world-resolution-contract-v2): swap to find_world_or_die in cutover release
if ! find_world_or_warn "${HOOK_EVENT:-UserPromptSubmit}"; then
  exit 0
fi

SESSION_ID="${HOOK_SESSION_ID}"
[ -z "$SESSION_ID" ] && exit 0

# Sanitized session id for tmp paths -- a malformed or forged session id
# must not escape into a different tmp path (same guard as
# _alive_session_sentinel_dir).
SAFE_SID="${SESSION_ID//[^A-Za-z0-9._-]/_}"
LASTCHECK="${TMPDIR:-/tmp}/alive-lastcheck-${SAFE_SID}"
DIRCACHE="${TMPDIR:-/tmp}/alive-walnutdir-${SAFE_SID}"
SQUIRRELSTAMP="${TMPDIR:-/tmp}/alive-squirrelstamp-${SAFE_SID}"

# File mtime as epoch seconds. Probes GNU stat by output validity, not
# by --version -- BusyBox accepts --version but parses -f as filesystem
# mode, and a failed command substitution must replace, never append.
get_mtime() {
  local m
  m=$(stat -c %Y "$1" 2>/dev/null)
  case "$m" in ''|*[!0-9]*) m=$(stat -f %m "$1" 2>/dev/null) ;; esac
  case "$m" in ''|*[!0-9]*) m=0 ;; esac
  printf '%s' "$m"
}

# -- WALNUT RESOLUTION --

SQUIRRELS_DIR="$WORLD_ROOT/.alive/_squirrels"
ENTRY="$SQUIRRELS_DIR/$SESSION_ID.yaml"
[ ! -f "$ENTRY" ] && exit 0

# First matching line only; strip CR and surrounding quotes. Session
# records in the wild carry bare names, quoted names, and full paths.
WALNUT=$(grep '^walnut:' "$ENTRY" 2>/dev/null | head -1 \
  | sed -e 's/^walnut:[[:space:]]*//' -e 's/\r$//' \
        -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
[ -z "${WALNUT:-}" ] || [ "$WALNUT" = "null" ] && exit 0

# Resolve to a path relative to the world root: session cache, then the
# world index, then a direct path check, then pruned find as last resort.
WALNUT_REL=""
if [ -f "$DIRCACHE" ]; then
  WALNUT_REL=$(head -1 "$DIRCACHE" 2>/dev/null)
  [ -n "$WALNUT_REL" ] && [ ! -d "$WORLD_ROOT/$WALNUT_REL" ] && WALNUT_REL=""
fi

if [ -z "$WALNUT_REL" ]; then
  INDEX_JSON="$WORLD_ROOT/.alive/_index.json"
  if [ -f "$INDEX_JSON" ]; then
    if [ "$ALIVE_JSON_RT" = "python3" ]; then
      WALNUT_REL=$(ALIVE_WALNUT="$WALNUT" ALIVE_INDEX="$INDEX_JSON" python3 -c '
import json, os
val = os.environ["ALIVE_WALNUT"].strip().strip("/")
try:
    d = json.load(open(os.environ["ALIVE_INDEX"], encoding="utf-8"))
except Exception:
    raise SystemExit
entries = []
for key in ("walnuts", "people"):
    v = d.get(key) or {}
    entries += list(v.values()) if isinstance(v, dict) else list(v)
best = ""
for e in entries:
    if not isinstance(e, dict):
        continue
    path = (e.get("path") or "").strip().strip("/")
    if not path:
        continue
    name = e.get("name") or path.rsplit("/", 1)[-1]
    if val != path and val != name and not path.endswith("/" + val):
        continue
    if not path.startswith("01_Archive"):
        best = path
        break
    if not best:
        best = path
print(best)
' 2>/dev/null)
    elif [ "$ALIVE_JSON_RT" = "node" ]; then
      WALNUT_REL=$(ALIVE_WALNUT="$WALNUT" ALIVE_INDEX="$INDEX_JSON" node -e '
const fs = require("fs");
const val = process.env.ALIVE_WALNUT.trim().replace(/^\/+|\/+$/g, "");
let d;
try { d = JSON.parse(fs.readFileSync(process.env.ALIVE_INDEX, "utf8")); }
catch (e) { process.exit(0); }
let entries = [];
for (const key of ["walnuts", "people"]) {
  const v = d[key] || {};
  entries = entries.concat(Array.isArray(v) ? v : Object.values(v));
}
let best = "";
for (const e of entries) {
  if (!e || typeof e !== "object") continue;
  const path = String(e.path || "").replace(/^\/+|\/+$/g, "");
  if (!path) continue;
  const name = e.name || path.split("/").pop();
  if (val !== path && val !== name && !path.endsWith("/" + val)) continue;
  if (!path.startsWith("01_Archive")) { best = path; break; }
  if (!best) best = path;
}
console.log(best);
' 2>/dev/null)
    fi
  fi
fi

if [ -z "$WALNUT_REL" ] && [ -d "$WORLD_ROOT/$WALNUT" ]; then
  WALNUT_REL="$WALNUT"
fi

if [ -z "$WALNUT_REL" ]; then
  BASENAME="${WALNUT##*/}"
  FOUND=$(find "$WORLD_ROOT" -maxdepth 6 \
    \( -name "01_Archive" -o -name ".alive-migrate-backup" -o -name "*-backup" \
       -o -name "node_modules" -o -name ".git" -o -name ".worktrees" \) -prune -o \
    -type d -name "$BASENAME" -print -quit 2>/dev/null)
  [ -n "$FOUND" ] && WALNUT_REL="${FOUND#"$WORLD_ROOT"/}"
fi

[ -z "$WALNUT_REL" ] && exit 0
printf '%s\n' "$WALNUT_REL" > "$DIRCACHE" 2>/dev/null || true

WALNUT_DIR="$WORLD_ROOT/$WALNUT_REL"
if [ -d "$WALNUT_DIR/_kernel" ]; then
  WALNUT_KERNEL="$WALNUT_DIR/_kernel"
else
  WALNUT_KERNEL="$WALNUT_DIR"
fi

MESSAGES=""

# -- EXTERNAL CHANGE DETECTION --

if [ ! -f "$LASTCHECK" ]; then
  date +%s > "$LASTCHECK"
else
  LAST_CHECK_TIME=$(head -1 "$LASTCHECK" 2>/dev/null)
  case "$LAST_CHECK_TIME" in ''|*[!0-9]*) LAST_CHECK_TIME=0 ;; esac

  # Stamp scan start minus one BEFORE scanning: a save landing while we
  # scan is caught next prompt instead of lost (worst case one repeated
  # notice, absorbed by the self-attribution check below).
  SCAN_START=$(date +%s)

  CHANGED=""
  for file in "$WALNUT_KERNEL/now.json" "$WALNUT_KERNEL/_generated/now.json" \
              "$WALNUT_KERNEL/tasks.json" "$WALNUT_KERNEL/now.md" \
              "$WALNUT_KERNEL/log.md" "$WALNUT_KERNEL/tasks.md"; do
    if [ -f "$file" ]; then
      MTIME=$(get_mtime "$file")
      if [ "$MTIME" -gt "$LAST_CHECK_TIME" ] 2>/dev/null; then
        CHANGED="${CHANGED} $(basename "$file")"
      fi
    fi
  done

  echo $((SCAN_START - 1)) > "$LASTCHECK"

  if [ -n "${CHANGED:-}" ]; then
    # Skip if the change was made by US (session id in now.json's
    # squirrel field; short 8-char ids and full UUIDs both occur).
    LAST_SQUIRREL=""
    NOW_JSON_PATH=""
    if [ -f "$WALNUT_KERNEL/now.json" ]; then
      NOW_JSON_PATH="$WALNUT_KERNEL/now.json"
    elif [ -f "$WALNUT_KERNEL/_generated/now.json" ]; then
      NOW_JSON_PATH="$WALNUT_KERNEL/_generated/now.json"
    fi
    if [ -n "$NOW_JSON_PATH" ]; then
      if [ "$ALIVE_JSON_RT" = "python3" ]; then
        LAST_SQUIRREL=$(ALIVE_NOW="$NOW_JSON_PATH" python3 -c 'import json, os; print(json.load(open(os.environ["ALIVE_NOW"], encoding="utf-8")).get("squirrel", ""))' 2>/dev/null)
      elif [ "$ALIVE_JSON_RT" = "node" ]; then
        LAST_SQUIRREL=$(ALIVE_NOW="$NOW_JSON_PATH" node -e 'try{const d=JSON.parse(require("fs").readFileSync(process.env.ALIVE_NOW,"utf8"));console.log(d.squirrel||"")}catch(e){console.log("")}' 2>/dev/null)
      fi
    elif [ -f "$WALNUT_KERNEL/now.md" ]; then
      LAST_SQUIRREL=$(grep '^squirrel:' "$WALNUT_KERNEL/now.md" 2>/dev/null | head -1 | sed 's/squirrel: *//' | tr -d '[:space:]')
    fi
    SHORT_SID="${SESSION_ID:0:8}"
    if [ "${LAST_SQUIRREL:-}" != "$SESSION_ID" ] && [ "${LAST_SQUIRREL:-}" != "$SHORT_SID" ]; then
      MESSAGES="Another session just saved to ${WALNUT_REL}. Changed:${CHANGED}. Re-read those files in the walnut's kernel directory before relying on this walnut's state -- your loaded context may be stale."
    fi
  fi
fi

# -- CROSS-SESSION AWARENESS (issue #88) --
# Only rescan when a session record actually changed since our stamp;
# find -newer against the stamp file makes the idle path a single stat.

SQUIRREL_SCAN=""
if [ ! -f "$SQUIRRELSTAMP" ]; then
  SQUIRREL_SCAN="1"
elif find "$SQUIRRELS_DIR" -name '*.yaml' -newer "$SQUIRRELSTAMP" -print -quit 2>/dev/null | grep -q .; then
  SQUIRREL_SCAN="1"
fi

if [ -n "$SQUIRREL_SCAN" ]; then
  touch "$SQUIRRELSTAMP" 2>/dev/null || true
  ACTIVE_NOTE=""
  if [ "$ALIVE_JSON_RT" = "python3" ]; then
    ACTIVE_NOTE=$(ALIVE_SID="$SESSION_ID" ALIVE_SQ_DIR="$SQUIRRELS_DIR" ALIVE_W_PATH="$WALNUT_REL" python3 -c '
import glob, os, re
sid = os.environ["ALIVE_SID"]
wpath = os.environ["ALIVE_W_PATH"].strip("/")
wbase = wpath.rsplit("/", 1)[-1]
same, others = [], set()
for f in glob.glob(os.path.join(os.environ["ALIVE_SQ_DIR"], "*.yaml")):
    if os.path.basename(f)[:-5] == sid:
        continue
    try:
        c = open(f, encoding="utf-8", errors="replace").read()
    except Exception:
        continue
    if "ended: null" not in c:
        continue
    m = re.search(r"^saves:\s*(\d+)", c, re.M)
    if m and int(m.group(1)) > 0:
        continue
    wm = re.search(r"^walnut:\s*(.+)", c, re.M)
    w = wm.group(1).strip().strip("\"" + chr(39)) if wm else ""
    if not w or w == "null":
        continue
    wb = w.strip("/").rsplit("/", 1)[-1]
    items = re.findall(r"^\s*(?:-\s*)?content:\s*\"?(.+?)\"?\s*$", c, re.M)
    if wb == wbase or w.strip("/") == wpath:
        if items:
            same.append("Another active session on this walnut has unsaved stash: " + "; ".join(items[:3]))
    else:
        others.add(wb)
out = list(same)
if others:
    out.append("Other active sessions with unsaved work: " + ", ".join(sorted(others)[:5]) + ".")
print("\n".join(out))
' 2>/dev/null)
  elif [ "$ALIVE_JSON_RT" = "node" ]; then
    ACTIVE_NOTE=$(ALIVE_SID="$SESSION_ID" ALIVE_SQ_DIR="$SQUIRRELS_DIR" ALIVE_W_PATH="$WALNUT_REL" node -e '
const fs = require("fs"), path = require("path");
const sid = process.env.ALIVE_SID;
const wpath = process.env.ALIVE_W_PATH.replace(/^\/+|\/+$/g, "");
const wbase = wpath.split("/").pop();
const dir = process.env.ALIVE_SQ_DIR;
const same = [], others = new Set();
let files = [];
try { files = fs.readdirSync(dir).filter(f => f.endsWith(".yaml")); } catch (e) { process.exit(0); }
for (const f of files) {
  if (path.basename(f, ".yaml") === sid) continue;
  let c;
  try { c = fs.readFileSync(path.join(dir, f), "utf8"); } catch (e) { continue; }
  if (!c.includes("ended: null")) continue;
  const sm = c.match(/^saves:\s*(\d+)/m);
  if (sm && parseInt(sm[1], 10) > 0) continue;
  const wm = c.match(/^walnut:\s*(.+)/m);
  let w = wm ? wm[1].trim().replace(/^["\x27]|["\x27]$/g, "") : "";
  if (!w || w === "null") continue;
  const wb = w.replace(/^\/+|\/+$/g, "").split("/").pop();
  const items = [...c.matchAll(/^\s*(?:-\s*)?content:\s*"?(.+?)"?\s*$/gm)].map(m => m[1]).slice(0, 3);
  if (wb === wbase || w.replace(/^\/+|\/+$/g, "") === wpath) {
    if (items.length) same.push("Another active session on this walnut has unsaved stash: " + items.join("; "));
  } else {
    others.add(wb);
  }
}
const out = same.slice();
if (others.size) out.push("Other active sessions with unsaved work: " + [...others].sort().slice(0, 5).join(", ") + ".");
console.log(out.join("\n"));
' 2>/dev/null)
  fi
  if [ -n "$ACTIVE_NOTE" ]; then
    if [ -n "$MESSAGES" ]; then
      MESSAGES="${MESSAGES}

${ACTIVE_NOTE}"
    else
      MESSAGES="$ACTIVE_NOTE"
    fi
  fi
fi

[ -z "$MESSAGES" ] && exit 0

# Full JSON string encoding (handles control bytes, unlike the small-
# string escape path).
MESSAGES_JSON=$(alive_json_encode_string "$MESSAGES")
[ -z "$MESSAGES_JSON" ] && exit 0
cat <<CHANGEEOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": ${MESSAGES_JSON}
  }
}
CHANGEEOF
exit 0
