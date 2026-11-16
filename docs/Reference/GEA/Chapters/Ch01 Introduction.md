---
tags: [chapter, gea]
chapter: 1
pages: 3-68
---

# Ch1: Introduction

## 1.1 The team
- **Engineers** split into runtime and tools programmers, each with specialties (rendering, AI, gameplay…). There are also generalists, leads, technical directors and the CTO.
- **Artists**: concept, 3D modelling (foreground and background), texture, lighting, animation, motion capture, sound, voice, composers.
- **Designers**: macro-level (story arc), level design, technical designers who script. Writers.
- **Producers**, other staff, publishers. First-party studios are owned by a console maker; Naughty Dog belongs to Sony.

## 1.2 What a game is
- A game is a **soft real-time, interactive, agent-based simulation**. "Soft" means missing a deadline isn't catastrophic.
- Deadlines come at different rates: render at 30 or 60 Hz, physics around 120 Hz, AI about 1 Hz, audio buffers about every 1/60 s.
- The world is a **numerical** model stepped forward by a game loop, because there is no analytic solution to it.

## 1.3–1.5 Engines, genres, survey
- "Game engine" dates from Doom: a clean split between core software and art/data made **mods** possible.
- **Engines are data-driven**, and the line between engine and game is blurry.
- Genre needs differ. Surveyed: FPS, platformers, fighting, racing, RTS (the camera type closest to a CRPG), MMOs, player-authored content, VR/AR.
- Engines surveyed: Quake (source code available to study), Unreal, Source, Frostbite, RAGE, CRYENGINE, PhyreEngine, XNA, Unity, OGRE (renderer only), open-source engines.

## 1.6 Runtime engine architecture
See [[Engine Layers]].
- Middleware named: Havok, PhysX, ODE (physics); **Granny** ("the best-designed and most logical animation API of any I've seen… especially its excellent handling of time"); Havok Animation; Euphoria.
- **Platform independence layer**: wraps OS and SDK APIs.
- **Core systems**: assertions, memory, math, containers.
- **Renderer** layers: low-level renderer (should know nothing about the scene graph) → scene graph and culling → visual effects → front end (HUD, GUI, in-game cinematics, FMV).
- **Profiling and debugging**: instrumented timers, memory statistics, print channels, record and playback.
- **Animation** gives the renderer a matrix palette. Ragdolls couple animation and physics.
- **HID**: dead zones, debouncing, edges, remapping, chords, gestures. See [[Input Action Mapping]].
- **Gameplay foundations**: world and object model, events, scripting, AI foundations, world streaming, high-level flow.

## 1.7 Tools and the asset pipeline
- **DCC tools** (Maya, Photoshop…) → **asset conditioning pipeline** (export → process → package per platform) → engine.
- The engine needs the mesh, the skeleton (names, parents, bind pose) and the clips. Uncompressed animation is huge, so it's always compressed.
- A **resource database** holds per-asset metadata: id, source path, frame range, loop flag, compression settings. See [[Resource Lifetimes]].
- **Tool architectures**: standalone, built on the shared engine layers, or **editor inside the runtime** (UnrealEd). The in-runtime editor is fast to iterate in, but an engine crash takes the tools down too.
- Web-based tools are increasingly common (Naughty Dog's localization tool, Tasker, Connector).

## Plotweaver
- Validates D7 and D11.
- Plotweaver's editor is in-engine, like UnrealEd, so the trade-off above applies.

Next: [[Ch02 Tools of the Trade]] · Back: [[GEA Index]]
