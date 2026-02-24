---
name: config
description: Customize how the system works. Preferences, walnut-level config, custom skills, plugins.
user-invocable: true
triggers:
  # Direct
  - "walnut:config"
  - "config"
  - "settings"
  - "preferences"
  # Intent
  - "I want it to always"
  - "I want it to never"
  - "change how"
  - "turn off"
  - "turn on"
  - "enable"
  - "disable"
  # Customization
  - "customize"
  - "personalize"
  - "adjust"
  - "tweak"
  - "modify the system"
  # Voice
  - "change the voice"
  - "change the tone"
  - "be more"
  - "be less"
  - "sound like"
  # System audit
  - "how am I using this"
  - "what's configured"
  - "show me my settings"
  - "what preferences do I have"
  # Plugin
  - "make a skill"
  - "create a workflow"
  - "package this"
  - "share this process"
---

# Config

Customize how the system works. Four levels, from simplest to most complex.

---

## The Spectrum

| Level | What it is | Example | Where it lives |
|-------|-----------|---------|---------------|
| **Preference** | Toggle on/off | "Turn off sparks" | `preferences.yaml` |
| **Config** | Walnut-level setting | "Nova Station should have a technical voice" | YAML config in walnut's `_core/` |
| **Skill** | Repeatable workflow | "When I paste a transcript, always extract action items" | Custom skill .md file |
| **Plugin** | Distributable package | "Package my launch checklist for other teams" | Plugin directory structure |

**The line:** Toggle = preference. Setting = config. Process = skill. Shareable = plugin.

## How It Routes

When the conductor says "I want X":

1. **Is it a toggle?** → Write to `preferences.yaml`. Takes effect immediately.
2. **Is it walnut-specific?** → Write YAML config to that walnut's `_core/`. Different walnuts, different settings.
3. **Is it a repeatable process?** → Draft a custom skill .md and install it.
4. **Is it something others could use?** → Structure as a plugin with manifest.

If unclear, the squirrel asks once:

```
╭─ 🐿️ that sounds like a preference (toggle).
│  Add to preferences.yaml?
│  Or is this walnut-specific config?
╰─
```

---

## Preferences

`preferences.yaml` at `.claude/` or world root. Read by session-start hook.

```yaml
# preferences.yaml
spark: true                    # observation at open
show_reads: true               # show ▸ reads when loading files
health_nudges: true            # surface stale walnuts proactively
stash_checkpoint: true         # shadow-write stash every 5 items / 20 min
always_watching: true          # people, working fits, capturable content
save_prompt: true              # "anything else?" before save
```

Toggle any value. Takes effect next session (or after `/compact`).

---

## Walnut-Level Config

Per-walnut settings in `_core/config.yaml`:

```yaml
# _core/config.yaml
voice:
  character: [technical, precise, confident]
  blend: 90% sage, 10% rebel
  never_say: [basically, essentially, it's worth noting]
rhythm: daily
capture:
  default_mode: deep            # override fast default for this walnut
  auto_types: [transcript, email]  # always deep capture these types
```

---

## Custom Skills

When a process should always happen the same way:

```
╭─ 🐿️ that sounds like a repeatable workflow.
│  Want me to draft it as a custom skill?
│
│  It would fire when: [trigger description]
│  It would do: [steps]
╰─
```

Custom skills live in `.claude/skills/` or the plugin's skills directory.

---

## System Audit

"How am I using this?" triggers an audit:

```
╭─ 🐿️ system audit
│
│  Preferences: 6 set (all defaults)
│  Walnuts: 14 total (5 active, 4 quiet, 3 waiting, 2 archived)
│  Sessions: 47 squirrel entries across all walnuts
│  References: 89 captured (62 indexed, 27 missing from key.md)
│  Working files: 23 drafts (4 older than 30 days)
│  Custom skills: 0
│  Plugins: 1 (walnut core)
│
│  Recommendation: run walnut:check to address 27 unindexed refs
│  and 4 stale drafts.
╰─
```

---

## Adapt Mode

Wrap third-party tools to be walnut-native:

"I use Notion for project management. Can walnut work with it?"

The squirrel drafts an adapter — a custom skill that bridges the external tool's data model with the walnut structure. MCP integration where possible, manual import flow where not.

---

## Version Control

**System files** (hooks, core rules, skills) → always updated by plugin, never user-modified.
**User files** (preferences.yaml, voice config, custom skills, walnut-level config) → never touched by plugin updates.
**Hybrid files** (some rules) → version-tagged in frontmatter. On plugin update, if user modified the file, present diff instead of overwriting.

Every rules file has `version:` in frontmatter. Update compares checksums.
