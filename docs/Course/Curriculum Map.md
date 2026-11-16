---
tags: [course]
---

# Curriculum Map

Back to [[Home]]. Stages and their gates are described in the [[Roadmap]]. Sources named here are listed in full in [[Sources]].

**Status:** ✍️ written and ready · 📋 planned, written when you get close.

Later lessons are planned and not yet written, on purpose. What they need to cover depends on what the gates before them show.

## Stage 0 — The Machine

### Module A — Programs and bytes ✍️

| # | Lesson | You come out able to |
|---|---|---|
| 0.1 | [[0.1 From notebook to executable]] | Explain what the compiler and linker produce, build and run from the terminal, read compiler errors |
| 0.2 | [[0.2 The debugger]] | Stop a program anywhere, step through it, read variables and the call stack, find a bug without print statements |
| 0.3 | [[0.3 Bits, bytes and integers]] | Read binary and hex, predict overflow, pack several values into one integer, use `bit_set` |
| 0.4 | [[0.4 Floating point]] | Explain why floats are inexact, where precision runs out, and how to compare them |
| 0.5 | [[0.5 Addresses and pointers]] | Draw memory, take and follow addresses, explain value vs. pointer parameters |
| 0.6 | [[0.6 Arrays, slices and strings]] | Explain what a slice is made of, predict aliasing, walk bytes of a UTF-8 string |
| Gate | [[Gate A - Hex dump]] | Build a hex dump tool and read a real binary file header with it |

### Module B — Memory 📋

| # | Lesson | You come out able to |
|---|---|---|
| 0.7 | Structs and layout | Predict `size_of` and padding, order fields well, read a struct in the memory view |
| 0.8 | The stack | Explain what a call does to memory, and why returning a pointer to a local is a bug |
| 0.9 | The heap and lifetimes | Allocate and free, name the owner of every allocation, find leaks and use-after-free with the tracking allocator |
| 0.10 | Build a dynamic array | Write your own growable array, and explain why growing it breaks pointers into it |
| 0.11 | Arenas | Write an arena allocator, plug it into `context.allocator`, explain the temp allocator |
| 0.12 | Pools and handles | Write a pool with a free list and generational handles that detect stale use |
| Gate | Gate B — Entity table | A table of game entities on your own pool and arena, with tests and zero leaks |

### Module C — Speed and structure 📋

| # | Lesson | You come out able to |
|---|---|---|
| 0.13 | Measuring | Time code correctly, read a profile, state a result with its uncertainty |
| 0.14 | The cache | Explain why walking an array beats chasing pointers, and show it with a benchmark |
| 0.15 | Layout for speed | Compare array-of-structs with struct-of-arrays (`#soa`) on a real loop |
| 0.16 | Enums, unions and state machines | Model "one of several things" and "what state am I in" as data |
| 0.17 | Errors | Use multiple return values, `or_return` and asserts, and decide which failures are bugs |
| 0.18 | Packages and tests | Split a program into packages, write tests with `core:testing` |
| 0.19 | Choosing a design | Run the seven-step method from [[Decisions]] on a small problem and write a decision record |
| Gate | Gate C — The skill-test kernel | Plotweaver's d20, modifiers, advantage and plot die as a tested package, checked by simulation against exact probabilities |

## Stage 1 — Pixels from first principles 📋

Main sources: Gambetta, *Computer Graphics from Scratch*. Sokolov, *tinyrenderer*. 3Blue1Brown, *Essence of Linear Algebra*.

| # | Lesson |
|---|---|
| 1.1 | A framebuffer: pixels, colour, getting an image on screen with SDL |
| 1.2 | Lines, and why integers are enough |
| 1.3 | Vectors: length, dot product, cross product, what each one tells you |
| 1.4 | Filling a triangle: edge functions and barycentric coordinates |
| 1.5 | Matrices as machines that move points: scale, rotate, translate, compose |
| 1.6 | Coordinate spaces: model, world, view |
| 1.7 | Perspective: projection, the divide by w, clip space |
| 1.8 | The depth buffer |
| 1.9 | Clipping and back-face culling |
| 1.10 | Textures, and perspective-correct interpolation |
| 1.11 | Light on a surface: normals and Lambert's law |
| 1.12 | Rotation done properly: Euler angles, their failure, quaternions |
| Gate | A lit, textured, spinning cube rendered by your own code |

