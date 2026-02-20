---
rule: world
version: 0.1.0
description: How worlds are built — walnut structure, ALIVE domains, conventions.
---

# World

A World is an ALIVE folder system on the worldbuilder's machine. Every file has frontmatter. Every folder has purpose. Nothing gets deleted. Everything progresses.

---

## Foundational

These are the physics. They don't change.

### The Walnut

Three files:

| File | What it holds | Changes |
|------|---------------|---------|
| `key.md` | What it is — people, specs, evergreen | Rarely |
| `now.md` | Where it is — phase, next action, open tasks | Every close |
| `log.md` | Where it's been — signed entries, prepend-only | Every close |

Supporting folders:

- `_squirrels/` — session entries (.yaml)
- `_scratch/` — drafts, saves, preferences
- `_chapters/` — closed log chapters
- `_references/` — source material + companions

Any type can be a Walnut: venture, person, campaign, experiment, life area, project. Type lives in `key.md`.

### ALIVE

Five domains. The letters are the folders.

| | Folder | Purpose |
|-|--------|---------|
| **A** | `01_Archive/` | Everything that was. Mirror paths. Graduation, not death. |
| **L** | `02_Life/` | Personal. Goals, people, patterns. The foundation. |
| **I** | `03_Inputs/` | Buffer only. Content arrives, gets routed out. Never work here. |
| **V** | `04_Ventures/` | Revenue intent. |
| **E** | `05_Experiments/` | Testing grounds. |

Life is the foundation. Ventures and experiments serve life goals.

### Frontmatter

YAML on everything. The scannable layer. A squirrel reads frontmatter before loading the body.

**key.md:**
```yaml
type: venture | person | campaign | experiment | life | project
goal: one sentence
created: 2026-01-15
rhythm: weekly  # daily | weekly | fortnightly | monthly | custom: 5d
people:
  - name: Will Adler
    role: advisor
    email: will@example.com
tags: []
links: [[other-walnut]]
references: []  # index of _references/ contents
```

**now.md:**
```yaml
phase: one word
health: active | quiet | waiting
updated: 2026-02-20T14:00:00
next: single concrete action
squirrel: 5551126e
```

**log.md:**
```yaml
walnut: name
created: 2026-01-15
last-entry: 2026-02-20T14:00:00
entry-count: 147
summary: one sentence
```

### Log

Prepend-only. Newest entry goes right after frontmatter. Every entry is signed.

```markdown
## 2026-02-20T14:00:00 — squirrel:5551126e

[content — decisions, work done, insights]

signed: squirrel:5551126e
```

Open the file, see what happened last. No scrolling. Wrong entry? Add a correction above it. Never edit history.

At 50 entries or phase close → chapter. Best Of synthesis moves to `_chapters/chapter-[nn].md`. Log continues fresh.

### Archive

Never delete. Mirror the original path into `01_Archive/`.

```
Active:   04_Ventures/old-project/
Archived: 01_Archive/04_Ventures/old-project/
```

Archive is graduation. The walnut served its purpose. It's still indexed — find still searches it, wikilinks still resolve. Just not on the daily dashboard.

### Don'ts

1. **Don't work in `03_Inputs/`.** Route first, then work.
2. **Don't delete.** Archive.
3. **Don't edit log history.** Correct forward.
4. **Don't store secrets in files.** Keys in env vars.
5. **Don't iterate without reflecting.** Every version knows why it exists.

---

## Functional

Conventions with sensible defaults. Customizable via `preferences.yaml`.

### Scratch

Three things live here:

1. **Drafts** — v0.1, v0.2, progressing toward shareable
2. **Saves** — great responses, framings, outputs worth keeping verbatim
3. **Preferences** — "always do X" → routed to worldbuilding skill

Single version = file. Two versions = folder with README.

Before iterating: what worked, what didn't, what changes.
```yaml
version: v0.2
previous: v0.1
kept: [structure, tone]
changed: [too long, missing section]
```

**Everything progresses.** v0 is a draft. v1 is shareable — HTML, PDF, email, link. The aha moment is turning a v0 into something you can send someone. Scratch unchanged for 30 days gets surfaced.

### People

Every person who matters has a walnut in `02_Life/people/`. Same structure — key.md, now.md, log.md. Cross-reference via `[[name]]`. The person's walnut is the source of truth — don't duplicate person context across other walnuts.

### Connections

`[[walnut-name]]` links walnuts together. Use in key.md `links:` field and inline in log entries.

Worlds collide. People appear across ventures. Insights from one experiment feed another. The links are the connective tissue.

### References

Binary files always have a companion `.md`. Three tiers: frontmatter (scan) → companion body (read) → raw file (deep). Name files: `YYYY-MM-DD-description.ext`.

Each reference indexed in key.md under `references:` — type, date, one-line description. The squirrel reads key.md to know what references exist without scanning the filesystem.

---

## Optional

### Health Signals
`preference: health_signals (default: true)`

Applies to endeavors (ventures, experiments, campaigns). Based on `rhythm:` config in key.md.

| Signal | Meaning |
|--------|---------|
| active | Within rhythm |
| quiet | 1–2x past rhythm |
| waiting | 2x+ past rhythm |

**People** don't get health signals. They show `last updated` in frontmatter. If someone close hasn't had a context update in a while, the squirrel nudges — "worth reaching out?" Not a judgment. A prompt.

### Health Nudges
`preference: health_nudges (default: true)`

When a walnut goes quiet or waiting, the squirrel surfaces it proactively. Can be disabled if the worldbuilder prefers to check manually.
