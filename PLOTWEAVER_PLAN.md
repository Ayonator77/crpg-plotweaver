# Plotweaver — Engine & Game Plan

> Working document (tracked in git). This is the plan we follow from session to session:
> milestones, decisions and their reasons, and what you have learned so far.
> **You write the code yourself.** Claude explains, reviews and gives snippets. The snippets are there
> to teach, so read them, understand them, then type your own version.

---

## 0. The North Star

A 3D, turn-based, party CRPG in the vein of **Divinity: Original Sin 2** and **Rogue Trader**, built on a
**from-scratch engine** in **Odin + OpenGL + SDL3**. The engine has an **Entity Component System (ECS)** at its core,
a **Dear ImGui + ImGuizmo editor**, and a **custom animation system**. The **Plotweaver TTRPG ruleset** is the game layer.

The second goal matters as much as the first: **by the end you should be a noticeably better programmer.**
That means you should understand *why* each piece exists and not just have code that works.

### Learning tracks (every milestone touches several)

| Track | What "mastery" looks like by the end |
|---|---|
| **Odin** | Allocators and `context`, `defer`, distinct types, parametric polymorphism (`$T`), `typeid`/`rawptr`/`core:reflect`, `#soa`, unions, procedure groups, `when`, packages, `odin test`, foreign imports |
| **OpenGL / GPU** | The pipeline end to end, buffers and VAOs, UBOs and SSBOs, FBOs, textures and sRGB, instancing, shadow maps, GPU skinning, debug output, timer queries |
| **Memory** | Thinking in *lifetimes* (frame, level, program), arenas, the temp allocator, the tracking allocator, handles and entity IDs instead of pointers |
| **Performance** | Measure first, frame budgets, cache lines, AoS vs SoA, draw call and state reduction, CPU/GPU sync pitfalls |
| **Architecture & ECS** | Engine / Editor / Game split, dependency direction, **data-oriented design**, composition over inheritance, systems as plain procedures, deferred structural changes, render extraction |
| **Animation** | Skeletons, sampling, quaternion interpolation, blending, state machines, retargeting, IK. You will be able to explain each algorithm |

---

## 1. Where we are right now (snapshot: 2026-09-22)

**Done (M0):** SDL3 window, OpenGL 4.3 core context, a triangle drawn from shaders loaded from files,
colour controlled by a uniform, and a clean `init`/`shutdown` pair for each subsystem, with shutdown
tolerating a partial init. The folder layout moved to `src/engine/*` and uses the `pw:` collection.

**Things you did well (keep doing these):**

- Each subsystem receives an explicit `^State`, so there are no hidden globals. This is the backbone of the engine/game split.
- `defer platform.shutdown(&host)` is registered *before* `init`, and `shutdown` checks each field, so a half-initialised state still cleans up. That's a mature pattern.
- The shader compile and link paths check their errors and print the GL info log.

**Things we'll fix in M1 (they make good lessons):**

1. **Engine/game leak:** `platform.Events` has `r_pressed/g_pressed/b_pressed`. The *engine* now knows about
   a *game* feature. The platform layer should expose generic input state, and the game should decide what "R" means.
2. **Renderer knows about "the triangle":** `renderer.State` has `triangle_vao`, and the shader paths are hard-coded
   inside `renderer`. A renderer should own *resources* (meshes, shaders), not specific game objects.
   In ECS terms, "the triangle" will become an *entity* with a `Mesh_Renderer` component.
3. **`platform.pause(8)` as a frame limiter:** a sleep isn't a frame limiter. Use vsync plus measured delta time.
4. **`run.bat` comment vs reality:** the comment says `-debug` enables a tracking allocator and a GL debug context,
   but neither is set up yet. `ODIN_DEBUG` is defined, but nothing reads it. We'll make the comment true.
5. **`spatial.Transform` has no rotation:** we'll add a `quaternion128` and explain why quaternions and not Euler angles.
   It will later split into `Local_Transform` and `World_Transform` components (see §2.5).
6. The shader file source could use `context.temp_allocator`, which is our first real memory-lifetime lesson.

**Editor mock-up:** the reference photo didn't come through in the planning session. §6 uses a standard layout
until you re-attach it.

---

## 2. Architecture — the how and the why

### 2.1 The three layers

```
                ┌──────────────────────────────┐
                │           main.odin          │  "composition root": creates everything,
                │  (owns the loop, wires deps) │  decides order, owns lifetimes
                └──────┬──────────┬──────────┬─┘
                       │          │          │
               ┌───────▼───┐ ┌────▼─────┐ ┌──▼────────┐
               │   game/   │ │ editor/  │ │ (tools/)  │
               │ components│ │ ImGui    │ │ importers │
               │ + systems │ │ panels,  │ │ bakers    │
               │ rules,    │ │ gizmos,  │ │           │
               │ combat,   │ │ undo,    │ │           │
               │ dialogue  │ │ reflect- │ │           │
               │           │ │ inspector│ │           │
               └─────┬─────┘ └────┬─────┘ └─────┬─────┘
                     │            │             │
               ┌─────▼────────────▼─────────────▼──────┐
               │                engine/                │
               │ core · ecs · platform · math ·        │
               │ renderer · assets · scene · animation │
               │ · nav · audio · debug                 │
               └───────────────────────────────────────┘
```

**The one rule: arrows only point down.** `engine` never imports `game` or `editor`.

**Why this matters:**

- **Odin enforces it for you.** Odin forbids cyclic package imports. If `engine/renderer` ever tries to
  import `game`, the compiler refuses. So the architecture holds because the build fails when you break it,
  not because you remembered to be disciplined.
- **Reuse:** the engine can ship a second game, or a sci-fi spinoff built on the Modular Sci-Fi kit, with no changes.
- **Testability:** game rules (a d20 vs DC, the plot die) are plain data and procedures. They can be tested with no window.
- **Hot reload (M10):** if `game` is a separate package with a narrow interface, you can compile it as a DLL and
  reload it while the engine keeps running. That's a huge boost to iteration speed for a CRPG with lots of rules.
- **Thinking clearly:** when you write code, ask "does this know about d20s, factions or dialogue?"
  If yes, it goes in `game`. If it's about triangles, files, time or bones, it goes in `engine`.

**How ECS fits the split.** The ECS *machinery* (entities, pools, queries) lives in `engine/ecs` and knows nothing
about any specific component. The **engine** defines engine components (`Local_Transform`, `Mesh_Renderer`,
`Animator`, `Light`, `Camera`) and engine systems. The **game** defines its own components (`Stats`, `Initiative`,
`Faction`, `Status_Effect`) and systems, and *registers* them with the same world at startup.
The world holds both kinds, and the engine still never imports the game.

**Where does the editor go?** The editor is a *tool* on top of the engine. Thanks to ECS plus Odin's
runtime type information, the editor can show **any** component, including game ones, without importing
`game`. It walks the registered component types with `core:reflect` (see §2.6).

### 2.2 Target folder layout

