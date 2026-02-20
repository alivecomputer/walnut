---
skill: example
version: 1.0.0
user-invocable: false
description: This skill should be used when the owner-operator asks to "do the example thing", "run example", or describes wanting the example capability.
triggers: [example, run example, do the thing]
requires-apis: []
---

# Example

One sentence: what this skill does.

## Flow

1. AskUserQuestion: present options
2. Read relevant Walnut context (now.md, log.md frontmatter)
3. Do the work
4. Catch results to squirrel file
5. Present output
6. Route at sign-off via Add to World
