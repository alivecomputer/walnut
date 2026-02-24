#!/bin/bash
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
