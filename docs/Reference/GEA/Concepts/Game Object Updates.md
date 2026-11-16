---
tags: [concept, architecture, loop, ecs]
source: GEA 16.6, 16.7
---

# Updating game objects

## The simple approach that doesn't work (GEA 16.6.1)
Each object gets a virtual `Update(dt)` that also updates its own animation, collision, physics, audio and rendering.

## Batched updates (GEA 16.6.2)
- Each subsystem **owns its per-object state** (mesh instances, rigid bodies…) and updates **all objects in one batch**, called from the main loop.
- Objects only *set properties* on their components ("play this clip", "show", "hide").
- Benefits:
  - cache coherency;
  - shared calculations done once;
  - no reallocating resources per object;
  - scatter/gather parallelism;
  - some systems simply need it, e.g. solving collisions between many bodies at once.
- This is exactly ECS systems plus render extraction (D11, D12).

## Phased updates (GEA 16.6.3.1)
- Subsystems depend on each other (ragdoll ↔ animation) and objects depend on each other (a person carrying a cat).
- So **hand-code the order** in the main loop and give game code hook points: PreAnim / PostAnim / Final.
- Better still: **register callbacks per phase**, so only interested clients run.

## Bucketed updates (GEA 16.6.3.2)
Arrange the dependency forest in tiers and run the **full phased update once per bucket**.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{O/.style={draw, rounded corners, minimum width=1.6cm, minimum height=0.6cm}}
\node[O] (v) at (0,0) {cart};
\node[O] (p) at (4,0) {platform};
\node[O] (c1) at (-1,-1.2) {hero};
\node[O] (c2) at (1,-1.2) {ally};
\node[O] (c3) at (4,-1.2) {goblin};
\node[O] (w1) at (-1,-2.4) {sword};
\node[O] (w2) at (4,-2.4) {spear};
\draw[->] (c1) -- (v); \draw[->] (c2) -- (v); \draw[->] (c3) -- (p);
\draw[->] (w1) -- (c1); \draw[->] (w2) -- (c3);
\node[anchor=west] at (6,0) {bucket 0: vehicles, platforms};
\node[anchor=west] at (6,-1.2) {bucket 1: characters};
\node[anchor=west] at (6,-2.4) {bucket 2: attached objects};
\node[anchor=west, font=\footnotesize] at (-1.8,-3.3) {arrow: depends on. Each bucket runs PreAnim, Anim, PostAnim, Physics, Final.};
\end{tikzpicture}
\end{document}
```

Naughty Dog used three fixed buckets for Uncharted and TLOU.

## Consistency rule (GEA 16.6.3.3)
> **Object states are consistent before and after the update loop, but may be inconsistent during it.**

If B reads A's state before A has been updated this frame, you get a **one-frame-off lag** bug. Fixes:
- **Bucket discipline**:
  - read objects in *earlier* buckets to get their new state;
  - read objects in *later* buckets to get their old state;
  - never read objects in your own bucket.
- **State caching**: keep the previous state alongside the current one. Anyone can safely read the previous state, and you can interpolate between the two. Havok does this for every body. It costs 2× memory.
- **Time-stamping**: stamp states with the frame, and assert that the object you're querying isn't in the bucket currently being updated.

## Concurrency (GEA 16.7)
- Kick asynchronous requests (ray casts and so on) **as early as possible**, and use the results **as late as possible**, or next frame.
- "The secret of optimized concurrent design is delay" (Mike Acton).
- Naughty Dog's TLOU Remastered:
  - each bucket runs as a set of jobs;
  - **snapshots** (read-only copies of each object's state) for reads within a bucket;
  - **mutations within a bucket go into a request queue that's applied after the bucket**. That's our ECS **command buffer** (D12).

## Plotweaver
- `main.odin`'s explicit schedule *is* a phased, batched update.
- Write down the read-after-write expectations as comments next to the schedule, for example "Attachment transforms read animation's global poses, so they run after animation".
- Parent-first transform propagation is a mini bucket ordering inside one system.

Related: [[Object Models]], [[Events and Messaging]], [[Job Systems]], [[Animation Pipeline]].
