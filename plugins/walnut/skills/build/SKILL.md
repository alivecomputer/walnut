---
skill: build
version: 0.1.0
user-invocable: true
description: Customization surface for the World. Use when the worldbuilder wants to change how their system behaves — from a one-line preference to a full plugin. Educates on the difference between settings, rules, skills, and plugins when the intent is unclear.
triggers: [build, customize, I want it to, make it always, can we change, I want a skill that, build a plugin, create a skill, make a plugin, when I do X it should Y, preferences, settings]
sub-skills: []
requires-apis: []
---

# Build

The worldbuilder wants their system to do something different. This skill figures out what that actually means and routes to the right output.

---

## The Spectrum

Not everything needs a skill. Not everything is a setting. There are four levels:

| Level | What it is | Where it lives | Example |
|-------|-----------|----------------|---------|
| **Preference** | A one-line rule | `worldbuilder.md` | "never use emojis in my logs" |
| **Config** | A structured setting | walnut-level YAML | voice character, rhythm, formatting |
| **Skill** | A repeatable workflow | `skills/[name]/SKILL.md` | "when I paste a transcript, extract action items" |
| **Plugin** | A distributable package | standalone plugin | a social media manager for all Walnut users |

**The squirrel's job:** figure out which level the worldbuilder actually needs. Most customization requests are preferences or configs. Only create a skill when there's a repeatable multi-step workflow. Only create a plugin when it's meant for other people.

---

## When This Triggers

The worldbuilder says something like:
- "I want it to always do X" → probably a preference
- "Can we change how close works?" → could be preference or config
- "Every time I paste an email, I want it to..." → probably a skill
- "Build me a plugin for managing social media" → plugin

If the intent is unclear, educate:

```
That could be a few things:

  1. preference — a rule I follow every session
     (e.g. "always summarize under 3 sentences")

  2. config — a setting that changes how your walnut works
     (e.g. voice, rhythm, formatting)

  3. skill — a repeatable workflow I can run on command
     (e.g. "process this transcript" → extract people, decisions, tasks)

  4. plugin — a full package other people can install
     (e.g. a social media manager with its own skills and hooks)

which feels right? or just describe what you want and I'll figure it out.
```

---

## Level 1: Preference

Add a line to `worldbuilder.md` in the project's `.claude/rules/`. Done.

The squirrel reads worldbuilder.md every session. Preferences take effect immediately.

```
Adding to worldbuilder.md: "Never use emojis in log entries."

Done. Every squirrel will follow this from now on.
```

---

## Level 2: Config

Write or update a YAML config file. Could be:
- **World-level:** `.claude/config.yaml` — affects all walnuts
- **Walnut-level:** `key.md` fields — affects one walnut

```yaml
# .claude/voice.yaml
character: qui-gon
sage: 70
rebel: 30
never_say: ["Great question!", "Absolutely!"]
```

Show the worldbuilder what changed and confirm.

---

## Level 3: Skill

A repeatable multi-step workflow. The squirrel walks through:

1. **What it does** — one sentence
2. **When it triggers** — what the worldbuilder says
3. **What it reads** — which files, which APIs
4. **What it produces** — where output goes
5. **Draft the SKILL.md** — present for review
6. **Write it** — save to the worldbuilder's custom skills location

```
skills/[name]/
├── SKILL.md
├── references/       (if needed)
└── scripts/          (if needed)
```

The skill follows the same contract as every other skill:
- Read walnut files via standard order (key.md → now.md → log frontmatter)
- Write to log.md as append-only signed entries
- Write scratch to _scratch/
- Route through add-to-world at close
- Sign all work as squirrel:[id]

---

## Level 4: Plugin

A standalone distributable package for other Walnut users. Full scaffold:

```
[plugin-name]/
├── CLAUDE.md
├── PLUGIN.md
├── LICENSE
├── rules/            (if the plugin has its own rules)
├── skills/
├── templates/        (if needed)
├── hooks/            (if needed)
└── scripts/          (if needed)
```

Follow the interface contract in `references/plugin-contract.md`.

---

## The Squirrel's Instinct

Sometimes the worldbuilder asks for something and the squirrel just knows: "This is a preference, not a skill." Don't over-build.

```
"I want the stash to show at the top of every response"

That's a preference. Adding to worldbuilder.md:
"Always show stash at the top of responses, not just on change."

Done. No skill needed.
```

Other times it's clearly a workflow:

```
"Every Monday morning I want to see all my walnuts that went
quiet over the weekend and draft a plan for the week"

That's a skill — multi-step, repeatable, specific trigger.
Want me to build it?
```

When in doubt, start with the simplest level. A preference today can become a skill later if it turns out to need more structure.
