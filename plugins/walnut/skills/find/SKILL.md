---
description: Search the world. Past decisions, people, files, references, insights — one verb for all retrieval.
user-invocable: true
triggers:
  # Direct
  - "walnut:find"
  - "find"
  - "search"
  # Decision recall
  - "when did we decide"
  - "what did we agree"
  - "what was the decision on"
  - "didn't we already"
  - "remind me"
  # People
  - "who is"
  - "who's involved in"
  - "who handles"
  - "what do we know about"
  - "when did I last talk to"
  # File retrieval
  - "where is"
  - "where's the"
  - "find the file"
  - "I had a document about"
  - "there was a draft"
  # Reference recall
  - "that email from"
  - "the transcript where"
  - "that screenshot of"
  - "the research on"
  # Temporal
  - "what happened last week"
  - "what changed since"
  - "history of"
  - "what's the timeline"
  # Connection
  - "what's linked to"
  - "what else touches"
  - "related walnuts"
---

# Find

Search across the world. One verb for all retrieval.

---

## How It Searches

Priority order — fastest and highest signal first:

### 1. Frontmatter Scan (fast, structured)
Scan `_core/key.md` across all walnuts. Matches on: type, goal, people names, tags, links, reference descriptions.

### 2. Insights Search (standing knowledge)
Scan `_core/insights.md` across relevant walnuts. Domain knowledge that persists — "Nova Station test windows are Tue-Thu only."

### 3. Log Search (decisions, history)
Search `_core/log.md` entries. Signed decisions, session summaries, what happened when. Frontmatter first (last-entry, summary), then entry bodies.

### 4. Task Search (work queue)
Scan `_core/tasks.md` across walnuts. Find tasks by status, age, attribution.

### 5. Working File Search (drafts)
Scan `_core/_working/` across walnuts. Find drafts by name, version, age, squirrel attribution.

### 6. Reference Companion Search (captured content metadata)
Search `_core/_references/` companion .md files. Match on frontmatter: type, date, source, participants, subject.

### 7. Raw Reference Search (last resort, expensive)
Load actual raw files. Only on explicit request — "read me that email from Kai."

---

## Cross-Walnut Search

Find searches across ALL walnuts by default. Results show which walnut each match came from.

```
╭─ 🐿️ found 3 matches for "radiation shielding"
│
│   1. nova-station / insights.md
│      "Ceramic composites outperform aluminum at 3x the cost"
│
│   2. nova-station / log.md — 2026-02-23
│      Decision: go with hybrid shielding approach
│
│   3. nova-station / _references/research/
│      2026-02-23-radiation-shielding-options.md
│
│  number to load, or refine search.
╰─
```

## Connections

When a match is found, surface connected walnuts:

```
╭─ 🐿️ [[ada-chen]] is mentioned in this entry.
│  She also appears in: nova-station, glass-cathedral
│  Load her context?
╰─
```

## Temporal Queries

"What happened last week" → filter log entries by date range, show across all active walnuts.

"What changed since Tuesday" → scan `now.md` updated timestamps + recent log entries.

"History of nova-station" → show log.md frontmatter (entry count, summary) + offer to load recent entries.
