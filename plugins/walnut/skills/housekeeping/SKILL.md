---
name: housekeeping
description: System housekeeping. Stale walnuts, broken references, unsigned entries, stale drafts. Starts by scanning what squirrels have been up to.
user-invocable: true
triggers:
  - "walnut:housekeeping"
  - "housekeeping"
  - "clean up"
  - "tidy up"
  - "tidy"
  - "maintenance"
  - "audit"
  - "anything stale"
  - "anything broken"
  - "anything I'm missing"
  - "what's falling behind"
  - "what needs attention"
  - "what am I neglecting"
  - "is everything ok"
  - "system check"
  - "check"
  - "health"
  - "how's my world looking"
  - "any problems"
  - "anything off"
---

# Housekeeping

System housekeeping. Starts by scanning what squirrels have been up to, then surfaces issues one at a time.

Not a dashboard (that's world). Not a search (that's find). Not session recall (that's recall). Pure maintenance.

---

## Step 1: Squirrel Scan

Before checking for problems, get the lay of the land. Scan `_core/_squirrels/` across all walnuts (or the current walnut if one is open).

```
╭─ 🐿️ housekeeping — recent squirrel activity
│
│  alive-gtm       5 sessions this week (3 signed, 2 unsigned)
│  nova-station    1 session (signed)
│  glass-cathedral 0 sessions in 12 days
│
│  2 unsigned entries need attention. Starting there.
╰─
```

This gives context before diving into issues. The squirrel knows what's been happening before it starts flagging problems.

---

## Step 2: Issues (one at a time)

In priority order:

### 2a. Unsigned Squirrel Entries

```
╭─ 🐿️ housekeeping — unsigned session
│  nova-station / squirrel:a3f7b2c1 — started Feb 21, never signed
│  Has 4 stash items that were never saved.
│
│  → review stash / clear entry / skip
╰─
```

### 2b. Stale Walnuts Past Rhythm

| Rhythm | Quiet at | Waiting at |
|--------|----------|-----------|
| daily | 2 days | 4+ days |
| weekly | 2 weeks | 4+ weeks |
| fortnightly | 3 weeks | 6+ weeks |
| monthly | 6 weeks | 3+ months |

```
╭─ 🐿️ housekeeping — stale walnut
│  midnight-frequency has been quiet for 18 days (rhythm: weekly)
│  Last entry: Feb 5 — "locked episode 11 structure"
│
│  → open it / archive it / change rhythm / skip
╰─
```

### 2c. References Without Companions

```
╭─ 🐿️ housekeeping — orphan reference
│  nova-station / _references/documents/raw/2026-02-15-vendor-proposal.pdf
│  No companion file.
│
│  → create companion / skip
╰─
```

### 2d. Working Files Older Than 30 Days

```
╭─ 🐿️ housekeeping — stale draft
│  glass-cathedral / _working/submission-draft-v0.1.md
│  Last modified: Jan 15 — 39 days ago.
│
│  → promote to v1 / archive / delete / skip
╰─
```

### 2e. key.md References Out of Sync

```
╭─ 🐿️ housekeeping — unindexed reference
│  nova-station has 3 references not in key.md
│
│  → index all / review individually / skip
╰─
```

### 2f. Tasks Overdue or Stale

```
╭─ 🐿️ housekeeping — stale task
│  nova-station / "Book ground control sim" — added Feb 10, no progress
│
│  → still relevant / remove / reprioritise / skip
╰─
```

### 2g. Inputs Buffer (> 48 hours)

```
╭─ 🐿️ housekeeping — unrouted input
│  03_Inputs/ has 2 items older than 48 hours
│
│  → route them / skip
╰─
```

### 2h. now.md Zero-Context Failures

---

## Presentation

**One at a time.** Surface the highest priority issue, let the conductor deal with it, then surface the next.

```
╭─ 🐿️ housekeeping complete
│  3 issues found, 2 resolved, 1 skipped
│  World is healthy.
╰─
```

## When to Trigger

- Suggested after every walnut:save checkpoint
- Post-compaction
- After a long silence (30+ minutes)
- When the conductor seems lost ("wait, what was I doing?")
