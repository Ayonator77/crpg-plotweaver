---
tags: [plan, progress]
---

# Progress

Back to [[Home]]. Update this page yourself when you finish a lesson or pass a gate.

## Where you are

**Stage 0, Module A, Lesson 0.1.** Start at [[0.1 From notebook to executable]].

## What exists from before the rework (2026-11-16)

The repo has about 790 lines of Odin that you typed under the old plan:

| Piece | File | State |
|---|---|---|
| Window, GL 4.3 context, event polling | `src/engine/platform/platform.odin` | Works |
| Input: key and mouse state and edges | `src/engine/platform/input.odin` | Works |
| Frame timing, vsync | `src/engine/platform/time.odin` | Works |
| Shader loading, a triangle | `src/engine/renderer/` | Works |
| GL debug callback, logger, tracking allocator | `src/engine/renderer/debug.odin`, `src/main.odin` | Works |
| A `game` package that owns colours and quit | `src/game/game.odin` | Works |
| A transform with position and scale | `src/engine/spatial/transform.odin` | Works, no rotation |

> [!warning] The engine doesn't compile right now
> The last old lesson was half applied. `renderer.draw_triangle` now takes an `mvp` matrix, and `src/main.odin` line 97 still calls it without one. You have two clean options, and either is fine:
> - `git stash` the uncommitted changes, so `main` is back to the last commit that builds.
> - Leave it. You won't touch `src/` until Stage 2, and fixing it then is a good first exercise.

That code stays. Much of it was typed from snippets, though, so it doesn't yet count as yours. Stage 2 opens with rebuild drills: you rewrite pieces of it from a blank file, with the debugger and the docs and nothing else. What you can rebuild, you own.

## What was retired

- `PLOTWEAVER_PLAN.md` (the old milestone plan M0–M21 and decisions D1–D15). It is in git history at commit `ae22c07` if you want to read it. Its useful content moved into [[Roadmap]], [[Decisions]], [[Assets]] and the [[Curriculum Map]].
- `.local-roadmap.md` (an even older plan). Deleted.
- The session protocol where Claude delivered code for you to type. Replaced by [[How This Course Works]].

## Gates

| Gate | Self-test | Oral exam | Code review | Date |
|---|---|---|---|---|
| Stage 0 · Module A | ☐ | ☐ | ☐ | |
| Stage 0 · Module B | ☐ | ☐ | ☐ | |
| Stage 0 · Module C | ☐ | ☐ | ☐ | |
| Stage 1 | ☐ | ☐ | ☐ | |
| Stage 2 | ☐ | ☐ | ☐ | |
| Stage 3 | ☐ | ☐ | ☐ | |
| Stage 4 | ☐ | ☐ | ☐ | |
| Stage 5 | ☐ | ☐ | ☐ | |
| Stage 6 | ☐ | ☐ | ☐ | |
| Stage 7 | ☐ | ☐ | ☐ | |
| Stage 8 | ☐ | ☐ | ☐ | |
| Stage 9 | ☐ | ☐ | ☐ | |

## Lessons

| Lesson | Lab done | Check passed | Explain-back written | Reviews (1 day · 1 week · 1 month) |
|---|---|---|---|---|
| 0.1 From notebook to executable | ☐ | ☐ | ☐ | ☐ ☐ ☐ |
| 0.2 The debugger | ☐ | ☐ | ☐ | ☐ ☐ ☐ |
| 0.3 Bits, bytes and integers | ☐ | ☐ | ☐ | ☐ ☐ ☐ |
| 0.4 Floating point | ☐ | ☐ | ☐ | ☐ ☐ ☐ |
| 0.5 Addresses and pointers | ☐ | ☐ | ☐ | ☐ ☐ ☐ |
| 0.6 Arrays, slices and strings | ☐ | ☐ | ☐ | ☐ ☐ ☐ |

Add rows as new lessons are written.

## Log

| Date | What happened |
|---|---|
| 2026-11-16 | Plan and course reworked. New goals, MVP, roadmap and decisions. Vault moved to `docs/`. Stage 0 Module A written |
