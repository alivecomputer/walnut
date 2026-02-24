#!/bin/bash
# Hook 1a: Session New — SessionStart (startup)
# Creates squirrel entry, reads preferences, sets env vars, checks rule staleness.

set -euo pipefail

# Find the ALIVE world root by walking up from PWD
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

# Generate session ID (short hash)
SESSION_ID=$(head -c 16 /dev/urandom | shasum | head -c 8)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S")
MODEL="${CLAUDE_MODEL:-unknown}"

# Set env vars via CLAUDE_ENV_FILE if available
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "WALNUT_SESSION_ID=$SESSION_ID" >> "$CLAUDE_ENV_FILE"
  echo "WALNUT_WORLD_ROOT=$WORLD_ROOT" >> "$CLAUDE_ENV_FILE"
fi

# Detect current walnut (if PWD is inside one)
WALNUT_NAME=""
WALNUT_PATH=""
if [ -d "$PWD/_core" ]; then
  WALNUT_PATH="$PWD"
  WALNUT_NAME=$(basename "$PWD")
elif [ -d "$(dirname "$PWD")/_core" ]; then
  WALNUT_PATH="$(dirname "$PWD")"
  WALNUT_NAME=$(basename "$WALNUT_PATH")
fi

# Create squirrel entry if walnut detected
if [ -n "$WALNUT_PATH" ] && [ -d "$WALNUT_PATH/_core/_squirrels" ]; then
  ENTRY_FILE="$WALNUT_PATH/_core/_squirrels/$SESSION_ID.yaml"
  if [ ! -f "$ENTRY_FILE" ]; then
    cat > "$ENTRY_FILE" << EOF
session_id: $SESSION_ID
runtime_id: squirrel.core@0.2
engine: $MODEL
walnut: $WALNUT_NAME
started: $TIMESTAMP
ended: null
signed: false
stash: []
working: []
EOF
  fi
fi

# Read preferences
PREFS_FILE="$WORLD_ROOT/.claude/preferences.yaml"
if [ -f "$PREFS_FILE" ]; then
  PREFS=$(cat "$PREFS_FILE")
else
  PREFS="defaults (no preferences.yaml found)"
fi

# Check rule staleness (compare plugin version vs project rules)
RULES_STATUS="ok"
# TODO: version comparison logic

# Output context for Claude (stdout is added to conversation)
cat << EOF
ALIVE session initialized. Session ID: $SESSION_ID
World: $WORLD_ROOT
Walnut: ${WALNUT_NAME:-none detected}
Preferences: $PREFS
Rules: $RULES_STATUS
EOF
