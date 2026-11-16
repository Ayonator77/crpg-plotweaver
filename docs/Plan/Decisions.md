---
tags: [plan, decisions]
---

# Decisions

Back to [[Home]].

The old plan handed you its architecture: a sparse-set ECS, a forward renderer, a 2D surface grid, all decided up front. That gave you an engine design and taught you nothing about how to produce one. This page works differently. A few things are **settled**, because you chose them or because nothing is gained by reopening them. Everything else is an **open decision** that you make, at the stage where you finally know enough to make it.

## How to choose an architecture

This is the method. You'll use it for every open decision below, and Stage 0 Module C has a lesson that practises it on a small problem first.

1. **Write down what the thing must do.** Then write the three hardest cases you can think of. For entity storage, "a barrel that gets possessed and joins combat" is a hard case. Easy cases don't separate designs. Hard ones do.
2. **List the options, including the dumbest one.** A plain array of structs is always an option. So is "don't build it". If you can only think of one option, you don't understand the problem yet.
3. **Write the code that *uses* it first.** Before designing storage, write the ten lines a game system would write against it, for each option. The design whose calling code reads best usually wins.
4. **Ask what each option makes easy and what it makes hard.** Look at how the data is read and written: how often, in what order, how many items, by which systems.
5. **Run the cheapest experiment that could change your mind.** A one-day throwaway prototype, a benchmark, a paper trace of the hard cases. Never argue about what you can measure.
6. **Decide, and write it down** with the template at the bottom of this page. Include what evidence would make you reverse it.
7. **Keep the door open.** Put the choice behind a small set of procedures, so changing it later means changing one package.

Two habits go with the method:

- **Do the simple thing until it hurts.** Build the plain version, use it, and note exactly where it fights you. Then you know what the better version has to fix. Abstractions designed before the pain are guesses.
- **Three examples before a general solution.** Write the specific code three times. The shared shape is then visible, and you can pull it out without inventing parts nobody needs.

## Settled

| # | Decision | Why |
|---|---|---|
| S1 | **Odin** is the language | Your choice. Simple, explicit about memory, good for learning what the machine does |
| S2 | **SDL3** for window, input and OS services | Ships with Odin (`vendor:sdl3`), already in use |
| S3 | **OpenGL core profile** first. The renderer sits behind a small set of procedures so another backend can come later | Already in use. Far less ceremony than Vulkan while you are learning what a GPU does |
| S4 | **Turn-based combat on the Plotweaver rules.** Never real-time-with-pause | Your choice |
| S5 | **Right-handed, Y up, metres. Column vectors, column-major matrices** | Matches glTF, OpenGL and Odin's `matrix` type. Note that the GEA book uses row vectors, so its matrices need transposing |
| S6 | **glTF 2.0 (`.glb`) is the format assets arrive in.** Anything else is converted to glb in Blender first | `vendor:cgltf` ships with Odin. Parsing FBX yourself teaches little and costs a lot |
| S7 | **`engine` never imports `game` or `editor`** | Odin forbids import cycles, so the compiler enforces this for you |
| S8 | **The animation system is your own** | It is one of the main things you want to learn |
| S9 | **Dear ImGui for tools and debug UI.** The in-game UI is separate | ImGui is built for tools, not for a game HUD |
| S10 | **No AI-written code, and no AI debugging** | Goal 1. See [[How This Course Works]] |
| S11 | **Large continuous areas, with real height** | Your choice. This drives DL-05, DL-06 and DL-07 |

## Open decisions

Each one lists the options, the experiment to run, and the stage where it's due. Each also has a collapsed note with Claude's current lean. **Don't open the lean until you've written your own answer.** It is one opinion formed before the experiment, and your measurements outrank it.

### DL-01 Entity storage

*Due: Stage 4. Until then, Stage 3 uses plain arrays on purpose.*

How do you store everything in the world (characters, props, lights, triggers) so that systems can find and update what they need?

- **A. One big struct per entity** in an array, with flags saying which parts are in use.
- **B. Separate arrays per kind** of thing: characters, props, lights.
- **C. Sparse-set ECS:** entities are IDs, each component type has its own packed array.
- **D. Archetype ECS:** entities with the same set of components are stored together in tables.