```
src/
  main.odin                 composition root + main loop + system schedule
  engine/
    core/                   logging, handles, pools, arenas, time, asserts
    ecs/                    entities, sparse-set pools, queries, command buffer, registry
    platform/               SDL window, GL context, input state, file paths
    math/  (spatial/)       transform math, camera math, rays, AABBs, planes
    renderer/               gl wrappers, shader, mesh, texture, material, passes, debug draw
                            (knows NOTHING about ECS; it consumes a flat render list)
    scene/                  engine components + systems: transforms/hierarchy, render extraction,
                            camera, lights; scene serialization
    assets/                 glTF import (cgltf), texture load (stb), asset cache, handles
    animation/              skeleton, clip, sampling, blend, state machine, IK, retarget
                            + Animator component and animation systems
    grid/                   generic cell grids: world↔cell, neighbours, shape rasterisation,
                            flood fill, dirty rects, GPU upload + grid-decal render feature
    nav/                    A* (with cost callback), line of sight
    audio/                  (later) miniaudio wrapper
  editor/                   imgui setup, dockspace, panels, gizmos, undo/redo, reflection inspector
  game/                     plotweaver components + systems, combat flow, surfaces (types, reactions,
                            statuses), dialogue, AI, game UI
assets/                     shaders, models (.glb), textures, data (.json)
```

### 2.3 The engine ↔ game contract

```odin
// game/game.odin: the game exposes a small, stable surface.
package game

import "pw:engine/ecs"
import "pw:engine/core"

// Game components are plain data. No methods, no inheritance.
Stats      :: struct { health, focus, essence: i32 }
Initiative :: struct { value: i32 }
Turn_Active :: struct {}                 // a "tag": zero-size component, pure marker

register_components :: proc(world: ^ecs.World) {
    ecs.register(world, Stats)
    ecs.register(world, Initiative)
    ecs.register(world, Turn_Active)
}

init     :: proc(world: ^ecs.World, engine: ^core.Engine) -> ^Game_State { /* ... */ }
update   :: proc(game: ^Game_State, world: ^ecs.World, dt: f32) { /* runs game systems */ }
shutdown :: proc(game: ^Game_State) { /* ... */ }
```

`main.odin` calls these. Later, for hot reload, the same procedures get loaded from `game.dll` by name.

### 2.4 Explicit state over globals

You're already doing this with `platform.State` and `renderer.State`. The rule is that **a procedure's inputs
are its parameters.** In ECS, that means every system is `proc(world: ^ecs.World, ...)`. There is no global world.
We'll allow exactly one kind of implicit state: Odin's `context` (the allocator and logger). It's designed for that.

### 2.5 The ECS — what it is and why

**The three ideas:**

- **Entity**: just an ID. It has no data and no behaviour. Think of it as a row number.
- **Component**: a plain struct of data attached to an entity (`Local_Transform`, `Stats`, `Burning`).
- **System**: a plain procedure that runs over *every entity that has a certain set of components*.

**Why ECS for *this* game.** DOS2 is famously *systemic*. You can set a barrel on fire, electrify water,
possess an object, or turn a chicken into a party member. With inheritance (`Barrel extends Prop`,
`Character extends Actor`), every "what if a barrel could…" breaks the class tree.
With ECS, you just **add a component**:

```
Barrel      = [Local_Transform, Mesh_Renderer, Flammable, Health]
+ set alight  → add Burning           (burning system now affects it; nothing else changes)
+ possessed   → add Controllable, Initiative, Stats   (it joins combat)
```

That's **composition over inheritance**, and it's the big architectural lesson of this project.

**Entity IDs are generational handles** (the same idea as §3):

```odin
Entity :: struct { index: u32, generation: u32 }
// A destroyed entity's index is reused with generation + 1,
// so old IDs held by (say) an "attack target" field are detected as dead instead of silently
// pointing at whatever entity took that slot.
```

**Storage: sparse sets (decision D5).** Each component type gets one pool:

```
entity index:   0    1    2    3    4    5
sparse:        [ 1 , -  , 0  , -  , 2  , - ]   entity index → slot in dense  (- = doesn't have it)
                 │         │         │
dense:         [ e2 , e0 , e4 ]                 packed list of owners
data:          [ S2 , S0 , S4 ]                 packed components, same order as dense
```

- **has / get**: `sparse[e.index]` → slot. O(1).
- **add**: append to `dense`/`data`, then record the slot in `sparse`. O(1).
- **remove**: **swap-remove**. Move the *last* element into the hole so the arrays stay packed. O(1).
- **iterate**: walk `data` linearly. It's contiguous memory, so the CPU prefetcher is happy (a performance lesson).

```odin
Sparse_Set :: struct($T: typeid) {
    sparse: [dynamic]u32,     // entity.index → slot in dense (or INVALID)
    dense:  [dynamic]Entity,  // owners, packed
    data:   [dynamic]T,       // components, packed, parallel to dense
}

remove :: proc(set: ^Sparse_Set($T), e: Entity) {
    slot := set.sparse[e.index]
    last := len(set.dense) - 1
    set.dense[slot] = set.dense[last]           // move the last owner into the hole
    set.data[slot]  = set.data[last]            // ...and its component
    set.sparse[set.dense[slot].index] = slot    // fix up the moved entity's lookup
    pop(&set.dense)
    pop(&set.data)
    set.sparse[e.index] = INVALID
}
```

The generic `Sparse_Set($T)` above is the *teaching* version. The real world can't have a field per component type,
because the engine can't know about game components. So in M4 you'll build a **type-erased** pool
(`data: [dynamic]byte` + element size, keyed by `typeid`) with typed accessors on top:

```odin
get :: proc(world: ^World, e: Entity, $T: typeid) -> ^T   // typed API on the outside...
// ...inside: pool := world.pools[T]; bytes at slot * size_of(T); cast to ^T
```

That teaches `typeid`, `rawptr`, `size_of` and how generic containers are really built.

**Queries:** to run a system over `(Local_Transform, Velocity)`, iterate the **smaller** pool and check the
other with an O(1) `has`. Simple, and fast enough for our entity counts.

```odin
velocity_system :: proc(world: ^ecs.World, dt: f32) {
    for e in ecs.each(world, Velocity) {                 // walk the Velocity pool
        transform := ecs.get(world, e, Local_Transform)  // look up the other component
        if transform == nil do continue
        velocity := ecs.get(world, e, Velocity)
        transform.position += velocity.value * dt
    }
}
```

**Sparse set vs archetype (why we chose sparse sets).**

| | Sparse set (EnTT-style) | Archetype (Unity DOTS, Bevy, flecs) |
|---|---|---|
| Add/remove a component | O(1), nothing moves | Entity *moves* to another table (copies all its components) |
| Iterating 1 component | Perfect, contiguous | Perfect, contiguous |
| Iterating many components | Lookups into the other pools | Perfect, all in one table |
| Complexity to write | Low | High (tables, graphs of archetype moves) |

A CRPG **adds and removes components constantly**: `Burning`, `Stunned`, `Selected`, `Turn_Active`, `In_Combat`.
It also has **hundreds, not millions**, of entities. That favours sparse sets. We'll measure in M9, and if
profiling ever proves otherwise, the `ecs` API can stay the same while the storage changes. That's the value of
a clean package boundary.

