---
tags: [concept, rendering, math]
source: GEA 11.1.4.8
---

# Depth buffer precision and z-fighting

After the perspective divide, the stored depth behaves like `1/z_view`. That puts **most of the precision near the camera**:

```tikz
\begin{document}
\begin{tikzpicture}[font=\small, x=1.6cm, y=2.6cm]
\draw[->] (0,0) -- (5,0) node[right] {$z_{view}$ (distance)};
\draw[->] (0,0) -- (0,1.5) node[above] {stored depth $\sim 1/z$};
\draw[thick, domain=0.7:4.8, samples=60] plot (\x, {1/\x});
\draw[dashed] (0.8,0) -- (0.8,1.25); \draw[dashed] (1.0,0) -- (1.0,1.0);
\draw[<->] (-0.08,1.25) -- (-0.08,1.0); \node[left] at (-0.1,1.12) {large};
\draw[dashed] (4.0,0) -- (4.0,0.25); \draw[dashed] (4.2,0) -- (4.2,0.238);
\node[above] at (4.1,0.3) {tiny $\Delta$};
\node[below] at (0.9,0) {near};
\node[below] at (4.1,0) {far};
\end{tikzpicture}
\end{document}
```

Two surfaces close together far from the camera can map to the same depth value. The farther one then "pokes through": **z-fighting**.

## What the book suggests
- A **w-buffer** stores linear view-space z, which gives uniform precision. It is more expensive because the inverted values must be re-inverted around interpolation.
- Decals avoid z-fighting with a slight z-bias, made by shifting the near plane (GEA 11.4.2).

## Practical rules (partly beyond the book)
- **Push the near plane out as far as you can.** Most precision is lost to a near plane that's too close.
- A tactical CRPG camera never gets closer than a metre or so, so you can use a generous near plane.
- Use a 24-bit depth buffer with an 8-bit stencil, packed into 32 bits (GEA 11.1.4.8).
- Modern alternative, not in the book: **reversed-Z** with a floating-point depth buffer.

Related: [[Rendering Pipeline]], [[Coordinate Spaces]].
