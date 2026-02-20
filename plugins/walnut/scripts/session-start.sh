#!/bin/bash
# Walnut 0.1 — Session Start
# Detects World, sets Squirrel ID, creates .yaml entry, detects system version.
# Input: JSON on stdin { "session_id": "...", "cwd": "..." }
# Output: Context string injected into session

set -euo pipefail

input=$(cat)
SESSION_ID=$(echo "$input" | jq -r '.session_id // empty')
CWD=$(echo "$input" | jq -r '.cwd // empty')

if [ -z "$SESSION_ID" ]; then
  SESSION_ID=$(uuidgen 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "unknown-$(date +%s)")
fi

SQUIRREL_SHORT="${SESSION_ID:0:8}"
ALIVE_ROOT="${CWD:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"

# ── Detect ALIVE World ──────────────────────────────────
find_world() {
  local dir="$1"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/02_Life" ] && [ -d "$dir/04_Ventures" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

WORLD_ROOT=$(find_world "$ALIVE_ROOT" 2>/dev/null || echo "")

if [ -z "$WORLD_ROOT" ]; then
  echo "No ALIVE World detected. Run walnut:world to set one up."
  exit 0
fi

# ── Persist Squirrel ID ─────────────────────────────────
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export ALIVE_SQUIRREL_ID=\"$SESSION_ID\"" >> "$CLAUDE_ENV_FILE"
  echo "export ALIVE_ROOT=\"$WORLD_ROOT\"" >> "$CLAUDE_ENV_FILE"
fi

# ── Detect system version ───────────────────────────────
# Fast path: read from world key.md if it exists
# Fallback: scan rules files to determine version

SYSTEM_VERSION="unknown"
MIGRATION_REMAINING=0

# Fast path — world key.md has system.version
if [ -f "$WORLD_ROOT/key.md" ]; then
  KEY_VERSION=$(grep "version:" "$WORLD_ROOT/key.md" 2>/dev/null | head -1 | sed 's/.*version: *//')
  if [ -n "$KEY_VERSION" ]; then
    SYSTEM_VERSION="v1"
    MIGRATION_REMAINING=$(grep "remaining:" "$WORLD_ROOT/key.md" 2>/dev/null | head -1 | sed 's/.*remaining: *//')
    MIGRATION_REMAINING="${MIGRATION_REMAINING:-0}"
  fi
fi

# Fallback — scan rules files
if [ "$SYSTEM_VERSION" = "unknown" ]; then
  if [ -f "$WORLD_ROOT/.claude/rules/squirrels.md" ] && [ -f "$WORLD_ROOT/.claude/rules/world.md" ]; then
    SYSTEM_VERSION="v1"
  elif [ -f "$WORLD_ROOT/.claude/rules/system.md" ]; then
    SYSTEM_VERSION="v4"
  elif [ -f "$WORLD_ROOT/.claude/rules/behaviors.md" ] || [ -f "$WORLD_ROOT/.claude/rules/conventions.md" ]; then
    SYSTEM_VERSION="v3"
  elif [ ! -f "$WORLD_ROOT/.claude/CLAUDE.md" ]; then
    SYSTEM_VERSION="fresh"
  else
    SYSTEM_VERSION="v3"
  fi
fi

# ── Detect model ────────────────────────────────────────
MODEL="${CLAUDE_MODEL:-unknown}"

# ── Read preferences ────────────────────────────────────
PREFS_FILE="$WORLD_ROOT/.claude/preferences.yaml"
PREFS_OUTPUT=""
if [ -f "$PREFS_FILE" ]; then
  # Read non-comment, non-empty lines as preference overrides
  while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$line" ]] && continue
    PREFS_OUTPUT="${PREFS_OUTPUT}  ${line}\n"
  done < "$PREFS_FILE"
fi

# ── Detect rule staleness ──────────────────────────────
RULES_STALE=""
PLUGIN_RULES="${CLAUDE_PLUGIN_ROOT:-}/rules"
PROJECT_RULES="$WORLD_ROOT/.claude/rules"

if [ -d "$PLUGIN_RULES" ] && [ -d "$PROJECT_RULES" ]; then
  for rulefile in squirrels.md world.md worldbuilder.md; do
    if [ -f "$PLUGIN_RULES/$rulefile" ]; then
      if [ ! -f "$PROJECT_RULES/$rulefile" ]; then
        # Rule file missing entirely
        RULES_STALE="${RULES_STALE}  ${rulefile}: MISSING\n"
      else
        PLUGIN_VER=$(grep "^version:" "$PLUGIN_RULES/$rulefile" 2>/dev/null | head -1 | sed 's/version: *//')
        PROJECT_VER=$(grep "^version:" "$PROJECT_RULES/$rulefile" 2>/dev/null | head -1 | sed 's/version: *//')
        if [ -n "$PLUGIN_VER" ] && [ "$PLUGIN_VER" != "$PROJECT_VER" ]; then
          RULES_STALE="${RULES_STALE}  ${rulefile}: ${PROJECT_VER:-none} → ${PLUGIN_VER}\n"
        fi
      fi
    fi
  done
fi

# ── Create squirrel entry (.yaml) ───────────────────────
# Find the current walnut (closest folder with key.md or now.md)
WALNUT_NAME=""
WALNUT_DIR=""
check_dir="$ALIVE_ROOT"
while [ "$check_dir" != "/" ] && [ "$check_dir" != "$WORLD_ROOT" ]; do
  if [ -f "$check_dir/now.md" ] || [ -f "$check_dir/key.md" ]; then
    WALNUT_NAME=$(basename "$check_dir")
    WALNUT_DIR="$check_dir"
    break
  fi
  check_dir="$(dirname "$check_dir")"
done

if [ -n "$WALNUT_DIR" ] && [ -d "$WALNUT_DIR/_squirrels" ]; then
  ENTRY_FILE="$WALNUT_DIR/_squirrels/squirrel:${SQUIRREL_SHORT}.yaml"
  if [ ! -f "$ENTRY_FILE" ]; then
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%S")
    cat > "$ENTRY_FILE" << EOF
squirrel: ${SQUIRREL_SHORT}
model: ${MODEL}
walnut: ${WALNUT_NAME}
started: ${NOW}
signed: false
stash: []
scratch: []
EOF
  fi
fi

# ── Count Walnuts and health ────────────────────────────
WALNUT_COUNT=$(find "$WORLD_ROOT" -name "now.md" \
  -not -path "*/01_Archive/*" \
  -not -path "*/.claude/*" \
  -not -path "*/templates/*" \
  -not -path "*/_scratch/*" 2>/dev/null | wc -l | tr -d ' ')

BRAIN_COUNT=$(find "$WORLD_ROOT" -type d -name "_brain" \
  -not -path "*/01_Archive/*" \
  -not -path "*/.claude/*" 2>/dev/null | wc -l | tr -d ' ')

# ── Count walnuts missing key.md (need migration) ───
NEEDS_MIGRATION=0
while IFS= read -r -d '' nowfile; do
  dir=$(dirname "$nowfile")
  [ ! -f "$dir/key.md" ] && NEEDS_MIGRATION=$((NEEDS_MIGRATION + 1))
done < <(find "$WORLD_ROOT" -name "now.md" \
  -not -path "*/01_Archive/*" \
  -not -path "*/.claude/*" \
  -not -path "*/templates/*" \
  -not -path "*/_scratch/*" -print0 2>/dev/null)

# ── Find unsigned squirrel entries ──────────────────────
UNSIGNED_COUNT=0

# Check .yaml entries
while IFS= read -r -d '' file; do
  if grep -q "signed: false" "$file" 2>/dev/null; then
    UNSIGNED_COUNT=$((UNSIGNED_COUNT + 1))
  fi
done < <(find "$WORLD_ROOT" -path "*/_squirrels/squirrel:*.yaml" \
  -not -path "*/01_Archive/*" -print0 2>/dev/null)

# Also check legacy .md entries
while IFS= read -r -d '' file; do
  if grep -q "signed: false" "$file" 2>/dev/null; then
    UNSIGNED_COUNT=$((UNSIGNED_COUNT + 1))
  fi
done < <(find "$WORLD_ROOT" -path "*/_squirrels/squirrel:*.md" \
  -not -path "*/01_Archive/*" -print0 2>/dev/null)

# ── Count health signals ────────────────────────────────
WAITING_COUNT=0
ACTIVE_COUNT=0
QUIET_COUNT=0
CUTOFF_14=$(date -v-14d +%Y-%m-%d 2>/dev/null || date -d "14 days ago" +%Y-%m-%d 2>/dev/null || echo "")
CUTOFF_7=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d "7 days ago" +%Y-%m-%d 2>/dev/null || echo "")

