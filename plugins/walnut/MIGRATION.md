# Migration Guide

## v3 → v1 (from Unlimited Elephant)

| v3 | v1 | Action |
|---|---|---|
| `_brain/status.md` | `key.md` + `now.md` at root | Split: evergreen → key.md, state → now.md |
| `_brain/changelog.md` | `log.md` at root | Create log.md, changelog becomes chapter-00 |
| `_brain/tasks.md` | Tasks in `now.md` body | Move open tasks to now.md |
| `_brain/insights.md` | Merged into `log.md` | Key insights become log entries |
| `.claude/CLAUDE.md` per walnut | `key.md` at root | Merge identity into key.md |
| `_brain/` folder | Left in place | Stops being read |
| `_working/` | `_scratch/` | Rename |
| `.claude/rules/system.md` | 3 rules files | squirrels.md, world.md, worldbuilder.md |
| squirrel files (.md) | squirrel entries (.yaml) | Format change |
| `/alive:home` | `walnut:world` | Skill rename |
| `/alive:quick-start` | `walnut:open` | Skill rename |
| `/alive:add` | `walnut:add-to-world` | Skill rename |
| owner-operator | worldbuilder | Vocabulary |

## v4 → v1 (from Walnut 4.x (previous))

| v4 | v1 | Action |
|---|---|---|
| `.claude/CLAUDE.md` per walnut | `key.md` at root | Merge identity into key.md |
| `now.md` has type/goal | `key.md` has type/goal | Move evergreen fields to key.md |
| `.claude/rules/system.md` | 3 rules files | squirrels.md, world.md, worldbuilder.md |
| `.claude/rules/references/` | Archived | Folded into the 3 files |
| squirrel files (.md) | squirrel entries (.yaml) | Format change |
| `/alive:*` skills | `walnut:*` skills | Skill rename |
| AskUserQuestion everywhere | Numbered menus | UX change |
| catch to squirrel file | stash in conversation | Mechanic change |
| owner-operator | worldbuilder | Vocabulary |

## Vocabulary

| Stop saying | Start saying |
|---|---|
| entity | walnut |
| user, owner-operator | worldbuilder |
| catch, capture | stash |
| sign-off | close |
| dormant | waiting |
| about.md | key.md |
| /alive:home | walnut:world |
| /alive:quick-start | walnut:open |
| /alive:add | walnut:add-to-world |

## What Stays the Same

- The A.L.I.V.E. framework (01_Archive through 05_Experiments)
- `_references/` structure (companion + raw)
- `_scratch/` for drafts and saves
- Archive convention (01_Archive/ mirroring paths)
- People in `02_Life/people/`
- Inputs buffer at `03_Inputs/`
- Log entries: append-only, signed blocks
- Wikilinks: `[[walnut-name]]`

## Run the Upgrade

```
walnut:world
```

The upgrade skill handles everything automatically. ~5 minutes.
