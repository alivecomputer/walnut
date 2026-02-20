---
sub-skill: upgrade
parent: world
description: Migration from v3 or v4 to v1. Triggered when session-start detects an older system version.
---

# Upgrade

Your computer is ready to become something else.

---

## Detection

Session-start outputs `▸ system v3` or `▸ system v4`. World routes here.

---

## Opening

```
squirrel:[id] waking up

▸ system         [v3/v4] detected · upgrade available to v1

Your World remembers everything.
It just needs to learn a new way to organize what it knows.

This takes about 5 minutes:
  1. update system files (rules, CLAUDE.md)
  2. convert your walnuts (key.md, squirrel .yaml)
  3. clean up anything leftover

  ready?  /  show me what changes first  /  not now
```

If "show changes" — present the summary, then ask again.
If "not now" — exit. The old system continues to work. Offer again next time.

---

## Phase 1: System Files

### 1.1 Archive old rules

```
▸ archiving old rules
```

**From v3:** Archive `.claude/rules/behaviors.md`, `conventions.md`, `voice.md`, `intent.md`, `ui-standards.md`, etc. → `01_Archive/system/v3-rules/`

**From v4:** Archive `.claude/rules/system.md` and `.claude/rules/references/` → `01_Archive/system/v4-rules/`

### 1.2 Install v1 rules

Copy from plugin source into `.claude/rules/`:

```
▸ installing v1 rules
  squirrels.md    → .claude/rules/
  world.md        → .claude/rules/
  worldbuilder.md → .claude/rules/
```

### 1.3 Update CLAUDE.md

Archive the old CLAUDE.md → `01_Archive/system/`.

Generate v1 world CLAUDE.md from template. Carry forward: name, goals, context sources, notes. Ask to confirm:

```
Here's your updated World identity — anything to change?

  Worldbuilder: [name]
  Goals: [goals]
  Context sources: [sources]
```

Confirm or edit. Write to `.claude/CLAUDE.md`.

### 1.4 Clean hooks

Remove v3/v4 hooks from `.claude/settings.local.json`:
- Session-start hooks (plugin handles this)
- Pre-compact hooks (plugin handles this)

Keep useful custom hooks. Show what changed.

---

## Phase 2: Walnut Migration

### From v3 (has _brain/)

Scan for all `_brain/` folders (excluding 01_Archive/).

For each:

1. Read `_brain/status.md` — extract goal, phase, focus
2. Read `_brain/tasks.md` — extract open tasks
3. Generate **key.md** at walnut root:
   ```yaml
   type: [infer from location]
   goal: [from status.md]
   created: [earliest date or today]
   rhythm: weekly
   people: []
   tags: []
   ```
   Plus freeform description from status.md context.

4. Generate **now.md**:
   ```yaml
   phase: [from status.md]
   health: active
   updated: [today]
   next: [most urgent task]
   squirrel: [current id]
   links: []
   ```
   Plus open tasks as checkboxes.

5. Generate **log.md** with first entry:
   ```
   ## [today] — squirrel:[id]

   Migrated from [v3/v4] to v1. Previous history in _chapters/chapter-00.md.

   signed: squirrel:[id]
   ```

6. Create **_chapters/chapter-00.md** from `_brain/changelog.md`

7. Rename `_working/` → `_scratch/` if exists

8. Create `_squirrels/` directory

9. Leave `_brain/` in place — it stops being read by v1

### From v4 (has now.md + log.md, no key.md)

Simpler migration:

1. Generate **key.md** from walnut-level `.claude/CLAUDE.md`:
   ```yaml
   type: [from CLAUDE.md]
   goal: [from CLAUDE.md]
   created: [from log.md frontmatter]
   rhythm: weekly
   people: [from CLAUDE.md if present]
   tags: []
   ```
   Plus description from CLAUDE.md body.

2. Archive walnut-level `.claude/CLAUDE.md` (key.md replaces it)

3. Update **now.md** frontmatter — remove `type:` and `goal:` (these now live in key.md). Add default `rhythm:` reference.

4. Convert any `.md` squirrel entries to `.yaml` format

### Batch presentation

```
▸ migrated [n] walnuts

  VENTURES
  ─────────────────────────────────────
  sovereign-systems    launching
  hypha                pre-launch

  EXPERIMENTS
  ─────────────────────────────────────
  alive-gtm            building
  zeitgeist            building

  LIFE
  ─────────────────────────────────────
  identity             active
  health               active

  review each?  /  approve all  /  skip
```

If review: show each key.md for confirmation.

### Sub-walnuts

For entities with many sub-entities (e.g. clients):

```
sovereign-systems has 73 client sub-entities.
Migrate all automatically?

  1. migrate all
  2. skip clients for now
  3. review each (not recommended for 73)
```

---

## Phase 3: Cleanup (Optional)

```
▸ scanning for cleanup

  [n] folders without key.md or now.md
  [n] items in 03_Inputs/ pending triage
  [n] stale files in _scratch/

  clean up?  /  skip
```

If cleanup:
- Orphan folders → route or archive
- Inputs → triage
- Stale scratch → surface

---

## Completion

```
▸ upgrade complete

  system:    Walnut v1
  walnuts:   [n] migrated
  cleanup:   [n] resolved

Your alive computer is running Walnut v1
Run walnut:world to see your World.
```

---

## Community Guide

1. Update the plugin: `claude plugin update alivecomputer/walnut`
2. Open your ALIVE folder
3. `walnut:world`
4. Follow the upgrade (~5 minutes)
5. Done