if [ -n "$CUTOFF_14" ]; then
  while IFS= read -r -d '' nowfile; do
    UPDATED=$(grep "^updated:" "$nowfile" 2>/dev/null | head -1 | sed 's/updated: *//' | cut -dT -f1)
    if [ -n "$UPDATED" ]; then
      if [[ "$UPDATED" < "$CUTOFF_14" ]]; then
        WAITING_COUNT=$((WAITING_COUNT + 1))
      elif [[ "$UPDATED" < "$CUTOFF_7" ]]; then
        QUIET_COUNT=$((QUIET_COUNT + 1))
      else
        ACTIVE_COUNT=$((ACTIVE_COUNT + 1))
      fi
    fi
  done < <(find "$WORLD_ROOT" -name "now.md" \
    -not -path "*/01_Archive/*" \
    -not -path "*/.claude/*" \
    -not -path "*/templates/*" \
    -not -path "*/_scratch/*" -print0 2>/dev/null)
fi

# ── Count pending inputs ─────────────────────────────────
INPUTS_COUNT=0
if [ -d "$WORLD_ROOT/03_Inputs" ]; then
  INPUTS_COUNT=$(find "$WORLD_ROOT/03_Inputs" -maxdepth 1 -type f \
    -not -name "Icon*" -not -name ".DS_Store" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
fi

# ── Output ───────────────────────────────────────────────
echo "squirrel:${SQUIRREL_SHORT} waking up"
echo ""
echo "▸ world          found · ${WORLD_ROOT}"
echo "▸ system         ${SYSTEM_VERSION}"

if [ "$SYSTEM_VERSION" = "v3" ] || [ "$SYSTEM_VERSION" = "v4" ]; then
  echo "▸ upgrade        ${SYSTEM_VERSION} detected · upgrade available"
  if [ "$BRAIN_COUNT" -gt 0 ]; then
    echo "▸ legacy         ${BRAIN_COUNT} _brain/ entities need migration"
  fi
fi

if [ "$SYSTEM_VERSION" = "fresh" ]; then
  echo "▸ setup          no World configured yet · run walnut:world to begin"
fi

if [ "$WALNUT_COUNT" -gt 0 ]; then
  echo "▸ walnuts        ${ACTIVE_COUNT} active · ${QUIET_COUNT} quiet · ${WAITING_COUNT} waiting"
fi

if [ "$MIGRATION_REMAINING" -gt 0 ] && [ "$SYSTEM_VERSION" = "v1" ]; then
  echo "▸ migration      ${MIGRATION_REMAINING} walnut(s) remaining — upgrade incomplete"
elif [ "$NEEDS_MIGRATION" -gt 0 ] && [ "$SYSTEM_VERSION" = "v1" ]; then
  echo "▸ migration      ${NEEDS_MIGRATION} walnut(s) need key.md"
fi

if [ "$UNSIGNED_COUNT" -gt 0 ]; then
  echo "▸ unsigned       ${UNSIGNED_COUNT} squirrel(s) left without closing"
fi

if [ "$INPUTS_COUNT" -gt 0 ]; then
  echo "▸ inputs         ${INPUTS_COUNT} item(s) pending triage"
fi

if [ -n "$RULES_STALE" ]; then
  echo ""
  echo "⚠ RULES UPDATE REQUIRED — run walnut:world to update before doing anything else"
  echo -e "$RULES_STALE"
  echo "Skills expect the latest rules. Stash, close, and routing may not work correctly on stale rules."
fi

if [ -n "$PREFS_OUTPUT" ]; then
  echo "▸ preferences"
  echo -e "$PREFS_OUTPUT"
fi

exit 0
