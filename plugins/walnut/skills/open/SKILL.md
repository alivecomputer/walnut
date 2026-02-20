---
skill: open
version: 0.1.0
user-invocable: true
description: Single-Walnut focus. Load one Walnut's full context, start working. Close with walnut:close when done.
triggers: [open, work on, focus on, let's work on, continue, pick up, what's happening with, status of, back to, into]
surfaces: [open]
sub-skills: [prototyper]
requires-apis: []
---

# Open

Single-Walnut focus. Everything else is out of view.

Load one Walnut. See where things are. Work.

---

## Opening

If no Walnut is specified, show available Walnuts as a numbered list. If named in the invocation ("open sovereign-systems"), load directly.

---

## Load Sequence

```
▸ key.md      Sovereign Systems — open source context infra
▸ now.md      Phase: launching. Next: rebuild site.
▸ _squirrels/ 1 unsigned entry (empty — safe to clear)
▸ _scratch/   plugin-refactor-v0.1 in progress
```

If unsigned entries found with stash items: surface before loading.

Then ask:

```
sovereign-systems
────────────────────────────────────────────
Goal:    Build ALIVE into a business
Phase:   launching
Next:    Rebuild alivecomputer.com

Load full context, or just chat?
```

The worldbuilder decides. "Load context" reads log frontmatter, recent entries, linked walnuts. "Just chat" starts freestyle — the squirrel can load more later if needed.

---

## During Work

The squirrel stashes in conversation (see squirrels.md). No file writes mid-session.

**Always watching for:**
- People updates — new info about someone → stash for their walnut
- Scratch fits — conversation connects to something in `_scratch/`
- Save-worthy moments — a response or framing worth keeping verbatim

When a working file gets substantial enough to share — offer the Prototyper: "This looks ready to share. Want to generate a document?"

---

## Reading Deeper

At the squirrel's discretion or on request:

- `log.md` tail — recent history when context requires it
- `log.md` search — "when did we decide X"
- Linked Walnut — "This references [[will-adler]]. Want me to load it?"
- `_scratch/` body — when frontmatter suggests a fit

Always ask before loading another Walnut. One walnut, one focus.

---

## Closing

When the worldbuilder signals done ("done", "save", "wrap up", "close", "that's it"):

→ Route to `walnut:close`. The close skill handles stash review, routing, and closing.

---

## Prototyper Sub-skill

Takes markdown from `_scratch/`. Generates styled HTML using brand config (or defaults). Three layouts: `brief` / `plan` / `report`.

Output → `_references/renders/[slug].html` + companion `.md`.
