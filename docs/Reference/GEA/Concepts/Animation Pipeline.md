---
tags: [concept, animation]
source: GEA 12.9, 16.6.3.1, 16.8.9.2
---

# Animation pipeline

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{B/.style={draw, rounded corners, minimum width=5.2cm, minimum height=0.7cm, align=center}}
\node[B] (s1) at (0,0) {1. Decompress + extract pose per clip};
\node[B] (s2) at (0,-1.1) {2. Blend (LERP / partial / additive)};
\node[B] (s3) at (0,-2.2) {3. Global pose (walk hierarchy)};
\node[B] (s4) at (0,-3.3) {4. Post-process (IK, ragdoll, procedural)};
\node[B] (s5) at (0,-4.4) {5. Recompute global pose};
\node[B] (s6) at (0,-5.5) {6. Matrix palette ($C_j B_j^{-1}$)};
\foreach \a/\b in {s1/s2,s2/s3,s3/s4,s4/s5,s5/s6} { \draw[->, thick] (\a) -- (\b); }
\node[draw, rounded corners, align=center] (in) at (-5,-0.5) {clips, local clocks,\\blend spec, skeleton};
\draw[->] (in) -- (s1);
\node[draw, rounded corners] (gp) at (5,-3.3) {gameplay systems};
\draw[<->] (gp) -- (s4);
\node[draw, rounded corners] (rd) at (5,-5.5) {renderer};
\draw[->] (s6) -- (rd);
\node[right, align=left, font=\footnotesize] at (2.8,-1.65) {post-processing that needs\\no global pose goes here};
\end{tikzpicture}
\end{document}
```

- Outputs: **local pose**, **global pose**, **matrix palette**.
- Stage 4 often needs global poses but writes local ones, which is why stage 5 exists.

## Where the game hooks in (GEA 16.6.3.1)
Naughty Dog updates game objects three times per frame: **PreAnimUpdate** (start or stop clips), **PostAnimUpdate** (adjust the intermediate pose), and **FinalUpdate**.
- Better to implement these as **registered callbacks** per phase, so only interested clients run and the animation system doesn't need to know about game objects.

## Event ordering (GEA 16.8.9.2)
Advance clip clocks first. That detects end-of-clip and fires events. Then **dispatch events**, so a handler can start the next clip. **Then** blend.
This avoids a one-frame gap between animations.

## Plotweaver mapping (M11–M14)
1. State machine
2. Advance control clocks and eases
3. **Sample and accumulate**: stages 1 and 2 fused, Granny-style
4. Local pose
5. IK: stages 4 and 5
6. World pose
7. Skin matrices: stage 6
8. Render extraction (SSBO offset)

Related: [[Animation Blending]], [[Skinning and Matrix Palette]], [[Action State Machines]], [[Animation Clocks]].
