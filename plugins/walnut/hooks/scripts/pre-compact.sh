#!/bin/bash
# Hook: PreCompact — command only
# Writes current stash to squirrel YAML before context compression.
# Cannot inject context back — SessionStart(compact) handles re-injection.

set -euo pipefail

# Find the current unsigned squirrel entry
ENTRY=""
if [ -d "$PWD/_core/_squirrels" ]; then
  ENTRY=$(grep -rl 'signed: false' "$PWD/_core/_squirrels/"*.yaml 2>/dev/null | head -1)
fi

if [ -z "$ENTRY" ]; then
  # No entry found, nothing to save
  exit 0
fi

# Mark that compaction happened
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S")

# Append a compaction marker to the entry
# The stash content itself is managed by the squirrel's shadow-write behaviour
# This marker tells the next SessionStart(compact) that compaction occurred
if ! grep -q 'compacted:' "$ENTRY"; then
  echo "compacted: $TIMESTAMP" >> "$ENTRY"
else
  sed -i '' "s/compacted:.*/compacted: $TIMESTAMP/" "$ENTRY"
fi

exit 0
