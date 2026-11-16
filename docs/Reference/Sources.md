---
tags: [reference]
---

# Sources

Back to [[Home]]. Lessons point at specific chapters of these. You don't need to buy or read any of them up front.

## Odin

| Source | Use it for |
|---|---|
| [Odin overview](https://odin-lang.org/docs/overview/) | The language reference. Free |
| [Package docs](https://pkg.odin-lang.org) | Every `core:` and `vendor:` package |
| `F:\odin\core`, `F:\odin\base`, `F:\odin\vendor` | The source of all of the above, on your disk. The final authority |
| `F:\odin\examples\demo\demo.odin` | A tour of the language in one file |
| Karl Zylinski, *Understanding the Odin Programming Language* | A paid book. The clearest long explanation of pointers, memory and allocators in Odin |
| gingerBill, *Memory Allocation Strategies* (gingerbill.org) | A series by Odin's creator on arenas, stacks, pools and free lists. Module B follows its order |

## How computers work

| Source | Use it for |
|---|---|
| Bryant and O'Hallaron, *Computer Systems: A Programmer's Perspective* | The textbook for Stage 0. Data representation, the stack, linking, memory |
| Charles Petzold, *Code* | A gentle book from switches to a working computer |
| Casey Muratori, *Performance-Aware Programming* (computerenhance.com) | A paid course on what the CPU does with your code. Module C and Stage 6 |
| Ulrich Drepper, *What Every Programmer Should Know About Memory* | A free paper. Caches in depth. Stage 6 |
| Ryan Fleury, *Untangling Lifetimes: The Arena Allocator* (rfleury.com) | The best single essay on thinking in lifetimes. Module B |

## Debugging and design

| Source | Use it for |
|---|---|
| `F:\raddbg\raddbg_readme.md` | Your debugger's manual |
| David Agans, *Debugging: The 9 Indispensable Rules* | Method |
| John Ousterhout, *A Philosophy of Software Design* | Short. What makes a module boundary good or bad. Module C onward |
| Casey Muratori, "Semantic Compression" (caseymuratori.com) | An essay on writing the plain code first and extracting structure from it |
| Robert Nystrom, *Game Programming Patterns* (free online) | State machines, command, event queues, game loops. Stage 3 |
| Richard Fabian, *Data-Oriented Design* (free online) | Designing around data and how it's accessed. Stage 4 |
| Mike Acton, "Data-Oriented Design and C++" (CppCon 2014 talk) | The talk that started most of the above |
| Sander Mertens, *ECS FAQ*, and Michele Caini's "ECS back and forth" series | How entity component systems are stored. Stage 4, DL-01 |

## Graphics

| Source | Use it for |
|---|---|
| Gabriel Gambetta, *Computer Graphics from Scratch* (free online) | Stage 1's main text. A software renderer from nothing |
| Dmitry Sokolov, *tinyrenderer* (GitHub wiki) | Stage 1. The same journey in a different order |
| 3Blue1Brown, *Essence of Linear Algebra* (YouTube) | The geometric meaning of what you already use numerically in ML |
| Scratchapixel (scratchapixel.com) | Careful derivations of projection, rasterisation, shading |
| Joey de Vries, *Learn OpenGL* (learnopengl.com) | Stages 2 and 7. Written for C++, so you translate, which is good practice |
| Fabian Giesen, *A Trip Through the Graphics Pipeline 2011* | What the driver and GPU do with a draw call. Stage 2 |
| Akenine-Möller, Haines, Hoffman, *Real-Time Rendering* (4th ed.) | The reference book for everything in Stage 7 |
| *Physically Based Rendering in Filament* (Google's Filament documentation) | A complete, practical PBR design with derivations. Stage 7 |
| Olsson, Billeter, Assarsson, "Clustered Deferred and Forward Shading" (2012) | The paper behind DL-08 |
| The glTF 2.0 specification (Khronos) | Stage 4. The asset format, defined precisely |

## Engines and games

| Source | Use it for |
|---|---|
| Jason Gregory, *Game Engine Architecture* (3rd ed.) | The companion book for Stages 2 to 9. Notes are in [[GEA Index]]. It uses row vectors, so transpose its matrices |
| Amit Patel, *Red Blob Games* (redblobgames.com) | Grids, A\*, line of sight, with interactive diagrams. Stages 3 and 8 |
| Mikko Mononen, *Recast & Detour* (GitHub) and his blog | Voxelizing a level into walkable spans. Stage 6, DL-05 |
| Casey Muratori, *Handmade Hero* (handmadehero.org) | Hundreds of hours of a game built from nothing, live. Watch a few early episodes for the way of working |

## Learning itself

| Source | Use it for |
|---|---|
| Brown, Roediger, McDaniel, *Make It Stick* | Why this course uses retrieval, spacing and prediction |
