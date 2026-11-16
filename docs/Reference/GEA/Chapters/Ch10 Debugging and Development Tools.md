---
tags: [chapter, gea, m1, m5, m9]
chapter: 10
pages: 589-617
---

# Ch10: Tools for debugging and development

## 10.1 Logging and tracing
- Printf debugging is still valid, especially for timing-dependent bugs or long sequences of events.
- Wrap `OutputDebugString` with formatting, using a `va_list` variant.
- **Verbosity** levels.
- **Channels**: one per system, filtered with a bitmask. ND sends channels to Redis and views them in a web tool ("Connector").
- **Mirror everything to a log file** regardless of the active filters. Flush it for crash safety (or make flushing configurable).
- **Crash reports**: see [[Error Handling Policy]].

## 10.2 Debug drawing
See [[Debug Draw]]: the primitives, world vs screen space, depth on or off, queuing, lifetimes, and scaling to many primitives.

## 10.3–10.4 In-game menus and console
- **Menus**: toggle booleans, edit numbers, call functions, nest submenus. Opening the menu pauses the game.
- ND's example: Rendering → Mesh Options → hide background meshes.
- A **console** can be more powerful, especially if it speaks the scripting language (Quake, Minecraft).

## 10.5 Debug cameras and pausing
- Detached fly camera.
- Pause, single-step and slow-motion while rendering keeps running. This needs a separate game clock; see [[Abstract Timelines]].

## 10.6 Cheats
- No-clip / fly mode, invincibility, give weapon, infinite ammo, choose mesh.
- For Plotweaver: win combat, set stats, spawn surfaces, force dice results.

## 10.7 Screenshots and movie capture
- Options: include or exclude debug drawing and the HUD; high-resolution tiled capture; camera paths.
- ND captures video automatically when the game crashes (PS4 share feature).

## 10.8 In-game profiling
- `PROFILE(SID("name"))` scoped timers. In Odin, use `defer`.
- Predeclared hierarchical bins. **Inclusive vs exclusive** time. Track **call counts per frame**.
- Export to CSV per frame for spreadsheet analysis.
- ND's per-core timeline view.

## 10.9 Memory statistics and leak detection
- You can't control third-party allocations; VRAM is hard to track; there are many custom allocators. Instrument **each allocator** and track high-water marks.
- In-game display of memory per subsystem; an "out of memory on retail hardware" warning on dev kits.
- **Missing-asset visuals**: see [[Error Handling Policy]].

## Plotweaver
- M1 L4 added the logger, tracking allocator and GL debug output.
- M5 adds the Log and Stats panels.
- M9: spall profiling plus a per-system ms table.

Prev: [[Ch09 Human Interface Devices]] · Next: [[Ch11 The Rendering Engine]]
