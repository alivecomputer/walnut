---
name: example-plugin
version: 0.1.0
description: Example ALIVE plugin — copy this as a starter for your own.
author: Your Name
license: MIT
---

# Example Plugin

Starter template for an ALIVE-compatible plugin.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Example | (semantic) | Does the example thing |

## Hooks

| Hook | Event | Type | Purpose |
|------|-------|------|---------|
| Example | PostToolUse (Edit) | prompt | Logs edits to relevant Walnut |

## Directory Structure

```
example-plugin/
├── PLUGIN.md
├── LICENSE
├── skills/
│   └── example/
│       └── SKILL.md
├── templates/
│   └── example/
│       └── template.md
└── hooks/
    └── hooks.json
```
