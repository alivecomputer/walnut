---
sub-skill: calibrate
parent: world
description: Progressive world-building over 30 days. Maps context sources, guides extraction one source at a time, tracks coverage.
---

# Calibrate

Not a one-time wizard. A progressive process that fills the World with context over the first 30 days.

Surfaces as a World mode — a coverage view that shows what's rich and what's empty.

---

## How It Works

### Phase 1: Context Map (first calibration session)

```
Let's map your context sources. What do you use?

  1. AI tools (ChatGPT, Claude — exportable history)
  2. Communication (email, Slack, messages)
  3. Calls and meetings (Otter, Fathom, Zoom transcripts)
  4. Documents (Google Docs, Notion, local files)
```

Multiselect. For each, follow up on volume (handful / a lot / massive).

Build the **context map** — ranked list of sources by priority and volume. Store in `_scratch/calibration-map.md`:

```yaml
type: extraction-map
toward: fully contextualised World
status: active
started: 2026-02-19

sources:
  - name: ChatGPT export
    volume: massive
    priority: high
    status: not started
  - name: Gmail
    volume: massive
    priority: high
    status: not started
```

### Phase 2: Progressive Extraction (sessions 2–30+)

Each session focuses on ONE source. At World dashboard:

```
Your World is 15% contextualised.

  biggest gap: email (0 references)
  last extraction: ChatGPT (47 conversations processed)

  1. email — 0% covered (highest impact)
  2. Otter calls — 0% covered
  3. continue ChatGPT — 23% covered
  4. something new

what do you want to bring in?
```

When the worldbuilder picks a source:
1. Route to `walnut:add-to-world`
2. Add-to-world handles extraction for that source type
3. The squirrel guides what to look for based on source type:
   - Emails: decisions, people, action items, project updates
   - Transcripts: decisions, quotes, people, commitments, context
   - Chat exports: recurring themes, people, projects, insights
   - Documents: structure, references, key data
4. Each extraction creates companions, routes to walnuts, logs decisions
5. At close, update the calibration map with progress

**One source per session. Thorough, not shallow.**

### Phase 3: Recalibration (ongoing)

After each extraction, the system recalibrates:
- What percentage of each source is processed?
- New sources discovered? ("You mentioned Notion in a transcript — bring in Notion docs?")
- Blank areas? (Walnuts with thin context, people with no log history)

**Blank area detection:**

```
Noticed:
  - [[will-adler]] referenced 12 times, walnut has 0 references
  - sovereign-systems has no _references/ at all
  - "ad library" mentioned in 3 sessions — no walnut exists

fill any of these gaps?
```

---

## The Coverage View

```
Your World — 42% contextualised

  rich:    sovereign-systems (87%) · alive-gtm (95%)
  thin:    attila-mora (12%) · elite-oceania (5%)
  empty:   launch-week (0%) · bitcoin-treasury (0%)
  missing: email history · Notion docs

  1. extract — pick a source    2. dashboard
```

Percentage is rough — based on: log entries, references, chapters, linked walnuts, scratch files. More signals = richer.

---

## When Calibration Shifts

- **Days 1–7:** heavy extraction, building the map
- **Days 7–14:** filling major gaps, discovering blank areas
- **Days 14–30:** refinement, thin walnuts getting richer
- **Day 30+:** maintenance — surfaces new gaps but no longer the default World opening

After day 30 (or when dismissed), coverage view becomes a World mode accessible via "calibrate" rather than the default.

---

## Game Feel

The coverage percentage IS the game. 0% → 42% → 78%. Each session moves the number. Each blank area filled is visible progress.

Don't gamify with badges. The World getting richer IS the reward. The coverage view makes it visible.

---

## Design Notes

- ONE source per session
- Quality > speed. 10 well-processed transcripts beat 100 shallow imports
- Reference raws for re-processing later
- The calibration map is a scratch file — it evolves
- Blank areas are the most valuable signal
