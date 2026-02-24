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

This is Mission Control. When the conductor opens their world, it should feel like booting an operating system — everything they care about, at a glance, with clear paths to action.

NOT a database dump. NOT a flat list. A living view of their world, grouped by what matters, showing relationships, surfacing what needs attention.

---

## Load Sequence

1. Find the ALIVE world root (walk up from PWD looking for `01_Archive/` + `02_Life/`)
2. Scan all `_core/key.md` files — extract type, goal, phase, health, rhythm, next, updated, people, links, parent
3. Scan all `_core/now.md` files — extract health status, last updated, next action
4. Build the tree — parent/child relationships from `parent:` field in key.md
5. Compute attention items
6. Surface API context if configured (Gmail, Slack, Calendar via world-config.yaml)

## State Detection

Before rendering, detect system state:

- **Fresh install** (no walnuts exist) → route to `setup.md`
- **Stale rules** (plugin version > project rules version) → route to `upgrade.md`
- **Previous system detected** (v3/v4 `_brain/` folders exist) → route to `upgrade.md`
- **Normal** → render dashboard

---

## Dashboard Layout

The dashboard has 4 sections. Each tells the conductor something different.

### Section 1: Right Now

What needs you TODAY. Not everything — just what's active and demanding.

```
╭─ 🐿️ your world
│
│  RIGHT NOW
│  ──────────────────────────────────────────────
│
│   1. alive-gtm              building
│      Next: Test plugin install end-to-end
│      Last: 2 hours ago · 6 sessions this week
│
│   2. sovereign-systems       launching
│      Next: Set up Cloudflare API for DNS
│      Last: 2 days ago
│      People: Will Adler, Attila Mora
│
│   3. supernormal-systems     legacy
│      Next: Send 9 client email drafts
│      ⚠ 4 days past rhythm
│
╰─
```

Only show walnuts that are `active` or past their rhythm. Sort by most recently touched. Show:
- Phase
- Next action (from now.md)
- Last activity (relative time)
- People involved (from key.md — max 2-3 names)
- Warning if past rhythm

### Section 2: Attention

Things that need the conductor's decision or action. Not walnuts — specific issues.

```
╭─ 🐿️ attention
│
│   → 3 unread emails from Will (Gmail, 2 days)
│   → Unsigned session on alive-gtm (squirrel:a3f7, 6 stash items)
│   → 03_Inputs/ has 2 items older than 48 hours
│   → peptide-calculator quiet for 12 days (rhythm: weekly)
│   → 4 working files older than 30 days across 3 walnuts
│
╰─
```

Sources:
- API context (Gmail unread, Slack mentions, Calendar upcoming)
- Unsigned squirrel entries with stash items
- Inputs buffer > 48 hours
- Stale walnuts (quiet/waiting)
- Stale working files

### Section 3: Your World (the tree)

The full structure — grouped by ALIVE domain, with parent/child nesting visible.

```
╭─ 🐿️ your world
│
│  LIFE
│   identity           active     XRP panel Feb 27
│   health             quiet      ADHD diagnosis
│   people/
│     will-adler       updated 2 days ago
│     attila-mora      updated 1 day ago
│     clara            updated 5 days ago
│
│  VENTURES
│   sovereign-systems  launching  Cloudflare API
│     └ walnut-plugin  building   Test install
│   supernormal        legacy     Client emails
│   hypha              quiet      Podcast landing
│
│  EXPERIMENTS
│   alive-gtm          building   Test plugin
│   ghost-protocol     waiting    Decide: rewrite or revise
│   peptide-calculator quiet      ⚠ 12 days
│   zeitgeist          quiet      Simplify countdown
│   ... +6 more (3 waiting, 3 quiet)
│
│  INPUTS
│   2 items (oldest: 4 days)
│
│  ARCHIVE
│   1 walnut (fangrid)
│
╰─
```

Key features:
- **Grouped by ALIVE domain** — not a flat list
- **Parent/child nesting** — sub-walnuts indented under parents with `└`
- **People** shown under Life with last-updated
- **Collapse quiet/waiting** — if there are 6+ quiet experiments, show the count not the full list
- **Inputs count** — just how many and how old
- **Archive count** — just the number
- **5-day activity indicator** — `●` dot for each of the last 5 days the walnut was touched. Visual pulse at a glance.

```
│   alive-gtm          ●●●●● building   Test plugin
│   sovereign-systems  ●●○○○ launching   Cloudflare API
│   ghost-protocol     ○○○○○ waiting     Decide: rewrite or revise
```

`●` = touched that day. `○` = no activity. Read left to right: today, yesterday, 2 days, 3 days, 4 days. Five dots tells you this walnut is hot. Zero tells you it's cold. No numbers, no dates — just a visual heartbeat.

### Section 4: Recent Squirrel Activity

What's been happening across the world. A pulse check.

```
╭─ 🐿️ recent activity
│
│   Today     alive-gtm         6 sessions · shipped v0.1-beta
│   Yesterday alive-gtm         rebuilt architecture, 22 decisions
│   Feb 22    walnut-world      infrastructure, KV, DNS
│   Feb 22    alive-gtm         companion app, web installer
│   Feb 21    alive-gtm         plugin refactor, ecosystem plan
│
│   5 sessions this week · 3 walnuts touched · 47 stash items routed
│
╰─
```

---

## Rendering Rules

1. **Right Now comes first.** Always. It answers "what should I work on?"
2. **Attention is actionable.** Every item should have a clear next step.
3. **The tree is scannable.** Indent sub-walnuts. Collapse where sensible. Show people under Life.
4. **Recent activity gives pulse.** Not details — just "what's been happening."
5. **Numbers for navigation.** Any walnut with a number can be opened by typing the number.
6. **Don't show everything.** Waiting walnuts can be collapsed. Quiet experiments get a count. The conductor asks for more if they want it.

---

## After Dashboard

- **Number** → open that walnut (invoke `walnut:open`)
- **"just chat"** → freestyle conversation, no walnut focus
- **"housekeeping"** → invoke `walnut:housekeeping`
- **"find X"** → invoke `walnut:find`
- **"recall"** → invoke `walnut:recall`
- **"open [name]"** → open a specific walnut
- **Attention item** → address it directly ("deal with those emails", "sign that session")

---

## API Context (world-config.yaml)

If the conductor has configured context sources in `.claude/world-config.yaml`, surface relevant items:

- **Gmail (MCP live):** Unread count, recent senders, anything flagged
- **Slack (sync script):** Unread mentions, DMs
- **Calendar (MCP live):** Today's events, upcoming deadlines
- **Other sources:** Only if they have new/relevant items

Only show API context that's actionable. "3 unread emails from Will" is useful. "You have 847 emails" is not.

Filter API context by walnut scoping — only show sources relevant to active walnuts (from world-config.yaml `walnuts:` field).

---

## Internal Modes

These have their own .md files in this skill directory. They are NOT separately invocable — they trigger automatically based on state detection.

- `setup.md` — first-time world creation
- `calibrate.md` — progressive 30-day context extraction
- `upgrade.md` — version migration from previous systems
