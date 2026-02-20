---
hook: compaction-save
event: PreCompact
description: Before context compaction, dump the in-conversation stash to the squirrel entry so nothing is lost.
---

# Compaction Save — PreCompact Hook

Context compaction is about to happen. Your stash — decisions, tasks, notes you've been carrying in conversation — will be lost when memory shrinks.

**Before compaction proceeds:**

1. Write your current stash to the squirrel entry (`_squirrels/squirrel:[id].yaml`) under the `stash:` field
2. Note any scratch files you've been working on under the `scratch:` field
3. Allow compaction to proceed

**This is not a close.** The session continues. But your conversational memory won't survive. The squirrel entry is the only thing that persists — make sure it has your stash.
