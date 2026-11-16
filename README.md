# Plotweaver

A turn-based, party-driven 3D CRPG built on a custom engine written from scratch in [Odin](https://odin-lang.org/).

This is an unofficial fan project that brings the **Plotweaver** tabletop RPG to life. It uses Plotweaver's ruleset as the foundation for its mechanics: d20 skill checks against a DC, the plot die and the complications or opportunities it creates, a fast or slow turn structure, and conversations played out as contests of focus.

It aims for the scope of games like *Divinity: Original Sin 2* and *Warhammer 40,000: Rogue Trader*: an isometric camera, tactical turn-based combat, environmental interactions, and branching conversations.

> **Disclaimer:** This video game is a fan-made project. It is not affiliated with, endorsed by, or sponsored by the creators of the Plotweaver tabletop RPG. All rights to the original game belong to their respective owners.

> **Status:** early development. The engine foundation (windowing, OpenGL context, shader loading, input) is in place. There's nothing to play yet.

## Tech stack

| Area      | Choice                                    |
| --------- | ----------------------------------------- |
| Language  | Odin                                      |
| Platform  | SDL3 (`vendor:sdl3`)                      |
| Graphics  | OpenGL 4.3 Core, with Vulkan planned later |
| Tools UI  | Dear ImGui (planned)                      |
| Data      | JSON                                      |

No third-party engine is used. The renderer, input, entity system, and animation system are all written as part of this project.

## Building

### Requirements

- Windows 10 or 11
- A recent [Odin](https://odin-lang.org/docs/install/) nightly build, with `odin` on your `PATH`
- A GPU and driver that support OpenGL 4.3

### Steps

```bat
git clone https://github.com/Ayonator77/crpg-plotweaver.git
cd crpg-plotweaver

:: One-time setup: the executable needs SDL3.dll next to it.
:: Odin ships the DLL in its vendor folder.
mkdir bin
copy "%ODIN_ROOT%\vendor\sdl3\SDL3.dll" bin\

run.bat
```

If `ODIN_ROOT` isn't set, replace it with the folder that contains `odin.exe`.

`run.bat` builds a debug binary to `bin/plotweaver.exe` and launches it. It maps `src/` to the `pw` collection, so packages import each other with paths like `import "pw:engine/platform"` instead of relative `../../` paths.

## Project layout

```
assets/
  shaders/          GLSL shaders, loaded from disk at runtime
src/
  main.odin         entry point and main loop
  app.odin          application config and state
  engine/
    platform/       window, GL context, input (SDL3)
    renderer/       OpenGL resources and shader compilation
    spatial/        transforms and spatial math
  game/             game-specific state and rules
labs/               small standalone programs written while learning
docs/               the plan and the course, as an Obsidian vault
run.bat             build-and-run script
debug.bat           build and open in the RAD Debugger
```

The code is split into two layers. `engine/` holds generic systems, and game-specific rules sit in a separate layer on top of it.

## A learning project

This is also a way of learning low-level programming, graphics programming and software architecture from the ground up. All code in `src/` and `labs/` is written by hand, without AI assistance. The course material and the plan are in [`docs/`](docs/Home.md). Open that folder as a vault in [Obsidian](https://obsidian.md/) for working links and folded hints.

## Roadmap

The full version is in [`docs/Plan/Roadmap.md`](docs/Plan/Roadmap.md), and the MVP is defined in [`docs/Plan/North Star and MVP.md`](docs/Plan/North%20Star%20and%20MVP.md).

- [ ] Stage 0: the machine (memory, pointers, allocators, measuring)
- [ ] Stage 1: a software renderer, to learn the graphics pipeline from first principles
- [ ] Stage 2: the GPU and the engine skeleton
- [ ] Stage 3: a graybox CRPG (party, turns, pathfinding, a playable fight with cubes)
- [ ] Stage 4: asset loading, the world model, and a level editor
- [ ] Stage 5: a skeletal animation system and an animation editor
- [ ] Stage 6: large continuous areas, verticality, and traversal (jump, fly, teleport)
- [ ] Stage 7: lighting and atmospherics
- [ ] Stage 8: the Plotweaver systems (combat, elemental surfaces, exploration, dialogue) and their editors
- [ ] Stage 9: the MVP slice

## Author

Developed by [Ayodeji Odetola](https://github.com/Ayonator77).
