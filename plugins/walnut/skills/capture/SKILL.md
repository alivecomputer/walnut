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

### Stage 1 — Store Raw (always happens, non-negotiable)

Even if extraction fails or is skipped, the raw content is preserved.

1. Write raw file → `_core/_references/[type]/raw/[name].[ext]`
2. Write companion → `_core/_references/[type]/[name].md` with type-specific frontmatter
3. Update `_core/key.md` references index (rolling 30 — add new, drop oldest if over cap)
4. Update `_core/_references/index.md` projection (full list, never drops)

**File naming:** `YYYY-MM-DD-descriptive-name.ext`
**Garbage filenames** (CleanShot timestamps, IMG_xxxx) get renamed on import.

### Stage 2 — Extract and Route (bounded, optional)

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

---

## Two Speeds

**Fast capture** (default): Stage 0 + 1 only. Store raw, create companion, index. Done. Instant.

**Deep capture** (on request or for rich content): Stage 0 + 1 + 2. Full extraction and routing.

The squirrel offers deep capture for content that's clearly rich:

```
╭─ 🐿️ captured — transcript from Kai (45 min)
│  Stored: _core/_references/transcripts/2026-02-23-kai-shielding-review.md
│  Indexed in key.md
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

When the squirrel does significant research during a session, that knowledge should not die with the conversation.

```
╭─ 🐿️ we just spent 30 minutes mapping radiation shielding options.
│  Capture as a reference so the next session has it?
╰─
```

Research gets packaged as `type: research` with the squirrel's synthesis, sources, and open questions. Not raw search results — structured knowledge.

---

## Reference Index in key.md

Rolling window of 30 most recent references. New reference always enters. Oldest rolls off to `_core/_references/index.md` (which holds the complete history).

```yaml
references:
  - type: transcript
    date: 2026-02-23
    description: Kai shielding vendor review (45 min)
  - type: email
    date: 2026-02-23
    description: Kai's vendor shortlist
  - type: research
    date: 2026-02-23
    description: Radiation shielding options for LEO
```
