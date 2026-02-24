---
name: publish
description: Context out. Preview drafts on your phone, publish to your walnut.world, share via token links.
user-invocable: true
triggers:
  # Direct
  - "walnut:publish"
  - "publish"
  - "publish this"
  # Preview
  - "preview this"
  - "let me see this on my phone"
  - "how does this look"
  - "can I view this somewhere"
  - "send this to my link"
  # Ship
  - "ship it"
  - "ship this"
  - "make this live"
  - "put this on my site"
  - "push this"
  # Share
  - "share this"
  - "send this to someone"
  - "make a link"
  - "give me a shareable link"
  - "I want to send this to"
  # View
  - "show me what I've published"
  - "my published stuff"
  - "my gallery"
  - "what's live"
---

# Publish

Context out. The opposite of capture.

Capture brings context in. Publish sends context out — to the conductor's walnut.world link for preview, publishing, or sharing.

---

## Three Modes

### Preview (v0.x → protected link)

For working drafts. "Let me see this on my phone."

1. Take content from `_core/_working/` (or any file)
2. Render markdown → clean HTML with default viewer
3. API call to walnut.world: `POST /api/publish`
4. Available at `user.walnut.world/slug` — keyphrase protected
5. Only the conductor can see it

```
╭─ 🐿️ preview live
│  nova-station.walnut.world/launch-checklist
│  Keyphrase protected — only you can see this.
╰─
```

### Publish (v1 → index)

For shareable work. Graduated from `_core/_working/` to live context.

1. Content already promoted to v1 (outside `_core/`)
2. Render and push to walnut.world
3. Added to the index at `user.walnut.world` — personal gallery
4. `_core/key.md` gets entry in `published:` field
5. Log entry: "Published [name] to [url]"
6. Still keyphrase protected by default

```
╭─ 🐿️ published
│  nova-station.walnut.world/orbital-safety-brief
│  Added to your gallery index.
│  Keyphrase protected. Share with a token link?
╰─
```

### Share (token link for one item)

For sending a specific piece to another person.

1. Generate a random token for one published item
2. `user.walnut.world/slug?token=abc123` — bypasses keyphrase for that item
3. Not indexed, not crawlable (`noindex, nofollow` on everything)
4. Token can be revoked
5. Log entry: "Shared [name] via token link"

```
╭─ 🐿️ share link generated
│  nova-station.walnut.world/orbital-safety-brief?token=k9x2m4
│  Anyone with this link can view it. Revoke anytime.
╰─
```

---

## API Contract

```
POST /api/publish
Headers:
  X-Walnut-Keyphrase: [conductor's keyphrase]
Body:
  {
    "slug": "orbital-safety-brief",
    "content": "<html>...</html>",
    "title": "Orbital Safety Brief",
    "walnut": "nova-station",
    "mode": "preview" | "publish",
    "visibility": "private" | "token"
  }
Response:
  {
    "url": "https://you.walnut.world/orbital-safety-brief",
    "token_url": "..."  // if visibility=token
  }

GET /api/index
Headers:
  X-Walnut-Keyphrase: [conductor's keyphrase]
Response:
  {
    "items": [
      { "slug": "...", "title": "...", "walnut": "...", "mode": "...", "published_at": "..." }
    ]
  }

DELETE /api/publish/:slug
Headers:
  X-Walnut-Keyphrase: [conductor's keyphrase]
```

## Keyphrase Auth

Stored in `.env.local` as `WALNUT_KEYPHRASE`. The publish script reads it. No passwords in walnut files.

If no keyphrase is set, the squirrel offers to claim one:

```
╭─ 🐿️ no walnut.world keyphrase found.
│  Claim your link at walnut.world to start publishing.
│  What name do you want? (e.g., nova-station.walnut.world)
╰─
```

---

## Gallery Index

`user.walnut.world` shows everything published — keyphrase protected. A personal searchable index of all work product the conductor has shipped.

Default view: markdown rendered as clean HTML. No framework, no bloat. Just readable content.

---

## v0 Beta Scope

- Preview and publish only
- Owner-only access (keyphrase protected)
- Share with token links
- No P2P, no federation, no public indexing
- Default markdown viewer
- `noindex, nofollow` on everything
