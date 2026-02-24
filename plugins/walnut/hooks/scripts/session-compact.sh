#!/bin/bash
# Hook 1c: Session Compact — SessionStart (compact)
# Re-injects stash + walnut context after context compression.

set -euo pipefail

find_world() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/01_Archive" ] && [ -d "$dir/02_Life" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

WORLD_ROOT=$(find_world) || { echo "No ALIVE world found."; exit 0; }

# Find the most recent unsigned squirrel entry (current session)
LATEST_ENTRY=""
if [ -d "$PWD/_core/_squirrels" ]; then
  LATEST_ENTRY=$(grep -rl 'signed: false' "$PWD/_core/_squirrels/"*.yaml 2>/dev/null | head -1)
fi

if [ -n "$LATEST_ENTRY" ]; then
  SESSION_ID=$(grep 'session_id:' "$LATEST_ENTRY" | awk '{print $2}')
  WALNUT=$(grep 'walnut:' "$LATEST_ENTRY" | awk '{print $2}')
  STASH=$(grep -A 100 'stash:' "$LATEST_ENTRY" | head -50)

  # Re-read brief pack for context
  NOW_CONTENT=""
  KEY_CONTENT=""
  if [ -f "$PWD/_core/now.md" ]; then
    NOW_CONTENT=$(head -20 "$PWD/_core/now.md")
  fi
  if [ -f "$PWD/_core/key.md" ]; then
    KEY_CONTENT=$(head -20 "$PWD/_core/key.md")
  fi

  cat << EOF
CONTEXT RESTORED after compaction. Session: $SESSION_ID | Walnut: $WALNUT

Stash recovered:
$STASH

Current state (re-read — do not trust pre-compaction memory):
$NOW_CONTENT

Identity:
$KEY_CONTENT

IMPORTANT: Re-read _core/key.md, _core/now.md, _core/tasks.md before continuing work. Do not trust memory of files read before compaction.
EOF
else
  echo "Context compacted. No squirrel entry found — stash may be lost."
fi
