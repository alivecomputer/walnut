---
hook: log-guardian
event: PreToolUse
tools: [Edit]
description: Blocks edits to existing log.md entries. Log is append-only. New entries at the end only.
---

# Log Guardian — PreToolUse Hook

When the tool is **Edit** and the target file is `log.md`:

**CHECK:** Is the `old_string` being replaced part of an existing signed entry?

A signed entry looks like:
```
## [datetime] — squirrel:[id]
...
signed: squirrel:[id]
```

**If the edit modifies content within a signed entry → BLOCK.**

Say:
```
log.md is append-only. That entry is signed by squirrel:[id] — it can't be changed.
If something was wrong, add a correction entry instead.
```

**If the edit appends new content after the last entry → ALLOW.**

**If the edit modifies the YAML frontmatter (updating last-entry, entry-count, summary) → ALLOW.** Frontmatter maintenance is expected after appending entries.
