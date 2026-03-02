---
description: Scaffold a new walnut. Any type, any domain. Optionally seed it with existing context.
user-invocable: true
triggers:
  # Direct
  - "walnut:create"
  - "create"
  - "new walnut"
  - "new venture"
  - "new experiment"
  - "new project"
  # Intent
  - "I want to start something new"
  - "set up a new"
  - "create a walnut for"
  - "make a walnut"
  - "start tracking"
  - "add a new"
  # People
  - "add a person"
  - "new person"
  - "track this person"
---

# Create

Scaffold a new walnut — any type, any ALIVE domain. Describe what it is, the squirrel infers the rest. Optionally bring in existing content (Step 5 — only if the conductor has files to migrate).

Not a setup wizard (that's `world/setup.md` — first-time only). Not opening an existing walnut (that's `walnut:open`).

---

## Template Locations

The squirrel MUST read these templates before writing — not reconstruct from memory. Templates live relative to the plugin install path.

```
templates/walnut/key.md       → _core/key.md
templates/walnut/now.md       → _core/now.md
templates/walnut/log.md       → _core/log.md
templates/walnut/insights.md  → _core/insights.md
templates/walnut/tasks.md     → _core/tasks.md
templates/squirrel/entry.yaml → _core/_squirrels/{session_id}.yaml
```

### Placeholders

| Placeholder | Source |
|------------|--------|
| `{{type}}` | Step 1 selection |
| `{{goal}}` | Extracted from Step 2 free text |
| `{{name}}` | Kebab-case slug derived from Step 2 |
| `{{date}}` | Current ISO date (YYYY-MM-DD) |
| `{{next}}` | Set to the goal initially |
| `{{session_id}}` | Current session ID |
| `{{engine}}` | Current model (e.g. `claude-opus-4-6`) |
| `{{walnut}}` | Same as `{{name}}` |
| `{{description}}` | The conductor's free text from Step 2, lightly cleaned |

---

## Domain Routing

| Type | ALIVE folder | Notes |
|------|-------------|-------|
| venture | `04_Ventures/{name}/` | |
| experiment | `05_Experiments/{name}/` | |
| life | `02_Life/{name}/` | Under `goals/` if it's a goal |
| person | `02_Life/people/{name}/` | Always under `people/` |
| project | Inside parent walnut folder | Requires parent selection |
| campaign | Inside parent walnut folder | Requires parent selection |

---

## Flow

### Step 1 — Type Selection

```
→ AskUserQuestion: "What type of walnut?"
- Venture — revenue intent (business, client, product)
- Experiment — testing ground (idea, prototype, exploration)
- Life area — personal (goal, habit, health, identity)
- Person — someone who matters
- Project — scoped work inside a venture or experiment
- Campaign — time-bound push with a deadline
```

### Step 2 — Describe It

Free text prompt: "Describe it in a sentence or two — what is it and what's the goal?"

The squirrel infers `name` (kebab-case slug), `goal`, and `domain` from the response.

If type is project or campaign:

```
→ AskUserQuestion: "Which walnut does this belong under?"
- [list active ventures/experiments by scanning _core/key.md frontmatter across ALIVE folders]
- Standalone (no parent)
```

To build the parent list: scan `04_Ventures/*/_core/key.md` and `05_Experiments/*/_core/key.md` — read frontmatter only (type, goal). Present as options with goal as description.

### Step 3 — Confirm Before Writing

```
╭─ 🐿️ new walnut
│
│  Name:    peptide-calculator
│  Type:    experiment
│  Goal:    Build a peptide dosage calculator for personal use
│  Path:    05_Experiments/peptide-calculator/
│  Parent:  none
│  Rhythm:  weekly (default)
│
│  → create / change name / change type / change rhythm / cancel
╰─
```

If the conductor picks "change name" / "change type" / "change rhythm", ask once, then re-present the confirmation.

### Step 4 — Scaffold

Follow the 9-step process from `conventions.md § Creating a New Walnut` exactly:

1. Domain already determined (Step 1-2 above)
2. Create folder at the resolved path (kebab-case name)
3. Read each template from `templates/walnut/`, fill `{{placeholders}}`, write to `_core/`
4. Create empty directories: `_core/_squirrels/`, `_core/_working/`, `_core/_references/`
5. Fill key.md frontmatter: type, goal, created (today), rhythm (default: weekly), tags (empty `[]`)
6. Fill key.md body: description from Step 2. Leave Key People and Connections sections as the scaffolded HTML comments from the template.
7. Write first log entry: "Walnut created. {goal}" — signed with session_id
8. If sub-walnut: set `parent: [[parent-name]]` in key.md frontmatter
9. Add `[[new-walnut-name]]` to parent's key.md `links:` frontmatter field

```
╭─ 🐿️ scaffolding...
│
│  ▸ 05_Experiments/peptide-calculator/
│  ▸   _core/key.md — type: experiment, goal set
│  ▸   _core/now.md — phase: starting, health: active
│  ▸   _core/log.md — first entry signed
│  ▸   _core/insights.md — empty, ready
│  ▸   _core/tasks.md — empty, ready
│  ▸   _core/_squirrels/
│  ▸   _core/_working/
│  ▸   _core/_references/
│
│  Walnut is alive.
╰─
```

### Step 5 — Existing Content Check

**DO NOT read `create/migrate.md` until the conductor answers "yes" below. It is a large file (~700 lines) that must not be loaded into context unless needed. Most walnut creations will skip this step entirely.**

```
→ AskUserQuestion: "Do you have existing files or a project on your computer for this?"
- Yes — I have docs, notes, or an existing project to bring across
- No — starting fresh
```

If **"No"** — done. Offer: "Say `open {name}` to start working."

If **"Yes"** — NOW read `create/migrate.md` and follow it from the Entry Point section. The migrate skill handles everything from here: asking what kind of content, detecting whether it's a light seed or full project migration, and running the appropriate flow.

---

## Files Created

| File | Template source |
|------|----------------|
| `{domain}/{name}/_core/key.md` | `templates/walnut/key.md` |
| `{domain}/{name}/_core/now.md` | `templates/walnut/now.md` |
| `{domain}/{name}/_core/log.md` | `templates/walnut/log.md` |
| `{domain}/{name}/_core/insights.md` | `templates/walnut/insights.md` |
| `{domain}/{name}/_core/tasks.md` | `templates/walnut/tasks.md` |
| `{domain}/{name}/_core/_squirrels/` | Empty directory |
| `{domain}/{name}/_core/_working/` | Empty directory |
| `{domain}/{name}/_core/_references/` | Empty directory |
| Parent's `key.md` | Updated `links:` field (if sub-walnut) |

## Files Read

| File | Why |
|------|-----|
| `templates/walnut/key.md` | Template — read before writing key.md |
| `templates/walnut/now.md` | Template — read before writing now.md |
| `templates/walnut/log.md` | Template — read before writing log.md |
| `templates/walnut/insights.md` | Template — read before writing insights.md |
| `templates/walnut/tasks.md` | Template — read before writing tasks.md |
| `templates/squirrel/entry.yaml` | Schema for squirrel entry |
| `rules/conventions.md § Creating a New Walnut` | The 9-step process — follow exactly |
| Active walnuts' `_core/key.md` frontmatter | For parent list (project/campaign types only) |
