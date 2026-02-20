---
skill: close
version: 1.0.0
user-invocable: true
description: Close a session. Review stash, route items to walnuts, sign log entries, regenerate now.md, sign squirrel entry.
triggers: [close, done, save, wrap up, signing off, that's it, brb, stepping away, finished, done for now]
surfaces: [close]
sub-skills: []
requires-apis: []
---

# Close

The stash becomes the review. Everything captured this session finds its home.

---

## Flow

### 1. Present the Stash

Show everything stashed this session as a numbered list:

```
🐿️ closing — 4 items

  1. 3 rules files: squirrels / world / worldbuilder → alive-gtm?
  2. key.md replaces walnut CLAUDE.md → alive-gtm?
  3. Will mentioned new timeline → create [[will-adler]]?
  4. "the shell IS the value proposition" → keep as note?

numbers to confirm, or tell me what's different.
```

The worldbuilder can:
- Confirm all (type "all" or "yes")
- Confirm specific items by number ("1, 2, 4")
- Redirect items ("3 goes to sovereign-systems")
- Drop items ("skip 4")
- Add items missed ("also stash: decided on walnut naming")

### 2. Route Each Item

For each confirmed item, use add-to-world logic:

- **Existing walnut** → append to that walnut's `log.md` as a signed entry
- **New person** → scaffold person walnut in `02_Life/people/`, first log entry
- **New venture/experiment** → scaffold walnut, first log entry
- **State change** → update the destination walnut's `now.md` at close

Each log entry is signed:

```markdown
## 2026-02-20T15:30:00 — squirrel:5551126e

[content from stash item]

signed: squirrel:5551126e
```

### 3. Update now.md

For each walnut that received routed items:

- Update `phase:` if a phase change was stashed
- Update `next:` based on new tasks or decisions
- Update `health:` to active
- Update `updated:` timestamp
- Update `squirrel:` to current ID
- Update `links:` if new cross-references emerged
- Refresh task list (add new, mark completed)

### 4. Sign the Squirrel Entry

Fill the squirrel .yaml that the hook created at session start:

```yaml
squirrel: 5551126e
model: claude-opus-4-6
walnut: alive-gtm
started: 2026-02-20T14:00:00
ended: 2026-02-20T15:30:00
signed: true
stash:
  - content: 3 rules files decided
    type: decision
    routed: alive-gtm
  - content: key.md replaces CLAUDE.md
    type: decision
    routed: alive-gtm
  - content: Will mentioned new timeline
    type: note
    routed: will-adler
scratch:
  - _scratch/plugin-refactor-v0.1.md
```

### 5. Confirm

```
🐿️ closed — 3 items routed, 1 skipped

  alive-gtm     2 entries added, now.md updated
  will-adler    1 entry added (new walnut created)

squirrel:5551126e signed.
```

---

## Empty Sessions

If nothing was stashed and no meaningful work happened — sign the entry empty and move on. No ceremony.

```
🐿️ closed — nothing to route. squirrel:5551126e signed.
```

---

## Orphan Recovery

When `walnut:world` finds unsigned entries with stash items from previous sessions:

Present them the same way — numbered list, route or skip. Then sign the orphaned entry. Nothing falls through.
