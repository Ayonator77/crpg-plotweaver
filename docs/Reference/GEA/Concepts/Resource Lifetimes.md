---
tags: [concept, memory, resources]
source: GEA 7.2.2
---

# Resource lifetimes

The runtime resource manager (GEA 7.2.2.1) has these jobs:
- keep **one copy** of each resource, using a registry from GUID to resource;
- manage each resource's lifetime;
- load composite resources (a model needs its meshes, materials, textures and skeleton);
- keep cross-references valid;
- decide where each resource lives in memory;
- run per-type **post-load initialization** and tear-down;
- stream, if the engine needs it.

## Lifetime classes (GEA 7.2.2.6)
| Lifetime | Example | Strategy |
|---|---|---|
| Global (load and stay resident) | player mesh, HUD font, core animations | load at boot, below the stack marker |
| Per level | level geometry, NPCs of that area | level arena; free on unload |
| Shorter than a level | cinematic animations and audio | load before use, dump after |
| Streamed | music, long speech | two ring-buffer chunks in memory |

## Level transitions with reference counts
1. Increment the count of every resource the **new** level uses (don't load anything yet).
2. Decrement the count of every resource the **old** level used. Unload anything that reaches 0.
3. Load every resource whose count went from 0 to 1.

Shared resources (B and C below) never unload.

| Event | A | B | C | D | E |
|---|---|---|---|---|---|
| Level X loaded | 1 | 1 | 1 | 0 | 0 |
| Y counts incremented | 1 | 2 | 2 | 1 | 1 |
| X counts decremented | **0** (unload) | 1 | 1 | 1 | 1 |
| Y plays | 0 | 1 | 1 | 1 (loaded) | 1 (loaded) |

## Don't load during gameplay
Loading a resource on demand mid-frame causes a hitch or a multi-second freeze. Load per level behind a
loading screen, or stream asynchronously (GEA 7.2.2.5).

## Memory placement
- general heap (acceptable on a PC with virtual memory);
- stack with a marker per level (see [[Stack Allocator]]);
- "chunky" pools of fixed-size blocks for streaming (ND uses 512 KiB–1 MiB chunks);
- **sectioned files**: main RAM, VRAM, load-time temp and debug-only sections, as in Granny's file format.

## Cross-references on disk
- **GUIDs**: after loading, look each one up in the global table and patch in the pointer.
- **Pointer fix-up tables**: store offsets in the file plus a list of where the pointers are. After loading, add the base address. Only works for plain-old-data types.
- **External references**: load every dependent file first, then do one fix-up pass.
- This is how the plan's Phase-5 "load-in-place binary" (like Granny `.gr2`) works.

Related: [[Handles]], [[Level Streaming]], [[Ch07 Resources and the File System]].
