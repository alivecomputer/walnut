#!/bin/bash
# Hook 4: Working Signer — PostToolUse (Write|Edit)
# Reminds to sign .md files in _working/ with squirrel ID and model.
# Only fires on markdown files. Silent for all other paths and types.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only care about .md files in _working/
if ! echo "$FILE_PATH" | grep -q '_working/.*\.md$'; then
  exit 0
fi

# Check if the file already has squirrel: in frontmatter
if [ -f "$FILE_PATH" ] && head -20 "$FILE_PATH" | grep -q 'squirrel:'; then
  exit 0
fi

# Remind
jq -n '{
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: "Working file needs signing — add squirrel: [session-id] and model: [model] to the YAML frontmatter."
  }
}'
exit 0
