---
tags: [concept, animation]
source: GEA 12.6, 12.8, 12.10.1–12.10.2
---

# Animation blending

**Blend local poses, joint by joint**, with each joint independent of the others. That makes it easy to parallelize.
Blending global poses looks biomechanically wrong (GEA 12.6.1).

For each joint:
- translation: LERP;
- rotation: NLERP or SLERP (plus the hemisphere check, see [[Quaternions]]);
- scale: LERP.

You can't LERP matrices, which is why local poses are stored as SRT.

## Cross-fades (GEA 12.6.2.2)
- **Smooth transition**: both clips' clocks keep running. The clips need synced, looping timelines.
- **Frozen transition**: clip A's clock stops. Use it for unrelated clips.
- **Ease curve**: a cubic Bézier with tangents equal to the end values. With β going from 0 to 1, it becomes `β(u) = 3u² − 2u³`.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small, x=6cm, y=3cm]
\draw[->] (0,0) -- (1.1,0) node[right] {$u$ (normalized blend time)};
\draw[->] (0,0) -- (0,1.15) node[above] {weight};
\draw[thick, domain=0:1, samples=50] plot (\x, {3*\x*\x - 2*\x*\x*\x});
\draw[thick, dashed, domain=0:1, samples=50] plot (\x, {1 - 3*\x*\x + 2*\x*\x*\x});
\node[right] at (1,1) {$w_B$ (ease in)};
\node[right] at (1,0.05) {$w_A$ (ease out)};
\node[below] at (0,0) {$t_{start}$}; \node[below] at (1,0) {$t_{end}$};
\end{tikzpicture}
\end{document}
```

- **Core poses** (stand, crouch, prone): every clip starts and ends in one of them, so clips connect without blending (C0 continuity).
- LERP blending gives C0 continuity and roughly C1. Watch out for **foot sliding**.

## Blend spaces (GEA 12.6.3)
```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[->, thick] (0,0) -- (10,0) node[right] {$b$ (e.g. speed)};
\foreach \x/\n in {0.5/idle,3/walk,6.5/jog,9/run} { \fill (\x,0) circle (2.5pt); \node[above] at (\x,0.15) {\n}; }
\draw[->, thick] (4.6,-0.9) node[below] {$b$} -- (4.6,-0.1);
\node[align=center, font=\footnotesize] at (4.75,-2.0) {neighbours walk ($b_1$) and jog ($b_2$):\\$\beta = (b-b_1)/(b_2-b_1)$};
\end{tikzpicture}
\end{document}
```

- **1D**: pick the two clips on either side of `b`. Directional strafing is a 1D blend over the angle −90…90°. Forward and backward need separate halves because the legs cross differently.
- **2D**:
  - four clips at the corners of a square: two 1D blends;
  - three clips in a triangle: **barycentric weights** (α, β, γ);
  - any number of clips: Delaunay-triangulate them first (EA's FIFA).

## Partial-skeleton blending (GEA 12.6.4)
- A per-joint blend mask: the plan's `Track_Mask`.
- Hard edges in the mask look disconnected. **Feather** it, e.g. 0.9 at the shoulder, 0.5 on the upper spine, 0.2 on the neck.
- The masked limb won't react to what the body is doing (a wave looks the same while running and standing).

## Additive blending (GEA 12.6.5–12.6.6)
- **Difference clip**: `D = S·R⁻¹` in the book's row convention. Apply it to *another* clip: `A = D·T`.
- Partial effect: `LERP(T, D·T, β)`, done per SRT channel.
- Rules:
  - keep hips, shoulders and elbows neutral in the reference clip;
  - make one difference clip per core pose;
  - watch for over-rotation when stacking.
- Uses:
  - stance variation (single-frame difference clips);
  - locomotion noise;
  - **aim and look-at** (left, right, up and down difference clips);
  - **overloading the time axis**: a 3-frame clip holding aim-left, aim-centre and aim-right; "play frame 2.5".

## Flat weighted average vs blend trees (GEA 12.10)
- **Flat weighted average**: one list of active clips, each with a weight. Result = `Σ wᵢ·xᵢ / Σ wᵢ`.
  - This is **Granny's** model (it normalizes weights automatically) and the plan's D13.
  - Cross-fading between *groups* of clips: scale the source group's weights by (1−λ) and the destination's by λ. That needs **group metadata** on top of the flat list.
- **Blend trees**: expression trees made of clip, LERP, additive and ternary nodes. A cross-fade is a temporary LERP node between the old tree and the new one.

## Compression (GEA 12.8)
- **Channel omission**: no scale, translation only on the root and face joints, quaternion stored as xyz with w reconstructed, constant channels stored once.
- **16-bit quantization**: use Jonathan Blow's **RL** encode/decode. The TL and RC variants add or remove energy; TC can't represent 0.
- Lower sample rate, or drop keys.
- **Granny fits B-splines** within a tolerance.
- Wavelets (used in *Thief*, 2014).
- Raw numbers: 1000 s of animation × 100 joints ≈ 114 MiB uncompressed.

Related: [[Animation Pipeline]], [[Animation Clocks]], [[Action State Machines]].
