---
description: Bring context in. Store as reference, route everywhere. The most important skill in the system.
user-invocable: true
triggers:
  # Direct
  - "walnut:capture"
  - "capture"
  - "capture this"
  # Content arriving
  - "here's an email"
  - "I got this from"
  - "someone sent me"
  - "check this out"
  - "look at this"
  # Paste/drop
  - "adding a file"
  - "pasting this"
  - "dropping this in"
  - "here's a transcript"
  - "here's a screenshot"
  # API pull
  - "pull my emails"
  - "check gmail"
  - "check slack"
  - "sync my messages"
  - "what came in"
  # Research
  - "save this research"
  - "capture what we found"
  - "don't lose this"
  - "we should keep this"
  # Implicit (squirrel detects external content)
  - "I just had a call"
  - "from the meeting"
  - "from the conversation"
---

# Capture

Bring context in. The most important skill in the system.

If capture is hard, people skip it. If people skip it, the system dies. Capture must feel instant.

---

## When It Fires

- File pasted or dropped into conversation
- Email forwarded or pulled via API
- Transcript from a call or meeting
- Screenshot shared
- Content pasted from another app
- API context pulled (Gmail, Slack, Calendar)
- Research completed during a session
- Conductor says "capture this" or "add this"
- Squirrel detects external content and offers to capture

**Capture is one of two operations that writes mid-session** (the other is _working/ drafts). Everything else waits for save.

---

## Three Stages

### Stage 0 — Detect and Classify (instant)

No processing. Just identification.

- **ref_type** — email, transcript, screenshot, document, message, article, research
- **sensitivity** — public, private, restricted (default: private)
- **source** — gmail, slack, web, manual, in-session

### Stage 1 — Store Raw + Create Companion (always happens, non-negotiable)

Even if extraction fails or is skipped, the raw content is preserved.

1. Write raw file → `_core/_references/[type]/raw/[name].[ext]`
2. Write companion → `_core/_references/[type]/[name].md`

**The companion is the critical artifact.** It has two parts:

**Frontmatter** (scan tier) — must include:
- `type:` — what kind of reference
- `description:` — **one-line summary of what this contains** (this is the scan layer — the thing that makes the reference findable without reading it)
- `date:` — when it was created/captured
- `tags:` — searchable keywords
- `squirrel:` — which session captured it
- Type-specific fields (from, to, participants, etc.)

**Body** (read tier) — AI-generated structured summary:
- `## Summary` — 2-5 sentences on what this is and why it matters
- `## Key Points` — specific facts, data, claims
- `## Action Items` — tasks, commitments, deadlines
- `## Source` — pointer to raw file path

The body should be **detailed enough that you rarely need the raw file.** This is the middle tier that saves the squirrel from loading the full raw content every time. Write it like someone who has 30 seconds to understand what this reference contains.

**References do NOT update key.md.** The companion frontmatter IS the index — the squirrel scans `_references/**/*.md` frontmatter to find what exists.

**File naming:** `YYYY-MM-DD-descriptive-name.ext`
**Garbage filenames** (CleanShot timestamps, IMG_xxxx) get renamed on import.

### Stage 2 — Extract, Stash, Route (bounded, optional)

Extract actionable content. Bounded by content type — don't over-extract.

| Type | Extract |
|------|---------|
| Email | Tasks, commitments, deadlines, people mentioned |
| Transcript | Decisions, action items, named entities, key quotes |
| Screenshot | Visual analysis summary |
| Document | Key claims, relevant sections, metadata |
| Message | Action items, people, context |
| Article | Key arguments, relevant quotes, source credibility |
| Research | Synthesis, sources consulted, open questions |

Extracted items become stash items tagged with destination walnuts. They route at save, not immediately.

**Stash insights from references.** When extracting, actively look for powerful phrases, domain knowledge, and standing truths. These should be stashed as insight candidates — bold, quotable, evergreen. Not everything — just the stuff that would change how the squirrel operates in this walnut. Example: a transcript reveals "we always lose 2 weeks to regulatory review" → stash as insight candidate.

---

## Two Speeds

**Fast capture** (default): Stage 0 + 1 only. Store raw, create companion, index. Done. Instant.

**Deep capture** (on request or for rich content): Stage 0 + 1 + 2. Full extraction and routing.

The squirrel offers deep capture for content that's clearly rich:

```
╭─ 🐿️ captured — transcript from Kai (45 min)
│  Stored: _core/_references/transcripts/2026-02-23-kai-shielding-review.md
│  Companion written with frontmatter + summary
│
│  This looks rich. Deep extract for decisions + tasks?
╰─
```

---

## Type-Specific Companion Frontmatter