**The rules that keep ECS code sane:**

1. **Components are data only.** No procedures inside them, and no pointers to other entities' components (store `Entity` IDs).
2. **Systems are plain procedures** run in an **explicit order** written in `main.odin`. There's no hidden scheduler magic, so you can read the frame top to bottom.
3. **No structural changes while iterating.** Adding or removing components during a loop can swap-remove the very element you're on (iterator invalidation). Instead, record changes in a **command buffer** and apply them after the system finishes.
4. **Pointers from `get` are short-lived.** They're valid until that pool changes. Never store them, and store the `Entity` instead.
5. **Not everything is an entity.** Global things (asset cache, nav grid, **surface grid**, camera settings, dice RNG) are **resources**, plain structs owned by the world or engine. **Sequential flows** (a combat turn's step-by-step resolution, a dialogue tree) are plain state machines that *read and write* components. They aren't forced into "run over all entities every frame".

**The frame, as a system schedule:**

```
input ─► game systems (turn/combat flow, AI, actions, status effects)
      ─► movement / navigation
      ─► animation  (sample → blend → IK → local-to-model → skin matrices)
      ─► transform propagation  (Local_Transform + Parent → World_Transform)
      ─► render extraction  (ECS → flat list of draw items)
      ─► renderer.draw(render_list)    ◄── renderer never touches the ECS
      ─► editor UI (ImGui)  ─► present
```

**Render extraction** is an important architecture idea. The renderer receives a flat array of
`{mesh, material, world matrix, skin offset}` and knows nothing about entities. That keeps the renderer
simple, testable and swappable (Vulkan later), and it gives you one place to cull and sort.

**Transform hierarchy in ECS:** `Local_Transform` (authored and edited) + `Parent` (an entity ID) + `World_Transform`
(computed). The propagation system processes parents before children, the same "parents first, one linear pass"
trick the animation system uses for bones. You'll see this pattern twice, deliberately.

### 2.6 Reflection: the editor and serialisation for free

Odin keeps **runtime type information** for every type. Because every component is a plain struct,
the editor can draw an inspector for **any** component, and the save system can write **any** component,
without special code per type:

```odin
import "core:reflect"

draw_component :: proc(ptr: rawptr, T: typeid) {
    for field in reflect.struct_fields_zipped(T) {
        field_ptr := rawptr(uintptr(ptr) + field.offset)
        // switch on field.type.id:
        //   f32      → imgui.DragFloat
        //   [3]f32   → imgui.DragFloat3
        //   bool     → imgui.Checkbox
        //   Entity   → entity picker
        //   struct   → recurse
    }
}
```

**Struct tags** give the editor hints: `` health: i32 `editor:"min=0,max=999"` ``.
This is how `game` components show up in the editor even though `editor` never imports `game`.

---

## 3. Memory strategy — think in lifetimes

The most important memory question is **"when does this die?"**, not "malloc or not". Group allocations by lifetime:

| Lifetime | Examples | Allocator | Freed |
|---|---|---|---|
| **Frame** | temp strings, per-frame lists, render list, command buffer, ImGui labels | `context.temp_allocator` | `free_all(context.temp_allocator)` at the end of each frame |
| **Level / scene** | entities and their components, loaded meshes for this map, nav grid | component pools (heap), a level **arena** for bulk level data | on level unload: `clear()` the pools (this **keeps capacity**, so the next level loads without reallocating), then free the arena |
| **Program** | engine subsystems, component registry, shader cache | `context.allocator` (heap), with explicit `delete` | at shutdown |
| **GPU** | VAOs, buffers, textures, programs | GL objects behind **handles** | explicit `destroy`, tracked in pools |

**Big data doesn't live inside components.** A skeleton's pose (60+ joints × TRS) doesn't go inline in the
`Animator` component. The component holds a **handle** into an animation-owned pool. This keeps components
small, so iterating them stays cache-friendly and swap-removes stay cheap.

**Debug-build leak detection.** We'll add this in M1 so `run.bat`'s comment becomes true:

```odin
import "core:mem"

main :: proc() {
    when ODIN_DEBUG {
        track: mem.Tracking_Allocator
        mem.tracking_allocator_init(&track, context.allocator)
        context.allocator = mem.tracking_allocator(&track)
        defer {
            for _, entry in track.allocation_map {
                fmt.eprintf("LEAK %v: %v bytes\n", entry.location, entry.size)
            }
            mem.tracking_allocator_destroy(&track)
        }
    }
    // ... rest of main
}
```

**Handles, not pointers.** A `[dynamic]Mesh` *reallocates* when it grows, and every `^Mesh` you handed out
now points at freed memory. A handle is an index plus a generation. It stays valid across reallocation and
*detects* stale use. ECS `Entity` IDs are exactly this pattern, and so are mesh, texture and skeleton handles:

```odin
Handle :: struct { index: u32, generation: u32 }

Pool :: struct($T: typeid) {
    items:       [dynamic]T,
    generations: [dynamic]u32,
    free_list:   [dynamic]u32,
}
// get(pool, h) returns nil if pool.generations[h.index] != h.generation → stale handle caught.
```

---

## 4. Performance principles (the ones we'll keep coming back to)

1. **Measure before optimising.** We'll add a CPU profiler (`core:prof/spall`) and GPU timer queries in M9.
2. **Budget:** 60 fps means 16.6 ms per frame for *everything*. The stats panel shows where the time goes, per system.
3. **The CPU cost of a draw call is setup work, not the triangles.** Fewer state changes, sort by shader and material (render extraction makes this easy), instance the modular kit pieces.
4. **Don't stall the GPU:** avoid `glGet*`/`glReadPixels` in the loop. The CPU and GPU run *asynchronously*, and reading back forces a wait.
5. **Data layout:** walk arrays linearly. Packed component pools, parent-before-child ordering (transforms *and* bones) and `#soa` are all examples. **ECS isn't automatically fast.** It's fast when components are small and systems walk them linearly.
6. **Vsync plus delta time**, never `sleep` for pacing.
7. **Debug vs release:** always check performance with `-o:speed`. The `-debug` build lies about speed.

---

## 5. Decisions log (with reasons)

| # | Decision | Why | Status |
|---|---|---|---|
| D1 | **glTF 2.0 (`.glb`) is the only runtime model format**; FBX (Mixamo) gets converted to glb offline in Blender | `vendor:cgltf` ships with Odin. glTF is *designed* as a runtime format, and its PBR metallic-roughness matches ambientCG. Parsing FBX in-engine is a swamp | ✅ decided |
| D2 | OpenGL **4.3 core** now; consider moving to **4.6 + DSA** at M3 | You learned "bind-to-edit" with the triangle (it's what most tutorials use). DSA is cleaner, avoids binding bugs and is closer to the Vulkan mental model | ⏳ decide at M3 |
| D3 | **Right-handed, Y-up, metres**; column vectors, column-major matrices | Matches glTF, OpenGL and Odin's `matrix` type, so no conversions at the boundaries | ✅ decided |
| D4 | Grid cell size for Plotweaver's 5 ft movement | 1.524 m (exact) or 1.5 m (round, easier to author levels) | ❓ open, decide at M15 |
| D5 | **Custom ECS with sparse-set storage**, type-erased pools keyed by `typeid`, built by you in M4 | Composition fits DOS2-style systemic gameplay. Sparse sets make the constant add/remove of status/tag components O(1). Entity counts are small, so archetype iteration gains don't matter. It's simpler to write, debug and reflect over. *(Changed 2026-09-22 from "fat struct entities" at your request.)* | ✅ decided |
| D6 | **Own animation system**; cgltf only *parses* the data | Learning goal. It also gives full control over blending, retargeting and combat-timed events | ✅ decided |
| D7 | Engine / Editor / Game as separate packages, arrows pointing down only | See §2 | ✅ decided |
| D8 | ImGui = **editor and debug UI only**; in-game UI is custom later | ImGui is great for tools but not styled for a shipped CRPG HUD | ✅ decided |
| D9 | Game code **hot-reloadable as a DLL** | Iteration speed, and it enforces the boundary physically. With ECS, pools must be keyed by a **stable registered name**, not only `typeid` (verify whether typeids stay stable across DLL builds) | ⏳ M10 |
| D10 | Forward renderer first; forward+ or clustered only if light counts demand it | Fewer moving parts while learning, and it handles transparency easily. **Watch point:** fire surfaces (M18) create many lights, so revisit then with profiler data | ✅ decided |
| D11 | **Renderer never reads the ECS**; a render-extraction system builds a flat draw list | Renderer stays simple, testable and swappable (Vulkan), with one place for culling and sorting | ✅ decided |
| D12 | **Systems run in an explicit, hand-written order**; structural changes go through a command buffer | Readable frame, no hidden scheduler, no iterator-invalidation bugs | ✅ decided |
| D13 | **Animation runtime modelled on Granny 3D's architecture** (concepts only, since Granny is proprietary): shared `Skeleton`/`Animation` assets vs per-character instances; **controls** (one playback each: clock, speed, weight, ease, mask); blending = **weighted accumulation over active controls**; caller-owned pose buffers in fixed stages; explicit motion extraction. A small state machine sits *on top* and drives the controls | Proven in shipped CRPGs (Larian ships animations as `.gr2`). Data-oriented, it fits the ECS asset/instance split and Odin's explicit memory. Its simple model suits a CRPG's modest animation needs better than a big blend graph. **Not copied (yet):** B-spline curve compression, multi-DCC/multi-platform generality | ✅ decided |
| D14 | **Surfaces are a grid field (a resource), not entities**; the ECS bridges them via events and components on objects | Area data with neighbour rules needs O(1) position and neighbour lookups, linear memory and a direct GPU upload. "ECS for things, grids for fields" | ✅ decided |
| D15 | Surface grid resolution: finer than the movement grid (e.g. 0.5 m, a 3 × 3 subdivision of a 1.5 m move cell) or the same size | Finer gives round-looking puddles and AoE edges; the same size is simpler and uses less memory. Tied to D4 | ❓ open, decide at M18 |

---

## 6. Editor v1 layout (placeholder until the reference photo is re-attached)

```
┌────────────────────────────────────────────────────────────────────────┐
│ File  Edit  View  Window │ ▶ Play  ⏸ Pause │ [T]ranslate [R]otate [S]cale │ Local/World │
├──────────────┬────────────────────────────────────────┬────────────────┤
│ Hierarchy    │                                        │ Inspector      │
│ (entities,   │          Scene Viewport                │ (one section   │
│  by Parent)  │   (scene rendered to an FBO, shown     │  per component,│
│  ▾ Tavern    │    with ImGui::Image + ImGuizmo on top)│  via reflect)  │
│    ▸ Party   │                                        │  [+ Add Comp.] │
│    ▸ Lights  │                                        │                │
├──────────────┴───────────────┬────────────────────────┴────────────────┤
│ Asset Browser (models, tex,  │ Console/Log │ Anim Timeline │ Stats      │
│ anims, materials)            │             │               │ (ms/system)│
└──────────────────────────────┴─────────────┴───────────────┴───────────┘
```

**Key techniques:**

- The game view is rendered into a **framebuffer object (FBO)**, and its colour texture is drawn as an ImGui image
  inside a docked window. The engine never knows it's inside an editor.
- The **Inspector** lists the selected entity's components and draws each with the reflection inspector (§2.6).
  **Add Component** is just a list of registered component types.
- **Stats** shows the time per system, which works because the schedule in `main.odin` is explicit.

---

## 7. Asset notes

| Asset | Likely format | Engine notes |
|---|---|---|
| **Universal Base Characters** (Quaternius) | glTF / FBX | Our *reference skeleton*. Everything humanoid ends up animating on this rig |
| **Universal Animation Library 2** (Quaternius) | glTF / FBX | Built to share the UBC rig (verify at import). This is the main clip library |
| **Mixamo** | FBX, `mixamorig:` bone names | Convert to glb in Blender. Different skeleton, so we need **retargeting** (M14). Choose "In Place" vs root motion deliberately |
| **Bestiary – Dungeon Monsters Kit** | check on import | Monsters likely have *their own* skeletons and clips. The animation system must support many skeletons |
| **ambientCG** | PNG/JPG maps: Color, NormalGL, Roughness, AO, Metalness, Displacement | Use **NormalGL**, not NormalDX (the green channel is flipped). **Color is sRGB**; every other map is *linear*. This is a big lesson in M8 |
| **Medieval Village MEGAKIT** (Quaternius) | glTF | Modular pieces, so **instancing** and **grid snapping** in the editor. Many pieces share materials, which is good for batching |
| **Modular Sci-Fi Megakit** (Quaternius) | glTF | Same pipeline as the Medieval kit, and a good test that the engine isn't medieval-specific |

**Pipeline:** `source asset → (Blender if FBX) → .glb in assets/models/ → engine import → runtime asset (cached) → spawned as entities`.
A glTF *node tree* becomes an entity hierarchy (`Parent` components). Later, an offline "cook" step can bake glb
into a fast binary format. That's a performance lesson.

---

## 8. Roadmap

Each milestone lists: **Goal**, **You'll learn**, **Done when**.
Milestones are sized to take a few sessions each. We don't move on until "Done when" is true
*and* you can explain the key concepts back.

### Phase 0 — Foundations

**M0 — Window + triangle** ✅
Learned: SDL3 init, GL context, VAO/VBO, shader compile and link, uniforms, `defer`, init/shutdown pairs, collections.

**M1 — Engine skeleton & hygiene**

- Goal: a proper frame loop and a clean engine/game boundary.
- Tasks: generic input (key down, pressed and released edges, mouse position and delta, wheel) · delta time with `sdl.GetPerformanceCounter` · vsync via `sdl.GL_SetSwapInterval` · GL **debug context + `glDebugMessageCallback`** · tracking allocator · per-frame `free_all(context.temp_allocator)` · `core:log` logger in `context` · move the R/G/B logic into a first `game` package.
- Lessons:
  1. **Input:** engine-owned `Key`/`Mouse_Button` enums, `bit_set` state vs edges, events vs polling, scancodes vs keycodes, stuck keys on focus loss.
  2. **The `game` package:** move R/G/B out of `main`, the first engine ↔ game contract.
  3. **Frame timing:** delta time, vsync, why `pause(8)` is wrong.
  4. **Debug infrastructure:** GL debug callback, tracking allocator, temp allocator per frame, `core:log`.
- You'll learn: `context` and allocators, `when ODIN_DEBUG`, callbacks with the `"c"` calling convention, why a frame loop is shaped like input → update → render → present.
- Done when: no game-specific names remain in `engine/`, the leak report is empty on exit, and a deliberately wrong GL call prints a debug message.

**M2 — Math & 3D camera**

- Tasks: `Transform` with a `quaternion128` rotation · `core:math/linalg` · model, view and projection matrices · a spinning cube with a depth buffer · **tactical camera** (orbit, pan, zoom, rotate like DOS2) · per-frame data in a **UBO** (std140).
- You'll learn: coordinate spaces (local → world → view → clip → NDC → screen), why quaternions (no gimbal lock, cheap interpolation), matrix order, std140 padding traps.
- Done when: you can draw the pipeline of spaces from memory and the camera feels like a CRPG camera.

**M3 — Resource layer**

- Tasks: `Shader`, `Mesh` and `Texture` abstractions behind **handles/pools** · `vendor:stb/image` loading · mipmaps · **sRGB textures** · a basic material · the renderer takes a **flat draw list** (preparing for D11) · decide D2 (DSA).
- You'll learn: generational handles (you'll reuse this exact idea for entity IDs next), resource lifetime, texture filtering and mipmaps, why gamma is a thing.
- Done when: the renderer has no specific game objects in its `State`, and textured cubes render from a draw list.

**M4 — The ECS core** *(new)*

- Goal: `engine/ecs`, built and understood from the ground up.
- Tasks, in teaching order:
  1. Entity allocator: generational IDs + free list, `create`/`destroy`/`alive`.
  2. A **generic** `Sparse_Set($T)` first (easy to reason about), with `add`/`remove` (swap-remove)/`get`/`has`.
  3. **Unit tests** with `core:testing` (`odin test src/engine/ecs -collection:pw=src`). Test swap-remove edge cases *before* building on it.
  4. Upgrade to **type-erased pools** in a `World` keyed by `typeid`, with a typed API (`ecs.get(world, e, T)`).
  5. Queries: iterate the smallest pool and check the others.
  6. **Command buffer** for deferred add/remove/destroy.
  7. **Resources** (singleton data on the world).
  8. Engine components + systems: `Local_Transform`, `World_Transform`, `Parent`, `Mesh_Renderer`. Transform propagation. **Render extraction** → M3's draw list.
- You'll learn: data-oriented design, cache lines, AoS vs SoA, parametric polymorphism (`$T`), type erasure with `typeid`/`rawptr`/`size_of`, swap-remove, iterator invalidation, why tests matter most for foundational code.
- Done when: 10,000 entities spin and render through the ECS, the tests pass, the triangle/cube is just an entity, and you can explain **sparse set vs archetype** and **why structural changes are deferred**.

### Phase 1 — Editor shell

**M5 — ImGui in the engine**

- Tasks: odin-imgui bindings (SDL3 + OpenGL3 backends) · docking · **render the scene to an FBO → viewport panel** · Log and Stats panels (ms per system).
- You'll learn: immediate mode vs retained mode UI (note that ImGui and ECS share a philosophy: plain data, recomputed each frame), FBOs, how a C/C++ library plugs into Odin (`foreign import`).
- Done when: the layout in §6 exists and resizing the viewport resizes the FBO correctly.

**M6 — Scene editor on top of the ECS**

- Tasks: Hierarchy panel from `Parent` components · **reflection-driven Inspector** (§2.6) with struct-tag hints · Add/Remove Component menu from the registry · mouse **ray picking** → entity · **ImGuizmo** translate/rotate/scale on `Local_Transform` (bindings may need generating from cimguizmo, a good FFI lesson) · **undo/redo** (command pattern: "set component field", "add component", "create entity") · **scene save/load via reflection** to JSON (`core:encoding/json`).
- You'll learn: `core:reflect` and struct tags, ray/AABB intersection, the command pattern, serialisation (and how `Entity` references get remapped on load), FFI binding.
- Done when: you can place, move, parent, add components to, undo, save and reload entities, and a *game* component appears in the inspector without the editor importing `game`.

### Phase 2 — Assets & rendering

**M7 — glTF static meshes**

- Tasks: import with `vendor:cgltf` · meshes, primitives, materials · asset cache keyed by path · glTF node tree → **entity hierarchy** · drag and drop from the Asset Browser spawns entities · **instanced** rendering of repeated kit pieces (render extraction groups them) · grid snapping.
- You'll learn: the glTF data model (nodes, meshes, accessors, buffer views), interleaved vs separate vertex layouts, instancing.
- Done when: you can build a small village street from the Megakit in the editor and save it.

**M8 — Lighting**

- Tasks: `Light` components · Blinn-Phong first → **PBR metallic-roughness** with ambientCG maps · normal mapping (tangents) · directional light + **shadow map** · point lights · **HDR + tonemapping** · correct gamma.
- You'll learn: the rendering equation in plain words, why PBR, tangent space, shadow acne and bias, linear vs sRGB workflow.
- Done when: a tavern interior with textured PBR materials, a sun shadow and torch lights looks right.

**M9 — Performance pass #1**

- Tasks: `core:prof/spall` CPU profiling (per system) · GL timer queries · frustum culling in render extraction · sort draws by shader and material · stats: draw calls, triangles, ms per pass and per system · **benchmark the ECS** (does sparse-set iteration hold up? where do the lookups cost?).
- You'll learn: how to read a profile, where the GPU time goes, why culling and sorting help, how to evaluate a data structure with evidence.
- Done when: you can say *why* a frame costs what it costs, backed by numbers.

**M10 — Hot reload the game layer** *(optional but recommended)*

- Tasks: build `game` as a DLL · reload on file change · the `ecs.World` lives in the host (the exe), so entities survive the reload · component registration by stable name (D9).
- You'll learn: DLLs, `dynlib`, why a clean engine/game boundary makes this possible, and the gotchas (GL function pointers, ImGui context, changing a component's layout during reload).
- Done when: you edit a rule in `game/`, save, and see it change without restarting.

