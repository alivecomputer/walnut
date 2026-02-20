---
sub-skill: setup
parent: world
description: First-time World creation. Triggers when World detects no ALIVE folder structure.
---

# Setup

Triggers automatically when `walnut:world` opens and no World structure exists.

---

## Flow

### 1. Welcome

```
Your World is empty. Let's build it.

This takes about 10 minutes. After that, you have a working system
that grows with every session.
```

### 2. Identity

```
First — who are you?

  1. just my name
  2. full profile (goals, constraints, what matters)
```

Capture name at minimum. If full profile, guide through goals, constraints, key patterns. This seeds the world-level CLAUDE.md and `02_Life/key.md`.

### 3. Folder Structure

Create the ALIVE framework:

```
World/
├── .claude/
│   ├── CLAUDE.md       ← from templates/world/CLAUDE.md, filled
│   ├── rules/
│   │   ├── squirrels.md
│   │   ├── world.md
│   │   └── worldbuilder.md
│   ├── apis/
│   └── brand/
├── 01_Archive/
├── 02_Life/
│   ├── key.md
│   ├── now.md
│   ├── log.md
│   ├── _squirrels/
│   ├── _scratch/
│   └── people/
├── 03_Inputs/
├── 04_Ventures/
└── 05_Experiments/
```

No questions needed — just create it. Show the tree.

Rules are copied from the plugin source into `.claude/rules/`.

### 3b. Path Setup (automatic)

Always create symlinks. No question, just do it:

```bash
# iCloud Drive shortcut (no more escaping spaces)
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ~/icloud

# World shortcut
ln -s ~/icloud/world ~/world
```

```
  ~/world is ready.

  from now on: cd ~/world && claude
  that's it. that's the entry point.
```

This is non-optional. Every worldbuilder gets `~/world` from day one.

### 4. Voice (optional)

```
Want to set your voice? This controls how your squirrel talks.

  1. warm and direct (default — Qui-Gon energy)
  2. let me customize
  3. skip for now
```

If customize: guide through character, tone, never-say list. Write to `.claude/voice.yaml`.

### 5. Brand (optional)

```
Want to set up your visual identity? Controls how shared documents look.

  1. yes — pick colors, fonts, style
  2. skip — use defaults
```

If yes: accent color, style preset (warm/minimal/bold/dark), logo. Write to `.claude/brand/config.yaml`.

### 6. First Walnut

```
What's the first thing you want to build context around?

  1. a business or project (venture)
  2. a person who matters
  3. something I'm experimenting with
  4. just explore — I'll add things as I go
```

Scaffold using walnut templates (key.md, now.md, log.md). Fill from what they describe. First log entry: "Walnut created."

### 7. The Aha Moment

Before finishing, give them a taste of what the system can do:

```
Your first walnut is set up. Want to see something?

Paste any text — an email, a note, anything — and I'll show you
how the system processes it.
```

If they paste: run it through add-to-world routing. Show them the extraction, the routing suggestion, the log entry it would create. Then offer to save it or skip.

This is the moment they feel it work.

### 8. Handoff

```
Your World is ready.

  walnut:world     see everything
  walnut:open      work on something
  walnut:close     save and sign off

Next time you open, I'll help you bring in your existing context —
emails, calls, old chats, whatever you've got.
```

Route to dashboard. Calibration begins next session.

---

## What Gets Created

| File | Content |
|------|---------|
| `.claude/CLAUDE.md` | World identity — name, goals |
| `.claude/rules/*.md` | Three rules files (copied from plugin) |
| `.claude/voice.yaml` | Voice config (if set up) |
| `.claude/brand/config.yaml` | Visual identity (if set up) |
| `02_Life/key.md` | Worldbuilder profile — name, goals |
| `02_Life/now.md` | Life current state |
| `02_Life/log.md` | First entry: "World created" |
| First walnut | key.md, now.md, log.md filled from setup |
| Folder structure | All 5 ALIVE domains |

---

## Design Notes

Fast. 10 minutes max. Don't over-ask. Get them in, let calibrate handle depth. The World should feel ready at the end. The aha moment at step 7 is what hooks them.
