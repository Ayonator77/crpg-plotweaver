---
tags: [concept, collision, gameplay]
source: GEA 13.3.7, 13.5.2.1, 13.5.3, 16.5.4
---

# Collision queries

These are hypothetical questions asked of the collision world. The query itself is never part of the world (GEA 13.3.7).

## Ray cast
A directed segment `p(t) = p0 + t·d`, with `t ∈ [0, 1]`.
- Returns the **earliest** contact (or all contacts), each with: `t`, collidable id, surface normal.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\fill (0,0) circle (2.5pt) node[below] {$p_0$ (eyes of A)};
\draw[->, thick] (0,0) -- (8,1.6) node[right] {$p_0 + d$ (chest of B)};
\draw[fill=gray!30] (3.5,0.2) rectangle (4.3,1.6); \node at (3.9,1.85) {crate};
\fill (3.5,0.7) circle (2.5pt) node[below right] {hit, $t = 0.44$};
\draw[fill=gray!10] (8.2,0.9) circle (0.5) node {B};
\node[align=left, anchor=west] at (0,-1.2) {earliest contact is not B, so A has no line of sight};
\end{tikzpicture}
\end{document}
```

Uses:
- **line of sight**;
- bullets;
- "is there ground under my feet";
- AI targeting;
- snapping tyres to terrain;
- **editor picking** (M6).

## Shape cast (sphere or capsule)
- Asks how far a convex shape can travel along a segment.
- It may start already overlapping something. It can return several contacts. **Sort them by t.**
- Uses:
  - **camera collision**;
  - **character movement**: slide along walls, pop up over curbs, refuse slopes that are too steep, play a "touch the wall" animation.

## Phantoms
A persistent shape cast with zero length, invisible to everything else. Uses:
- "all enemies within a radius";
- auras;
- trigger regions;
- the character controller (Havok models the character as a capsule phantom).

Phantoms benefit from temporal coherency.

## When to run queries (GEA 13.5.2.1)
1. Use the **previous frame's** state. Often correct, e.g. "was I standing on something?"
2. Accept a **one-frame lag**.
3. Run the query **after the physics step**, if the decision can wait until late in the frame.

## Game-object queries in general (GEA 16.5.4)
Decide which queries the game actually needs and build a structure for each. There's no general-purpose game-object database.

| Query | Structure |
|---|---|
| By id | hash table |
| By type or criterion | presorted lists |
| Along a path, LOS | collision ray and shape casts |
| Within a radius | spatial hash, grid, quadtree |

## Plotweaver
| Need | Approach |
|---|---|
| M6 picking | ray vs AABB of every pickable entity, then nearest `t`. Let repeated clicks cycle through hits (GEA 15.4.1.4) |
| M15 / M17 | grid line of sight with a ray cast for cover; AoE shapes as phantoms or rasterized onto the grid |
| Throw arcs (GEA 13.5.3.3) | precompute the arc with ray casts and **show it to the player** (DOS2 style), then follow the arc exactly when thrown |
| Isometric camera | fade or cut away occluders between the camera and the party (GEA 13.5.3.7) |

Related: [[Collision Detection]], [[Debug Draw]].
