---
skill: world
version: 1.0.0
user-invocable: true
description: World dashboard and main entry point. Shows actionable surface — walnuts, attention items, emails, people, inputs. Smart about figuring out what the worldbuilder needs.
triggers: [world, dashboard, morning, what's up, start my day, what should I work on, show me everything, where are we, what's happening, check email, check slack, this week, goals, people]
surfaces: [world]
sub-skills: [setup, calibrate, upgrade, tend, find, all]
requires-apis: []
optional-apis: [gmail, slack]
---

# World

The front door to everything. Not a dashboard — an intelligence surface.

The squirrel reads the system, pulls from APIs if available, and shows the worldbuilder what needs their attention right now. Then gets out of the way.

---

## Boot Sequence

Session-start hook has already run. Read its output for system state.

### State Detection

| State | Detected By | Route To |
|-------|-------------|----------|
| `fresh` | No `.claude/CLAUDE.md` | → [[setup]] |
| `v3` | v3 rules found | → [[upgrade]] |
| `v4` | system.md present, no key.md | → [[upgrade]] |
| `v1` | squirrels.md + world.md + worldbuilder.md | → Actionable surface |

---

## The Actionable Surface

This is what the worldbuilder sees on a normal boot. Three layers: walnuts, attention, actions.

### Layer 1: Top Walnuts

Scan all `now.md` across the World (excluding 01_Archive/, .claude/, templates/, _scratch/). Read `rhythm:` from `key.md` to calculate health. Show the 3 highest-signal walnuts:

```
your world — feb 20

  1. alive-gtm         building · next: test upgrade flow
  2. sovereign-systems  launching · next: rebuild site           quiet
  3. 02_Life            active · next: visa research
```

### Layer 2: Attention

This is the intelligence. Pull from everywhere available:

**System state:**
- Unsigned squirrel entries (loose threads from previous sessions)
- Inputs pending triage in `03_Inputs/`
- Walnuts past their rhythm (quiet or waiting)
- Scratch docs unchanged > 30 days

