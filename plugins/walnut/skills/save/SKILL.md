---
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

### 1. Read First (understand before acting)

Before presenting the stash or writing anything, the squirrel reads:

- `_core/now.md` — what was the previous `next:`? What was the context?
- `_core/log.md` — first ~100 lines (recent entries — what have previous sessions covered?)
- `_core/tasks.md` — current task queue

This gives the squirrel the full picture BEFORE it starts routing. It knows what was expected this session, what previous sessions accomplished, and what the task state is. This makes everything that follows smarter — better routing suggestions, better now.md synthesis, better log entries that don't duplicate what's already recorded.

### 2. Pre-Save Scan

"Anything else before I save?"

Then scan back through messages since last save for stash items the squirrel may have missed. Add them.

### 3. Present Stash by Category

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

### 4. Check next:

The squirrel already read now.md in step 1. It knows what `next:` was. Did we address it?

```
╭─ 🐿️ next is changing
│  Previous: "Review telemetry from test window"
│  → completed / deprioritised / still priority
╰─
```
→ AskUserQuestion: "Completed" / "Move to tasks, new next" / "Still the priority" (+ Other)

If previous next: was NOT completed and is being replaced, it moves to tasks.md with context.

### 5. Write Log Entry

**Before writing anything else, prepend a signed entry to log.md.** This is the primary record of what happened. Use the log-entry template structure:

- What happened (brief narrative)
- Decisions made (with rationale — WHY, not just WHAT)
- Tasks created or completed
- References captured
- Next actions identified

The log entry must be written BEFORE updating now.md. The log is truth. Everything else derives from it.

### 6. Route

For each confirmed stash item:
- **Existing walnut** → prepend signed log entry
- **New person** → scaffold person walnut in `02_Life/people/`
- **New venture/experiment** → scaffold walnut with _core/
- **Task** → add to appropriate `_core/tasks.md`
- **Insight** → add to appropriate `_core/insights.md` (only if confirmed as evergreen)
- **Cross-walnut note** → dispatch to destination walnut log (brief entry, not full session)

### 7. Update State

The squirrel already read now.md and recent log entries in step 1. It has the full picture.

**now.md is a synthesis of recent history, not a report on this session.** The context paragraph should cover the last 3-5 log entries worth of context — what's been happening across sessions, not just what happened right now. A new squirrel reading now.md should understand the full current situation without touching the log.

**Protect existing context.** If this session was minor (quick chat, small update) but the existing now.md has rich context from a previous deep session — do NOT flatten it. Merge the new information in. The test: is the new now.md MORE informative than the old one? If not, keep what was there and layer the new stuff on top.

- `now.md` — phase, health, next, updated, squirrel, context paragraph (synthesis of recent sessions)
- `tasks.md` — add new, mark completed, update in-progress

### 8. Integrity Check

Not a vibe check. A concrete checklist. Run through each:

- [ ] **now.md** — does the context paragraph reflect the full current picture (not just this session)?
- [ ] **Log entry** — does it capture WHY decisions were made, not just WHAT?
- [ ] **tasks.md** — are new tasks added, completed tasks marked, nothing stale left as active?
- [ ] **References** — was any external content discussed this session that wasn't captured? Any research worth saving?
- [ ] **Companions** — do all references have companions with `description:` in frontmatter?
- [ ] **Insights** — did any standing domain knowledge surface that should be proposed as evergreen?
- [ ] **People** — was anyone mentioned who should have context dispatched to their walnut?
- [ ] **Working files** — are any drafts ready to promote? Any created this session that need signing?

If anything fails, fix it before completing the save. This is the last gate.

### 9. Continue

Session continues. Stash resets for next checkpoint.

```
╭─ 🐿️ saved — checkpoint 2
│  3 decisions routed to log
│  2 tasks added
│  1 dispatch to [[kai-tanaka]]
│  next: updated
│  zero-context: ✓
│
│  Run walnut:housekeeping? (stale walnuts, orphan refs, stale drafts)
╰─
```

The check suggestion is lightweight — one line. If the conductor ignores it, no friction. If they say "check" or "yeah", invoke `walnut:housekeeping`.

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
