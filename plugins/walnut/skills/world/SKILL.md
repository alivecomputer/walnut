---
description: See your whole world. Dashboard, attention items, system state detection. Entry point for everything.
user-invocable: true
triggers:
  # Direct
  - "walnut:world"
  - "world"
  - "home"
  - "dashboard"
  # Intent
  - "show me everything"
  - "show me my world"
  - "what do I have"
  - "what's in my world"
  # Status
  - "what's going on"
  - "what needs me"
  - "what needs attention"
  - "status"
  - "overview"
  - "summary"
  # Time-based
  - "start of day"
  - "morning check"
  - "daily review"
  - "what should I work on"
  # Lost/confused
  - "where am I"
  - "what's active"
  - "help me prioritize"
---

# World

See your world. What needs you. What's stale. What's active.

---

## What It Does

Scans `_core/key.md` frontmatter across all walnuts to build the world map. Renders a dashboard with active walnuts, attention items, and system state.

## Load Sequence

1. Find the ALIVE world root (walk up from PWD looking for `01_Archive/` + `02_Life/`)
2. Scan all `_core/key.md` files — extract type, goal, phase, health, rhythm, next, updated
3. Scan all `_core/now.md` files — extract health status and last updated
4. Check for attention items:
   - Walnuts past their rhythm (quiet or waiting)
   - Unsigned squirrel entries across all walnuts
   - `_core/_working/` files older than 30 days
   - `03_Inputs/` items older than 48 hours
5. Surface API context if configured (Gmail, Slack, Calendar)

## State Detection

Before rendering the dashboard, detect system state:

- **Fresh install** (no walnuts exist) → route to setup mode (`world/setup.md`)
- **Stale rules** (plugin version > project rules version) → route to upgrade mode (`world/upgrade.md`)
- **Previous system detected** (v3/v4 `_brain/` folders exist) → route to migration mode (`world/upgrade.md`)
- **Normal** → render dashboard

## Dashboard Layout

```
╭─ 🐿️ Your World
│
│  Active
│   1. berties          production    Review March calendar
│   2. sovereign-systems launching   Cloudflare API setup
│   3. alive-gtm        building     Build v0 beta plugin
│
│  Attention
│   → 3 emails from Will (2 days old)
│   → peptide-calculator quiet for 12 days
│   → _working/ has 4 files older than 30 days
│
│  Waiting
│   4. ghost-protocol    Decide: rewrite or revise
│   5. fangrid           Archive candidate
│
│  number to open, or just chat.
╰─
```

## After Dashboard

- Number → open that walnut (invoke `walnut:open`)
- "just chat" → freestyle conversation, no walnut focus
- "check" → invoke `walnut:check` for system health
- "find X" → invoke `walnut:find`

## Internal Modes

These have their own .md files in this skill directory. They are NOT separately invocable — they trigger automatically based on state detection.

- `setup.md` — first-time world creation
- `calibrate.md` — progressive 30-day context extraction
- `upgrade.md` — version migration from previous systems
