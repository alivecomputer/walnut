---
name: setup
description: First-time world creation. Triggered automatically when walnut:world detects no existing ALIVE structure.
internal: true
---

# Setup

First time. No ALIVE folders exist. The conductor just installed walnut. Make it feel like something just came alive.

---

## Detection

`walnut:world` checks for `01_Archive/`, `02_Life/`, etc. If none found → this fires.

## Flow

### 1. Welcome

```
╭─ 🐿️ welcome
│
│  No world found. Let's build one.
│
│  This takes about 3 minutes. I'll create the folder structure,
│  set up your first walnut, and get you a walnut.world link
│  if you want one.
│
│  Ready?
╰─
```

### 2. Identity

→ AskUserQuestion: "What should I call you?"
- Just your first name. Used in greetings, not stored publicly.

→ AskUserQuestion: "Where should your world live?"
- Default: current directory
- Other: type a path

### 3. Create ALIVE Structure

```
╭─ 🐿️ building your world...
│
│  ▸ 01_Archive/
│  ▸ 02_Life/
│  ▸ 02_Life/people/
│  ▸ 02_Life/goals/
│  ▸ 03_Inputs/
│  ▸ 04_Ventures/
│  ▸ 05_Experiments/
│  ▸ .claude/rules/ (6 rules installed)
│  ▸ .claude/settings.json (10 hooks installed)
│  ▸ preferences.yaml (defaults)
│
│  Done. Five domains. Your world is alive.
╰─
```

### 4. Context Sources

→ AskUserQuestion: "Where does your existing context live? Pick all that apply."
- Options: ChatGPT, Claude Desktop, Gmail, Slack, Fathom/Otter, Apple Notes, Notion, WhatsApp, None yet
- multiSelect: true

For each selected source, ask for the path or confirm it's an MCP integration.

Create `.claude/world-config.yaml` with the selected sources. Each source gets `indexed: false` — the system knows they're there but hasn't processed them yet.

```
╭─ 🐿️ context sources registered
│
│  ▸ ChatGPT — ~/exports/chatgpt/ (indexed: false)
│  ▸ Gmail — MCP live (active)
│  ▸ Fathom — ~/exports/fathom/ (indexed: false)
│
│  These won't be loaded by default. The system knows they exist
│  and can search them when relevant context might be there.
│  Run walnut:recall to browse them anytime.
╰─
```

### 5. First Walnut

→ AskUserQuestion: "What's the most important thing you're working on right now?"
- Free text. This becomes the first walnut.

→ AskUserQuestion: "Is that a venture (revenue), experiment (testing), or life goal?"
- Routes to the right ALIVE domain.

Create the walnut with `_core/` structure. Pre-fill key.md from their answer.

```
╭─ 🐿️ first walnut created
│
│  ▸ 04_Ventures/nova-station/
│  ▸   _core/key.md — "Build the first civilian orbital platform"
│  ▸   _core/now.md — Phase: starting
│  ▸   _core/log.md — First entry signed
│  ▸   _core/insights.md — Empty, ready
│  ▸   _core/tasks.md — Empty, ready
│  ▸   _core/_squirrels/
│  ▸   _core/_working/
│  ▸   _core/_references/
│
│  Your first walnut is alive.
╰─
```

### 6. walnut.world (Optional)

→ AskUserQuestion: "Want a walnut.world link? It's free — a private space to preview and share your work."
- "Yes" → claim flow
- "Not now" → skip, can do later via walnut:config

If yes:
→ AskUserQuestion: "Pick a name (e.g., your-name.walnut.world)"
→ AskUserQuestion: "Set a keyphrase (like a password — you'll need this to publish)"

Call `/api/name/reserve`. Store `WALNUT_NAME` and `WALNUT_KEYPHRASE` in `.env.local`.

```
╭─ 🐿️ your link is live
│
│  nova-station.walnut.world — claimed and ready.
│  Publish anything with walnut:publish.
╰─
```

### 7. Done

```
╭─ 🐿️ your world is alive
│
│  World: /path/to/your/world
│  First walnut: nova-station (04_Ventures/)
│  Link: nova-station.walnut.world
│
│  9 skills ready:
│    world · open · save · capture · find · housekeeping · config · publish · recall
│
│  Say "open nova-station" to start working.
│  Say "world" anytime to see everything.
│  Say "save" to checkpoint your work.
│
│  Build your world.
╰─
```

---

## What Setup Creates

| Path | Purpose |
|------|---------|
| `01_Archive/` | Graduated walnuts |
| `02_Life/people/` | Person walnuts |
| `02_Life/goals/` | Life goals |
| `03_Inputs/` | Buffer — route out within 48h |
| `04_Ventures/` | Revenue intent |
| `05_Experiments/` | Testing grounds |
| `.claude/rules/` | 6 rules files from plugin |
| `.claude/settings.json` | 10 hooks from plugin |
| `preferences.yaml` | Defaults |
| `.env.local` | WALNUT_NAME + WALNUT_KEYPHRASE (if claimed) |
| `[first-walnut]/_core/` | Full walnut structure |

## What Setup Does NOT Do

- Import existing context (that's calibrate.md — progressive, over 30 days)
- Set up API integrations (that's walnut:config)
- Configure voice (defaults are fine, customize later)
- Create multiple walnuts (one is enough to start)
