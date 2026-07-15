---
title: "PipeHero: the webhook tool I built because I needed it"
date: 2026-07-15T00:00:00-03:00
description: "Why I built PipeHero, a webhook tunneling and debugging tool, after getting tired of re-pasting tunnel URLs while building GitArena. Includes an MCP server so AI agents can inspect and replay webhooks directly."
tags: ["pipehero", "webhooks", "developer-tools", "ai-tools", "mcp", "buildinpublic", "rust"]
categories: ["projects", "tools"]
author: "Alberto Paparelli"
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
  image: "/images/pipehero-cover.png"
  alt: "PipeHero dashboard showing a live tunnel and captured webhook requests"
  relative: false
  hiddenInSingle: true
---

I've been building [GitArena](https://gitarena.app) for a while now, and a good chunk of it lives and dies by webhooks. GitHub sends PR events, other services send their own, and all of it needs to land on my machine while I'm actually building the thing that reacts to it. That meant a tunnel to `localhost` was always running somewhere in a terminal I forgot about.

The annoying part wasn't the tunnel itself. It was everything around it: the URL rotates, so I go re-paste it into GitHub's webhook settings. I want to see the payload that just came in, so I dig through a provider's dashboard or add a `print()` I'll forget to remove. I want to re-send the same event without waiting for GitHub to fire it again, and that's not really an option unless I pay for it. Multiply that by every provider GitArena talks to, and it stops being a minor annoyance and starts being the thing that breaks my flow every time I sit down to work.

So I built [PipeHero](https://pipehero.app).

## What it actually does

PipeHero exposes your `localhost` on a public URL, the same shape as ngrok, but built around the webhook workflow specifically instead of tunneling in general:

- **Tunnels** with a stable name (`pipehero start gitarena --port 8090` gives you `gitarena.t.pipehero.app` every time, not a new random subdomain per run).
- **Capture** of every request that hits the tunnel: headers, body, timing, response.
- **Inspection** in a local panel or the web dashboard, live as requests come in.
- **Replay**, so you can re-fire a captured webhook straight to your local server without waiting for the provider to send it again.

None of this is exotic. It's the same problem ngrok, Hookdeck, and Svix's tooling solve in their own ways. What's different is who I built it for.

## I'm the main user

PipeHero doesn't have a roadmap driven by a sales team or a backlog of feature requests from someone else's customers. I use it every day to build GitArena, so the features that ship are the ones I hit a wall without. Named, stable subdomains happened because re-claiming a random one every restart was annoying. CLI replay happened because clicking through a dashboard mid-debug broke my concentration. Being both the person who builds the tool and the person who depends on it daily means the gap between "this is annoying" and "this is fixed" is usually a day, not a quarter.

## Where AI actually helps

The part I didn't expect to matter this much: PipeHero ships an MCP server, so an AI coding agent can talk to it directly instead of me relaying information back and forth.

Working on GitArena with Claude Code, the agent can list my tunnels, pull the full request and response for any captured webhook, and replay it, all without me switching to a browser:

| Tool | What it does |
|---|---|
| `list_tunnels` | Your tunnels and whether each is online |
| `list_requests` | Recent captured webhooks for a tunnel |
| `get_request` | Full request + response, headers and body |
| `replay_request` | Replay a webhook to your localhost |

The useful part isn't any single tool call, it's that the agent has both the webhook and my codebase at the same time. It can look at a captured GitHub event, look at the handler that's supposed to process it, explain why it failed, fix the code, and replay the same event to confirm, in one pass. I'm not copy-pasting payloads into a chat window anymore.

Connecting it is one line, no token to paste:

```bash
claude mcp add --transport http pipehero https://mcp.pipehero.app/mcp
```

*(Screenshot to add here: PipeHero's local inspector panel with a live tunnel and a list of captured webhook requests, headers and body visible. This is the artifact still missing, everything else in the post is accurate to what's built and running today.)*

## Try it

It's free to start with. Tunnel your app, watch the requests come in, and if you're already using an AI coding agent, connect the MCP server and let it do the debugging legwork.

[pipehero.app](https://pipehero.app) if you want to try it. I'd like to hear what breaks or what's missing, drop a comment below.
