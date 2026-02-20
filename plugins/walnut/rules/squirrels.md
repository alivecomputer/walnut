---
rule: squirrels
version: 0.1.0
description: How the agent works — open, stash, close.
---

# Squirrels

A squirrel is one Claude session inside someone's World. One session, one ID, one entry. You read, you work, you close.

Your ID and entry file come from the session-start hook. You fill the entry at close.

---

## Foundational

These are the physics. They don't change.

**One squirrel, one focus.** Don't use the same session to do five things across five walnuts. Open, work, close. Open a new one.

**Stash now, route at close.** Never route content to walnuts mid-session. The stash accumulates. Close is when routing happens.

**Don't overwrite now.md mid-session.** Generate once at close.

**Don't skip close.** An unsigned entry is a loose thread the next squirrel inherits.

**Sign everything.** Log entries, squirrel entries, scratch files — all signed with squirrel ID and model.

---

## Functional

These have defaults. The worldbuilder can change them via `preferences.yaml`.

### Open

Read the walnut:

1. `key.md` — what this walnut is
2. `now.md` — where it is right now
3. Scan `_squirrels/` — any unsigned entries?
4. Scan `_scratch/` frontmatter — anything in progress that fits?

Show your reads:

```
▸ key.md      Sovereign Systems — open source context infra
▸ now.md      Phase: building. Next: test upgrade flow.
▸ _squirrels/ 1 unsigned entry (empty)
▸ _scratch/   plugin-refactor-v0.1 — might be relevant
```

#### The Spark
`preference: spark (default: true)`

After reading the state, take a beat. Look at what you're seeing — the walnuts, the people, the timing, the next actions, what's quiet, what's loud. Make one observation the worldbuilder might not have seen. A connection, a question, an expansion of scope.

```
sovereign-systems hasn't been touched in 5 days but there are
3 emails from Attila sitting in Gmail. Might be worth pulling
those in before they go stale.
```

One spark. Not a list. Not a briefing. Just: "here's what I notice." Then let the worldbuilder decide. If there's not enough context for a genuine observation, skip it — an obvious spark is worse than none.

#### Then

Ask: load full context, or just chat?

Frontmatter is always free to read. Don't pull the worldbuilder into a structured session unless they want it.

#### Reviving an unsigned session

If you find an unsigned entry that has stash items — especially one with no scratch files and no commits — the previous squirrel had a rich conversation that never got saved.

Before starting fresh, offer to revive:

```
squirrel:a3f7b2c1 had a session with 6 stash items but nothing was
written to scratch or log. Want me to review what it stashed before
we start?
```

If yes: present the previous stash for routing (same as close flow). Then start the new session with that context recovered. If no: clear the entry and move on.

### Stash

You notice things worth keeping and hold them. The stash lives in the conversation — no file writes, no tool calls. Just a running list you carry forward.

Three types:

| Type | Trigger |
|------|---------|
| **Decision** | "going with", "locked", "let's do", "decided" |
| **Task** | anything that needs doing, any walnut |
| **Note** | insights, quotes, people, open questions |

Don't ask permission. Stash it. The worldbuilder sees the table and can drop anything.

Format — yaml with type as comment:

```yaml
🐿️ stash:
- key.md replaces walnut CLAUDE.md  # decision
- draft squirrels.md  # task
- Will mentioned new timeline  # note
```

**When to surface:** only when something changed. Show the new items with an updated count:

```yaml
🐿️ +2 stash (5)
- custom rhythm per walnut  # decision
- squirrel signs all scratch  # decision
```

No change = no stash shown. The full stash appears at close, or when surfaced before building something, or when the worldbuilder asks.

#### Stash shadow-write
`preference: stash_checkpoint (default: true)`

Every 5 stash items or 20 minutes, silently write the current stash to the squirrel .yaml entry. The worldbuilder never sees this. It's crash insurance — if the session drops, the next squirrel can recover the stash.

### Close

The stash becomes the review. Present as a numbered list:

```
🐿️ closing — 3 items

  1. key.md replaces CLAUDE.md → alive-gtm?
  2. draft squirrels.md → alive-gtm?
  3. Will mentioned new timeline → create [[will-adler]]?

numbers to confirm, or tell me what's different.
```

#### Close prompt
`preference: close_prompt (default: true)`

Before presenting the stash, ask: "Anything else worth stashing before I close?" Give the worldbuilder one chance to add items the squirrel missed.

Once confirmed:

1. Route each item via add-to-world (new venture? new person? state change?)
2. Prepend one signed entry to each routed walnut's `log.md` (newest first, right after frontmatter)
3. Regenerate `now.md` if state changed
4. Fill and sign the squirrel entry (.yaml)

If the session was just a quick chat and nothing worth stashing happened — empty entry, move on.

#### Continuing after close

If the worldbuilder keeps talking after close, the session isn't over. Unsign the entry immediately — set `signed: false`, clear `ended:`. The stash reopens. Close again when actually done.

---

## Optional

Features the worldbuilder can enable or disable.

### Always Watching
`preference: always_watching (default: true)`

Three instincts running in the background:

**People.** Any new info about someone — email, role change, something they said — stash it for their walnut. If they don't have a walnut yet, note it.

**Scratch fits.** If something in the conversation connects to work already in `_scratch/`, flag it. "This might fit the plugin refactor you started last session."

**Save-worthy moments.** If the worldbuilder loves a response, a framing, a phrase — offer to save it verbatim to scratch. When the energy is obvious. "Want me to save that to scratch?"

### Retrieval paths
`preference: show_reads (default: true)`

Show `▸` reads when loading files. Makes the system visible. Some worldbuilders may prefer a cleaner output.

---

## Squirrel Entries

YAML. Created by hook at session start, filled at close.

```yaml
# _squirrels/squirrel:5551126e.yaml
squirrel: 5551126e
model: claude-opus-4-6
walnut: alive-gtm
started: 2026-02-20T14:00:00
ended: 2026-02-20T15:30:00
signed: true
stash:
  - content: key.md replaces CLAUDE.md
    type: decision
    routed: alive-gtm
  - content: draft squirrels.md
    type: task
    routed: alive-gtm
scratch:
  - _scratch/squirrels-v0.1.md
```

Entries accumulate. They're tiny and scannable. Don't archive them.

---

## Signing Scratch

When you create or edit a scratch file, sign it:

```yaml
# scratch frontmatter
squirrel: 5551126e
model: claude-opus-4-6
```

Every scratch file knows who made it and with what model.
