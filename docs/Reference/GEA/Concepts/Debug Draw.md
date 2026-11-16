---
tags: [concept, debug, rendering]
source: GEA 10.2
---

# Debug draw

"A picture is worth a thousand minutes of debugging" (GEA 10.2).

## API requirements (GEA 10.2.1)
- **Primitives**: line, cross (for points), sphere, circle, coordinate axes (x red, y green, z blue), triangle, AABB, OBB, text.
- **Options**: color, line width, size or radius.
- **World space** (perspective) and **screen space** (orthographic, in pixels or normalized units) as separate managers.
- **Depth test on or off**: on shows true depth but can be hidden; off always shows but floats.
- **Callable from anywhere**. Calls **queue** primitives that are drawn at the end of the frame. That's why Naughty Dog names them `AddLine`, not `DrawLine`.
- **Lifetime per primitive**: 0 means this frame only. Use a few seconds for one-off events such as "computed a projectile arc".
- Must stay fast with thousands of primitives.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{B/.style={draw, rounded corners, minimum height=0.8cm, align=center}}
\node[B] (a) at (0,1.2) {any system:\\debug.add\_line(...)};
\node[B] (b) at (0,-0.2) {any system:\\debug.add\_sphere(...)};
\node[B] (q) at (4,0.5) {queue\\(+ lifetime)};
\node[B] (r) at (8,0.5) {debug pass\\(end of frame)};
\draw[->, thick] (a) -- (q); \draw[->, thick] (b) -- (q); \draw[->, thick] (q) -- (r);
\draw[->] (q.south) .. controls (4,-1.0) and (5.5,-1.0) .. node[below] {expire} (5.5,0.0);
\end{tikzpicture}
\end{document}
```

## Examples from Naughty Dog
- NPC perception: a "stick man" drawn at the player's last-known position.
- Explosion blast spheres.
- Ledge-search radii.
- An AI debug mode where the developer drives an NPC through a menu.

## Plotweaver uses
- Skeleton joints and axes (M11).
- Ray picks (M6).
- A\* paths and the grid (M15).
- LOS rays, cover values, AoE templates (M17).
- Surface cells and reaction BFS order (M18).

Store the queue in a frame or long-lived array, and render it as one `GL_LINES` batch.

Related: [[Ch10 Debugging and Development Tools]].
