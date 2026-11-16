---
tags: [home]
---

# Plotweaver

This vault holds two things that depend on each other.

1. **A course.** It teaches you to program at a low level, to do graphics programming, and to design and choose architectures, to the point where you can do all of it with no AI help. It assumes you are starting from Python and Jupyter notebooks and know nothing about any of this.
2. **A project.** A turn-based party CRPG engine, editor and game in Odin, built on the Plotweaver rules, in the style of Divinity: Original Sin 2, Baldur's Gate 3, Rogue Trader, Wrath of the Righteous and Pillars of Eternity 2.

The course comes first in every stage. You learn a thing in small throwaway programs, then you use it in the engine. The project is where the learning gets tested.

## Where to go

| If you want to | Open |
|---|---|
| Start working today | [[0.1 From notebook to executable]] |
| Understand the rules of the course | [[How This Course Works]] |
| See every lesson, written or planned | [[Curriculum Map]] |
| See what the finished MVP is | [[North Star and MVP]] |
| See the order things get built in | [[Roadmap]] |
| See what is decided and what you still have to decide | [[Decisions]] |
| See where you are | [[Progress]] |
| Look up the Plotweaver rules | [[Plotweaver Rules Digest]] |
| Look up books, sites and assets | [[Sources]] · [[Assets]] |
| Read the Game Engine Architecture notes | [[GEA Index]] |

## The one rule

**You write every line of code, and you solve every problem, without AI.** No autocomplete models, no asking a chatbot for the fix, no pasting errors into one. The lessons give you explanations, worked examples on *different* problems, specifications, and hints you can open one at a time. They never give you the solution to a lab.

Claude has three jobs, and none of them is writing your code:

- **Author.** Claude writes these lessons.
- **Examiner.** At each gate, Claude questions you with the `socratic-tutor` skill. It asks; it doesn't tell.
- **Reviewer.** After a gate, Claude reviews your code the way a senior engineer would, by asking questions about it and pointing at what to reconsider.

The full version of these rules is in [[How This Course Works]].

## Vault layout

```
docs/
  Home.md                 this page
  Plan/                   what we're building and in what order
  Course/                 how to learn, the curriculum, and the lessons
  Reference/              rules digest, sources, assets, GEA book notes
```

Your lab code lives outside the vault, in `labs/` at the repo root. The engine lives in `src/`.
