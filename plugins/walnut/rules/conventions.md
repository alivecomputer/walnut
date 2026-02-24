---
version: 0.2.0-beta
type: foundational
description: File naming, version progression, working folder lifecycle, reference types, cleanup conventions.
---

# Conventions

The boring infrastructure that prevents entropy. Every file follows these. No exceptions.

---

## File Naming

### Working Files (_core/_working/)

Pattern: `[context]-[name]-v0.x.md`

Anyone reading the filename knows what it is and where it belongs.

```
launch-checklist-v0.1.md
orbital-safety-brief-v0.2.md
festival-submission-v0.3.md
```

### References (_core/_references/)

Pattern: `YYYY-MM-DD-descriptive-name.ext`

```
2026-02-23-kai-shielding-review.md        ← companion
2026-02-23-kai-shielding-review.mp3        ← raw (in raw/ subfolder)
2026-02-20-vendor-proposal.pdf
```

### Raw File Renaming

Garbage filenames get renamed on import. The original name is preserved in the companion frontmatter as `original_filename:`.

| Before | After |
|--------|-------|
| `CleanShot 2026-02-23 at 14.32.07@2x.png` | `2026-02-23-competitor-pricing-screenshot.png` |
| `IMG_4892.jpg` | `2026-02-20-prototype-photo.jpg` |
| `Document (3).pdf` | `2026-02-18-vendor-proposal-v3.pdf` |

### Companion Files

Same name as the raw file, `.md` extension. Lives alongside the raw file's parent directory (not inside `raw/`).

```
_references/transcripts/
  2026-02-23-kai-shielding-review.md      ← companion
  raw/
    2026-02-23-kai-shielding-review.mp3   ← raw
```

---

## Version Progression

### The Lifecycle

```
v0.1  →  v0.2  →  v0.x  →  v1 (graduation)
draft    iterated  refined   shareable
```

- **v0.x** lives in `_core/_working/`. The squirrel's workspace. Nobody outside sees it.
- **v1** is shareable. Promoted OUT of `_core/_working/` to live context (outside `_core/`). This is the graduation moment — when a working file is ready to send to another human.
- **v1+** can be previewed/published via `walnut:publish`.

### Before Iterating

Every version after v0.1 gets version frontmatter documenting what changed:

```yaml
---
squirrel: 2a8c95e9
model: claude-opus-4-6
version: v0.3
previous: v0.2
kept: [structure, key sections, tone]
changed: [too long — cut by 40%, added regulatory section, removed speculation]
---
```

Never iterate without reflecting. The frontmatter forces the question: what worked, what didn't, what's different this time?

### Promotion

When a working file graduates to v1:

1. Move/copy from `_core/_working/` to its proper location in live context
2. Update version frontmatter to `v1`
3. Log entry: "Promoted [name] to v1"
4. Optionally: preview/publish via `walnut:publish`

---

## Working Folder Management

### _core/_working/ is a Hot Desk

Things move through it, not accumulate. It's a workspace, not a filing cabinet.

### Folder Graduation

When `_core/_working/` accumulates related files:

- **3+ related files with shared prefix** → graduate to a proper folder with README
- **Versioned files (v1, v2, v3)** → graduate to a folder

```
# Before
_working/
  nova-safety-research-v0.1.md
  nova-safety-checklist-v0.1.md
  nova-safety-regs-v0.1.md

# After
_working/
  nova-safety/
    README.md
    research-v0.1.md
    checklist-v0.1.md
    regs-v0.1.md
```

### Stale Drafts

Working files unchanged for 30+ days are surfaced by `walnut:check`:
- **Promote** → graduate to v1, move to live context
- **Archive** → move to `01_Archive/`
- **Kill** → delete (the only place deletion is acceptable — drafts are disposable)

---

## Reference Conventions

### Three-Tier Access

1. **Index** — `key.md` references field (rolling 30 most recent). Scan to know what exists.
2. **Companion** — `.md` file with type-specific frontmatter. Read to understand contents.
3. **Raw** — the actual file. Load only on explicit request.

The squirrel reads tier 1 at open, tier 2 on demand, tier 3 only when specifically asked.

### Type-Specific Frontmatter

Every companion has frontmatter matching its content type:

| Type | Required fields |
|------|----------------|
| email | from, to, subject, date |
| transcript | participants, duration, platform, date |
| screenshot | source, analysis, date |
| document | author, source, date |
| message | from, platform, date |
| article | author, publication, url, date |
| research | topic, sources, squirrel, date |

All companions also include: `type`, `squirrel`, and optionally `original_filename`.

### Reference Organisation

```
_core/_references/
  index.md              ← full list (projection, auto-generated)
  transcripts/
    raw/
    [companions]
  emails/
    raw/
    [companions]
  documents/
    raw/
    [companions]
  screenshots/
    raw/
    [companions]
  research/
    [companions only — no raw for in-session research]
```

---

## Frontmatter on Everything

Every `.md` file in the system has YAML frontmatter. No exceptions.

- System files (key.md, now.md, log.md, insights.md, tasks.md) — schema defined in world.md
- Working files — squirrel, model, version, previous, kept, changed
- Companions — type-specific fields + squirrel
- Rules — version, type, description
- Skills — name, description, triggers

The frontmatter is the scannable layer. A squirrel reads frontmatter before bodies. If a file doesn't have frontmatter, it's malformed.

---

## Signing

Every file the squirrel creates or modifies carries attribution:

- `squirrel: [session_id]` — which session created/modified it
- `model: [engine]` — which AI model was running

Log entries are additionally signed at the end: `signed: squirrel:[session_id]`

Squirrel entries carry the full metadata: session_id, runtime_id, engine, walnut, timestamps.