### Phase 3 — The animation system (our own)

Each milestone gets a full *algorithm walkthrough* (a diagram, the maths in plain words, then code).

**Architecture (D13, modelled on Granny):**

```
 SHARED ASSETS (loaded once, read-only)        PER CHARACTER (one per entity)
 ┌──────────────┐  ┌──────────────┐           ┌───────────────────────────────────┐
 │  Skeleton    │  │  Animation   │◄──────────│ Control × N  (clock, speed,       │
 │ parents,     │  │ joint tracks │  handle   │   weight, ease, loop, mask)       │
 │ bind pose,   │  │ (keyframes)  │           ├───────────────────────────────────┤
 │ inverse bind │  └──────────────┘           │ Pose buffers (local / world /skin)│
 └──────▲───────┘  ┌──────────────┐           └───────────────────────────────────┘
        │          │ Track_Mask   │                 ▲
        │          │ per-joint w  │                 │ handles
        └──────────┴──────────────┴──── Animator component (ECS): tiny, only handles
                                               + Anim_State_Machine (drives the controls)

 Per frame:  state machine → advance control clocks + eases → SAMPLE & ACCUMULATE (weighted)
             → local pose → IK → build world pose → skin matrices → render extraction (SSBO offset)
```

```odin
// Shared assets
Skeleton  :: struct { parents: []i32, bind_local: []Joint_TRS, inverse_bind: []matrix[4, 4]f32, names: []string }
Animation :: struct { duration: f32, tracks: []Joint_Track }

// One *playback* of an animation. Granny calls this a "control".
Control :: struct {
    animation: Animation_Handle,
    clock:     f32,
    speed:     f32,
    weight:    f32,
    ease:      Ease,              // ramps weight toward a target over a duration
    loop:      bool,
    mask:      Track_Mask_Handle, // optional per-joint weights (layering)
}

// ECS component: small, so pools stay cache-friendly and swap-removes stay cheap
Animator :: struct {
    skeleton: Skeleton_Handle,
    controls: Control_List_Handle,
    pose:     Pose_Handle,
}
```

