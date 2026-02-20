---
skill: worldbuilding
version: 0.1.0
user-invocable: true
description: Build your world. Use when the worldbuilder wants to personalize their system — preferences, configs, voice, APIs, custom skills, key.md fields, plugins. Also activates semantically when customization intent is detected.
triggers: [worldbuilding, build my world, customize, personalize, I want it to, make it always, can we change, I want a skill that, build a plugin, create a skill, when I do X it should Y, preferences, settings, connect, API, config]
sub-skills: []
requires-apis: []
---

# Build

The worldbuilder's customization surface. Not invoked directly — the squirrel recognizes when the worldbuilder is trying to change how the system works and activates this.

---

## What This Covers

Everything about making the system yours:

- **Understanding what you can change** — rules, preferences, configs, voice, rhythm
- **Changing it** — preferences.yaml, key.md fields, walnut-level configs
- **Building new workflows** — custom skills that automate repeatable processes
- **Connecting APIs** — Gmail, Slack, calendar, any service the worldbuilder uses
- **Key.md customization** — adding custom fields, people details, tags, whatever the walnut needs
- **System audit** — "how am I using this? what could work better?"
- **Publishing** — packaging a skill or config as a plugin for the marketplace

---

## The Spectrum

Four levels of customization. The squirrel figures out which one fits:

| Level | What it is | Where it lives | Example |
|-------|-----------|----------------|---------|
| **Preference** | A behavioral toggle | `preferences.yaml` | turn off the spark, disable health nudges |
| **Config** | A structured setting | `.claude/` or `key.md` | voice, rhythm, API connections, custom key.md fields |
| **Skill** | A repeatable workflow | `.claude/skills/[name]/` | "when I paste a transcript, extract action items" |
| **Plugin** | A distributable package | standalone repo | a social media manager for all worldbuilders |

Most customization is preferences or config. Skills are for multi-step workflows. Plugins are for sharing with others.

---

## When This Activates

The squirrel picks up on semantic intent:

- "I want it to always do X" → preference or config
- "Can we change how close works?" → preference (it's a toggle in preferences.yaml)
- "Every time I paste an email, I want it to..." → skill
- "How do I connect Gmail?" → config (API setup)
- "I need a field for billing dates in my client walnuts" → config (key.md custom fields)
- "How am I using this system?" → audit
- "Build me something other people can use" → plugin

If intent is unclear, explain the options:

```
that could be a few things:

  1. preference — toggle a behavior on or off
  2. config — change a setting (voice, rhythm, API, key.md fields)
  3. skill — automate a repeatable workflow
  4. plugin — package something for other worldbuilders

which feels right? or just describe what you want.
```

---

## Level 1: Preference

Toggle a behavior in `preferences.yaml`. Takes effect next session.

```yaml
# .claude/preferences.yaml
spark: false           # no proactive observation on open
health_nudges: false   # don't surface quiet/waiting walnuts
```

Show what changed. Done.

---

## Level 2: Config

### Voice & Style
Write or update YAML config:

```yaml
# .claude/voice.yaml (or walnut-level)
character: qui-gon
sage: 70
rebel: 30
never_say: ["Great question!", "Absolutely!"]
```

### API Connections
Set up API integration at `.claude/apis/[service].yaml`:

```yaml
service: gmail
key-env: GMAIL_API_KEY
configured: 2026-02-21
use-for: [email scanning, contact sync]
```

Guide the worldbuilder through: what service, what it needs (env var for key), test the connection, confirm it works. Once connected, skills and walnut:world can use it automatically.

### Key.md Custom Fields
Worldbuilders can add any fields they need to key.md:

```yaml
# key.md for a client walnut
type: venture
goal: deliver Q1 campaign
billing:
  rate: 150/hr
  invoice-day: 1st
  currency: AUD
contract:
  start: 2026-01-15
  end: 2026-06-30
  renewal: auto
```

The squirrel reads key.md on open — custom fields are immediately available as context. Help the worldbuilder design fields that make their walnuts more useful.

---

## Level 3: Skill

A repeatable multi-step workflow. Walk through:

1. **What it does** — one sentence
2. **When it triggers** — what the worldbuilder says or does
3. **What it reads** — which files, which APIs
4. **What it produces** — where output goes
5. **Draft the SKILL.md** — present for review
6. **Write it** — save to `.claude/skills/[name]/`

The skill follows the plugin contract:
- Read walnut files via standard order (key.md → now.md → log frontmatter)
- Write to log.md as prepend-only signed entries
- Write scratch to _scratch/
- Route through add-to-world at close
- Sign all work as squirrel:[id]

After creating a skill that works well:

```
🐿️ this skill could be useful to other worldbuilders.
   want to package it as a plugin for the marketplace?
```

---

## Level 4: Plugin

A standalone distributable package. Full scaffold:

```
[plugin-name]/
├── CLAUDE.md
├── PLUGIN.md
├── LICENSE
├── skills/
├── templates/        (if needed)
├── hooks/            (if needed)
└── scripts/          (if needed)
```

Follow the interface contract in `references/plugin-contract.md`. Help the worldbuilder through packaging, testing, and submitting to the marketplace.

---

## System Audit

When the worldbuilder asks "how am I using this?" or "what could be better?":

1. Scan preferences.yaml — what's customized vs defaults
2. Scan all key.md — what fields are used, what's thin
3. Check API connections — what's configured, what's available but not connected
4. Review _scratch/ — anything stale, anything ready to promote
5. Review squirrel entries — session patterns, frequency, stash usage
6. Present findings and suggest improvements

```
your system audit:

  preferences: 2 customized (spark off, health nudges off)
  APIs: Gmail connected, Slack not configured
  walnuts: 12 total, 3 have custom key.md fields
  scratch: 4 files older than 30 days
  sessions: averaging 3/week, stash usage: 60%

suggestions:
  1. connect Slack — you mention it in 4 walnuts
  2. add rhythm: daily to sovereign-systems (you work on it daily)
  3. promote _scratch/launch-plan to v1 — it's been stable 2 weeks
```

---

## The Squirrel's Instinct

Don't over-build. A preference today can become a skill later if it needs more structure. Start simple. When in doubt, preference > config > skill > plugin.

When a worldbuilder builds something that works well — suggest the marketplace. The ecosystem grows from worldbuilders sharing what works for them.
