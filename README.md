# blog.paparelli.com.ar

Personal blog built with [Hugo](https://gohugo.io/) and the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme. Deployed on Vercel at [blog.paparelli.com.ar](https://blog.paparelli.com.ar).

## Run locally

```bash
hugo server -D
```

Open [http://localhost:1313](http://localhost:1313). The `-D` flag includes draft posts.

## Write a post

Create a new file in `content/posts/`:

```bash
hugo new content posts/my-post-title.md
```

Or just create the file manually. Naming convention: `YYYY-MM-DD-slug.md`.

### Front matter

```yaml
---
title: "Post title"
date: 2026-05-11
description: "Short description shown in the post list."
tags: ["tag1", "tag2"]
categories: ["category"]
draft: false
cover:
  image: "/images/my-image.png"
  alt: "Image description"
  relative: false
---

Post content here...
```

- Set `draft: true` to preview without publishing.
- Images go in `static/images/` and are referenced as `/images/filename.png`.
- `cover.image` is optional — skip the whole block if there's no cover.

## Deploy

Push to `main` → Vercel auto-deploys.
