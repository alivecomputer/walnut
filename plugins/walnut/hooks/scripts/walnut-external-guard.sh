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

# Hook 6: External Guard — PreToolUse (mcp__.*)
# Escalates external write actions to user for confirmation.
# Read-only actions pass silently.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Read-only MCP actions — pass silently
if echo "$TOOL_NAME" | grep -qE '(search|read|list|get|fetch|view)'; then
  exit 0
fi

# Write/send/delete actions — escalate to user
if echo "$TOOL_NAME" | grep -qE '(send|create|delete|modify|batch|draft|update|download)'; then
  echo '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "ask",
      "permissionDecisionReason": "🐿️ External action detected. Confirm before proceeding."
    }
  }'
  exit 0
fi

# Unknown MCP action — escalate to be safe
echo '{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "🐿️ Unknown external action. Confirm before proceeding."
  }
}'
exit 0
