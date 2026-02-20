---
sub-skill: adapt
parent: worldbuilding
description: Take any external skill, plugin, or workflow and make it Walnut-native. Wraps third-party tools so they stash, sign, route, and respect the architecture.
---

# Adapt

Take something that works but doesn't speak Walnut. Make it native.

---

## When This Triggers

- "I love this superpowers skill, can we make it work with my world?"
- "There's a great Claude plugin for X, can it use my walnuts?"
- "I have a workflow in Obsidian/Notion, can we bring it here?"
- "This skill doesn't stash anything"
- The worldbuilder installs a third-party plugin and it ignores walnut conventions

---

## What "Walnut-Native" Means

A native skill does these things. A non-native skill doesn't:

| Convention | What it means |
|-----------|--------------|
| Reads key.md first | Knows what the walnut is before acting |
| Stashes decisions/tasks/notes | Nothing gets lost mid-session |
| Signs scratch with squirrel ID + model | Provenance on everything it creates |
| Routes through add-to-world at close | Content finds its place |
| Writes to log.md (prepend, signed) | History is preserved |
| Respects preferences.yaml | Honors the worldbuilder's customizations |
| Uses numbered menus not AskUserQuestion | Consistent UX |

---

## The Adapt Flow

### 1. Understand the source

Read the external skill/plugin. What does it do? What does it read? What does it produce? Where does output go?

```
🐿️ reading superpowers:brainstorming...
   it creates plans in docs/plans/, uses TodoWrite for checklists,
   invokes AskUserQuestion for decisions. doesn't stash, doesn't
   sign, doesn't route.
```

### 2. Map to walnut conventions

| External behavior | Walnut equivalent |
|-------------------|-------------------|
| Creates files in `docs/plans/` | Creates files in `_scratch/` |
| Uses TodoWrite | Uses `- [ ]` in now.md or stash as task |
| AskUserQuestion for everything | Numbered menus for navigation |
| No session awareness | Signs work, stashes decisions |
| No close flow | Routes through add-to-world at close |

### 3. Create the wrapper

Write a new SKILL.md that:
- Calls the external skill's logic (or reimplements the useful parts)
- Wraps input/output to respect walnut conventions
- Adds stashing, signing, routing
- Reads key.md for context the external skill didn't have

```
skills/[adapted-name]/
├── SKILL.md          ← the walnut-native version
├── references/
│   └── source.md     ← what it was adapted from, what changed
```

The `source.md` reference documents: what the original did, what was kept, what was changed, why. Every adaptation knows its origin.

### 4. Test it

Run the adapted skill on a real walnut. Does it:
- [ ] Read key.md on open?
- [ ] Stash decisions and tasks?
- [ ] Sign scratch files?
- [ ] Route at close?
- [ ] Respect preferences.yaml?
- [ ] Use numbered menus?

### 5. Suggest publishing

If the adaptation is clean and generally useful:

```
🐿️ this adaptation could help other worldbuilders who use
   [original tool]. want to package it for walnut.world/skills?
```

Route to the plugin builder sub-skill for packaging and submission.

---

## Common Adaptations

| Source | What to wrap |
|--------|-------------|
| superpowers:brainstorming | Plan output → _scratch/, decisions → stash |
| superpowers:writing-plans | Plan files → _scratch/plans/, steps → now.md tasks |
| superpowers:test-driven-development | Test results → log.md, failures → stash as tasks |
| Any MCP integration | API responses → add-to-world routing |
| Obsidian vault | Daily notes → log.md entries, links → wikilinks |
| Notion export | Pages → walnuts, databases → key.md fields |

---

## The Rule

Never break the source skill's core value. The adaptation adds walnut conventions on top — it doesn't replace what made the original useful. If brainstorming produces great plans, keep the plan quality. Just make sure it saves to _scratch/ and stashes the decisions.
