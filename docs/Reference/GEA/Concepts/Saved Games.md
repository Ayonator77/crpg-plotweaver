---
tags: [concept, data, serialization]
source: GEA 16.4.5
---

# Saved games

A save file is **not** a world chunk. A world chunk stores both the static world and the initial state of every dynamic object.
A save stores only **what changed and matters to gameplay** (GEA 16.4.5).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[fill=gray!10] (0,0) rectangle (6,2.4); \node[above] at (3,2.4) {world chunk (authored)};
\draw[fill=gray!30] (0.2,0.2) rectangle (3.4,2.2); \node[align=center] at (1.8,1.2) {static: meshes,\\collision, nav,\\lights};
\draw[fill=gray!5] (3.6,0.2) rectangle (5.8,2.2); \node[align=center] at (4.7,1.2) {initial\\dynamic\\state};
\draw[fill=gray!45] (8,0.6) rectangle (10.4,1.8); \node[align=center] at (9.2,1.2) {save:\\current\\gameplay state};
\draw[->, thick] (5.8,1.2) -- node[above] {diff} (8,1.2);
\end{tikzpicture}
\end{document}
```

## Strategies
- **Checkpoints**: the save holds little more than "last checkpoint", plus inventory and health. Tiny, but frustrating if checkpoints are far apart.
- **Save anywhere**: about the same information as a world chunk minus the static parts. Can share the chunk format, or use a compressed one.
- **Approximate**: you don't need exact animation time indices or rigid-body momenta. "Rely on the imperfect memories of human gamers."

## Plotweaver (M21)
- The plan's split between **level data (authored)** and **save data (changed at runtime)** is this idea.
- Save:
  - entity components that differ from the level's spawned state;
  - the combat state (turn order, statuses with remaining turns);
  - the **surface grid**, run-length encoded;
  - dialogue facts and quest flags.
- Leave transient state out: in-flight animation clocks, particles, render caches.
- Version the format, and store names or hashed ids, never enum ordinals ([[String IDs]]).

Related: [[Spawners and Type Schemas]], [[Level Streaming]].
