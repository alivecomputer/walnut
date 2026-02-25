---
description: Rebuild context from previous sessions. Browse, query, combine, and revive squirrel sessions — including full conversation transcripts.
user-invocable: true
triggers:
  # Direct
  - "walnut:recall"
  - "recall"
  # Resume
  - "pick up where I left off"
  - "what was I working on"
  - "continue that session"
  - "resume"
  - "revive"
  # Browse
  - "what have I been doing"
  - "show me recent sessions"
  - "what happened this week"
  - "what did we do on"
  - "session history"
  # Query
  - "that creative session where"
  - "the session about"
  - "when did I last work on"
  - "find that conversation"
  # Combine
  - "combine those sessions"
  - "merge the context from"
  - "give me everything about"
  - "I need the full picture on"
  # Handoff
  - "handoff"
  - "hand off"
  - "context transfer"
  - "brief me on"
---

# Recall

Rebuild context from previous sessions. The system's memory.

Not a search (that's find — searches content). Recall searches SESSIONS — what squirrels did, what was discussed, what was decided, what context existed in those conversations.

---

## How It Works

Two tiers of data. Always start with tier 1. Go to tier 2 on request or when depth is needed.

**Tier 1 — Squirrel Entries** (`_core/_squirrels/*.yaml`)
Structured, fast, indexed. Session ID, walnut, model, timestamps, stash items, working files, tags. Every squirrel leaves one of these.

**Tier 2 — Session Transcripts** (platform-specific, path stored in squirrel YAML `transcript_path:`)
The full conversation. Every human message, every agent response, every tool call, every result. This is the deep context — the actual thinking, the back-and-forth, the nuance that didn't make it into the stash.

The session-start hook discovers the transcript location and writes it to the squirrel YAML as `transcript_path:`. Recall reads this to find the full conversation. See the Transcript Discovery section below for platform-specific paths.

---

## Modes

### Browse (no args)

Show recent sessions across all walnuts.

```
╭─ 🐿️ recall — recent sessions
│
│   1. 2a8c95e9  alive-gtm     today       opus-4-6
│      System architecture, blueprint, 8 skills built, shipped v0.1-beta
│
│   2. a44d04aa  alive-gtm     yesterday   opus-4-6
│      alivecomputer.com rebuilt, whitepaper v0.3, brand locked
│
│   3. 5551126e  alive-gtm     Feb 22      opus-4-6
│      Companion app, web installer, plugin v0.1-beta released
│
│   4. fb6ec273  alive-gtm     Feb 21      opus-4-6
│      Otter transcript extraction, website built, manifesto captured
│
│   5. 224e54bb  walnut-world  Feb 22      opus-4-6
│      walnut.world infrastructure, KV, Blob, DNS, keyphrase system
│
│  number to dive in, or describe what you're looking for.
╰─
```

### Query (by walnut, date, topic)

"What sessions touched nova-station this month?"
"Find the session where we discussed shielding vendors"
"Show me all creative sessions" (matches by tags or stash content)

Searches tier 1 first (squirrel YAML frontmatter + stash content). If no match, offers tier 2 search (full transcript grep).

### Deep Dive (single session)

Pick a session → load its full context.

```
╭─ 🐿️ recall — squirrel:a44d04aa
│
│  Walnut: alive-gtm
│  Date: Feb 23, 10 hours
│  Model: claude-opus-4-6
│
│  Stash: 14 items (all routed)
│  Working: whitepaper-v0.3.md, alivecomputer.com
│
│  Tier 1 loaded. Load full transcript? (47,000 tokens)
╰─
```

If yes → reads the JSONL transcript, extracts the full conversation, rebuilds the context as if you were there.

### Combine (multiple sessions → one context pack)

The power move. Pick 2-5 sessions and merge their context.

"Give me everything from the last 3 alive-gtm sessions"
"Combine the shielding research session with yesterday's vendor call"

```
╭─ 🐿️ recall — combining 3 sessions
│
│  Loading:
│   ▸ 2a8c95e9 — system architecture (today)
│   ▸ a44d04aa — website rebuild (yesterday)
│   ▸ 5551126e — plugin shipping (Feb 22)
│
│  Combined context: 23 decisions, 8 tasks, 4 insights
│  Full transcripts available (142,000 tokens total)
│
│  What do you need this context for?
╰─
```

That last question is key: **the handoff is targeted.** You're not just dumping everything. The system builds the context pack around WHY you need it. "I need to write the investor deck" gets different context emphasis than "I need to debug the hook scripts."

### Handoff (context → new session)

Generate a context briefing that a new squirrel can load to continue the work. This is the output — a structured document that captures:

- Decisions and rationale (from log entries + stash)
- Current state (from now.md)
- Open questions (from stash + conversation)
- Working files in progress
- Key relationships and people context
- The specific reason for the handoff

Written to `_core/_working/recall-[date]-[topic].md` and optionally loaded directly into a new session.

```
╭─ 🐿️ handoff ready
│
│  _core/_working/recall-2026-02-24-investor-deck.md
│
│  Context from 3 sessions, focused on: investor deck preparation
│  12 decisions, 4 open questions, 3 working files referenced
│
│  Start a new session with this loaded?
╰─
```

---

## Reading Transcripts

Session transcripts are JSONL — one JSON object per line. Each line is a message:

```json
{"role": "human", "content": "..."}
{"role": "assistant", "content": "..."}
{"role": "tool_use", "name": "Read", "input": {...}}
{"role": "tool_result", "content": "..."}
```

The squirrel reads these and reconstructs the conversation. For large transcripts (50K+ tokens), it summarises by section rather than loading the full thing — key exchanges, decision points, research findings, creative moments.

**Privacy note:** Transcripts live on the conductor's machine in Claude Code's project directory. They never leave. Recall reads them locally.

---

## Transcript Discovery

Different platforms store session data in different places. The squirrel doesn't hardcode paths — it discovers them.

**Known locations:**

| Platform | Transcript path | Format |
|----------|----------------|--------|
| Claude Code | `~/.claude/projects/<hash>/<session>.jsonl` | JSONL (messages + tool calls) |
| Cursor | `~/.cursor/workspaceStorage/*/state.vscdb` | SQLite |
| Windsurf | `~/.windsurf/` | Varies |
| Codex | Platform-dependent | Varies |
| ChatGPT | Export only | JSON archive |
| Local models | No standard | Agent-dependent |

**How discovery works:**

1. Session-start hook detects the platform (env vars, process name, known paths)
2. Writes `transcript_path:` to the squirrel YAML entry
3. Recall reads the squirrel entry → knows where to find the full conversation
4. If the path doesn't exist or the platform is unknown → falls back to tier 1 (squirrel YAML only)

**The squirrel entry is the universal layer.** It works across every platform. Transcripts are a bonus when the platform supports them. The system never breaks if transcripts aren't available — it just has less depth.

**Future:** As more platforms standardise session export (AGENTS.md, OpenAI's agent protocol), transcript discovery gets easier. The discovery logic lives in the session-start hook and can be updated without changing the recall skill.

---

## What Recall Is NOT

- Not `walnut:find` — find searches content across walnuts. Recall searches sessions.
- Not `walnut:check` — check surfaces broken things. Recall surfaces past context.
- Not a log viewer — log.md has the signed record. Recall has the full conversation.

The log tells you WHAT was decided. Recall tells you WHY, in context, with every exchange that led to it.
