---
tags: [chapter, gea, m4, m6, m16, m21]
chapter: 16
pages: 1039-1158
---

# Ch16: Runtime gameplay foundation systems

## 16.1 Components of the gameplay foundation
The runtime object model, level management and streaming, real-time updating, messaging and events, scripting, objectives and game flow (the "spine").
The object model's required features are listed in [[Object Models]].

## 16.2 Runtime object model architectures
See [[Object Models]]:
- object-centric: Hydro Thunder's C structs, monolithic hierarchies and their problems, mix-ins, the bubble-up effect, composition, pure component models;
- **property-centric** (an ECS), with its pros and cons.

## 16.3 World chunk data formats
See [[Spawners and Type Schemas]]: binary images vs serialization (reflection plus a factory) vs **spawners and schemas** with defaults that propagate.

## 16.4 Loading and streaming
- See [[Level Streaming]]: one level at a time, air locks, streaming with load regions, PS4 PlayGo, memory for spawned objects.
- See [[Saved Games]]: checkpoints vs save-anywhere; save only what's relevant.

## 16.5 Object references and world queries
- Pointers (orphaned, stale, invalid), smart pointers (avoid rolling your own), **handles** (see [[Handles]]).
- **Queries**: by id, by type, by criterion, along a path or line of sight, within a radius. Build a structure for each query you actually need. See [[Collision Queries]].

## 16.6 Updating game objects in real time
See [[Game Object Updates]]: why one `Update()` per object doesn't work, **batched**, **phased** and **bucketed** updates, the consistency rule, state caching, time-stamping.

## 16.7 Concurrency for game objects
See [[Game Object Updates]] and [[Job Systems]]: thread-safe subsystems, asynchronous design, degree of parallelism and sync points, updates as jobs, snapshots, a deferred mutation queue.

## 16.8 Events and message passing
See [[Events and Messaging]].

## 16.9 Scripting
- **Data-definition languages vs runtime scripting languages.**
- Language characteristics: interpreted vs compiled, imperative, declarative, functional, procedural vs object-oriented, reflective.
- What game scripting languages are: interpreted, lightweight, fast to iterate, convenient.
- Languages: QuakeC (it gave birth to the mod community), UnrealScript (since retired in favour of Blueprints and C++), Lua, Python, Pawn.
- **Architectures**:
  - scripted callbacks;
  - scripted event handlers;
  - extending types in script;
  - **scripted components or properties** (Dungeon Siege had 148 scripted property types and 21 native ones);
  - a script-driven engine;
  - a script-driven game (Panda3D).
- **ND's DC language** (a Scheme dialect):
  - the VM is a loop over bytecode instructions, with a call stack made of register banks holding variants;
  - native functions live in a table mapping a `SID` name to a function taking an argument count and an array of variants, with an argument iterator that validates them;
  - `ToDebugString()` is for debugging only.
- **Object references in scripts**: numeric handles, or names (`'self` is a magic name), ideally as hashed ids.
- **Events in scripts**:
  - handlers can belong to a type or to an instance;
  - ND's scripts are FSM objects attached to game objects or regions, or standalone;
  - **scripts can send events, and define new event types just by naming them**.
- OOP in scripts, inheritance from native classes (only UnrealScript managed it seamlessly), composition (script components), scripted FSMs.
- **Cooperative multithreaded scripts**: `WaitUntil` plus named signals (two characters meet at a door, one opens it, both walk through).

## 16.10 High-level game flow
- An FSM of objectives or encounters, each tied to a place in the world. Failure restarts the current state.
- ND's **task graph** allows **parallel tasks** that fork and later join. A plain FSM can only be in one state at a time, so this is more like a quest graph.

## Plotweaver
- M4: this whole chapter is the background for the ECS.
- M6, M21: spawners, schemas, saves.
- M16: the combat flow is an FSM (ECS rule 5) driven by events posted into the future.
- Plotweaver's "scripting" is the hot-reloaded game DLL (D9) plus JSON data. Maybe later a small data language for ability effects.

Prev: [[Ch15 Introduction to Gameplay Systems]] · Next: [[Ch17 What Else]]