## Stage 2 — The GPU and the engine skeleton 📋

Main sources: *learnopengl.com*. Giesen, *A Trip Through the Graphics Pipeline*. GEA chapters 1, 6, 8, 9, 10.

| # | Lesson |
|---|---|
| 2.1 | What a GPU is, and what a driver does with your calls |
| 2.2 | Rebuild drill: window, context and main loop from a blank file |
| 2.3 | Buffers and vertex layouts (decide [[Decisions#DL-03 OpenGL version and style\|DL-03]]) |
| 2.4 | Shaders: the two programs you wrote by hand in Stage 1 |
| 2.5 | Uniforms and uniform blocks |
| 2.6 | Textures, mipmaps, filtering, sRGB |
| 2.7 | Depth, culling, blending |
| 2.8 | Rebuild drill: input and frame timing |
| 2.9 | A tactical camera: orbit, pan, zoom |
| 2.10 | Meshes and a draw list: the renderer stops knowing what it draws |
| 2.11 | Debug drawing: lines, boxes, text |
| 2.12 | Framebuffers: rendering to a texture |
| 2.13 | Layers: what belongs in `engine`, what belongs in `game` |
| Gate | A world of lit, textured cubes with a CRPG camera, and an oral walk through every GL call |

## Stage 3 — Graybox CRPG 📋

Main sources: Red Blob Games (grids, A\*). Nystrom, *Game Programming Patterns*. [[Plotweaver Rules Digest]].

| # | Lesson |
|---|---|
| 3.1 | Dear ImGui: immediate-mode UI and binding a C library |
| 3.2 | Game state as plain data |
| 3.3 | Picking: from a mouse position to a ray to a point in the world |
| 3.4 | Grids and graphs |
| 3.5 | Pathfinding: breadth-first search, Dijkstra, A\* |
| 3.6 | Moving along a path (decide [[Decisions#DL-02 Movement model\|DL-02]]) |
| 3.7 | A party of n: selection, following |
| 3.8 | The turn loop as a state machine: Plotweaver fast and slow turns |
| 3.9 | Actions as data: Move and Strike (decide [[Decisions#DL-04 Data format and reload\|DL-04]]) |
| 3.10 | Attack tests, damage, deflect, health and focus |
| 3.11 | NPCs and the simplest possible enemy AI |
| 3.12 | Testing a game with no window |
| Gate | A fight someone else can play to the end |

## Stage 4 — Assets, world model and level editor 📋

Main sources: the glTF 2.0 specification. GEA chapters 7, 15, 16. Fabian, *Data-Oriented Design*.

| # | Lesson |
|---|---|
| 4.1 | Resource lifetimes and handles in the engine |
| 4.2 | Reading a glb by hand with your hex dump tool |
| 4.3 | Importing static meshes with cgltf |
| 4.4 | Textures and materials. Placeholders for broken assets |
| 4.5 | Entity storage: the decision lab ([[Decisions#DL-01 Entity storage\|DL-01]]) |
| 4.6 | Building the storage you chose |
| 4.7 | Transforms and hierarchies |
| 4.8 | Runtime type information: an inspector for any struct |
| 4.9 | Serialization: saving and loading a scene |
| 4.10 | The editor viewport, selection, gizmos |
| 4.11 | Undo and redo |
| 4.12 | Instancing: drawing a thousand copies cheaply |
| Gate | A village block built, saved, reloaded and fought in |

## Stage 5 — Animation system and editor 📋

Main sources: GEA chapter 12 and the [[GEA Index|animation concept notes]].

| # | Lesson |
|---|---|
| 5.1 | Skeletons: a hierarchy stored as a flat array |
| 5.2 | Skinning on paper: one vertex, two joints |
| 5.3 | Skinning on the GPU |
| 5.4 | Clips: keyframes, sampling, interpolation |
| 5.5 | Blending two poses. Why averaging rotations is delicate |
| 5.6 | Many clips at once: weights, crossfades, masks (decide [[Decisions#DL-09 Animation runtime shape\|DL-09]]) |
| 5.7 | Locomotion: blending by speed without sliding feet |
| 5.8 | The animation state machine |
| 5.9 | Events: telling the game when the sword lands |
| 5.10 | Root motion |
| 5.11 | The animation editor: timeline, events, state graph |
| 5.12 | Retargeting between skeletons (optional for the MVP) |
| Gate | Animated characters in the graybox fight, with damage on the hit frame |

## Stage 6 — Big world and verticality 📋

Main sources: Drepper, *What Every Programmer Should Know About Memory*. The Recast navigation papers and source. GEA chapters 4, 8, 16.4.

| # | Lesson |
|---|---|
| 6.1 | Profiling the CPU with spall. Profiling the GPU with timer queries |
| 6.2 | Budgets (decide [[Decisions#DL-14 Frame budget\|DL-14]]) |
| 6.3 | Bounding volumes and frustum culling |
| 6.4 | Spatial structures: grids, trees |
| 6.5 | Level of detail |
| 6.6 | Threads, and one background loader (decide [[Decisions#DL-15 Threading\|DL-15]]) |
| 6.7 | Streaming a large map (decide [[Decisions#DL-07 Streaming unit\|DL-07]]) |
| 6.8 | Terrain |
| 6.9 | Voxelizing a level into walkable spans (decide [[Decisions#DL-05 Navigation for verticality\|DL-05]]) |
| 6.10 | Pathfinding across layers |
| 6.11 | Traversal links: jump, drop, climb |
| 6.12 | Flying and teleporting |
| 6.13 | The camera in a vertical world: roofs, floors, occluders |
| 6.14 | Editor tools for all of the above |
| Gate | The party crosses the map and three height levels inside the frame budget |

## Stage 7 — Light and air 📋

Main sources: *learnopengl.com* (PBR, shadows). The Filament design document. Akenine-Möller et al., *Real-Time Rendering*.

| # | Lesson |
|---|---|
| 7.1 | What light is, in plain words: radiance, the rendering equation |
| 7.2 | Linear colour, HDR, tone mapping |
| 7.3 | Physically based materials |
| 7.4 | Normal mapping and tangent space |
| 7.5 | Shadow maps |
| 7.6 | Cascaded shadows for a large world |
| 7.7 | Many lights (decide [[Decisions#DL-08 Lighting architecture\|DL-08]]) |
| 7.8 | Ambient light and reflections |
| 7.9 | Sky and time of day |
| 7.10 | Fog, then volumetric fog |
| 7.11 | Post-processing: bloom, ambient occlusion, colour grading |
| 7.12 | Particles |
| Gate | The big map at dusk with torches, fog and shadows, inside budget |

## Stage 8 — The Plotweaver systems 📋

Main sources: [[Plotweaver Rules Digest]]. GEA 14.6.2 and 16.8. Red Blob Games.

| # | Lesson |
|---|---|
| 8.1 | Conditions and statuses as data |
| 8.2 | Reactions and the ready action: interrupting a turn |
| 8.3 | Line of effect, range, cover |
| 8.4 | Area effects: shapes on cells |
| 8.5 | Surfaces as a field (decide [[Decisions#DL-06 Surface representation\|DL-06]]) |
| 8.6 | Reaction tables and chain reactions |
| 8.7 | Clouds, spread and decay |
| 8.8 | Elemental statuses on characters |
| 8.9 | Drawing surfaces and clouds |
| 8.10 | Enemy AI: scoring actions |
| 8.11 | The encounter editor |
| 8.12 | Exploration: interaction, skill tests, endeavors |
| 8.13 | NPC routines |
| 8.14 | Conversations: influence, focus, resisting |
| 8.15 | The dialogue editor (decide [[Decisions#DL-13 Scripting\|DL-13]]) |
| 8.16 | The game UI |
| Gate | Each system's tests and demo scene pass |

## Stage 9 — The MVP slice 📋

| # | Lesson |
|---|---|
| 9.1 | Building the slice map |
| 9.2 | A performance pass against the budget |
| 9.3 | Saving and loading a running game |
| 9.4 | Release builds and packaging |
| Gate | The acceptance walk-through in [[North Star and MVP]] |
