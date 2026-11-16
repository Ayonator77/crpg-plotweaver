---
tags: [concept, resources, world]
source: GEA 15.1.2, 16.4.1–16.4.4
---

# Level loading and streaming

## Progression of techniques
1. **One level at a time**, behind a loading screen. Load-and-stay-resident data sits below a stack marker; the level goes on top ([[Stack Allocator]]).
2. **Air locks**: a small corridor or puzzle area keeps the player busy while the next full chunk loads asynchronously. Halo and Jak 2 hid them every 5–10 minutes of play.
3. **Streaming**:
   - a few equal buffers that get recycled; or
   - **fine-grained chunky pools** for every asset, which is Naughty Dog's approach.

## Naughty Dog's level-load regions (GEA 16.4.3.1)

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[fill=gray!15] (0,0) rectangle (4.5,2); \node at (1.2,1.7) {region 1};
\draw[fill=gray!25, opacity=0.8] (3.5,0.2) rectangle (8,2.2); \node at (6.8,1.9) {region 2};
\draw[fill=gray!35, opacity=0.8] (7,0) rectangle (11,2); \node at (10,1.7) {region 3};
\node[font=\footnotesize] at (1.8,0.4) {chunks: L1, L2};
\node[font=\footnotesize] at (5.8,0.5) {chunks: L2, L3};
\node[font=\footnotesize] at (9.4,0.35) {chunks: L3, L4};
\fill (4,1.0) circle (3pt) node[above] {player};
\node[align=left, anchor=west] at (0,-0.8) {required = union of chunk lists of all regions containing the player = L1, L2, L3};
\end{tikzpicture}
\end{document}
```

- A chunk that disappears from the required set is unloaded. A chunk that appears is loaded into free blocks.
- The regions are laid out so the player **never sees a chunk pop in or out**, and every load has time to finish.

## Memory for spawned objects (GEA 16.4.4)
- **Offline allocation**: the "law of conservation of game objects". Nothing is created or destroyed after load; extra objects are pre-placed but dormant.
- **Dynamic allocation** options:
  - one pool per object size;
  - a **small memory allocator** (see [[Pool Allocator]]);
  - relocation.

## Plotweaver
- A CRPG with areas fits **one area at a time, with a loading screen** (plus a party-wide load-and-stay-resident set) for a long while.
- Revisit streaming in Phase 5, using the plan's "level arena" plus handles.

Related: [[Resource Lifetimes]], [[Saved Games]].
