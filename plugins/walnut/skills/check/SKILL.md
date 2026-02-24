---
name: check
description: System health. Stale walnuts, broken references, unsigned entries, stale drafts. One issue at a time.
user-invocable: true
triggers:
  # Direct
  - "walnut:check"
  - "check"
  - "health"
  # Intent
  - "anything stale"
  - "anything broken"
  - "anything I'm missing"
  - "what's falling behind"
  - "what needs attention"
  - "what am I neglecting"
  # Maintenance
  - "clean up"
  - "tidy up"
  - "housekeeping"
  - "maintenance"
  - "audit"
  # Proactive
  - "is everything ok"
  - "system check"
  - "how's my world looking"
  - "any problems"
  - "anything off"
---

# Check

System health. Surfaces one issue at a time. Fix it or dismiss it.

Not a dashboard (that's world). Not a search (that's find). Pure maintenance.

---

## What It Checks

In priority order:

### 1. Unsigned Squirrel Entries
Sessions that never closed properly. Previous squirrel had stash items that were never routed.

```
╭─ 🐿️ check — unsigned session
│  nova-station / squirrel:a3f7b2c1 — started Feb 21, never signed
│  Has 4 stash items that were never saved.
│
│  → review stash / clear entry / skip
╰─
```

### 2. Stale Walnuts Past Rhythm
Compare `_core/key.md` rhythm against `_core/now.md` updated timestamp.

| Rhythm | Quiet at | Waiting at |
|--------|----------|-----------|
| daily | 2 days | 4+ days |
| weekly | 2 weeks | 4+ weeks |
| fortnightly | 3 weeks | 6+ weeks |
| monthly | 6 weeks | 3+ months |

```
╭─ 🐿️ check — stale walnut
│  midnight-frequency has been quiet for 18 days (rhythm: weekly)
│  Last entry: Feb 5 — "locked episode 11 structure"
│
│  → open it / archive it / change rhythm / skip
╰─
```

### 3. References Without Companions
Raw files in `_core/_references/*/raw/` that have no corresponding companion .md.

```
╭─ 🐿️ check — orphan reference
│  nova-station / _references/documents/raw/2026-02-15-vendor-proposal.pdf
│  No companion file. Can't scan without loading the full PDF.
│
│  → create companion / skip
╰─
```

### 4. Working Files Older Than 30 Days
Drafts sitting in `_core/_working/` that haven't been touched.

```
╭─ 🐿️ check — stale draft
│  glass-cathedral / _working/submission-draft-v0.1.md
│  Last modified: Jan 15 — 39 days ago.
│
│  → promote to v1 / archive / delete / skip
╰─
```

### 5. key.md References Out of Sync
References exist in `_core/_references/` but aren't listed in `_core/key.md` references field.

```
╭─ 🐿️ check — unindexed reference
│  nova-station has 3 references not in key.md:
│   - 2026-02-20-ada-telemetry-report.md
│   - 2026-02-18-ground-control-sim-notes.md
│   - 2026-02-15-vendor-proposal.md (also missing companion)
│
│  → index all / review individually / skip
╰─
```

### 6. Tasks Overdue or Stale
Tasks in `_core/tasks.md` with no progress in 2+ weeks.

```
╭─ 🐿️ check — stale task
│  nova-station / "Book ground control sim" — added Feb 10, no progress
│
│  → still relevant / remove / reprioritise / skip
╰─
```

### 7. Inputs Buffer
Items sitting in `03_Inputs/` for more than 48 hours without being routed.

```
╭─ 🐿️ check — unrouted input
│  03_Inputs/ has 2 items older than 48 hours:
│   - vendor-brochure.pdf (3 days)
│   - meeting-notes-feb20.md (4 days)
│
│  → route them / skip
╰─
```

### 8. now.md Zero-Context Failures
Read `_core/now.md` — does it pass the zero-context test? If the context paragraph is empty, stale, or doesn't reflect reality.

---

## Presentation

**One at a time.** Don't overwhelm with a list of 15 problems. Surface the highest priority issue, let the conductor deal with it, then surface the next.

After all issues are addressed (or skipped):

```
╭─ 🐿️ check complete
│  3 issues found, 2 resolved, 1 skipped
│  World is healthy.
╰─
```

## When to Trigger Automatically

- Post-compaction (context was compressed, re-check state)
- After a long silence (30+ minutes of no activity)
- When the conductor says something suggesting drift ("wait, what was I doing?")
