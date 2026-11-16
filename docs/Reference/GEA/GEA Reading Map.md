---
tags: [plotweaver, gea, roadmap]
---

# GEA reading map

What to read from the book for each stage of the [[Roadmap]]. Back to [[GEA Index]].

The book assumes C++ and some experience. It becomes useful from Stage 2. For Stages 0 and 1, the lessons and the other [[Sources]] carry the teaching, and the chapters below are optional background.

| Stage | Read | Concept notes |
|---|---|---|
| 0 The Machine | 3.3 (data, code and memory layout), 6.2 (memory management) as background | [[Stack Allocator]] · [[Pool Allocator]] · [[Handles]] |
| 1 Pixels from first principles | Ch 5 (3D math), 11.1 (rendering foundations) | [[Row vs Column Vectors]] · [[Coordinate Spaces]] · [[Quaternions]] · [[Rendering Pipeline]] · [[Depth Buffer Precision]] |
| 2 The GPU and the engine skeleton | 1.6, 6.1, 8.1–8.5, 9.5, 10.1–10.2, 11.2 | [[Engine Layers]] · [[Frame Timing]] · [[Abstract Timelines]] · [[Debug Draw]] · [[Rendering Pipeline]] |
| 3 Graybox CRPG | 9.5.7–9.5.8, 15.1–15.3, 16.6, 16.8 | [[Input Action Mapping]] · [[Game Object Updates]] · [[Events and Messaging]] |
| 4 Assets, world model, level editor | 6.2–6.4, Ch 7, 15.4, 16.1–16.3, 16.5 | [[Resource Lifetimes]] · [[String IDs]] · [[Object Models]] · [[Spawners and Type Schemas]] · [[Error Handling Policy]] · [[Collision Queries]] (picking) |
| 5 Animation system and editor | Ch 12 in full | [[Skinning and Matrix Palette]] · [[Animation Pipeline]] · [[Animation Blending]] · [[Animation Clocks]] · [[Action State Machines]] · [[Motion Extraction and IK]] |
| 6 Big world and verticality | 3.5, Ch 4, 8.6, 10.8–10.9, 11.2.7, 13.3, 16.4 | [[Job Systems]] · [[Level Streaming]] · [[Collision Detection]] · [[Collision Queries]] |
| 7 Light and air | 11.1.3, 11.3, 11.4 | [[Rendering Pipeline]] |
| 8 The Plotweaver systems | 14.6.2, 16.8, 16.9, 16.10 | [[Conversation System]] · [[Events and Messaging]] |
| 9 The MVP slice | 16.3–16.4 | [[Saved Games]] |
