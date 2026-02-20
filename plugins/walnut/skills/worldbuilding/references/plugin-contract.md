# Walnut Plugin Interface Contract

Every plugin that operates in a worldbuilder's World follows this contract. Follow these rules and it works. Break them and it breaks the system.

---

## Structure

### Minimal Plugin (one skill)
```
plugin-name/
├── PLUGIN.md
└── skills/
    └── skill-name/
        └── SKILL.md
```

### Standard Plugin
```
plugin-name/
├── CLAUDE.md
├── PLUGIN.md
├── LICENSE
├── skills/
│   └── skill-name/
│       ├── SKILL.md
│       ├── references/
│       └── scripts/
├── templates/
├── hooks/
│   └── hooks.json
└── scripts/
```

---

## PLUGIN.md Manifest

```yaml
---
name: plugin-name
version: 0.1.0
description: One sentence — what this plugin does
author: Author Name
homepage: https://...
repository: https://github.com/...
license: MIT
---
```

Below the frontmatter: skills table, hooks table, directory structure, installation.

---

## SKILL.md Requirements

### Frontmatter (required)

```yaml
---
skill: skill-name
version: 0.1.0
user-invocable: true | false
description: This skill should be used when the worldbuilder asks to "specific phrase 1", "specific phrase 2". [Third person. Specific triggers.]
triggers: [phrase 1, phrase 2, phrase 3]
sub-skills: [name1, name2]
requires-apis: [openai, notion]
---
```

**Description rules:**
- Third person: "This skill should be used when..."
- Include exact phrases worldbuilders would say
- Concrete: "create a hook", "add a dashboard", not "work with hooks"

### Body (required)

- Imperative form ("Parse the frontmatter", not "You should parse")
- Under 2,000 words (move detail to references/)
- Reference sub-files explicitly
- Clear flow (numbered steps the squirrel follows)

### Sub-Skills (optional)

Additional .md files in the skill folder, referenced via `[[sub-skill-name]]`. Each has its own frontmatter. Loaded when relevant.

---

## Reading the World

Standard read order:

```
1. key.md            what this walnut is (evergreen)
2. now.md            current state + tasks
3. _squirrels/       any unsigned entries?
4. _scratch/         frontmatter scan for fits
5. log.md frontmatter   executive summary
6. log.md body       on demand only
```

Never read the full log body unless needed. Frontmatter is the scan layer.

**Cross-Walnut reads:** ask before loading another walnut. "This references [[x]]. Want me to load it?"

---

## Writing to the World

### Log entries
Prepend-only signed blocks (newest first, right after frontmatter):

```markdown
## [ISO datetime] — squirrel:[id]

[content]

signed: squirrel:[id]
```

Never edit existing entries. Open the file, see the latest. No scrolling.

### Tasks
`- [ ]` checkboxes in `now.md` body. Remove when complete (log completion to log.md).

### Scratch
Write to `_scratch/` as v0.x markdown with frontmatter. Sign with squirrel ID and model. Two versions = folder with README reflecting what worked / what changed.

### References
Binary always has companion `.md` in `_references/[type]/`. Raw in `_references/[type]/raw/`. Companion has YAML frontmatter.

### key.md
Update rarely. When new evergreen info arrives (new person, updated specs). Always through add-to-world routing.

### now.md
Regenerate at close only. Update frontmatter fields. Update task list. Never write mid-session.

---

## The Stash

Plugins that run sessions should implement the stash pattern:
- Carry decisions, tasks, and notes in conversation as yaml
- Surface on change only
- Review at close via numbered list
- Route through add-to-world
- Write to squirrel entry (.yaml) at close

---

## Hooks

Plugin hooks in `hooks/hooks.json`:

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolName",
        "hooks": [
          { "type": "prompt", "prompt": "What to check" }
        ]
      }
    ]
  }
}
```

**Types:** `command` (bash) or `prompt` (injected).
**Events:** SessionStart, PreToolUse, PostToolUse, Stop, PreCompact, SessionEnd, etc.
**Matchers:** exact name, pipe-separated, wildcard (`"*"`), regex.

---

## Templates

`{{variable}}` placeholders with optional defaults: `{{variable|default}}`. Every template has YAML frontmatter.

---

## APIs

Declare in SKILL.md: `requires-apis: [openai]`. If not configured, prompt setup on first use. Keys in env vars only. Never in files.

---

## Numbered Menus Over AskUserQuestion

Prefer numbered menus in natural text for navigation and choices. Reserve AskUserQuestion for specific binary decisions or when structured selection genuinely helps. The worldbuilder should feel free, not tested.

---

## Don'ts

1. Never edit log.md history
2. Never skip close
3. Never route mid-session (stash, route at close)
4. Never overwrite now.md mid-session
5. Never auto-fix (surface and ask)
6. Never expand scope without asking
7. Never delete (archive)
8. Never store secrets in files
9. Never iterate without reflecting
10. Never write a skill in second person