**People:**
- People walnuts with stale context (haven't been updated in a while)
- People referenced in recent sessions but with thin walnuts
- If someone close hasn't had any context logged recently: "worth reaching out to [[name]]?"

**APIs (if configured):**
- **Gmail:** Unread emails from people who have walnuts. Emails containing decisions, action items, or references to active ventures. Surface the sender and a one-line preview — don't dump full emails.
- **Slack:** Messages from synced channels. Unread threads mentioning active walnuts or known people.
- **Calendar (future):** Meetings today/tomorrow with links to relevant walnuts.

**Render the attention block only if there's something worth showing:**

```
  ── attention ──
  2 unsigned entries in alive-gtm
  3 emails from Attila (Gmail) — one mentions manifesto
  sovereign-systems quiet 5 days (rhythm: daily)
  [[will-adler]] no context logged in 12 days
  1 scratch doc stale: naming-brief (30+ days)
```

If nothing needs attention, skip this block entirely. Don't show an empty section.

### Layer 3: Actions

```
  4. open a walnut    5. add something    6. tend
  7. check email      8. check slack      9. see all

what do you want to do?
```

Only show API actions (check email, check slack) if those APIs are configured. Don't advertise what isn't available.

The worldbuilder types a number, a walnut name, or just says what they want. Freestyle.

---

## Intent Recognition

The worldbuilder doesn't always want the dashboard. The skill should read intent from how they opened it:

| What they say | What fires |
|---------------|-----------|
| "world" / "what's up" / "morning" | Full actionable surface |
| "check email" / "any emails?" | Gmail scan → surface relevant emails → route via add-to-world |
| "check slack" | Slack sync → parse → surface → route |
| "this week" / "what's my week" | Goal-oriented view: deadlines, meetings, tasks across all walnuts |
| "people" / "who needs attention" | People walnuts sorted by staleness + recent mentions |
| "goals" / "big picture" | Life walnut goals → venture progress → experiment status |
| "import chatgpt" / "bring in context" | Route to [[calibrate]] |
| "tend" / "health check" | Route to [[tend]] |
| "how does this work" | Guided tour of the system (especially for new users post-setup) |

Don't force the worldbuilder through the dashboard to get to what they want. If they say "check email," go straight there.

---

## Health Calculation

Based on `rhythm:` in key.md. Default `weekly` if not set.

| Signal | Meaning |
|--------|---------|
| active | Within rhythm |
| quiet | 1–2x past rhythm |
| waiting | 2x+ past rhythm |
| `*` | Unsigned squirrel entry |

Applies to endeavors only. People show `last updated` — nudge for context gaps, not health judgment.

---

## Signal Priority

What surfaces first in the top 3 and attention block:

1. **Unsigned entries** — loose threads, highest urgency
2. **Time-sensitive next actions** — deadlines, meetings, expiring items
3. **API signals** — emails from known people, slack messages
4. **Rhythm violations** — walnuts past their cadence
5. **People gaps** — close contacts without recent context
6. **Stale scratch** — work that's sitting idle

---

## API Integration

### Gmail (optional)

If Gmail MCP is configured:
- Scan for unread emails from people with walnuts
- Scan for emails mentioning active venture names
- Surface sender + one-line subject/preview
- On "check email": full scan, present as numbered list, route via add-to-world

The squirrel doesn't dump emails into the World automatically. It surfaces them. The worldbuilder decides what enters.

### Slack (optional)

If Slack sync script (`.claude/scripts/slack-sync.mjs`) is configured:
- Run sync to pull latest from watched channels
- Parse for mentions of known people, active walnuts, decisions, tasks
- Surface relevant messages in the attention block

### Future APIs

Calendar, WhatsApp, Telegram, Fathom — same pattern. Surface relevant signals. Worldbuilder routes what matters. The World gets smarter as more APIs connect.

---

## Sub-skills

### [[setup]]
First-time World creation. Folder structure, identity, voice, brand, first walnut, aha moment. See `setup.md`.

### [[calibrate]]
Progressive world-building. Maps context sources, guides extraction one at a time, tracks coverage as a percentage. The game is watching the number go up. See `calibrate.md`.

### [[upgrade]]
v3/v4 → v1 migration. System files, walnut conversion, cleanup. See `upgrade.md`.

### [[tend]]
System health check. Surfaces violations one at a time as numbered options. Never auto-fixes.

Checks:
- `_scratch/` unchanged > 30 days
- Binary files without companions
- Broken `[[wikilinks]]`
- Unsigned entries > 3 days old
- Missing frontmatter fields
- `now.md` timestamp older than last `log.md` entry
- People with stale context

### [[find]]
Search the World. Frontmatter first (fast), then log summaries, then bodies on demand. Results as numbered options. Searches archive too — nothing is truly gone.

### [[all]]
Full World view. Every walnut in every domain. Grouped by type, filterable by health, last activity, domain. People listed separately with last-updated dates.

---

## After Choosing

| Choice | Route |
|--------|-------|
| Walnut by name or number | `walnut:open` on that walnut |
| "add" / paste content | `walnut:add-to-world` |
| "tend" | [[tend]] flow |
| "find" / search query | [[find]] |
| "all" | [[all]] full list |
| "calibrate" / "import" | [[calibrate]] |
| "check email" | Gmail scan → numbered list → add-to-world |
| "check slack" | Slack sync → numbered list → add-to-world |
| "goals" / "big picture" | Goal view across Life → Ventures → Experiments |
| "people" | People view sorted by staleness |
| Anything else | Freestyle — the squirrel figures it out |

---

## Design Principles

**Fast.** The actionable surface should render in under 5 seconds. Frontmatter scans, not full file reads. API calls only if configured and fast.

**Smart.** Don't just list walnuts. Tell the worldbuilder what needs attention and why. "Sovereign-systems quiet 5 days (rhythm: daily)" is more useful than just showing a health icon.

**Honest.** If nothing needs attention, say so. Don't manufacture urgency. "Your world is quiet today" is a valid state.

**Progressive.** Day 1 the surface is simple — a few walnuts, basic health. Day 30 with Gmail and Slack connected, it's pulling in emails, people signals, calendar context. The World gets smarter as more sources connect. Same skill, richer surface.
