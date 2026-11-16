---
tags: [concept, memory]
source: GEA 6.2.1.1, 6.2.1.4, 7.2.2.7, 16.4.1
---

# Stack allocator

Grab one big block. Each allocation bumps a `top` pointer upward. You **free by rolling back to a marker**,
never one block at a time, which means **zero fragmentation** (GEA 6.2.1.1).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw (0,0) rectangle (10,1);
\fill[gray!40] (0,0) rectangle (3,1);
\fill[gray!15] (3,0) rectangle (7,1);
\draw (3,0) -- (3,1); \draw (7,0) -- (7,1);
\node at (1.5,0.5) {LSR data};
\node at (5,0.5) {Level A};
\node at (8.5,0.5) {free};
\draw[->, thick] (3,1.7) node[above] {marker} -- (3,1.05);
\draw[->, thick] (7,-0.7) node[below] {top} -- (7,-0.05);
\node[anchor=west] at (0,-1.6) {Unload level A: \texttt{free\_to\_marker(marker)}. Then load level B on top.};
\end{tikzpicture}
\end{document}
```

## Variants
**Double-ended stack** (Midway's *Hydro Thunder*, GEA 6.2.1.1). One block holds two stacks:
- the lower stack grows up and holds **level data**;
- the upper stack grows down and holds **per-frame temporaries**.

The two halves share space dynamically, and the game had no fragmentation at all.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw (0,0) rectangle (10,1);
\fill[gray!35] (0,0) rectangle (4,1);
\fill[gray!15] (7.5,0) rectangle (10,1);
\node at (2,0.5) {level data $\rightarrow$};
\node at (8.75,0.5) {$\leftarrow$ frame temp};
\node at (5.75,0.5) {free};
\end{tikzpicture}
\end{document}
```

- **Single-frame allocator.** A stack that is cleared at the start of every frame. Allocations never need freeing. **Never keep a pointer into it across a frame boundary.**
- **Double-buffered allocator.** Two single-frame stacks that swap every frame. Data from frame N stays valid through frame N+1. Typical use: results of async jobs.

## In Odin
| Book | Odin |
|---|---|
| Single-frame allocator | `context.temp_allocator` + `free_all(context.temp_allocator)` each frame (done in M1 L4) |
| Stack with markers | `mem.Arena` / temp-arena begin/end |
| LSR data + level on top | a **level arena**: free it on level unload |

## Why it matters for resources
A linear, level-based game loads everything a level needs above the load-and-stay-resident (LSR) marker,
then frees back to that marker on unload (GEA 7.2.2.7, 16.4.1).

Related: [[Pool Allocator]], [[Resource Lifetimes]], [[Ch06 Engine Support Systems]].
