---
tags: [chapter, gea]
chapter: 2
pages: 69-103
---

# Ch2: Tools of the trade

*Skimmed: the Subversion/TortoiseSVN and Visual Studio walkthroughs.*

## 2.1 Version control
- It gives you history, tags and branches, which are useful even when you're the only developer.
- Systems covered: Git (distributed, easy rebasing), Perforce (atomic changelists; used by ND and EA), Alienbrain (built for large art files).
- Three-way merges need the common ancestor.
- Deleted files stay in the history.

## 2.2 Compilers, linkers, IDEs
- Translation units → object files (relocatable, unlinked) → libraries → executables. DLLs are linked partly at load time.
- **Build configurations**:

| Config | Settings |
|---|---|
| Debug | no optimization, no inlining, full symbols |
| Development | local optimizations on, asserts and symbols kept |
| Ship | full optimization including link-time and profile-guided; asserts stripped |
| Hybrid | most code in development mode, the code under investigation in debug mode |

- **Test the build configuration you will ship.** Every extra configuration is another one to test.
- **Optimizations**:
  - local: constant folding and propagation, inlining, loop unrolling, dead-code elimination, instruction reordering;
  - global: common subexpression elimination;
  - link-time optimization (LTO), profile-guided optimization (PGO).
- **Debugger skills**: breakpoints, stepping, call stack, watch window (format suffixes like `,x`, `,n`), **data breakpoints** (break when an address is written), conditional breakpoints and hit counts.
- **Bugs that only appear in optimized builds** usually come from:
  - uninitialized variables;
  - code placed inside an assert (so it vanishes when asserts are stripped);
  - struct layout differences;
  - inlining.

  To debug them: read the disassembly, read registers, cast addresses in the watch window, look at globals, add temporary prints.

## 2.3 Profiling
- **Pareto / 80-20**: most of the time is spent in a small fraction of the code.
- Profilers are **statistical** (sampling; VTune) or **instrumenting** (accurate but slow; Quantify), or hybrids (LOP).
- Look at **call counts** as well as time: a function can be slow itself, or cheap but called very often.

## 2.4–2.5 Memory checking and other tools
- Purify, Insure++, Valgrind.
- Diff and three-way merge tools; hex editors.

## Plotweaver
- `run.bat -debug` vs `-o:speed` is this debug/development split.
- The plan's rule "always check performance with `-o:speed`" restates "the debug build lies about speed".

Prev: [[Ch01 Introduction]] · Next: [[Ch03 Software Engineering Fundamentals]]