**ECS shape:** `Animator` + `Skinned_Mesh` components. The animation systems run in the schedule between game
logic and transform propagation. Heavy per-joint data (poses, control lists) lives in animation-owned pools,
not inside components (§3). Pose buffers are owned by the caller, and no stage allocates behind your back.

**M11 — Skeletons & GPU skinning**

- Concepts: **joint hierarchy** stored as a flat array with `parent[i] < i` (parents always come first, so *one linear loop* computes every model-space transform, which is cache-friendly and needs no recursion; it's the same trick as ECS transform propagation) · **bind pose** · **inverse bind matrices** (they take a vertex from model space into the joint's local space) · **skinning matrix = model_space_joint × inverse_bind** · **linear blend skinning**: each vertex is influenced by up to 4 joints with weights summing to 1.
- Tasks: the shared **`Skeleton` asset** (loaded once, referenced by handle) vs per-entity **pose buffers** · load the skin from UBC glTF · joint matrices for *all* skinned entities packed into one SSBO (render extraction stores each entity's offset) · skinning in the vertex shader · debug-draw the skeleton.
- Why bones aren't entities: making each bone an entity is tempting (some engines do it), but it scatters a skeleton's joints across pools. A packed per-skeleton array keeps the hot loop linear. The *attachment points* (weapon in hand) are exposed as entities.
- Done when: a UBC character renders in bind pose, and moving one joint in the inspector deforms the mesh.

```odin
// The core loop of every skeletal animation system.
// Because parents come before children, model[parent] is already computed when we reach i.
for i in 0..<len(skeleton.parents) {
    local := trs_to_matrix(pose.local[i])      // translation, rotation (quat), scale
    parent := skeleton.parents[i]
    if parent < 0 {
        model[i] = local
    } else {
        model[i] = model[parent] * local
    }
    skin[i] = model[i] * skeleton.inverse_bind[i]  // this goes to the GPU
}
```

**M12 — Clip playback: `Animation` + `Control`**

- Concepts: keyframes · the **`Animation` asset** (shared) vs the **`Control`** (one playback: its own clock, speed and loop, so fifty goblins share one "walk") · **sampling** (find the two surrounding keys: binary search, or a cached cursor since time moves forward) · **lerp** for translation and scale · **slerp or nlerp** for rotation, with the **shortest-path check** (`q` and `-q` are the same rotation, so if `dot(a, b) < 0`, negate one first or the joint spins the long way) · looping and time wrapping.
- Tasks: a single control drives a character · Animation Timeline panel (scrub, speed, loop) bound to the selected entity's controls.
- Done when: UAL2 idle, walk and run clips play and scrub correctly.

**M13 — Blending: weighted accumulation over controls**

- Concepts: **weighted accumulation**, the Granny-style core. Every active control contributes `weight × mask[joint]`. Translations are summed and divided by the total weight. Rotations are sign-aligned, summed, then **normalised** (nlerp generalised to N poses). We'll prove *why* this approximation is fine for nearby rotations and where it breaks down. If the total weight is below 1, the bind pose fills the gap.
- Built on top of it: **crossfades** (one control eases 1→0 while another eases 0→1, using ease curves) · **1D blend space** (idle↔walk↔run by speed, with **phase sync** so feet don't slide) · **track masks** for layering (legs walk while the upper body casts) · **additive** controls (breathing, recoil).
- Done when: a character smoothly goes idle → walk → run and can cast while walking.

```
per joint (pseudocode):
  acc_t = 0; acc_q = 0; total = 0
  for control in active_controls:
      w    = control.weight * mask_weight(control.mask, joint)
      t, q = sample(control.animation, joint, control.clock)
      if dot(q, acc_q) < 0: q = -q        // keep all rotations in one hemisphere
      acc_t += t * w;  acc_q += q * w;  total += w
  local[joint] = { acc_t / total, normalize(acc_q) }
```

**M14 — State machine, events, motion extraction, retargeting, IK**

- **Animation state machine *on top of* controls:** data-driven states and transitions (conditions + crossfade times). A transition just means "ease in these controls, ease out those". Graph view in the editor. The controls stay low-level, and the state machine holds the decisions.
- **Animation events:** "hit" frame, footstep, spell release. *This is what syncs combat rules to visuals in a turn-based game*: the damage number appears on the hit frame, not when the rule resolves. In ECS terms, the animation system emits events and the combat flow consumes them.
- **Motion extraction (Granny's "accumulation"):** separate the root joint's per-frame movement into an explicit value. The game then decides whether to apply it (a dodge roll, root motion) or ignore it and follow the A\* path (in-place locomotion). We'll talk through the trade-offs.
- **Retargeting** (Mixamo → UBC): map bones by name, then transfer rotations *relative to each skeleton's bind pose*, because the two rigs have different rest orientations.
- **IK:** two-bone analytic IK (law of cosines) for feet on uneven ground, and look-at for heads. We'll do the geometry on paper first.
- Done when: a Mixamo clip plays correctly on a UBC character, and feet stay planted on stairs.

### Phase 4 — CRPG foundations (the game layer, built on ECS)

Game components, for example: `Stats` (health/focus/essence), `Skills`, `Initiative`, `Action_Points`,
`Grid_Position`, `Faction`, `Controllable`, `Status_Effect` / tags (`Burning`, `Stunned`, `Prone`),
`Cover`, `Dialogue_Speaker`, `Interactable`, `Selected`, `Turn_Active`, and the surface bridges `Flammable`,
`Explosive`, `Leaks_Surface` (the barrel that becomes an oil slick).

**M15 — Grid & navigation:** decide D4 · bake walkability from level geometry (a nav-grid **resource**) · **A\*** pathfinding · movement-range overlay · click-to-move → `Path_Follow` component + locomotion blending.
*Groundwork for surfaces:* put the generic grid tools in `engine/grid` (world↔cell mapping, neighbours, shape rasterisation) so the surface grid in M18 reuses them. A\* takes a **cost callback**, so M18 can make fire expensive to walk through without changing A\*.
**M16 — Turn-based combat framework:** Plotweaver rules as *data* (d20 + skill vs DC, plot die complications and opportunities, advantage "pick a die, roll two", fast/slow turns with 2/3 actions + 1 reaction, health/focus/essence, deflect, injuries) · initiative · a **combat flow state machine** (not a per-entity system; see ECS rule 5) that drives `Turn_Active` · actions as data · **status effects** with durations in turns · actions can carry an **element** (fire, water, lightning…) · combat log panel. Mostly `game/`, so this is where the split pays off.
**M17 — Line of sight, cover, AoE:** ray/grid LOS · cover values · AoE templates (circle, cone, line) **rasterised onto the grid** and drawn as projected **decals** · fog of war.

**M18 — Surfaces & elemental interactions (DOS2 / BG3 style)** *(new)*

Oil, water, blood, poison, fire, ice, mud on the ground, plus clouds (steam, smoke, poison gas) above it.
They react to elements (fire ignites oil, lightning electrifies water, ice freezes it), apply statuses to
whoever stands in them, spread, decay, block sight (clouds) and change pathing costs.

*Why it's here:* it needs the grid (M15), statuses, turns and elemental actions (M16), and AoE shapes and decals (M17).
It's the milestone where every earlier system comes together, and one of the most educational ones.

*The key design decision (D14): a surface is a **grid field**, not entities.*
An earlier draft of this plan said "surfaces as entities". That was wrong for this job. Surfaces are **area data where
neighbours matter** (fire spreads to the next cell, electricity floods a whole puddle). A dense 2D array gives O(1)
lookups by position, O(1) neighbours, linear memory and a direct GPU upload. As entities, every "what's at this spot?"
would become a spatial search. *Lesson: ECS is for **things**, grids are for **fields**.* The ECS still does the bridging:

```
 Actions/spells ──Element_Event{element, shape, source}──►  SURFACE GRID  ──► status on entities standing in it
 Barrels (Flammable, Explosive, Leaks_Surface components) ─►  (resource)   ──► A* cost modifier (AI avoids fire)
                                                                           ──► clouds block LOS
                                                                           ──► GPU texture → ground decal pass
```

```odin
Surface_Type :: enum u8 { None, Water, Blood, Oil, Poison, Fire, Ice, Mud }
Surface_Flag :: enum u8 { Electrified, Blessed, Cursed }
Element      :: enum u8 { Fire, Water, Ice, Lightning, Poison, Bless, Curse }

Surface_Cell :: struct {
    type:       Surface_Type,
    flags:      bit_set[Surface_Flag; u8],
    turns_left: u8,
    source:     u16,   // index into a small "who caused this" table (blame, aggro, XP)
}

Surface_Layer :: struct {
    width, height: i32,
    cell_size:     f32,                // metres (D15)
    cells:         #soa[]Surface_Cell, // SoA: all `type` bytes are contiguous → upload straight to the GPU
    dirty:         Cell_Rect,          // only re-upload what changed
}

Reaction :: struct { becomes: Surface_Type, add: bit_set[Surface_Flag; u8], cloud: Cloud_Type, explode: bool }
reactions: [Surface_Type][Element]Reaction   // enumerated array, filled from data/surfaces.json
```

*Memory maths (do this for every data structure):* a 100 m × 100 m map at 0.5 m cells is 200 × 200 = 40,000 cells.
The whole AoS grid would be about 240 KB, and the `type` layer alone in SoA is 40 KB, which sits comfortably in L2 cache.
This is why the cell is packed into a few bytes and `source` is a `u16` index and not a full `Entity`.

*Algorithms you'll learn (each gets a walkthrough):*

1. **Shape rasterisation:** circle, cone and line AoE → the set of cells covered (reused from M17).
2. **Reaction lookup:** `reactions[cell.type][element]`. Two array indexes replace a giant `if` chain, and the table is *data* the designer can edit.
3. **Chain reactions with a work queue:** an explosion creates fire, which ignites more oil, which explodes… Process these with a **queue (BFS)**, not recursion. You get no stack overflows, a deterministic order, and a budget cap so a bad data file can't loop forever.
4. **Flood fill:** lightning on one cell electrifies the *whole connected* body of water, as in DOS2. That's a BFS over 4-neighbours with the same type.
5. **Spread and decay as a double-buffered cellular automaton:** read from the old grid and write to the new one. Otherwise the result depends on loop direction (fire "races" left-to-right but crawls right-to-left). It's the same lesson as Conway's Game of Life.
6. **Time:** surfaces tick **per round** in combat and **per 6 s** in exploration (DOS2's convention), with one `turns_left` unit for both.

*Rendering:*

- The `type` layer uploads as an **integer texture** (`R8UI`, updated with `glTexSubImage2D` on the dirty rect only).
- A **ground decal pass** maps world position → grid UV → surface type → a material from a **texture array**, with animated shaders for fire, water and ice.
- Integer textures *can't be filtered*, so the edges would be blocky squares. We fix that with a separate coverage mask that *can* be filtered, plus **noise-perturbed edges**. It's a good lesson on sampler types.
- Clouds are a second, coarser layer, drawn as **instanced soft particles**. That means a **minimal particle system** comes forward from Phase 5 into this milestone.
- Fire fields mean *many* lights. Merge nearby burning cells into a few lights, or revisit **D10** (clustered forward) based on M9-style profiling.

*Engine vs game split:*

- `engine/grid` has the generic cell grid, rasterisation, flood fill, dirty-rect tracking, GPU upload and the "grid decal" render feature.
- `game/surfaces` has the surface types, the reaction table (JSON), spread rules, and the **Plotweaver** consequences: Burning damage each turn, a d20 + skill vs DC check to keep your footing on ice or go Prone, electrified water → Stunned (lose actions), and so on.
- The engine knows about *cells and masks*, never about *oil*.

*Done when:* you throw oil and ignite it with a fire action, the fire spreads and burns anyone standing in it (via
Plotweaver statuses), lightning on a puddle stuns everyone in the connected water, fire on water makes a steam
cloud that blocks LOS, the AI paths around fire, surfaces tick per turn in combat and per 6 s outside it, and
chain reactions can't hang the game.

**M19 — Conversations & endeavors:** data-driven dialogue trees (JSON) · focus as social HP · endeavor thresholds · a dialogue editor panel.
**M20 — Game UI:** hotbar, portraits, turn order, tooltips. A custom UI layer, per D8.
**M21 — Save/load:** reuse the reflection serialiser from M6 · versioned format · what's "level data" (authored) vs "save data" (changed at runtime) · entity ID remapping · surface grids saved with **run-length encoding** (mostly empty cells compress massively, a nice compression lesson).

### Phase 5 — Polish & beyond

Audio (`vendor:miniaudio`) · full particle and spell VFX (building on M18's minimal particles) · post-processing (SSAO, bloom, selection outlines) · level streaming · asset cooking into a **self-describing, load-in-place binary format** (one allocation + pointer fix-ups, as Granny's `.gr2` does) · **animation curve compression** (quantisation, then maybe splines, but only if profiling or memory says so) · animation LOD · a Vulkan or SDL_GPU backend (render extraction + a thin renderer make this possible) · multithreaded systems (an explicit schedule makes dependencies visible) · packaging and release builds.

---

## 9. How each session runs (the teaching protocol)

These techniques are chosen because the research on learning supports them:

1. **Retrieval warm-up (3–5 min).** A few quick questions from *earlier* sessions, not only the last one. Recalling from memory strengthens it far more than re-reading (*retrieval practice*, *spacing*).
2. **Goal + why (advance organiser).** What we're building today and where it fits on the architecture diagram.
3. **Concept first, with a picture.** A diagram or ASCII sketch plus a plain-words explanation (*dual coding*). Maths gets a concrete numeric example.
4. **Worked example → faded example.** First a complete snippet, explained line by line. Then a *partially* complete one with `// TODO` holes for you to fill (*worked-example effect*, *generation effect*).
5. **Predict, then run.** Before running, you write down what you expect to happen. Surprises are where learning happens.
6. **You write the code.** Claude reviews it: what's good, what's risky, and why.
7. **Debugging drill (sometimes).** A small deliberate bug to find. Debugging is a skill you practise, not a talent.
8. **Explain it back (Feynman).** At the end, you explain the key idea in 3–4 sentences as if to a junior dev.
9. **Update this file:** session log, concept ledger, next step.

**Interleaving:** sessions deliberately mix tracks (an Odin feature *inside* a GL task *inside* an architecture decision)
because that's how you'll meet problems in real work.

---

## 10. Concept ledger (for spaced review)

Each concept is reviewed ~1, ~3 and ~7 sessions after it was learned. ✅ means you explained it back correctly.

| Concept | Track | Learned (session) | Reviews |
|---|---|---|---|
| Init/shutdown pairs, `defer`, partial-init cleanup | Odin / Arch | pre-plan (M0) | ☐ ☐ ☐ |
| VAO vs VBO, vertex attribute layout | OpenGL | pre-plan (M0) | ☐ ☐ ☐ |
| Shader compile/link, info logs, uniforms | OpenGL | pre-plan (M0) | ☐ ☐ ☐ |
| Collections (`-collection:pw=src`) and packages | Odin | pre-plan (M0) | ☐ ☐ ☐ |
| Odin `matrix[4,4]f32`: `m[row, col]`, column-major storage, translation in column 3 | Odin / Math | pre-plan (M0) | ☐ ☐ ☐ |

---

## 11. Session log

| # | Date | Milestone | What we did | Next step |
|---|---|---|---|---|
| 1 | 2026-09-22 | planning | Reviewed M0 code, wrote this plan. Then switched D5 to a **custom sparse-set ECS** and added M4 (ECS core) and M6 (reflection-driven editor). Added D13: animation runtime modelled on Granny's asset/instance + control architecture. Added M18 (surfaces & elemental interactions) with D14 (grid field, not entities) and D15 (resolution, open); renumbered M19–M21 | Start M1: generic input state + move R/G/B into `game/` |
| 2 | 2026-09-23 | M1 · L1 | Input lesson: `Key` enum, `bit_set` state/edges, event-driven edges, focus-loss stuck keys. Faded exercise: `translate_scancode`, mouse, wiring into `main` | Review the user's Input code; answer P1–P3; then M1 · L2 (game package) |
| 3 | 2026-10-12 | M1 · L1 | Finished Input code: `KEY_DOWN`/`KEY_UP`, `translate_scancode` (named keys typed by Claude on request; user did digits/F-keys), mouse motion/buttons, wheel (`.FLIPPED`), focus loss fires released edges. Review caught `mouse_released -= ` (should be `+=`); rule: edges only grow inside the event loop. `Events` removed, `main` uses `platform.Input`. Fixed `ols.json` (missing `pw` collection broke ols import resolution + semantic highlighting) | User skipped L1 runtime tests + P1–P3/explain-back (L1 concepts not yet ✅ in ledger; fold into later warm-ups). M1 · L2 (game package) delivered: `game.State`/`init`/`update`/`shutdown`, `update(input: platform.Input)` immutable param, Escape moved to game, window-close stays engine |
| 4 | 2026-10-12 | M1 · L2 ✅ → L3 | L2 done: `src/game/game.odin` owns colours + rules, `main` wires input → update → quit check → render. Review caught `if !game.init()` on a no-return proc (don't add a bool init can't fail) and `game.shutdown` typed where `game.init` was meant (zero-init hides it: black-on-black). Explain-back for L2 not given yet. Plan file un-gitignored (repo is public). L3 delivered: `platform.Frame_Time` (perf counter, dt clamp, f64 total), `set_vsync`, remove `pause(8)`, dt-driven background pulse | Review user's L3 code; L2+L3 explain-backs; then L4 (debug infrastructure) |
| 5 | 2026-10-13 | M1 · L3 ✅ → L4 | L3 done: `time.odin` (review caught `max` vs `min` for a cap, `GetPerformanceCounter` without `()`, reversed subtraction), `set_vsync` moved to `platform.odin`, game pulse via `dt`. Explained `&` vs value params (read-only `input`). User skipped L3 predictions/explain-back. L4 delivered (verified on user's RTX 3080: callback fires, leak report empty): `core:log` logger, tracking allocator in `when ODIN_DEBUG` (+ `@(require) import "core:mem"` so release `-vet` passes), `defer free_all(context.temp_allocator)` in loop, shader read via temp allocator, debug context flag (`transmute(u32)` of SDL bit_set), `"c"` callback with saved `runtime.Context` via `user_param`. Note: vendor:OpenGL's `GL_DEBUG` (= ODIN_DEBUG) also reports call site per GL call | Review user's L4; then M1 done-when check → M2 (math & 3D camera) |

---

## 12. Open questions / parking lot

- Re-attach the editor reference photo, then update §6.
- D2: move to GL 4.6 + DSA at M3?
- D4: grid cell size (1.5 m vs 1.524 m).
- D15: surface grid resolution (depends on D4).
- Multi-level surfaces (a bridge over a river: oil on the bridge, water below). v1 = one surface layer per walkable floor? Decide at M18.
- Game design (yours): which Plotweaver checks and statuses each surface causes, e.g. ice → Agility DC or Prone? Electrified → lose 1 action or the whole turn?
- D9: are Odin `typeid`s stable across separately built DLLs? If not, key pools by registered name.
- Bestiary kit: confirm the format and whether monsters share a rig.
- ImGuizmo bindings: use existing ones or generate from cimguizmo (decide at M6).
