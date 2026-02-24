#!/bin/bash
# Hook 3: Archive Enforcer — PreToolUse (Bash)
# Blocks rm/rmdir/unlink inside ALIVE folders.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Check for destructive commands
if ! echo "$COMMAND" | grep -qE '(^|\s|;|&&|\|)(rm|rmdir|unlink)\s'; then
  exit 0
fi

# Check if target is inside ALIVE folders
if echo "$COMMAND" | grep -qE '(01_Archive|02_Life|03_Inputs|04_Ventures|05_Experiments|_core|_squirrels|_working|_chapters|_references)'; then
  echo "Blocked: deletion inside ALIVE folders. Archive instead — move to 01_Archive/." >&2
  exit 2
fi

exit 0
