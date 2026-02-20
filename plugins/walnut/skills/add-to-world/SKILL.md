---
skill: add-to-world
version: 0.1.0
user-invocable: true
description: Smart routing engine. Anything entering the World comes through here — stash items at close, pastes, files, links. Figures out what it's dealing with and where it goes.
triggers: [add to world, add this, note this, remember this, here's some context, FYI, I decided, I learned, here's an email, from my call, process this, here's a file, dropping this in]
surfaces: [add-to-world]
sub-skills: [route, new-walnut, companion]
requires-apis: []
---

# Add to World

Everything entering the World comes through here. The squirrel figures out what it's dealing with and where it goes.

Two modes:
1. **From close** — routing stash items at end of session
2. **Standalone** — worldbuilder brings content directly

---

## Standalone Mode

When invoked directly, ask simply:

```
What are you adding?

  1. something to note or capture
  2. content to paste (email, transcript, message)
  3. a file (audio, image, document)
  4. something that needs a new walnut

or just paste it and I'll figure it out.
```

Numbered menu. Or the worldbuilder just pastes — the squirrel reads the content and routes.

---

## The Routing Engine [[route]]

Given any content, figure out: **what is this, and where does it go?**

### Step 1: Classify

What am I dealing with?

- **Decision** → log entry in relevant walnut
- **Task** → now.md open items in relevant walnut
- **Person info** → person walnut (create if needed)
- **New venture/experiment** → new walnut
- **State change** → updates to existing walnut's now.md
- **Reference material** → _references/ with companion
- **Insight/note** → log entry
- **Preference** → scratch, then worldbuilding skill

### Step 2: Find the destination

Scan `key.md` and `now.md` frontmatter across existing walnuts. Match by:
- People mentioned
- Topics and tags
- Explicit walnut references
- Content type and domain

Present the best match as a numbered list:

```
This looks like it belongs in:

  1. sovereign-systems    mentioned explicitly
  2. will-adler           Will is the source
  3. alive-gtm            topic: plugin architecture
  4. new walnut            doesn't fit anywhere
  5. skip                  don't add

where does it go?
```

### Step 3: Write it

Route confirmed → create the appropriate artifact:

| Content type | Output |
|-------------|--------|
| Decision, insight, note | `log.md` signed entry |
| Task | `now.md` checkbox + `log.md` entry |
| Person info | Person walnut `log.md` entry |
| New venture/experiment | New walnut scaffolded |
| Reference/binary | `_references/` + companion `.md` |
| Preference | `_scratch/` → worldbuilding skill |

---

## Context Mining

When the worldbuilder brings in bulk content (email export, transcript, document dump), the squirrel guides the extraction:

1. **Assess** — what kind of source is this? What's it likely to contain?
2. **Guide** — "Email archives usually have decisions, people mentions, action items, and project updates. I'll look for all of those."
3. **Extract** — pull structured data: people, decisions, tasks, dates, references
4. **Route** — each extracted item goes through the routing engine
5. **Log the extraction** — create a master doc in `_scratch/`:

```yaml
# _scratch/extraction-[source]-[date].md
type: extraction
source: gmail export
date: 2026-02-20
total-items: 247
indexed: 89
people-found: 12
decisions-found: 23
routed-to:
  - sovereign-systems: 34
  - will-adler: 12
  - alive-gtm: 43
```

The extraction doc tracks what came in, how much was processed, and where it all went. The squirrel picks up crumbs — mentions of other people, references to projects, contextual clues — and logs those too.

---

## New Walnut [[new-walnut]]

When content warrants a new walnut:

```
This needs a new walnut.

  name: will-adler
  type: person
  domain: 02_Life/people/

confirm, or change something?
```

Scaffold:
```
walnut-name/
├── key.md           ← filled from incoming content
├── now.md           ← pre-filled with first context
├── log.md           ← first entry is the incoming content
├── _squirrels/
├── _scratch/
└── _references/
```

The walnut starts rich, not empty. Whatever triggered its creation becomes its first log entry and seeds its key.md.

---

## Companion [[companion]]

For binary files — audio, images, documents, PDFs.

Raw file → `_references/[type]/raw/[name].[ext]`
Companion → `_references/[type]/[name].md`

```yaml
# companion frontmatter
type: audio | image | document | pdf | video
date: 2026-02-16
description: one line
source: where it came from
tags: []
squirrel: 5551126e
```

If transcription is needed (audio, video) and API is configured, transcribe automatically. If not: flag it, prompt setup.
