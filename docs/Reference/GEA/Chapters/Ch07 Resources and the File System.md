---
tags: [chapter, gea, m3, m7]
chapter: 7
pages: 481-523
---

# Ch7: Resources and the file system

## 7.1 File system
- Wrap the OS file API, for three reasons: consistent behaviour across platforms, a smaller API, and extra media (DVD, network, memory cards).
- **Paths**: separators, case sensitivity, volumes, absolute vs relative.
  - Avoid **runtime search paths**. You should know where every asset lives in advance.
- **Buffered vs unbuffered I/O**. EA's *Red Alert 3* found that log writes were slow, so it buffered them in memory and flushed from a separate thread.
- **Synchronous vs asynchronous I/O**. Async I/O is a request queue serviced by an I/O thread, with a callback or semaphore when done. Requests need **priorities** (streaming audio beats textures) and deadlines.

## 7.2 The resource manager
### Offline (the tool chain)
- Revision control for assets is hard because the files are large. ND symlinks files from a shared drive and only copies on checkout.
- **Resource database** requirements:
  - handle many resource types; create, delete and inspect resources;
  - move source files around;
  - cross-references between resources, with **referential integrity**;
  - revision history; search.
- Examples:
  - **UnrealEd**: one-stop shop, validates assets when they're imported; binary packages are hard to merge.
  - **ND's Builder**: MySQL first, later XML in Perforce. Command-line builds: `ba <actor>`, `bl <level>`.
  - OGRE: runtime only, no database. XNA: built on Visual Studio.
- **Asset conditioning pipeline**: exporters → resource compilers → resource linkers, plus **dependency rules**. Example: the skeleton must be built before its animations, and a format change means rebuilding everything. "Countless hours wasted" on missing dependencies.

### Runtime
See [[Resource Lifetimes]].
- One copy of each resource; a **registry**; GUIDs (path or hash; Unreal: package name plus internal path).
- Loose files vs **archives**. ZIP is an open format, keeps relative paths, compresses, and is modular (e.g. one zip per language). Unreal's `.pak`.
- **Don't load on demand during gameplay.** Use loading screens or streaming.
- **Lifetimes and reference counting** across level changes.
- **Memory placement**: heap; stack with a marker per level; double-ended ping-pong of compressed levels (Bionic Games); **chunky pools** for streaming plus a **resource chunk allocator** that reuses the unused tail of each chunk, but only for data with the same lifetime.
- **Sectioned files**: main RAM, VRAM, temp-during-load, debug. Granny's format is cited as an excellent example.
- **Composite resources** (a model is meshes + materials + textures + skeleton + clips); **internal vs external references**.
- **Cross-references on disk**:
  - GUIDs plus a global lookup table;
  - **pointer fix-up tables**: offsets in the file, a list of where the pointers are, add the base address after loading. Only for plain-old-data types, or call constructors with placement `new` from a table.
- **Post-load initialization** ("logging in") and tear-down, defined per resource type:
  - some is unavoidable, e.g. uploading to VRAM;
  - some is convenience, and can move into the tools later;
  - Hydro Thunder could load into a temporary area and let post-load init copy only the useful parts out.

## Plotweaver
- M3: shader, mesh and texture **pools with handles**, keyed by path.
- M7: an asset cache for glb files.
- Phase 5: **load-in-place binary**, i.e. a single allocation plus pointer fix-ups, the way Granny's `.gr2` works.
- In Odin: store offsets or handles, never raw pointers, in cooked data.

Prev: [[Ch06 Engine Support Systems]] · Next: [[Ch08 The Game Loop]]
