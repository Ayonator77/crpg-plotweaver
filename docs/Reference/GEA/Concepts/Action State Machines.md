---
tags: [concept, animation]
source: GEA 12.10
---

# Action state machines (ASM)

The ASM sits **on top of** the animation pipeline. Each state is an arbitrary blend of clips. Higher-level game code
talks to states and transitions, not to individual clips.

## Layers (GEA 12.10, Fig 12.48)
Each layer runs its own state machine, and the layer outputs are combined. This gives **anticipation**: the head leads a turn, then the shoulders, hips and legs follow.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[->] (0,-0.4) -- (11,-0.4) node[right] {time};
\node[anchor=east] at (-0.1,0.2) {base};
\draw[fill=gray!25] (0,0) rectangle (4,0.4); \node at (2,0.2) {idle};
\draw[fill=gray!25] (4,0) rectangle (11,0.4); \node at (7.5,0.2) {move (1D blend)};
\node[anchor=east] at (-0.1,0.9) {variation (+)};
\draw[fill=gray!12] (1,0.7) rectangle (6,1.1); \node at (3.5,0.9) {tired additive};
\node[anchor=east] at (-0.1,1.6) {gesture (+)};
\draw[fill=gray!12] (5,1.4) rectangle (9,1.8); \node at (7,1.6) {aim L/R/U/D};
\node[anchor=east] at (-0.1,2.3) {gesture (mask)};
\draw[fill=gray!12] (7,2.1) rectangle (10.5,2.5); \node at (8.75,2.3) {cast (upper body)};
\end{tikzpicture}
\end{document}
```

The transitions in each layer are independent in time.

## Transitions (GEA 12.10.4)
- **Kinds**:
  - pop: the poses already match;
  - cross-fade;
  - **transitional state**: a full state used only between two others, e.g. lying down → standing.
- **Parameters**:
  - source and destination;
  - type;
  - duration;
  - ease curve;
  - **transition window**: only allowed within part of the source clip's timeline, e.g. "punch → impact only in the second half of the swing".
- **Transition matrix**: n² possible transitions but sparse.
  - MOHPA used **wildcards**: `from="*" to="*"` as the default, then `walk*`→`run*` smooth, then `*prone`→`*get-up` with a window.
  - Naughty Dog makes **transitions first-class and named**. Game code asks for the transition `"jump"`, and each state decides where `"jump"` leads. Also: transition groups, plus `transition-end` (taken when the clip runs out).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{S/.style={draw, rounded corners, minimum width=2cm, minimum height=0.7cm}}
\node[S] (w) at (0,1.2) {walk};
\node[S] (s) at (0,0) {walk-scared};
\node[S] (c) at (0,-1.2) {crouch-walk};
\node[S] (j) at (5,1.2) {jump};
\node[S] (js) at (5,0) {jump-scared};
\node[S] (cj) at (5,-1.2) {crouch-to-jump};
\draw[->, thick] (w) -- node[above] {``jump''} (j);
\draw[->, thick] (s) -- node[above] {``jump''} (js);
\draw[->, thick] (c) -- node[above] {``jump''} (cj);
\node[align=center, font=\footnotesize] at (2.5,-2.2) {game code asks for ``jump''; the data decides the destination};
\end{tikzpicture}
\end{document}
```

## Data-driven state specs (GEA 12.10.3)
- Four atomic node types are enough: clip, LERP, additive, ternary LERP. Bigger compound nodes can be built on top.
- Naughty Dog writes states in Scheme: `(define-state complex :tree (anim-node-lerp ...))`.
- **Rapid iteration** tools:
  - an in-game animation viewer;
  - hot-reloading the state scripts;
  - **recording the last few seconds of transitions so you can pause and rewind**;
  - a live link from Maya.

## Control parameters (GEA 12.10.5)
Game code sets named parameters such as `speed` or `aim_x`. It does not poke clip weights. The book lists three options:
- search the tree for a node by name;
- named variables;
- a control struct bound to the nodes.

## Plotweaver (M14)
- The plan already separates the decisions (the state machine) from the mechanics (the controls). Good.
- Add:
  - transition windows;
  - named transitions;
  - wildcard defaults in JSON;
  - a debug panel that shows each character's recent transitions.

Related: [[Animation Blending]], [[Motion Extraction and IK]], [[Animation Clocks]].
