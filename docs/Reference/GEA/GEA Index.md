---
tags: [index, gea]
aliases: [GEA, Game Engine Architecture]
---

# Game Engine Architecture (3rd ed.), Plotweaver reading vault

Notes on Jason Gregory's *Game Engine Architecture*, 3rd edition (CRC Press, 2018), read against the
[[GEA Plotweaver Impact|Plotweaver plan]]. Back to [[Home]]. Section numbers like **GEA 12.6.5** refer to the book.

> [!info] Setup
> The diagrams are `tikz` code blocks. To render them, install the community plugin **TikZJax**
> (Settings → Community plugins → Browse → "TikZJax"). In dark mode, turn on the plugin's
> "Invert dark colors in dark mode" option.

> [!warning] Matrix convention
> The book uses **row vectors** (`v' = v M`). Plotweaver uses **column vectors** (`v' = M v`).
> Transpose every matrix you copy from the book. See [[Row vs Column Vectors]].

## Start here
- [[GEA Plotweaver Impact]]: what the book confirms, what it changes, and what it leaves out
- [[GEA Reading Map]]: which chapters to read before each stage

## Chapters
| Part | Chapter |
|---|---|
| I Foundations | [[Ch01 Introduction]] · [[Ch02 Tools of the Trade]] · [[Ch03 Software Engineering Fundamentals]] · [[Ch04 Parallelism and Concurrency]] · [[Ch05 3D Math]] |
| II Low-Level Engine Systems | [[Ch06 Engine Support Systems]] · [[Ch07 Resources and the File System]] · [[Ch08 The Game Loop]] · [[Ch09 Human Interface Devices]] · [[Ch10 Debugging and Development Tools]] |
| III Graphics, Motion and Sound | [[Ch11 The Rendering Engine]] · [[Ch12 Animation Systems]] · [[Ch13 Collision and Rigid Body Dynamics]] · [[Ch14 Audio]] |
| IV Gameplay | [[Ch15 Introduction to Gameplay Systems]] · [[Ch16 Runtime Gameplay Foundations]] |
| V Conclusion | [[Ch17 What Else]] |

## Concepts (with diagrams)
**Architecture:** [[Engine Layers]] · [[Object Models]] · [[Game Object Updates]] · [[Events and Messaging]] · [[Spawners and Type Schemas]] · [[Error Handling Policy]]

**Memory and data:** [[Stack Allocator]] · [[Pool Allocator]] · [[Handles]] · [[String IDs]] · [[Resource Lifetimes]] · [[Saved Games]] · [[Level Streaming]]

**Math:** [[Row vs Column Vectors]] · [[Coordinate Spaces]] · [[Quaternions]]

**Time and loop:** [[Abstract Timelines]] · [[Frame Timing]] · [[Job Systems]]

**Input and debug:** [[Input Action Mapping]] · [[Debug Draw]]

**Rendering:** [[Rendering Pipeline]] · [[Depth Buffer Precision]]

**Animation:** [[Skinning and Matrix Palette]] · [[Animation Pipeline]] · [[Animation Blending]] · [[Animation Clocks]] · [[Action State Machines]] · [[Motion Extraction and IK]]

**Collision:** [[Collision Detection]] · [[Collision Queries]]

**Gameplay:** [[Conversation System]]

## Coverage
I read every chapter. These parts were only skimmed because they don't apply to Plotweaver:
- Ch2: the Subversion and Visual Studio walkthroughs
- 3.4: CPU and assembly basics
- most of Ch4 (pipelining, OS threads, locks, lock-free code, SIMD, GPGPU)
- 13.4: the rigid-body dynamics math
- 14.1–14.4: the physics and math of sound, and DSP

## Old plan numbers in these notes
These notes were written against the plan that was retired on 2026-11-16. Some of their "Plotweaver" sections
still mention its milestone numbers (M1–M21), decision numbers (D1–D15) and section numbers (§2.5, §2.6). Read them with this table.

| Old reference | Now |
|---|---|
| M1, M2, M3 | Stage 2 (The GPU and the engine skeleton). The math of M2 is also Stage 1 |
| M4 (ECS), D5 | Stage 4 and open decision DL-01 in [[Decisions]] |
| M5 (ImGui) | Stage 3 |
| M6, M7 | Stage 4 |
| M8 (lighting), D10 | Stage 7 and DL-08 |
| M9 (performance) | Stage 6 |
| M10 (hot reload), D9 | DL-11 |
| M11–M14 (animation), D13 | Stage 5 and DL-09 |
| M15 (grid and navigation) | Stage 3 (flat), Stage 6 (layered), DL-05 |
| M16, M17 (combat, line of sight, area effects) | Stage 3 (first version), Stage 8 |
| M18 (surfaces), D14, D15 | Stage 8 and DL-06 |
| M19 (conversations), M20 (game UI) | Stage 8 |
| M21 (save and load) | Stages 4 and 9 |
| D3 | S5 |
| D7 | S7 |
| D11, D12 (render extraction, explicit schedule) | Taught in Stages 2 and 4. No longer decided in advance |
| §2.5, §2.6 of the plan | The old plan's ECS and reflection sections. See DL-01 and Lesson 4.8 in the [[Curriculum Map]] |