Hard cases: a barrel that catches fire, then gets possessed and joins combat. 20,000 static props that never change. A status effect added and removed many times a turn. The editor showing any object's data without knowing its type in advance.

Experiment: after Stage 3, write the same three systems against A and C in throwaway code. Count the lines, trace the hard cases, and time a loop over 50,000 entities.

> [!note]- Claude's lean (open after writing your own)
> C, a custom sparse-set ECS. You asked for an ECS in the old plan, and the reasons still hold: a systemic CRPG adds and removes small pieces of state constantly, entity counts are in the thousands, and Odin's runtime type information makes a generic inspector cheap. But A is far more capable than its reputation, several shipped games use it, and Stage 3 will show you how far it goes. If A never hurts, that is real evidence.

### DL-02 Movement model

*Due: Stage 3.*

Plotweaver measures movement in 5-foot steps. The reference games differ: DOS2 and BG3 move freely and charge by distance, Rogue Trader uses a square grid.

- **A. Free movement,** cost by path length in metres.
- **B. Square grid,** one cell per 5 feet (1.5 m).
- **C. Free movement for exploration, grid for combat.**

This choice touches pathfinding, area effects, surfaces and the UI, so decide it by playing. Experiment: build A and B in the graybox with the same fight and play both.

> [!note]- Claude's lean
> A, free movement over a fine navigation grid, with costs shown in Plotweaver feet. It matches the Larian feel you named and it suits vertical maps better. B is noticeably easier to build and to make AI for. If you find you enjoy the grid version more, take B without guilt.

### DL-03 OpenGL version and style

*Due: Stage 2.*

- **A. Stay on 4.3** with bind-to-edit calls, as now.
- **B. Move to 4.6 with Direct State Access,** where you name the object you are changing in each call.

Experiment: write the same textured-quad setup both ways and compare how many ways each can go wrong.

> [!note]- Claude's lean
> B. Your GPU supports it, it removes a whole class of "wrong thing was bound" bugs, and its model is closer to modern APIs.

### DL-04 Data format and reload

*Due: Stage 3.*

How are actions, conditions, characters and encounters defined, and can they change while the game runs?

- **A. Odin code** (tables of struct literals).
- **B. JSON files** loaded at startup.
- **C. JSON files, reloaded when they change on disk.**
- **D. A custom text format.**

> [!note]- Claude's lean
> Start with A in Stage 3, since it is the fastest to change while you are still discovering the shapes. Move to C once the shapes settle. Names in data files, never enum numbers.

### DL-05 Navigation for verticality

*Due: Stage 6.*

The map has overlapping walkable levels, and characters jump, climb, fly and teleport. A flat 2D grid can't describe a bridge over a road.

- **A. Layered grid from voxelization:** scan the level geometry into columns of solid and empty spans, and keep the walkable tops as cells. Several cells can share one (x, z).
- **B. Navigation mesh:** polygons covering the walkable surfaces.
- **C. Hand-placed waypoints and links.**

Jumps, drops, ladders and teleports are **links** between cells or polygons in every option. Flying needs its own answer: either a 3D grid of open space, or "fly is a link between two walkable spots with a clear arc".

Experiment: on paper first. Trace a two-storey building with a bridge through A and B.

> [!note]- Claude's lean
> A. Cells are what surfaces, area effects and cover want anyway, so one structure serves pathfinding and DL-06. Larian's engine uses a grid as well. B gives smoother paths with less memory but makes surfaces a separate problem.

### DL-06 Surface representation

*Due: Stage 8. Depends on DL-05.*

Where do fire, water, oil, poison and ice on the ground live, and where do clouds live?

- **A. A field on the navigation cells:** each walkable cell has a surface type and timer. Works on every height level for free if DL-05 is A.
- **B. Flat 2D grid layers,** one per floor.
- **C. Surface entities** with shapes.

Statuses on characters (wet, burning, chilled, frozen) are a separate, smaller question and belong with conditions, whatever DL-01 turns out to be.

> [!note]- Claude's lean
> A. A surface is a property of a place, and reactions depend on neighbours, which cells give you in constant time. C makes "what is under this character's feet?" a search.

### DL-07 Streaming unit

