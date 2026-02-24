#!/bin/bash

# Walnut namespace guard — only fire inside an ALIVE world
find_world() {
  local dir="${CLAUDE_PROJECT_DIR:-$PWD}"
  while [ "$dir" \!= "/" ]; do
    if [ -d "$dir/01_Archive" ] && [ -d "$dir/02_Life" ]; then return 0; fi
    dir="$(dirname "$dir")"
  done
  return 1
}
find_world || exit 0

# Hook 3: Archive Enforcer — PreToolUse (Bash)
# Blocks rm/rmdir/unlink inside ALIVE folders.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Check for destructive commands
if ! echo "$COMMAND" | grep -qE '(^|\s|;|&&|\|)(rm|rmdir|unlink)\s'; then
  exit 0
fi

# Extract the TARGET path(s) after the rm/rmdir/unlink command
# Strip everything before the rm command, then get the path arguments
TARGET=$(echo "$COMMAND" | sed -E 's/.*\b(rm|rmdir|unlink)\s+(-[^ ]+ )*//' | tr ' ' '\n' | grep -v '^-')

# Check if any TARGET path is inside ALIVE folders
if echo "$TARGET" | grep -qE '(01_Archive|02_Life|03_Inputs|04_Ventures|05_Experiments|_core|_squirrels|_working|_chapters|_references)'; then
  echo "Blocked: deletion inside ALIVE folders. Archive instead — move to 01_Archive/." >&2
  exit 2
fi

exit 0
