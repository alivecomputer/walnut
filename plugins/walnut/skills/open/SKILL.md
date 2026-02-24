---
name: open
description: Open one walnut. Load context, focus, work. Single-walnut attention.
user-invocable: true
triggers:
  # Direct
  - "walnut:open"
  - "open"
  # Intent
  - "open nova-station"
  - "let's work on"
  - "focus on"
  - "switch to"
  - "load"
  - "pull up"
  # Action
  - "start working"
  - "let's go"
  - "dive into"
  - "pick up where I left off"
  # Return
  - "back to"
  - "resume"
  - "continue with"
  - "where was I on"
---

# Open

Single-walnut focus. Load one walnut. See where things are. Work.

---

## If No Walnut Named

Show available walnuts as a numbered list grouped by domain:

```
╭─ 🐿️ pick a walnut
│
│  Life
│   1. identity         active    Mars visa application
│   2. health           quiet     Sleep study results
│
│  Ventures
│   3. nova-station      active   Orbital test window
│   4. paper-lantern     quiet    Menu redesign
│
│  Experiments
│   5. midnight-frequency active  Episode 12 edit
│   6. glass-cathedral   waiting  Decide: gallery or festival
│
│  number to open, or name one.
╰─
```

## Load Sequence

Read in order (show `▸` reads):

1. `_core/key.md` — what this walnut is
2. `_core/now.md` — where it is right now
3. `_core/insights.md` — frontmatter scan (what domain knowledge exists)
4. `_core/tasks.md` — current task queue
5. `_core/_squirrels/` — any unsigned entries?
6. `_core/_working/` — anything in progress?

```
▸ key.md      Nova Station — orbital tourism platform, weekly rhythm
▸ now.md      Phase: testing. Next: review telemetry from test window.
▸ insights    3 sections (engineering, regulatory, partners)
▸ tasks       2 active, 1 urgent, 4 to do
▸ _squirrels/ 1 unsigned entry (empty — safe to clear)
▸ _working/   launch-sequence-checklist-v0.2 in progress
```

## The Spark

One observation the conductor might not have seen. A connection, a question, a nudge.

```
╭─ 🐿️ spark
│  Ada hasn't been mentioned in 8 days but there are 2 telemetry
│  reports from her team sitting in email. Might be test results.
╰─
```

If there's not enough context for a genuine spark, skip it. An obvious one is worse than none.

## Then Ask

```
╭─ 🐿️ nova-station
│  Goal:    Build the first civilian orbital tourism platform
│  Phase:   testing
│  Next:    Review telemetry from test window
│
│  Load full context, or just chat?
╰─
```

"Load context" reads log frontmatter, recent entries, linked walnuts.
"Just chat" starts freestyle — the squirrel loads more later if needed.

## During Work

- Stash in conversation (see squirrels.md). No file writes except capture + _working/.
- Always watching: people updates, _working/ fits, capturable content.
- When a _working/ file looks shareable → offer to publish via `walnut:publish`.

## Cross-Loading

If another walnut becomes relevant during work ("this references [[ada-chen]]"), ask before loading it. One walnut, one focus.

```
╭─ 🐿️ cross-reference
│  This mentions [[ada-chen]]. Load her context?
╰─
```

## Unsigned Entry Recovery

If `_squirrels/` has an unsigned entry with stash items from a previous session:

```
╭─ 🐿️ previous session had 6 stash items that were never saved.
│  Review before we start?
╰─
```

If yes: present the previous stash for routing. If no: clear and move on.
