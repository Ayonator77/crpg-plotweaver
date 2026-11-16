---
tags: [concept, architecture, ecs]
source: GEA 15.2, 16.1, 16.2
---

# Game object models

## Tool-side vs runtime (GEA 15.2.2)
- The object model designers see in the editor can differ completely from the one used at runtime.
- "Each tool-side game object might be **nothing more than a unique id** at runtime, with all of its state data stored in tables." That's an ECS.

## Object-centric vs property-centric (GEA 16.2)

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\node at (2,3.4) {object-centric (array of objects)};
\foreach \r/\n in {0/Obj1,1/Obj2,2/Obj3} {
  \draw (0,2.6-\r*0.8) rectangle (4,3.1-\r*0.8);
  \node[anchor=west] at (0.1,2.85-\r*0.8) {\n: pos, rot, health, mesh, ...};
}
\node at (9.2,3.4) {property-centric (tables keyed by id)};
\foreach \c/\h in {0/Position,1/Health,2/Mesh} {
  \draw (6.6+\c*1.6,1.0) rectangle (8.1+\c*1.6,3.1);
  \node at (7.35+\c*1.6,2.85) {\h};
}
\node at (7.35,2.2) {1: (0,3,15)}; \node at (7.35,1.7) {2: (-12,0,8)};
\node at (8.95,2.2) {2: 15};
\node at (10.55,2.2) {1: barrel}; \node at (10.55,1.7) {3: torch};
\end{tikzpicture}
\end{document}
```

### Object-centric
- Hydro Thunder: a C struct `WorldOb_t` with a `void*` for user data plus function pointers for update and draw.
- **Monolithic class hierarchies** (Unreal's `Actor`) run into problems:
  1. Hard to understand: to understand a class you have to understand every class above it.
  2. Only **one taxonomy axis**. An amphibious vehicle doesn't fit `LandVehicle` / `WaterVehicle`.
  3. Multiple inheritance brings the deadly diamond. Mix-ins are a partial fix.
  4. **Bubble-up effect**: a feature like floating gets pushed up to the root class until the root does everything.
- **Composition**: has-a instead of is-a (a Window *has* a Rectangle). Options:
  - a hub `GameObject` with pointers to its components;
  - a generic list of components;
  - a **pure component model**, where components share an id and there's no hub. That needs factories or data-defined types, and makes communication between components awkward.

### Property-centric
**This is Plotweaver's ECS (D5)**. Shipped examples: *Thief*, *Deus Ex 2*, *Dungeon Siege* (148 scripted property types vs 21 native ones).

Pros:
- memory goes only to the data each object actually has;
- designers can add properties without recompiling;
- **cache-friendly struct-of-arrays layout**.

Cons, and how Plotweaver answers them:

| Con (GEA 16.2.2.4) | Plotweaver's answer |
|---|---|
| Hard to enforce relationships between properties | Validation in systems and asserts; "required component" checks in the editor |
| Hard to build large-scale behaviour out of fine-grained properties | ECS rule 5: sequential flows (combat turns, dialogue) are plain state machines that *use* components |
| Hard to debug, since there's no single object in the watch window | A reflection inspector that shows every component of an entity (§2.6, M6) |

"Choose the architecture you're most comfortable with that fits your game." Neither style clearly wins.

## Further reading named in the book
- Scott Bilas, *A Data-Driven Game Object System* (GDC 2002)
- Doug Church, *Object Systems* (2003)
- Rob Fermier, *Creating a Data Driven Engine* (GDC 2002)
- Alex Duran, *Building Object Systems* (GDC 2003)

## What a runtime object model must provide (GEA 16.1)
- spawning and destroying objects;
- linkage to engine systems;
- real-time simulation in dependency order;
- a way to add new types (ideally data-driven);
- unique ids;
- queries;
- references ([[Handles]]);
- FSM support;
- network replication;
- save and load (needs RTTI, reflection and **abstract construction**, i.e. creating an instance from a type id).

Related: [[Game Object Updates]], [[Spawners and Type Schemas]], [[Handles]].