```yaml
# Email
---
type: email
from: kai@novastation.space
to: you@example.com
subject: Shielding vendor shortlist
date: 2026-02-23
squirrel: 2a8c95e9
---

# Transcript
---
type: transcript
participants: [You, Kai Tanaka, Dr. Elara Voss]
duration: 45m
platform: Fathom
date: 2026-02-23
squirrel: 2a8c95e9
---

# Screenshot
---
type: screenshot
source: Competitor orbital pricing page
analysis: Three tiers, lowest at $450K per seat, no group discount visible
date: 2026-02-23
squirrel: 2a8c95e9
---

# Document
---
type: document
author: Dr. Elara Voss
source: Internal engineering team
date: 2026-02-20
squirrel: 2a8c95e9
---

# Research (in-session)
---
type: research
topic: Radiation shielding options for LEO tourism
sources: [NASA technical reports, SpaceX Crew Dragon specs, ESA safety standards]
squirrel: 2a8c95e9
date: 2026-02-23
---
```

---

## In-Session Research Capture

**This is critical.** When the squirrel does significant research during a session — web searches, code analysis, system exploration, competitor analysis, architecture research, API investigation — that knowledge MUST NOT die with the conversation. It cost tokens, time, and thinking to produce. It is a first-class reference.

The squirrel should proactively offer to capture when:
- Significant research was done (10+ minutes of searching/reading/synthesising)
- A complex topic was explored with multiple sources
- The conductor asked the squirrel to investigate something
- The squirrel produced a synthesis, comparison, or analysis worth keeping

```
╭─ 🐿️ we just spent 30 minutes mapping radiation shielding options.
│  3 sources consulted, 4 key findings, 2 open questions.
│  Capture as a reference so the next session has it?
╰─
```

### What Gets Created

A full reference — the same as any other captured content. Not a summary note. A proper companion file with frontmatter and structured body.

**1. Companion file** at `_core/_references/research/YYYY-MM-DD-topic.md`:

```yaml
---
type: research
description: Radiation shielding options for LEO tourism — 3 vendors compared, hybrid approach recommended
topic: Radiation shielding options for LEO tourism
sources:
  - NASA Technical Reports Server — LEO radiation exposure data
  - SpaceX Crew Dragon safety specs (public documentation)
  - ESA human spaceflight safety standards (ECSS-E-ST-10-04C)
  - Interview notes from Dr. Elara Voss (Feb 20)
date: 2026-02-23
squirrel: 2a8c95e9
tags: [radiation, shielding, engineering, vendors, safety]
---

## Summary

Three shielding approaches evaluated for the Nova Station habitat module:
aluminium (proven, heavy, cheap), ceramic composite (lighter, 3x cost),
and hybrid (aluminium primary + ceramic secondary for crew quarters).
Hybrid recommended — meets NASA exposure limits at acceptable weight
penalty. Decision pending vendor pricing from Kai's shortlist.

## Key Findings

- LEO radiation exposure: 0.5-1.0 mSv/day (NASA data)
- Aluminium alone requires 10cm thickness → 2,400kg per module
- Ceramic composite at 4cm achieves same protection → 800kg but $2.1M premium
- Hybrid approach: 6cm aluminium + 2cm ceramic for crew areas only → 1,600kg, $900K premium
- FAA Part 450 requires demonstration of <50 mSv annual exposure for passengers

## Open Questions

- Does Kai's vendor shortlist include ceramic composite suppliers?
- What's the weight budget from SpaceVentures? (impacts which approach is viable)
- Has Dr. Voss reviewed the hybrid approach?

## Sources Consulted

- NASA TRS: "Radiation Exposure in Low Earth Orbit" (2024)
- SpaceX Crew Dragon User Guide, Section 4.3 (radiation protection)
- ECSS-E-ST-10-04C: Space Environment Standard
- Session notes from Feb 20 call with Dr. Voss

## Implications

If weight budget allows hybrid approach, it's the clear winner — 33% cheaper
than full ceramic, 33% lighter than full aluminium, meets all regulatory
requirements. The vendor pricing from Kai is the decision gate.
```

**2. Stash insights** — any standing truths discovered during research get stashed as insight candidates:

```
╭─ 🐿️ +2 stash (7)
│  "LEO radiation exposure: 0.5-1.0 mSv/day" → insight candidate
│  "FAA Part 450 requires <50 mSv annual for passengers" → insight candidate
│  → drop?
╰─
```

**3. Stash action items** — any tasks that emerged from the research:

```
╭─ 🐿️ +1 stash (8)
│  Check weight budget with SpaceVentures → [[nova-station]]
│  → drop?
╰─
```

### When NOT to Capture Research

- Quick lookups (one search, one answer) — just answer, don't create a reference
- Obvious facts the squirrel already knew — don't create a file for common knowledge
- Research that led nowhere — unless the dead end is itself useful ("we looked into X, it doesn't work because Y")

The test: **would the next squirrel waste time rediscovering this?** If yes, capture it. If no, let it go.
