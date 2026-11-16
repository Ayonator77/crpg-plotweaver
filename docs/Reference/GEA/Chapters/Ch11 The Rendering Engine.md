---
tags: [chapter, gea, m2, m3, m7, m8, m9]
chapter: 11
pages: 621-720
---

# Ch11: The rendering engine

Overview: [[Rendering Pipeline]] · [[Depth Buffer Precision]] · [[Coordinate Spaces]]

## 11.1 Depth-buffered triangle rasterization
### Scene description
- Rendering means solving the rendering equation per pixel. Games mostly render **surfaces**, using alpha for transparency.
- Film uses patches and subdivision surfaces. Games use **triangle meshes**: triangles are always planar, survive transforms, and GPUs are built for them.
- Fixed tessellation means silhouettes look blocky up close → **LOD chains**, dynamic tessellation for terrain and water, progressive meshes.
- **Winding order** decides front vs back faces and drives back-face culling. **It must be consistent across all assets**; inconsistent winding is a common junior-modeller mistake.
- Triangle lists → **indexed** triangle lists (16-bit indices); strips and fans; **vertex cache optimization** (Sony's Edge gets about 4% better than stripping).
- **Mesh instances**: shared mesh data plus a model-to-world matrix. Static level geometry can be stored already in world space.

### Surface properties
- Light: absorption, reflection (diffuse, specular, anisotropic), transmission and refraction, diffraction, subsurface scattering.
- RGB and colour formats; alpha.
- **Vertex attributes**: position, normal, tangent and bitangent, colours, UVs, skinning indices and weights.
- **Vertex formats** multiply quickly. Limit the set (e.g. 0, 2 or 4 skin weights) or use one "über-format".
- **Gouraud shading**; vertex normals control whether a surface looks smooth or faceted.
- **Textures**:
  - types: diffuse/albedo, normal, gloss, environment, lookup tables;
  - addressing: wrap, mirror, clamp, border;
  - compression: DXT/S3TC, which is also *faster* to render;
  - **texel density** and **mipmaps**; consistent world-space texel density;
  - filtering: nearest, bilinear, trilinear, anisotropic.
- **Materials** = shaders + textures + parameters + render state. A mesh–material pair is a "render packet". Models have one submesh per material.

### Lighting basics
- Local vs global illumination. **Phong**: ambient + Σ(diffuse `N·L` + specular `(R·V)^α`). Blinn-Phong uses `(N·H)^a`. BRDFs.
- **Light types**: static (light maps), ambient, directional, point (radius cutoff), spot (inner and outer cone), area (faked), emissive.
- The Luigi's Mansion flashlight combines five techniques into one effect.

### Virtual camera
- View space. **The view matrix is the inverse of the camera's transform.**
- Projections: perspective and orthographic matrices; the perspective divide; perspective-correct interpolation.
- Frustum and clip space (GL z ∈ [−1, 1], DX z ∈ [0, 1]), screen mapping, aspect ratio.
- Frame buffer, double and triple buffering, render targets.
- Rasterization into fragments. **Depth buffer**, z-fighting, w-buffer.

## 11.2 The rendering pipeline
See [[Rendering Pipeline]].
- Stages: tools → asset conditioning → application → geometry → rasterization.
- GPU substages; programmable shaders (registers: input, constant, temporary, output; read-only textures; render to texture); HLSL/GLSL syntax (semantics, uniforms); effect files (techniques and passes).
- **Anti-aliasing**: SSAA, MSAA, CSAA, MLAA/FXAA, SMAA.
- **Application stage**: visibility (frustum culling, PVS, portals, antiportals), submission, **render-state leaks**, GPU command lists, **sorting and z-prepass**, order-independent transparency, scene graphs (quadtree, octree, sphere tree, BSP, kd-tree). Choose the scene graph from measurements.

## 11.3 Advanced lighting and global illumination
- Normal maps (store 2 channels, reconstruct the third); height maps for bump, **parallax occlusion** (ND's bullet decals) and displacement mapping; specular, gloss and power maps; sphere vs **cube** environment maps; 3D textures.
- **HDR** and tone mapping; bloom; log-LUV.
- **Shadows**:
  - tag casters, receivers and excluded objects, and tag which lights cast shadows;
  - shadow volumes (stencil buffer);
  - **shadow maps** (depth rendered from the light; orthographic for directional lights).
- Ambient occlusion (precomputed for static objects); reflections (mirror via render-to-texture); caustics (projected animated texture); subsurface scattering (BSSRDF; depth-map trick); PRT with spherical harmonics.
- **Deferred rendering**: a G-buffer (Killzone 2). **Physically based shading** with real-world units.

## 11.4 Visual effects and overlays
- **Particles**: quads, billboarded, translucent, animated by curves or procedurally, spawned by emitters, killed by lifetime or a death plane.
- **Decals**: project a box into the scene, clip the triangles it hits, generate UVs, apply a z-bias.
- **Skies**: draw **last**, with depth test at max−1 and no depth writes, so the sky's pixel shader runs on the fewest pixels. Sky domes and boxes; clouds.
- **Terrain**: height fields plus LOD, texture splatting, cut-outs for buildings.
- **Water**: a combination of techniques, often interacting with gameplay.
- **Overlays and text**: glyph atlas, FreeType, signed-distance-field text, Slug; shaping and kerning. **Only implement the text features the game needs.**
- **Gamma**: decode textures, light in linear space, encode at the end.
- **Post effects**: motion blur, depth of field, vignette, colourization.

## 11.5 Further reading
*Real-Time Rendering* [2]; the "definitive reference" [16]; Lengyel on the math [32]; the *Graphics Gems* and *GPU Gems* series.

Prev: [[Ch10 Debugging and Development Tools]] · Next: [[Ch12 Animation Systems]]
