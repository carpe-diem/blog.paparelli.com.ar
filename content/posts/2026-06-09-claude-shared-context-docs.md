---
title: "Teaching Claude about your codebase, once, for everyone"
date: 2026-06-09T10:01:00-03:00
description: "30% of Claude Code tool calls in my sessions are Read operations Claude exploring the codebase before it can do anything useful. Here's the experiment we're running to fix that at team scale."
tags: ["claude-code", "ai-tools", "developer-productivity", "llm"]
categories: ["experiments", "tools"]
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
  image: "/images/claude-tools-by-volume.png"
  alt: "Claude Code tool usage breakdown: Bash 48%, Read 30%, Edit 13%"
  relative: false
  hiddenInSingle: true
---

I've been building a CLI tool to monitor Claude Code usage: tokens consumed, costs per session, tool breakdown by volume. The cost numbers weren't surprising. But the tool breakdown was.

```
Tools by volume  (last 7 days, all projects)
------------------------------------------------
Bash                      ████████████████████   427  (48%)
Read                      █████████████          270  (30%)
Edit                      █████                  112  (13%)
Write                     █                       30  ( 3%)
Agent                     █                       16  ( 2%)
```

30% of all tool calls are `Read` operations. Not writing code, not running tests. Just Claude opening files to understand how the codebase is structured before it can help with anything. Context it builds up over the session and loses completely when the session ends.

## The math at team scale

On my own that's interesting but not urgent. At team scale, if 30% of all usage is exploratory reads that reset every session, eliminating even half of that would be a meaningful reduction in monthly spend. The hypothesis is 15-30% savings per session, and that compounds across every dev every day.

Worth trying.

## The fix: context docs Claude can load upfront

The idea is a `docs/context/` directory in the repo with files that Claude loads automatically at the start of every session, via `CLAUDE.md`. Instead of reading five files to understand how a core feature works, it already knows.

The important part: these are not human documentation. They're written specifically for LLM consumption. Dense, structured, no prose padding. The goal is to answer the questions Claude would otherwise open 3-5 files to answer.

For our codebase, that looks like:

- `data_models.md` key models and their relationships
- `app_map.md` what each app owns, routing, cross-app flows
- `xxx_domain.md` domain-specific enums, lifecycle states, terminology
- `patterns.md` how to write endpoints, services, and tests in this repo
- `pdf_document_system.md` the most-read file in the project, pre-summarized
- `services.md` key service functions and their responsibilities
- `recent_changes.md` last 10 merged PRs summarized
- `frontend_components.md` component structure, state patterns, shared utilities
- `testing_patterns.md` test setup, factories, what gets mocked and what doesn't

Nine files. Loaded once. No more cold-start exploration.

## They maintain themselves

The obvious objection: docs go stale. If keeping them accurate requires manual effort, they'll drift and become noise.

The CI job handles it. On every merge to main, it reads the diff, figures out which context docs are affected by what changed, and calls Claude API to update only those docs. A PR touching a models file updates `data_models.md`. A PR touching frontend features updates `frontend_components.md`. The updated docs are committed back to main automatically.

No one on the team needs to think about it. The docs stay accurate because the same merges that change the code also update the docs that describe it.

## Getting team data

My usage only reflects the parts of the codebase I work in. The context docs are only as useful as the coverage they have, and my sessions can't tell me which files are most-read in areas I don't touch.

To fill the gaps, I sent the team a message asking them to run a short Python script in their own Claude Code sessions. The script analyzes their local session history, extracts the top-read files and most common grep patterns, and pastes the output. No data leaves anyone's machine; I'm just asking them to share the printed results.

For now it's a standalone script: a prompt people paste into Claude Code, which runs it on their local files and shows them the output before they decide what to share.

## What's next

A few things I'm working on or thinking about:

- **Open-sourcing `claude-usage-monitor`**: the CLI I built to surface the token/cost/tool breakdowns. It stores data in SQLite and has a Datasette integration for a browser dashboard. Coming soon.
- **Sharing results from the experiment**: once a few teammates have run the survey and the context docs have been in use for a few weeks, I'll post the actual numbers. Did session token usage drop? By how much? I don't know yet.
- **Shared prompt cache**: Anthropic's cache is scoped per API key, not per user. If the whole team routes Claude API calls through a shared key, identical prefixes, like the context docs that everyone loads at session start, would hit the cache across users. One dev's session warms it; everyone else reads from it at a fraction of the cost. This is speculative and not an officially supported pattern, but it's technically how the cache works. Worth investigating.

---

This is an experiment, not a finished product. The hypothesis is that pre-loading structured context reduces the Read-heavy exploration phase and measurably cuts token costs. I'll share what actually happens.

If you're doing something similar or have a different approach to the same problem, I'd like to hear about it. Drop a comment below.
