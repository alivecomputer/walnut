# Plugin Examples

Three levels of complexity. Start minimal, add structure as needed.

---

## Level 1: Minimal Skill

A single SKILL.md. No hooks, no templates, no scripts. Good for simple capabilities.

**Example: `alive:focus` — Pomodoro-style focus timer**

```
focus/
└── SKILL.md
```

```yaml
---
skill: focus
version: 0.1.0
user-invocable: false
description: This skill should be used when the worldbuilder asks to "start a focus session", "pomodoro", "focus for 25 minutes", "deep work", or wants timed focused work with breaks.
triggers: [focus, pomodoro, deep work, focus session, time block]
requires-apis: []
---

# Focus

Start a timed focus session. Set a duration. Work. Break when done.

## Flow

1. AskUserQuestion: "How long? [1] 25 min [2] 50 min [3] Custom"
2. Set the timer (log start time to squirrel entry)
3. Worldbuilder works. Squirrel stashes as normal.
4. At duration: surface "Time's up. Break or continue?"
5. Log focus session to log.md at close.
```

That's it. One file. Works inside the system because it follows the contract: stashes in conversation, logs at close, uses numbered menus.

---

## Level 2: Standard Plugin

Skills + references + templates. Good for domain-specific capabilities.

**Example: `alive:invoice` — Generate and track invoices**

```
invoice/
├── PLUGIN.md
├── skills/
│   └── invoice/
│       ├── SKILL.md
│       └── references/
│           └── fields.md
└── templates/
    └── invoice/
        └── invoice.html
```

SKILL.md handles: create invoice, find invoice, mark paid. References describe required fields. Template is the HTML layout (uses brand config for styling).

The skill:
- Reads the client Walnut (people/[client]) for billing details
- Creates the invoice in _scratch/ as v0.1
- Offers Prototyper to render as HTML/PDF
- Logs "invoice created" to the client Walnut's log.md
- Marks paid → logs to both client Walnut and venture Walnut

Follows the contract: reads via standard protocol, writes to log, uses AskUserQuestion for decisions, closes.

---

## Level 3: Full Plugin

Skills + hooks + templates + scripts + APIs. Good for complex integrations.

**Example: `alive:social` — Social media management**

```
social/
├── PLUGIN.md
├── CLAUDE.md
├── LICENSE
├── skills/
│   └── social/
│       ├── SKILL.md
│       ├── schedule.md      ← sub-skill: schedule posts
│       ├── analytics.md     ← sub-skill: review performance
│       └── references/
│           └── platforms.md ← platform-specific rules
├── templates/
│   └── post/
│       └── post.md          ← post draft template
├── hooks/
│   └── hooks.json           ← PostToolUse: log social actions
└── scripts/
    └── publish.sh           ← API call to publish
```

The skill:
- Reads the venture Walnut for brand voice and goals
- Reads brand config for visual identity
- Creates posts in _scratch/ as v0.x (iterate with reflection)
- Sub-skill [[schedule]] handles timing via API
- Sub-skill [[analytics]] reads platform data via API
- Hook logs every publish action to the venture's log.md
- Script handles the actual API call to Buffer/Twitter/LinkedIn

Declares `requires-apis: [buffer]` in frontmatter. On first use, prompts for API setup.

---

## What Makes These Work

All three examples follow the same contract:

| Principle | How |
|---|---|
| Reads via standard protocol | _squirrels → now.md → log frontmatter |
| Writes to log as signed entries | squirrel:[id] signs every entry |
| Uses AskUserQuestion for decisions | Never assumes, always asks |
| Stashes in conversation | No routing mid-session |
| Scratch for drafts | v0.x, promote to v1 |
| APIs declared in frontmatter | Setup on first use |
| Wikilinks for connections | Links to relevant Walnuts |

The complexity of the plugin doesn't change the interface. A one-file skill and a twenty-file plugin interact with the World the same way.
