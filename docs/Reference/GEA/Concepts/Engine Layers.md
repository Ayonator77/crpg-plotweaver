---
tags: [concept, architecture]
source: GEA 1.6, Fig 1.16
---

# Engine layers

A game engine is built in layers. **Upper layers depend on lower layers, never the reverse.** A lower
layer that depends on a higher one creates a cycle, and cycles cause coupling, kill testability and
block reuse (GEA 1.6).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{L/.style={draw, rounded corners, minimum height=0.55cm, align=center}}
\node[L, minimum width=10cm, fill=gray!15] at (5,0) {Target hardware};
\node[L, minimum width=10cm] at (5,0.7) {Device drivers};
\node[L, minimum width=10cm] at (5,1.4) {Operating system};
\node[L, minimum width=10cm] at (5,2.1) {3rd-party SDKs (OpenGL, SDL3, cgltf, miniaudio)};
\node[L, minimum width=10cm] at (5,2.8) {Platform independence layer};
\node[L, minimum width=10cm] at (5,3.5) {Core systems: asserts, memory, math, containers, string ids};
\node[L, minimum width=10cm] at (5,4.2) {Resource manager};
\node[L, minimum width=1.55cm] at (0.78,4.95) {Render};
\node[L, minimum width=1.55cm] at (2.46,4.95) {Anim};
\node[L, minimum width=1.55cm] at (4.14,4.95) {Collision};
\node[L, minimum width=1.55cm] at (5.82,4.95) {HID};
\node[L, minimum width=1.55cm] at (7.50,4.95) {Audio};
\node[L, minimum width=1.55cm] at (9.18,4.95) {Debug};
\node[L, minimum width=10cm] at (5,5.7) {Gameplay foundations: object model, events, scripting, world loading, game flow};
\node[L, minimum width=10cm, fill=gray!15] at (5,6.4) {Game-specific subsystems (Plotweaver rules, combat, dialogue, AI)};
\draw[->, thick] (10.6,6.4) -- (10.6,0) node[midway, right, align=left] {depends\\on};
\end{tikzpicture}
\end{document}
```

## Points from the book
- The **platform independence layer** wraps OS and third-party APIs. It does two jobs: it gives a consistent API across platforms, and it insulates the engine from swapping libraries later.
- The **low-level renderer should not know about the scene graph or culling.** OGRE lets you plug in different scene graphs over the same submission code.
- Animation hands the renderer a **matrix palette** (see [[Skinning and Matrix Palette]]). This is the only coupling between the two.
- The engine/game line "is never perfectly distinct". Some game knowledge always leaks down into the gameplay foundations.

## Plotweaver
- This is D7. Odin's ban on import cycles enforces the arrows at compile time.
- D11 (the renderer consumes a flat draw list) is the book's "agnostic low-level renderer".
- See also [[Object Models]], [[Game Object Updates]].
