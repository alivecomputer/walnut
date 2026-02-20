---
skill: example
version: 0.1.0
user-invocable: false
description: This skill should be used when the worldbuilder asks to "do the example thing", "run example", or describes wanting the example capability.
triggers: [example, run example, do the thing]
requires-apis: []
---

# Example

One sentence: what this skill does.

## Flow

1. AskUserQuestion: present options
2. Read relevant Walnut context (now.md, log.md frontmatter)
3. Do the work
4. Stash results in conversation
5. Present output
6. Route at close via Add to World
