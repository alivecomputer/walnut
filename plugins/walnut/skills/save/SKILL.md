---
name: save
description: Checkpoint. Route stash, update state, keep working. Multiple saves per session.
user-invocable: true
triggers:
  # Direct
  - "walnut:save"
  - "save"
  - "checkpoint"
  # Intent
  - "route this"
  - "save my work"
  - "persist this"
  - "lock this in"
  - "commit this"
  # Natural pause
  - "let me save before"
  - "save and continue"
  - "quick save"
  # Wrap up
  - "that's a good stopping point"
  - "before I forget"
  - "let's capture that"
  # Explicit close (redirects to save)
  - "close"
  - "done for now"
  - "wrap up"
  - "sign off"
  - "I'm done"
  - "that's it"
---

# Save

Checkpoint. Route the stash. Update state. Keep working.

Save is NOT a termination. The session continues. Save can happen multiple times. The squirrel entry is signed only when the session actually ends.

---

## Flow

### 1. Pre-Save Scan

"Anything else before I save?"

Then scan back through messages since last save for stash items the squirrel may have missed. Add them.

### 2. Present Stash by Category

Each category is a separate AskUserQuestion with options. Skip empty categories.

**Decisions:**
```
╭─ 🐿️ decisions (3)
│   1. Orbital test window confirmed for March 4  → nova-station
│   2. Ada's team handles all telemetry review  → nova-station
│   3. Festival submission over gallery showing  → glass-cathedral
╰─
```
→ AskUserQuestion: "Confirm all 3" / "Review list" / "Drop some"

**Tasks:**
```
╭─ 🐿️ tasks (2)
│   4. Book ground control sim for Feb 28  → nova-station
│   5. Submit festival application by Mar 1  → glass-cathedral
╰─
```
→ AskUserQuestion: "Confirm all 2" / "Edit or drop"

**Notes:**
```
╭─ 🐿️ notes (1)
│   6. Kai mentioned new radiation shielding vendor  → [[kai-tanaka]]
╰─
```
→ AskUserQuestion: "Confirm" / "Drop"

**Insight Candidates:**
```
╭─ 🐿️ insight candidate
│   "Orbital test windows only available Tue-Thu due to
│    ISS scheduling conflicts"
│
│   Commit as evergreen insight, or just log it?
╰─
```
→ AskUserQuestion: "Commit as evergreen" / "Just log it"

### 3. Check next:

Read current `now.md` next: field. Did we address it?

```
╭─ 🐿️ next is changing
│  Previous: "Review telemetry from test window"
│  → completed / deprioritised / still priority
╰─
```
→ AskUserQuestion: "Completed" / "Move to tasks, new next" / "Still the priority" (+ Other)

If previous next: was NOT completed and is being replaced, it moves to tasks.md with context.

### 4. Route

For each confirmed item:
- **Existing walnut** → prepend signed log entry
- **New person** → scaffold person walnut in `02_Life/people/`
- **New venture/experiment** → scaffold walnut with _core/
- **Task** → add to appropriate `_core/tasks.md`
- **Insight** → add to appropriate `_core/insights.md` (only if confirmed as evergreen)
- **Cross-walnut note** → dispatch to destination walnut log (brief entry, not full session)

### 5. Update State

- `now.md` — phase, health, next, updated, squirrel, context paragraph
- `tasks.md` — add new, mark completed, update in-progress

### 6. Zero-Context Check

"Would a new squirrel have full context?"

If the answer isn't clearly yes — the log entry needs more detail, or now.md context paragraph needs updating. The squirrel fixes it before completing the save.

### 7. Continue

Session continues. Stash resets for next checkpoint.

```
╭─ 🐿️ saved — checkpoint 2
│  3 decisions routed to log
│  2 tasks added
│  1 dispatch to [[kai-tanaka]]
│  next: updated
│  zero-context: ✓
╰─
```

---

## On Actual Session Exit

When the session truly ends (stop hook, explicit "I'm done done", conductor leaves):

- Sign the squirrel entry with `ended:` timestamp and `signed: true`
- Final `now.md` update
- This is the ONLY time the entry gets signed

---

## Empty Save

If nothing was stashed since last save — skip the ceremony.

```
╭─ 🐿️ nothing to save since last checkpoint.
╰─
```
