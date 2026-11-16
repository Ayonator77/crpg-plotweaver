---
tags: [plotweaver, gea, decisions]
---

# GEA and the Plotweaver plan

How the book relates to the [[Roadmap]] and the [[Decisions]]. Back to [[GEA Index]].

## Where the book supports something settled

| Plan item | Book evidence |
|---|---|
| S7: `engine` never imports `game` or `editor` | GEA 1.6: upper layers depend on lower ones, never the reverse. See [[Engine Layers]] |
| Explicit `init` and `shutdown` pairs called from `main` | GEA 6.1: explicit start-up and shut-down is simple and debuggable |
| Thinking in lifetimes (Stage 0, Module B) | GEA 6.2: stack, double-ended stack, single-frame and double-buffered allocators. See [[Stack Allocator]], [[Resource Lifetimes]] |
| Handles in place of pointers (Lesson 0.12, Stage 4) | GEA 6.2.2, 16.5. See [[Handles]] |
| Vsync and delta time, no sleep for pacing | GEA 8.5. See [[Frame Timing]] |
| S8: your own animation system | GEA 12.9's six-stage pipeline is the frame loop to build. See [[Animation Pipeline]] |

## Where the book informs an open decision

| Decision | What the book offers |
|---|---|
| [[Decisions#DL-01 Entity storage\|DL-01]] Entity storage | GEA 16.2 compares object-centric and property-centric models. The property-centric one is an ECS (used in Thief, Deus Ex 2, Dungeon Siege). See [[Object Models]]. GEA 16.6 covers batched and phased updates. See [[Game Object Updates]]. GEA 16.7.4.5: deferring structural changes to a queue |
| [[Decisions#DL-04 Data format and reload\|DL-04]] Data format | GEA 6.4.3 and 16.8.3: hashed string ids for names in data, and never saving enum numbers. See [[String IDs]]. GEA 16.3.3: spawners and schemas with defaults. See [[Spawners and Type Schemas]] |
| [[Decisions#DL-07 Streaming unit\|DL-07]] Streaming | GEA 16.4. See [[Level Streaming]] |
| [[Decisions#DL-09 Animation runtime shape\|DL-09]] Animation runtime | GEA 12.10.1.2: Granny is a flat weighted average with normalised weights. GEA 12.4.3: Granny uses a global clock, where each playing clip stores a start time and a rate. Local clocks can leave paired clips a frame apart. See [[Animation Blending]], [[Animation Clocks]] |
| [[Decisions#DL-13 Scripting\|DL-13]] Scripting | GEA 16.9. For dialogue, GEA 14.6.2 describes Naughty Dog's conversation system: segments, rules over fact dictionaries, speaker and listener roles, priorities. See [[Conversation System]] |
| [[Decisions#DL-15 Threading\|DL-15]] Threading | GEA chapter 4 and 8.6. See [[Job Systems]] |

## Things the book adds that the roadmap should include

1. **Transpose the book's matrices.** It uses row vectors and the engine uses column vectors (S5). See [[Row vs Column Vectors]]. Matters from Stage 1.
2. **A game clock separate from real time,** for pause, single-step and slow motion while debugging combat (GEA 8.4, 10.5). See [[Abstract Timelines]]. Stage 2.
3. **An input action-mapping layer,** so keys can be rebound and the editor and game each own their inputs (GEA 9.5.7–9.5.8). See [[Input Action Mapping]]. Stage 3.
4. **Queued debug drawing with lifetimes** (GEA 10.2). See [[Debug Draw]]. Stage 2.
5. **A policy for developer errors:** show a magenta texture or red text, don't crash (GEA 3.2.2.2, 10.9). See [[Error Handling Policy]]. This is MVP item E1. Stage 4.
6. **Save format:** leave out values equal to the default, and save only the dynamic state that gameplay needs (GEA 16.3.3, 16.4.5). See [[Saved Games]]. Stages 4 and 9.
7. **Animation state machine details:** transition windows, named transitions, wildcard defaults, attach points, reference locators for paired animations. See [[Action State Machines]], [[Motion Extraction and IK]]. Stage 5.
8. **Where to dispatch animation events:** advance clocks, dispatch events, then blend, so an end-of-clip event can start the next clip in the same frame (GEA 16.8.9.2). See [[Events and Messaging]]. Stage 5.
9. **Camera occluders:** fade or cut away what sits between the camera and the party (GEA 13.5.3.7). Stage 6, and central to verticality.

## What the book doesn't cover

Other sources are needed for these. See [[Sources]].

- Everything in Stage 0 and Stage 1 at the level this course teaches it. The book assumes you already program in C++
- Navigation grids, navigation meshes and A\*
- Turn-based structure, initiative and action economies
- Grid fields, cellular automata, surfaces
- How modern ECS storage works (sparse sets, archetypes)
- Modern OpenGL (4.6, DSA), clustered shading, volumetric fog
- Odin
