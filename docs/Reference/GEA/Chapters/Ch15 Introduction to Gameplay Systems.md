---
tags: [chapter, gea, m6]
chapter: 15
pages: 1015-1037
---

# Ch15: Introduction to gameplay systems

A game is defined by its **gameplay** (its mechanics, or "G-factor"), not by its technology.

## 15.1 Anatomy of a game world
- **Static elements** (terrain, buildings) vs **dynamic elements** (characters, items, lights, regions, splines). *Game state* is the state of all the dynamic elements.
- The static/dynamic split is really a range of optimizations: anything static can be precomputed (lighting, AO, PRT). Destructibles swap between undamaged, damaged and destroyed versions.
- Static geometry uses **instancing** of modular pieces (like the Megakit) and **brushes** for quick block-out. Greybox levels early so gameplay can be tested cheaply.
- **World chunks** (levels, maps, areas): linear, hub (star), graph or open world. They exist because of memory limits, to control game flow, and to divide the work between people.
- **High-level flow**: a sequence, tree or graph of objectives, loosely coupled to chunks and grouped into chapters or acts.

## 15.2 Dynamic elements: game objects
- **Type** (attribute schema plus behaviours) vs **instance**. Pac-Man has 4 types but many instances.
- The "game object model" means the facilities the engine provides for these objects. It often extends the language with reflection, persistence and replication.
- **The tool-side and runtime object models can differ completely.** See [[Object Models]].

## 15.3 Data-driven engines
- Content grows faster than teams. Data-driven tools put creative power in the hands of designers and artists.
- But: "many teams make a mad rush into data-driven architectures… dramatically overshoot… ironically… lower productivity."
- **KISS**: weigh what the tool costs against the time it will save.

## 15.4 The game world editor
Examples: Radiant, Hammer, Sandbox, UnrealEd. Typical features:
- **chunk management**; visualization (four views, or perspective only); navigation (focus on the selection, saved camera positions, history);
- **selection** (rubber band, ray picking that **cycles through overlapping hits**, hide the selection, an outliner list);
- **layers** (show and hide, colour coding, **save each layer separately** to avoid merge conflicts);
- a **property grid**:
  - with several objects selected, show the values they share and leave differing values blank;
  - with mixed types selected, show only the attributes they have in common;
  - **free-form key-value properties** for prototyping;
- placement aids (gizmos, snap to grid or terrain, align);
- **special objects**: lights (with a live preview), particle emitters, sound radii and cones, **regions** (triggers), **splines** (Catmull-Rom; separate selection modes for the object and its points), **nav meshes**, custom data (cover points, ledges);
- saving and loading chunks (binary or JSON);
- **rapid iteration**, best when the editor runs inside the game.
- **Integrated asset management** (UnrealEd).
- Where to pay the platform-optimization cost: on import (Unreal), when baking the level (Source, Quake), or on first load with caching (Halo).

## Plotweaver M6 checklist (from this chapter)
- outliner from `Parent`;
- reflection inspector = property grid;
- multi-select showing shared values;
- ImGuizmo with grid snapping;
- click picking that cycles through hits;
- layers later;
- region, nav and surface painting tools later;
- play in editor.

Prev: [[Ch14 Audio]] · Next: [[Ch16 Runtime Gameplay Foundations]]
