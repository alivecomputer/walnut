#!/bin/bash
# Hook 7: Reference Indexer — PostToolUse (Write)
# Reminds to index new references in key.md.
# Only fires for writes to _references/. Silent for everything else.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only care about files in _references/
if ! echo "$FILE_PATH" | grep -q '_references/'; then
  exit 0
fi

# Don't fire for index.md itself
if echo "$FILE_PATH" | grep -q '_references/index\.md$'; then
  exit 0
fi

# Remind to index
jq -n '{
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: "New reference written. Index it in key.md under references: (type, date, description). If key.md has 30+ references, drop the oldest — it still lives in _core/_references/index.md."
  }
}'
exit 0
