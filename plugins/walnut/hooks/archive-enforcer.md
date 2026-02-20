---
hook: archive-enforcer
event: PreToolUse
tools: [Bash]
description: Blocks file deletion commands. Nothing is deleted in ALIVE — everything is archived.
---

# Archive Enforcer — PreToolUse Hook

When the tool is **Bash** and the command contains `rm`, `rm -rf`, `rm -r`, `unlink`, or any deletion pattern:

**CHECK:** Is the target inside an ALIVE World (any path containing `01_Archive/`, `02_Life/`, `03_Inputs/`, `04_Ventures/`, `05_Experiments/`, `_squirrels/`, `_scratch/`, `_chapters/`, `_references/`)?

**If yes → BLOCK.**

Say:
```
Nothing gets deleted in ALIVE. Archive it instead.

Move to: 01_Archive/[original-path]

Want me to archive it?
```

**If the target is outside the ALIVE World → ALLOW.** This hook only protects World contents.

**Exception:** Files in `_squirrels/` that are signed and older than 30 days can be cleaned up during tend — but even then, archive, don't delete.
