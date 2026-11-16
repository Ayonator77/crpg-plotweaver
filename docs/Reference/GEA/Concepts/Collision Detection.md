---
tags: [concept, collision]
source: GEA 13.3.1–13.3.6, 13.3.8
---

# Collision detection

## Collidables and the collision world
- A **collidable** is a **shape** plus a **transform** (GEA 13.3.1).
- It is separate from the object's gameplay data and from its visual mesh.
- Shapes can be shared between collidables, e.g. every car using one car shape.
- The **collision world** is a private structure holding only collidables. That makes it cache-friendly, encapsulated and testable (GEA 13.3.2).
  - Plotweaver: this is a *resource*, the same way the surface grid is (D14). Collision isn't done by iterating the ECS.

## Primitives, from cheapest to most expensive (GEA 13.3.4)
1. sphere (fits in a vec4)
2. capsule (two points and a radius; good for limbs)
3. AABB
4. OBB (half-extents and a transform)
5. k-DOP
6. convex hull (checked for convexity offline)
7. poly soup (static terrain and buildings; winding order gives front/back)
8. compound shapes with a bounding volume ("midphase")

**Prefer convex shapes**: the tests are much simpler.

## Separating axis theorem (GEA 13.3.5.3)
If you can find any axis along which the projections of two **convex** shapes don't overlap, the shapes don't intersect.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[fill=gray!20] (0,1) rectangle (2,2.5); \node at (1,1.75) {A};
\draw[fill=gray!40] (3.2,0.8) -- (4.8,1.2) -- (4.4,2.6) -- (3.4,2.2) -- cycle; \node at (4,1.7) {B};
\draw[->] (-0.5,0) -- (6,0) node[right] {separating axis};
\draw[very thick] (0,0) -- (2,0); \draw[very thick] (3.2,0) -- (4.8,0);
\draw[dashed] (0,1) -- (0,0); \draw[dashed] (2,1) -- (2,0);
\draw[dashed] (3.2,0.8) -- (3.2,0); \draw[dashed] (4.8,1.2) -- (4.8,0);
\node[below] at (2.6,-0.05) {gap};
\draw[dashed] (2.6,-0.2) -- (2.6,3) node[above] {separating line};
\end{tikzpicture}
\end{document}
```

- **AABB vs AABB**: compare the min/max interval on x, y and z. The boxes intersect only if all three overlap.
- **Sphere vs sphere**: compare `|c1 − c2|²` with `(r1 + r2)²`. Never take a square root you don't need.
- **GJK**: two convex shapes intersect exactly when their **Minkowski difference contains the origin**. GJK searches for a simplex around the origin using a **support function** per shape. Recommended: Casey Muratori's video "Implementing GJK".

## Choosing the test for a pair of shapes
N shape types need about N² pairwise tests. Engines dispatch them through a **2D function table** (Havok calls these "collision agents").
In Odin that's `[Shape_Kind][Shape_Kind]proc(...)`, the same trick as the surface reaction table.

## Moving objects (GEA 13.3.5.7)
- Discrete snapshots each step: fine unless objects move faster than their own size per step.
- Otherwise you get **tunneling** ("bullet through paper"). Fixes: swept shapes, or continuous collision detection (time of impact, conservative advancement).

## Performance (GEA 13.3.6)

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{B/.style={draw, rounded corners, minimum height=0.8cm, align=center}}
\node[B, minimum width=8cm] (b) at (0,0) {broad phase: AABB sweep-and-prune (sorted extents)};
\node[B, minimum width=6cm] (m) at (0,-1.2) {midphase: compound bounding volumes};
\node[B, minimum width=4cm] (n) at (0,-2.4) {narrow phase: exact primitive tests};
\draw[->, thick] (b) -- (m); \draw[->, thick] (m) -- (n);
\end{tikzpicture}
\end{document}
```

- **Temporal coherency**: cache results between frames, since objects barely move.
- **Spatial partitioning**: octree, BSP, kd-tree, sphere tree, spatial hash.

## Filtering (GEA 13.3.8)
- **Collision layers** with a 32-bit mask per layer saying which layers collide.
- Contact callbacks that can accept or reject a contact.
- **Collision materials** (wood, stone, flesh): a small integer index into a global table. The table drives sounds, particles, friction and decals. Naughty Dog calls these polygon attributes (PATs).

Related: [[Collision Queries]], [[Ch13 Collision and Rigid Body Dynamics]].
