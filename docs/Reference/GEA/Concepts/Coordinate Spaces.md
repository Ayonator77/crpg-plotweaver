---
tags: [concept, math, rendering]
source: GEA 5.3.9, 5.3.10, 11.1.4
---

# Coordinate spaces

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{S/.style={draw, rounded corners, minimum width=1.6cm, minimum height=0.8cm, align=center}}
\node[S] (m) at (0,0) {Model};
\node[S] (w) at (2.4,0) {World};
\node[S] (v) at (4.8,0) {View};
\node[S] (c) at (7.2,0) {Clip};
\node[S] (n) at (9.6,0) {NDC};
\node[S] (s) at (12.0,0) {Screen};
\draw[->, thick] (m) -- node[above] {$M$} (w);
\draw[->, thick] (w) -- node[above] {$V$} (v);
\draw[->, thick] (v) -- node[above] {$P$} (c);
\draw[->, thick] (c) -- node[above] {$\div w$} (n);
\draw[->, thick] (n) -- node[above] {viewport} (s);
\node[align=center] at (6,-1.2) {Column vectors: $p_{clip} = P\,V\,M\,p_{model}$ (applied right to left)};
\end{tikzpicture}
\end{document}
```

## Model space
- The origin is somewhere convenient, for example the ground between the character's feet.
- Name the axes **Front, Up, Left/Right**: pitch is about L, yaw about U, roll about F (GEA 5.3.9.1).
- Pick one mapping (for example U = +y, F = +z) and use it for **every** asset.

## World space
- Keep the origin near the playable area, because floats lose precision far from it.
- Plotweaver: right-handed, Y up, metres (D3).

## View space
- The camera sits at the origin. OpenGL view space is right-handed with the camera looking down **−z** (GEA 11.1.4.1).
- **The view matrix is the inverse of the camera's view-to-world matrix.** GEA calls this "a common point of confusion and bugs".

## Clip space and NDC
- The canonical view volume is x, y ∈ [−1, 1], with z ∈ [−1, 1] in GL and [0, 1] in DX.
- The perspective divide by `w = −z_view` is what makes distant things smaller.
- Attributes must be interpolated in a perspective-correct way.

## Change of basis
- `M_C→P` holds the child's axes `i, j, k` and its origin `t`, all expressed in the parent space.
- With column vectors, these are the columns. So you can read an object's **facing vector straight out of its model-to-world matrix** (GEA 5.3.10.3).
- A matrix that moves points from child to parent also moves the parent's axes onto the child's.

## Points vs directions
- Points have `w = 1`, directions `w = 0`, so directions ignore translation.
- point − point = direction. point + point is meaningless.

Related: [[Row vs Column Vectors]], [[Depth Buffer Precision]], [[Rendering Pipeline]].