*Due: Stage 6.*

How is a large map cut up so only the nearby part is loaded and drawn?

- **A. Fixed square chunks** on a grid.
- **B. Hand-authored regions.**
- **C. Everything loaded, only culling.**

Experiment: measure C first. A 500 m map might simply fit, and then streaming is a memory question for later, not an MVP blocker.

> [!note]- Claude's lean
> Measure C, then build A when the numbers ask for it.

### DL-08 Lighting architecture

*Due: Stage 7.*

- **A. Forward:** each object is shaded once, looping over the lights that affect it.
- **B. Clustered forward:** the view is cut into a 3D grid of cells, each with a list of lights, and each pixel only loops over its cell's list.
- **C. Deferred:** write surface properties to buffers first, then light each pixel once.

Hard cases: a street of thirty torches, a field of burning cells, transparent fog and particles, anti-aliasing.

> [!note]- Claude's lean
> Start with A and one sun, because it is the smallest step from Stage 2. Move to B when light counts climb. B handles transparency and many lights and keeps one shading path.

### DL-09 Animation runtime shape

*Due: Stage 5.*

- **A. Controls with weighted accumulation,** in the style of Granny 3D: each playing clip has a weight, and the pose is a weighted average. A small state machine sits on top.
- **B. A blend tree:** a graph of nodes that each combine poses.

Also to decide here: does each playing clip keep its own clock, or store a start time against one global clock? The global clock keeps paired animations (an attack and its hit reaction) in step.

> [!note]- Claude's lean
> A, with a global clock. It is simple, proven in CRPGs, and enough for turn-based characters. See [[Animation Blending]] and [[Animation Clocks]].

### DL-10 Asset pipeline

*Due: Stage 4, revisit in Stage 6.*

- **A. Load glb files directly at runtime.**
- **B. Cook assets into your own binary format** offline and load that.

> [!note]- Claude's lean
> A until load times are measured to be a problem. Then B, and the cooked format is a good lesson in itself.

### DL-11 Hot reload of game code

*Due: optional, Stage 3 or 4.*

Build `game` as a DLL and reload it while the engine runs?

> [!note]- Claude's lean
> Worth it once rule-tweaking dominates your time, which is Stage 8. It also teaches a lot about what a program is. Not before Stage 4.

### DL-12 Editor and game relationship

*Due: Stage 4.*

- **A. One program** with an edit mode and a play mode.
- **B. Two programs** sharing the engine.

> [!note]- Claude's lean
> A. Play-in-editor is the whole point of owning your tools, and the acceptance walk-through assumes it.

### DL-13 Scripting

*Due: Stage 8.*

How do encounters, dialogue conditions and special abilities express logic that data tables can't?

- **A. Data only:** conditions and effects are small tagged structs the game interprets.
- **B. Embedded Lua** (`vendor:lua` ships with Odin).
- **C. Odin code** registered by name.

> [!note]- Claude's lean
> A plus C. See how far it goes before adding a second language.

### DL-14 Frame budget

*Due: Stage 6.*

What frame time does the MVP hold, on what machine, at what resolution? 16.6 ms is 60 frames per second. 6.9 ms is 144.

> [!note]- Claude's lean
> 16.6 ms at 1440p on your current machine in the worst scene, with the editor open. Then track the typical frame separately and try to keep it under 7 ms.

### DL-15 Threading

*Due: Stage 6.*

Single-threaded, a few dedicated threads (asset loading), or a job system?

> [!note]- Claude's lean
> One background thread for loading first, because streaming needs it. A job system only when a profile shows a system that needs it.

## Decision record template

Copy this into a new section under "Made" when you decide something.

```markdown
### DR-00 Title (date)
**Question:** what is being decided, in one sentence.
**Must handle:** the requirements and the three hardest cases.
**Options considered:** each with what it makes easy and what it makes hard.
**Experiment:** what you built or measured, and the result.
**Decision:** what you chose.
**Would reverse if:** the evidence that would change your mind.
**Boundary:** which package hides this choice from the rest of the code.
```

## Made

Nothing yet. Your first record will be for [[#DL-03 OpenGL version and style|DL-03]] in Stage 2, or earlier if a Stage 0 lab asks for one.
