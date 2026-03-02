---
description: System housekeeping. Root audit first, then one walnut at a time. Surfaces issues with recommended fixes.
user-invocable: true
triggers:
  # Direct
  - "walnut:housekeeping"
  - "housekeeping"
  - "check"
  - "health"
  # Intent
  - "anything stale"
  - "anything broken"
  - "anything I'm missing"
  - "what's falling behind"
  - "what needs attention"
  - "what am I neglecting"
  # Maintenance
  - "clean up"
  - "tidy up"
  - "maintenance"
  - "audit"
  # Proactive
  - "is everything ok"
  - "system check"
  - "how's my world looking"
  - "any problems"
  - "anything off"
---

# Housekeeping

System maintenance. Root health first, then one walnut at a time. Surfaces issues with recommended fixes — the conductor picks.

Not a dashboard (that's `walnut:world`). Not a search (that's `walnut:find`). Not session recall (that's `walnut:recall`). Pure maintenance.

---

## Source of Truth

The housekeeping skill MUST read the source file that defines each check's standard before running that check. No checking from memory.

**At invocation, before any checks run, read these deployed files:**

```
▸ .claude/rules/world.md          — ALIVE structure, health signals, walnut anatomy
▸ .claude/rules/conventions.md    — reference system, wikilinks, stale drafts, archiving
▸ .claude/rules/behaviours.md     — zero-context standard, capture policy
▸ .claude/rules/squirrels.md      — core read sequence, squirrel entries, stash spec
▸ templates/walnut/now.md         — what a good now.md looks like (read from plugin install path)
▸ templates/squirrel/entry.yaml   — entry schema (read from plugin install path)
```

Read the **deployed** rule files (`.claude/rules/` in the World), not the plugin cache. The point is to audit the system as it exists.

If any rule file is missing:

```
╭─ 🐿️ housekeeping — missing rule
│  .claude/rules/conventions.md does not exist.
│  The reference system, wikilinks, and archiving checks
│  cannot run without it.
│
│  Recommended: reinstall rules from plugin.
│  → install from plugin / skip affected checks
╰─
```

### Phase 1 Source Mapping

| Check | Read before checking | What it defines |
|-------|---------------------|----------------|
| 1a. ALIVE Structure | `rules/world.md § The ALIVE Framework` | The 5 required folders and their purposes |
| 1b. Inputs Buffer | `rules/world.md § The ALIVE Framework` + `rules/behaviours.md § Capture Proactively` | The 48-hour routing expectation |
| 1c. Plugin & Rules Version | Plugin `CLAUDE.md` frontmatter `version:` + each `.claude/rules/*.md` frontmatter `version:` | Version comparison — plugin vs deployed |
| 1d. Preferences & Config | `rules/squirrels.md § Core Read Sequence` items 9-11 | Which config files should exist |
| 1e. Cross-Walnut Health | `rules/conventions.md § Wikilinks` | Link syntax, valid link targets |
| 1f. Unsigned Entries | `rules/squirrels.md § Squirrel Entries` + `templates/squirrel/entry.yaml` | Entry schema, `signed: false` meaning |

### Phase 3 Source Mapping

| Check | Read before checking | What it defines |
|-------|---------------------|----------------|
| 3a. now.md Zero-Context | `rules/behaviours.md § Zero-Context Standard` + `templates/walnut/now.md` | The test: "would a new agent have everything?" |
| 3b. Stale Past Rhythm | `rules/world.md § Health Signals` | Rhythm → quiet → waiting thresholds |
| 3c. Orphan References | `rules/conventions.md § Reference System` + `§ Companion Structure` | Three-tier system, companion requirements |
| 3d. Stale Working Files | `rules/conventions.md § Stale Drafts` | 30-day threshold, promote/archive/kill options |
| 3e. Stale Tasks | `templates/walnut/tasks.md` | Marker syntax, section structure |

---

## Three-Phase Flow

```
Phase 1: Root Audit (system-level health)
    ↓
Phase 2: Walnut Summary (quick scan, conductor picks)
    ↓
Phase 3: Deep Audit (one walnut, issue by issue)
```

---

## Phase 1 — Root Audit

Full system health check before touching any walnut. Six checks in priority order.

### 1a. ALIVE Structure

Source: `rules/world.md § The ALIVE Framework`

Verify all 5 ALIVE folders exist at the world root:

```
╭─ 🐿️ housekeeping — ALIVE structure
│
│  ▸ 01_Archive/     ✓
│  ▸ 02_Life/        ✓
│  ▸ 03_Inputs/      ✓
│  ▸ 04_Ventures/    ✓
│  ▸ 05_Experiments/ ✓
│
│  Structure intact.
╰─
```

If missing:

```
╭─ 🐿️ housekeeping — missing folder
│  02_Life/ does not exist.
│
│  Recommended: create it — this is a core ALIVE domain.
│  → create / skip
╰─
```

### 1b. Inputs Buffer

Source: `rules/world.md § The ALIVE Framework` + `rules/behaviours.md § Capture Proactively`

Scan `03_Inputs/` for items older than 48 hours. **HIGH PRIORITY** — unrouted inputs may contain decisions or context that affects active walnuts.

```
╭─ 🐿️ housekeeping — unrouted inputs
│  03_Inputs/ has 3 items older than 48 hours:
│   - vendor-brochure.pdf (3 days)
│   - meeting-notes-feb20.md (4 days)
│   - ada-email-thread.eml (2 days)
│
│  These may contain decisions or tasks affecting active walnuts.
│  Recommended: route via walnut:capture before continuing.
│  → route now / skip
╰─
```

### 1c. Plugin & Rules Version

Source: Plugin `CLAUDE.md` frontmatter `version:` + each `.claude/rules/*.md` frontmatter `version:`

Compare plugin version against deployed rules. Read `version:` from YAML frontmatter of each file.

```
╭─ 🐿️ housekeeping — version check
│  Plugin: 0.1.0-beta
│  Deployed rules: 3 of 6 rules are version 0.2.0-beta (older build)
│   - conventions.md — stale
│   - squirrels.md — stale
│   - worldbuilder.md — stale (also renamed to conductor.md in plugin)
│
│  Recommended: update rules from plugin.
│  → update all / review individually / skip
╰─
```

### 1d. Preferences & Config Validation

Source: `rules/squirrels.md § Core Read Sequence` items 9-11

Check that expected config files exist:
- `_core/config.yaml` — walnut-level config (optional, no issue if absent)
- `.claude/preferences.yaml` — global preferences (should exist)
- `.claude/world-config.yaml` — context sources (should exist if sources are configured)

```
╭─ 🐿️ housekeeping — preferences
│  preferences.yaml exists. 6 keys, all valid.
│  world-config.yaml exists. 3 sources configured (Gmail, Slack, Otter).
│
│  No issues.
╰─
```

If missing:

```
╭─ 🐿️ housekeeping — missing config
│  No preferences.yaml found.
│
│  Recommended: create with defaults via walnut:config.
│  → create defaults / skip
╰─
```

### 1e. Cross-Walnut Health

Source: `rules/conventions.md § Wikilinks`

Quick scan across ALL walnuts — read only `_core/key.md` frontmatter (`links:` and `parent:` fields). Check for:

- **Broken wikilinks** — `links:` entries pointing to walnut names that don't exist as folders anywhere in ALIVE
- **Orphan parents** — walnuts with `parent:` set to a name that doesn't exist
- **Structureless folders** — folders in ALIVE domains (02-05) that have no `_core/` — stray folders or broken walnuts

```
╭─ 🐿️ housekeeping — cross-walnut
│  2 issues:
│   - [[glass-cathedral]] referenced in nova-station/key.md but no folder exists
│   - 04_Ventures/old-draft/ has no _core/ — is this a walnut or a stray folder?
│
│  → fix glass-cathedral (create walnut / remove link) / skip
╰─
```

One issue at a time. Resolve or skip, then surface the next.

### 1f. Unsigned Squirrel Entries

Source: `rules/squirrels.md § Squirrel Entries` + `templates/squirrel/entry.yaml`

Scan `_core/_squirrels/` across ALL walnuts. Look for YAML files where `signed: false`. These are sessions that crashed or were abandoned without a save.

```
╭─ 🐿️ housekeeping — unsigned sessions
│  2 unsigned entries across your world:
│   - alive-gtm / squirrel:a3f7b2c1 — started Feb 21, 4 stash items
│   - nova-station / squirrel:9d2e44f8 — started Feb 19, 0 stash items
│
│  Recommended: review alive-gtm (has unrouted stash). Clear nova-station.
│  → review alive-gtm stash / clear both / skip
╰─
```

### Phase 1 Completion

```
╭─ 🐿️ root audit complete
│  6 checks run. 2 issues found, 1 resolved, 1 skipped.
│
│  Ready for walnut-level audit.
│  → continue to walnut audit / done
╰─
```

If "done" — skip to Final Summary.

---

## Phase 2 — Walnut Summary

Quick scan of all walnuts. For each walnut, read ONLY:
- `_core/now.md` frontmatter — phase, health, updated
- `_core/key.md` frontmatter — rhythm

**Do not read full files.** Frontmatter only. This keeps Phase 2 fast.

Present a one-line summary per walnut:

```
╭─ 🐿️ walnut health summary
│
│   #  Walnut               Health    Last Updated    Rhythm    Flag
│   1. alive-gtm            active    2 hours ago     weekly
│   2. sovereign-systems    active    2 days ago      weekly
│   3. nova-station         quiet     12 days ago     weekly    ⚠ past rhythm
│   4. peptide-calculator   quiet     18 days ago     weekly    ⚠ past rhythm
│   5. glass-cathedral      waiting   34 days ago     monthly   ⚠ past rhythm
│   6. ghost-protocol       waiting   41 days ago     weekly    ⚠ past rhythm
│
│  Which walnut to audit? (number, or "done" to finish)
╰─
```

Health is computed from `now.md` updated timestamp vs `key.md` rhythm, using the thresholds from `rules/world.md § Health Signals`:

| Rhythm | Quiet at | Waiting at |
|--------|----------|-----------|
| daily | 2 days | 4+ days |
| weekly | 2 weeks | 4+ weeks |
| fortnightly | 3 weeks | 6+ weeks |
| monthly | 6 weeks | 3+ months |

The conductor picks by number. Only one walnut at a time.

---

## Phase 3 — Deep Audit (single walnut)

Read the selected walnut's brief pack:

```
▸ _core/key.md        — full
▸ _core/now.md        — full
▸ _core/tasks.md      — full
▸ _core/log.md        — frontmatter + first ~100 lines
▸ _core/_working/     — frontmatter only (scan what drafts exist)
▸ _core/_references/  — frontmatter only (scan what's been captured)
```

Then run checks in priority order, one issue at a time:

### 3a. now.md Zero-Context Check

Source: `rules/behaviours.md § Zero-Context Standard` + `templates/walnut/now.md`

Read the context paragraph in now.md. Compare against recent log entries (first ~100 lines of log.md). The test: "If a brand new agent loaded this walnut with no prior context, would it have everything it needs to continue the work?"

Fail conditions:
- Context paragraph is empty or just the HTML comment from the template
- Context paragraph is one sentence when log shows 3+ recent sessions of substantial work
- Context paragraph references things not in the log (hallucinated or outdated context)
- `updated:` timestamp is more than 2 weeks old

```
╭─ 🐿️ housekeeping — thin now.md
│  nova-station / now.md context paragraph is 1 sentence.
│  Last 3 log entries cover: test window confirmed, shielding vendor shortlisted,
│  telemetry review completed.
│
│  Recommended: rewrite now.md to synthesise recent sessions.
│  → rewrite now / skip
╰─
```

### 3b. Stale Walnut Past Rhythm

Source: `rules/world.md § Health Signals`

Already computed in Phase 2, but present it here as an actionable issue with options:

```
╭─ 🐿️ housekeeping — stale walnut
│  nova-station has been quiet for 18 days (rhythm: weekly)
│  Last entry: Feb 5 — "locked episode 11 structure"
│
│  Recommended: open it and check if it's still active, or change rhythm.
│  → open it / archive it / change rhythm / skip
╰─
```

### 3c. References Without Companions

Source: `rules/conventions.md § Reference System` + `§ Companion Structure`

Scan `_core/_references/*/raw/` for files. For each raw file, check if a companion `.md` exists in the parent directory (same name, `.md` extension).

```
╭─ 🐿️ housekeeping — orphan reference
│  nova-station / _references/documents/raw/2026-02-15-vendor-proposal.pdf
│  No companion file. Can't scan without loading the full PDF.
│
│  Recommended: create a companion with description + summary.
│  → create companion now / skip
╰─
```

### 3d. Working Files Older Than 30 Days

Source: `rules/conventions.md § Stale Drafts`

Check file modification timestamps for everything in `_core/_working/`. Flag anything older than 30 days.

```
╭─ 🐿️ housekeeping — stale draft
│  nova-station / _working/submission-draft-v0.1.md
│  Last modified: Jan 15 — 39 days ago.
│
│  Recommended: if it's done, promote to v1. If it's dead, archive it.
│  → promote to v1 / archive / delete / skip
╰─
```

### 3e. Tasks Overdue or Stale

Source: `templates/walnut/tasks.md`

Read `_core/tasks.md`. Find tasks marked `[ ]` (not started) or `[~]` (in progress). Check if they have a `@session_id` — if so, look up that session's timestamp in `_core/_squirrels/`. Flag tasks with no progress in 2+ weeks.

If no `@session_id` attribution, flag tasks that appear to be old based on position and surrounding context.

```
╭─ 🐿️ housekeeping — stale task
│  nova-station / "Book ground control sim" — added Feb 10, no progress
│
│  Recommended: check if it's still relevant.
│  → still relevant / remove / reprioritise / blocked (note why) / skip
╰─
```

### Phase 3 Completion

```
╭─ 🐿️ nova-station audit complete
│  5 checks run. 3 issues found, 2 resolved, 1 skipped.
│
│  → audit another walnut / done
╰─
```

If "audit another walnut" — return to Phase 2 summary with updated health flags.
If "done" — Final Summary.

---

## Final Summary

```
╭─ 🐿️ housekeeping complete
│
│  Root: 6 checks, 2 issues, 1 resolved
│  nova-station: 5 checks, 3 issues, 2 resolved
│  peptide-calculator: 5 checks, 1 issue, 1 resolved
│
│  4 resolved, 2 skipped. World is healthy.
╰─
```
