---
tags: [chapter, gea, m6, m15, m17]
chapter: 13
pages: 817-910
---

# Ch13: Collision and rigid body dynamics

*Skimmed: 13.4.1–13.4.8 (the dynamics math). Read: everything else, plus the start of 13.4.4 and 13.4.9–13.4.10.*

## 13.1 Do you want physics?
- What a physics system can give you:
  - collisions with static geometry; rigid bodies; springs; destructibles;
  - **ray and shape casts**; **trigger volumes**;
  - machines, traps, vehicles; ragdolls (and powered ragdolls);
  - dangling props, cloth, water and buoyancy, audio propagation.
- Physics can also run **offline** to bake animation clips (Endorphin).
- **Is it fun?** It suits simulations, physics puzzles and sandboxes. In goal-driven and story-driven games, chaos fights control: "if something absolutely must happen a certain way every time, it's usually better to animate it".
- Impacts on the project:
  - design: predictability, tuning, emergent behaviour;
  - engineering: tool pipeline, UI, AI pathing, jitter and sleeping, ragdoll instability, networking, **record/playback needs determinism**;
  - art and production costs.
- "The game design should usually drive the physics requirements of a game engine, not the other way around."

## 13.2 Middleware
ODE, **Bullet** (has continuous collision detection), TrueAxis, PhysX, Havok, PAL, DMM (finite elements).

## 13.3 Collision detection
See [[Collision Detection]] and [[Collision Queries]].

## 13.4 Rigid body dynamics (mostly skimmed)
- Classical (Newtonian) mechanics on rigid bodies, under the non-penetration constraint.
- **Numerical integration**: explicit Euler assumes velocity is constant over the step. Integrators are judged on **convergence**, **order** (Euler's error is O(Δt²)) and **stability** (methods that add energy blow up).
- Section titles: linear dynamics; angular dynamics in 2D and 3D; collision response; constraints.
- **Controlling bodies**: gravity (an acceleration), forces applied each frame, torques (via force couples), **impulses**.
- **The physics step**:
  1. integrate;
  2. detect collisions;
  3. resolve them;
  4. run the constraint solver;
  5. iterate until resolved or a maximum iteration count (spreads the cost over frames; can cause stretchy chains or brief interpenetration).

## 13.5 Integrating physics into the game
- A game object has 0, 1 or many rigid bodies (characters and machines link bodies to skeleton joints).
- **Motion types**:
  - **physics-driven**;
  - **game-driven / keyframed**: infinite mass, moved with impulses, never teleported;
  - **fixed**: collision only.
  - The type can change at runtime, e.g. a held object becomes physics-driven when thrown. The safe-door example uses both.
- **Update order**:
  1. update game-driven bodies and phantoms;
  2. apply forces and impulses, adjust constraints;
  3. step;
  4. read back physics-driven transforms;
  5. query phantoms;
  6. run casts.
- **When to run queries**: use last frame's result, accept a one-frame lag, or run after the step.
- Typical loop: HID → preAnim → anim → postAnim → **physics step** → ragdolls → postPhysics → finalize animation → effects → audio → render.
- **Step physics at a fixed Δt.** If you fall behind, let the physics look slower rather than increasing Δt.
- **Examples**:
  - simple props;
  - **bullets**: ray cast vs projectile body; the camera ray and the gun ray disagree; **an object-ID render target for picking**; impact effects via physical materials or ND's PATs;
  - **grenades**: precompute the arc with ray casts and show it to the player, then control the bounces;
  - explosions: radial impulses with falloff, pushing foliage;
  - destructibles: structural and explosive pieces, health per piece, collapse that propagates slowly;
  - **character controllers** built on capsule casts;
  - **camera collision**: zoom in rather than swinging horizontally; occluders between camera and player are either made translucent or avoided;
  - **ragdolls**: a separate set of bodies from the living character, powered constraints during the transition, single-sided collision, picking a get-up animation by matching key joints.

## 13.6 Advanced
Deformable bodies, cloth, hair (cloth sheets), water and buoyancy, fluids (LittleBigPlanet's 2D smoke), physically based audio, GPGPU (ND moved cloth to the GPU).

## Plotweaver
- A turn-based CRPG needs **collision queries** (picking, LOS, AoE, triggers), not rigid-body simulation at first.
- Steal these: the throw-arc preview, occluder fading for the isometric camera, collision layers, and collision materials for footstep sounds.

Prev: [[Ch12 Animation Systems]] · Next: [[Ch14 Audio]]
