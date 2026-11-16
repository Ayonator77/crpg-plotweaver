---
tags: [concept, animation, rendering]
source: GEA 12.2–12.5
---

# Skinning and the matrix palette

## Skeleton (GEA 12.2)
- A skeleton is an **array of joints** in which each child appears after its parent, so joint 0 is the root.
- Each joint stores:
  - its name (a [[String IDs|string id]]);
  - a `u8` parent index (at most 256 joints; root = 0xFF);
  - its **inverse bind pose**.
- Engines care about *joints*. "Bones" are just the gaps between them.
- Joint poses are **local** (relative to the parent) and stored as SRT: quaternion first, for alignment.

## The skinning matrix (GEA 12.5.2)
A vertex bound to a joint has **constant coordinates in that joint's space**. To skin it:
1. Take the vertex from model space (bind pose) into joint space with the inverse bind pose.
2. Move the joint to its current pose.
3. Take the vertex back to model space.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{B/.style={draw, rounded corners, minimum height=0.9cm, align=center}}
\node[B] (a) at (0,0) {$v^{B}_{M}$\\model space,\\bind pose};
\node[B] (b) at (4.5,0) {$v_j$\\joint space\\(constant)};
\node[B] (c) at (9,0) {$v^{C}_{M}$\\model space,\\current pose};
\draw[->, thick] (a) -- node[above] {$B_j^{-1}$} node[below, font=\footnotesize] {inverse bind} (b);
\draw[->, thick] (b) -- node[above] {$C_j$} node[below, font=\footnotesize] {current global} (c);
\node at (4.5,-1.6) {column vectors: $K_j = C_j\,B_j^{-1}$ \quad (book, row vectors: $K_j = B_j^{-1} C_j$)};
\end{tikzpicture}
\end{document}
```

- The `B⁻¹` values are constant, so **cache them in the skeleton**.
- `C_j` (the global pose) is built from local poses by walking from the root down. Because parents come first in the array, one linear loop does it.
- The array of `K_j` is the **matrix palette** that goes to the renderer, for example in an SSBO.
- You *can* premultiply the model-to-world matrix into the palette. **Don't** if you want **animation instancing** (crowds sharing one palette).

## Per-vertex data (GEA 12.5.1)
- At most **4 joints per vertex**: four `u8` indices packed in 32 bits, plus 3 weights. The 4th weight is `1 − (w0+w1+w2)`.
- Most people can't see a quality difference beyond 4 influences.
- Final position = `Σ w_i · K_{j_i} · v`.

## Relationships (GEA 12.4.7)
- One skeleton is shared by many meshes and many clips. Clips don't know about meshes, and meshes don't know about clips.
- **Minimize the number of unique skeletons** so clips can be shared. This is why the plan has the UBC reference rig.
- Retargeting between different rigs: Naughty Dog uses a **retarget pose** that captures the difference between two bind poses.

Related: [[Animation Pipeline]], [[Row vs Column Vectors]], [[Ch12 Animation Systems]].
