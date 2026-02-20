---
name: walnut
version: 0.1.0
codename: Walnut
description: The world's first alive computer. Open source context infrastructure that lives on your machine.
author: Alive Computer
homepage: https://alivecomputer.com
repository: https://github.com/alivecomputer/walnut
community: https://skool.com/worldbuilders
license: MIT
---

# Walnut 0.1

Build Your World.

## Skills

| Skill | Command | Invocable | Description |
|-------|---------|-----------|-------------|
| World | `walnut:world` | Yes | World dashboard — boot, health, tend, find |
| Open | `walnut:open` | Yes | Single-Walnut focus — load context, work |
| Close | `walnut:close` | Yes | Review stash, route items, close |
| Add to World | `walnut:add-to-world` | Yes | Smart routing — content finds its place |
| Build | `walnut:build` | Yes | Customize — preferences, configs, skills, plugins |

Sub-skills (invoked by master skills):
- **setup** — first-time World creation (World)
- **upgrade** — v3/v4 → v1 migration (World)
- **calibrate** — progressive world-building, 30 days (World)
- **tend** — system health check (World)
- **find** — search the World (World)
- **route** — content routing to Walnuts (Add to World)
- **new-walnut** — scaffold a new Walnut (Add to World)
- **companion** — .md companions for binary (Add to World)
- **prototyper** — markdown → styled HTML (Open)

## Rules

| File | Purpose |
|------|---------|
| `rules/squirrels.md` | How the agent works — open, stash, close |
| `rules/world.md` | How worlds are built — structure, conventions |
| `rules/worldbuilder.md` | How the system serves the human |

Setup/upgrade copies rules into the project's `.claude/rules/` where Claude Code loads them.

## Hooks

| Hook | Event | Type | Purpose |
|------|-------|------|---------|
| Session Start | SessionStart | command | Detect World, set Squirrel ID, create .yaml entry, detect version |
| Log Guardian | PreToolUse (Edit) | prompt | Block edits to signed log.md entries |
| Archive Enforcer | PreToolUse (Bash) | prompt | Block file deletion — suggest archive |
| Compaction Save | PreCompact | prompt | Dump stash to squirrel entry before memory shrinks |

Hooks fire from the plugin cache. No copying needed.

## Walnut Structure

```
walnut-name/
├── key.md              ← what it is (evergreen, people, specs)
├── now.md              ← where it is (phase, next, tasks)
├── log.md              ← where it's been (signed entries)
├── _squirrels/         ← session entries (.yaml)
├── _scratch/           ← drafts, saves, preferences
├── _chapters/          ← closed log chapters
└── _references/        ← source material + companions
```

## Plugin vs Project

| Feature | Plugin Cache | Project `.claude/` |
|---------|-------------|-------------------|
| Skills | Provided | Not needed |
| Hooks | Fire from cache | Not needed |
| Rules | Source files | **Copied** by setup/upgrade |
| CLAUDE.md | Plugin identity | **Generated** by setup/upgrade |

## Directory Structure

```
walnut/
├── CLAUDE.md
├── PLUGIN.md
├── MIGRATION.md
├── LICENSE
├── rules/
│   ├── squirrels.md
│   ├── world.md
│   └── worldbuilder.md
├── skills/
│   ├── world/        (SKILL.md, setup.md, calibrate.md, upgrade.md)
│   ├── open/         (SKILL.md)
│   ├── close/        (SKILL.md)
│   ├── add-to-world/ (SKILL.md)
│   └── build/        (SKILL.md, references/, examples/)
├── templates/        (walnut, world, scratch, chapter, companion,
│                      squirrel, organisational, prototyper, brand, api)
├── hooks/            (hooks.json)
└── scripts/          (session-start.sh)
```

## Installation

```
claude plugin install alivecomputer/walnut
```

Restart Claude Code. Open your ALIVE folder. `walnut:world`.
- **New:** Setup triggers automatically.
- **v3/v4:** Upgrade triggers automatically.

## Philosophy

1. No ads on ALIVE. Ever.
2. Fork it. Open source.
3. Consistency is the moat.
4. Local-first, always.
5. Do it in the system.
