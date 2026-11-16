---
tags: [chapter, gea, m11, m12, m13, m14]
chapter: 12
pages: 721-815
---

# Ch12: Animation systems

Concept notes: [[Skinning and Matrix Palette]] · [[Animation Pipeline]] · [[Animation Blending]] · [[Animation Clocks]] · [[Action State Machines]] · [[Motion Extraction and IK]]

## 12.1 Types of character animation
- Cel animation → sprites.
- **Rigid hierarchical** animation cracks at the joints.
- **Per-vertex animation** and **morph targets**. Morph targets are used for faces, sometimes combined with joint-driven face rigs.
- **Skinned animation** is what almost everything uses.
- "Animation methods are a form of **data compression**." A skeleton compresses well when one joint moves many vertices. Faces don't, which is why they use morph targets.

## 12.2–12.3 Skeletons and poses
- An array of joints, parent index, parents before children, inverse bind pose. "Bone" really means joint.
- **Bind (T-) pose**; **local poses** stored as SRT. Joint scale: none, uniform or non-uniform, never shear.
- Put the quaternion first in `JointPose` for alignment.
- Global pose = product of local poses walking toward the root.

## 12.4 Clips
- Clips are fine-grained so they can be recombined in-game. Cinematics (IGC/NIS/FMV) and quick-time events are the exceptions.
- Time:
  - local timeline, **continuous time**;
  - **frames vs samples** (looping clips drop the last sample);
  - **normalized time (phase)**.
- The global timeline mapping `t = (τ − τ_start)·R`, with clamp, mod or loop count. See [[Abstract Timelines]].
- **Local vs global clocks**: see [[Animation Clocks]] (decide this before M12).
- Data format: `AnimationClip {skeleton id, fps, frameCount, samples[], isLooping}` with 10 channels per joint. Channels are piecewise-linear functions of time.
- **Metachannels**:
  - **event triggers** (footsteps, reload, hit frame);
  - **locators** (camera, attach targets);
  - texture and material parameters.
- One skeleton ↔ many meshes ↔ many clips. **Minimize the number of skeletons.** Retargeting via a retarget pose.

## 12.5 Skinning
See [[Skinning and Matrix Palette]]. `K = C·B⁻¹` in column form, at most 4 influences per vertex, the matrix palette, and the trade-off of premultiplying model-to-world vs animation instancing.

## 12.6 Blending
See [[Animation Blending]]:
- LERP of local poses per joint;
- temporal interpolation;
- cross-fades (smooth and frozen) with ease curves; core poses;
- directional locomotion (pivotal vs targeted);
- 1D and 2D blend spaces (barycentric, Delaunay);
- partial-skeleton masks;
- **additive / difference clips** and their uses.

## 12.7 Post-processing
Procedural animation (wheels, foliage), IK, ragdolls.

## 12.8 Compression
Channel omission, RL quantization, lower sample rates and dropped keys, Granny's B-splines, wavelets, selective loading.

## 12.9 Pipeline
The six stages. See [[Animation Pipeline]].

## 12.10 Action state machines
See [[Action State Machines]]:
- layers;
- flat weighted average (OGRE, **Granny**) vs blend trees;
- data-driven state specs (ND's Scheme, UE4 tools);
- transitions (kinds, parameters, windows, transition matrix, MOHPA wildcards, **ND named transitions**);
- control parameters.

## 12.11 Constraints
See [[Motion Extraction and IK]]: attachments and attach points, **reference locators**, hand IK, **motion extraction**, foot IK, look-at, cover, traversal.

## Plotweaver takeaways
1. The plan's D13 matches Granny's *flat weighted average*. Also adopt Granny's **global clock** (see [[Animation Clocks]]).
2. Hemisphere alignment of quaternions is missing from the book's blend formulas. Keep the plan's `dot < 0 → negate`.
3. Use metachannel events for the combat hit frame (M14).
4. Use reference locators for paired actions (backstab, grapple, opening doors).

Prev: [[Ch11 The Rendering Engine]] · Next: [[Ch13 Collision and Rigid Body Dynamics]]
