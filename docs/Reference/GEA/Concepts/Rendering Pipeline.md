---
tags: [concept, rendering]
source: GEA 11.2
---

# Rendering pipeline

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{B/.style={draw, rounded corners, minimum width=2.2cm, minimum height=0.8cm, align=center}}
\node[B, fill=gray!10] (t) at (0,0) {Tools\\(Blender)};
\node[B, fill=gray!10] (a) at (2.7,0) {Asset\\conditioning};
\node[B, fill=gray!25] (p) at (5.4,0) {Application\\(CPU)};
\node[B, fill=gray!40] (g) at (8.1,0) {Geometry\\(GPU)};
\node[B, fill=gray!40] (r) at (10.8,0) {Rasterization\\(GPU)};
\draw[->, thick] (t) -- (a); \draw[->, thick] (a) -- (p); \draw[->, thick] (p) -- (g); \draw[->, thick] (g) -- (r);
\node[align=center, font=\footnotesize] at (0,-1.1) {meshes,\\materials};
\node[align=center, font=\footnotesize] at (2.7,-1.1) {export, compile,\\link (.glb)};
\node[align=center, font=\footnotesize] at (5.4,-1.1) {cull, sort,\\submit, set state};
\node[align=center, font=\footnotesize] at (8.1,-1.1) {VS, GS, clip,\\screen map};
\node[align=center, font=\footnotesize] at (10.8,-1.1) {setup, traverse, early-z,\\PS, ROP blend};
\node at (5.4,1.0) {mesh instances, submeshes};
\node at (8.1,1.0) {vertices};
\node at (10.8,1.0) {fragments $\rightarrow$ pixels};
\end{tikzpicture}
\end{document}
```

Throughput is limited by the **slowest stage** (GEA 11.2).

## GPU stages (GEA 11.2.4)
- **Vertex shader**: transform to clip space, per-vertex lighting, skinning, procedural deformation.
- **Geometry shader** (optional), **stream output**.
- **Clipping**, **screen mapping**, **triangle setup and traversal**: fixed function. Traversal does perspective-correct interpolation.
- **Early-z** test: skips the pixel shader for hidden fragments.
- **Pixel shader**.
- **Merge / ROP**: depth, alpha and stencil tests, then blending with `C' = A_s·C_s + (1−A_s)·C_d`.

## The application stage is our render extraction (D11)
1. **Visibility.**
   - Frustum-cull bounding spheres: plug the sphere's centre into each plane equation and compare the result with the radius.
   - Occlusion culling: PVS (potentially visible sets), portals for indoors, antiportals for outdoors.
2. **Submission**: send mesh–material pairs ("render packets") to the GPU.
3. **Render state**: the material must fully describe the GPU state, otherwise state **leaks** from the previous draw.

## Sorting (GEA 11.2.7.3)
- Sort by material to minimize state changes. But for early-z you want front to back. These conflict.
- **Z-prepass** resolves it: a depth-only pass front to back, then a colour pass sorted by material.
- Translucent geometry: drawn **after** opaque, **back to front**. Order-independent transparency avoids sorting but costs a lot of memory.

## Scene graphs (GEA 11.2.7.4)
Options: quadtree, octree, sphere tree, BSP, kd-tree.
- A quadtree suits mostly flat outdoor scenes seen from above (strategy games), which is close to Plotweaver's camera.
- "Choose your scene graph based on hard data from measuring performance."

## Materials, textures, lighting (GEA 11.1.2–11.1.3, 11.3)
- **Indexed triangle lists.** Use a consistent winding order across *all* assets.
- **Mipmaps**: trilinear and anisotropic filtering. Keep **world-space texel density** consistent across assets.
- **Lighting**: Phong / Blinn-Phong, then PBR. Light types: directional, point (with a radius cutoff), spot (inner and outer cone).
- **Shadow maps**: render depth from the light. Use an orthographic projection for directional lights.
- **HDR** with tone mapping.
- **Gamma**: decode textures to linear, light in linear, encode at the end. This is the sRGB lesson in M3 and M8.
- **Normals** transform with the inverse transpose.
- **Decals**: project a box, clip the triangles it hits, generate UVs, apply a small z-bias.
- **Particles**: billboarded quads, translucent, with emitters.

## Anti-aliasing (GEA 11.2.6)
SSAA (4× cost) → **MSAA** (shades once per pixel) → CSAA → FXAA/MLAA → **SMAA** ("arguably the best").

Related: [[Depth Buffer Precision]], [[Coordinate Spaces]], [[Ch11 The Rendering Engine]].
