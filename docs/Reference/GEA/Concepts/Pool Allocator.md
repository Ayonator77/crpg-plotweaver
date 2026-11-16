---
tags: [concept, memory]
source: GEA 6.2.1.2, 6.2.2, 16.4.4.2
---

# Pool allocator

A pool preallocates N elements of the **same size**. The free elements form a singly linked list, and
**the "next" links are stored inside the free elements themselves**, so the list costs no extra memory.
Allocation and freeing are both O(1) (GEA 6.2.1.2).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\foreach \i in {0,...,7} { \draw (\i*1.2,0) rectangle (\i*1.2+1.1,0.9); \node[below] at (\i*1.2+0.55,0) {\i}; }
\foreach \i in {0,2,3,6} { \fill[gray!40] (\i*1.2,0) rectangle (\i*1.2+1.1,0.9); \node at (\i*1.2+0.55,0.45) {used}; }
\draw[->, thick] (1.75,0.9) .. controls (2.5,1.9) and (4.6,1.9) .. (5.35,0.9);
\draw[->, thick] (5.35,0.9) .. controls (5.8,1.6) and (6.0,1.6) .. (6.55,0.9);
\draw[->, thick] (6.55,0.9) .. controls (7.4,1.9) and (8.3,1.9) .. (8.95,0.9);
\node[draw, rounded corners] (h) at (-1.2,1.8) {free head};
\draw[->, thick] (h) .. controls (0,2.2) and (1.2,1.8) .. (1.75,0.95);
\node at (9.2,1.4) {null};
\end{tikzpicture}
\end{document}
```

- If an element is smaller than a pointer, store **u16 indices** instead of pointers (limit 65,536 elements).
- Fragmentation exists, but it can never cause an allocation to fail, because every slot is the same size (GEA 6.2.2.1).

## Small memory allocator (GEA 16.4.4.2)
Keep a set of pools with element sizes 8, 16, 32, … 512 bytes, plus the general heap for anything bigger.
- Each request uses the smallest pool whose elements fit.
- You trade a little wasted space for **no fragmentation** and very fast small allocations.

## Plotweaver
- The plan's `Pool($T)` with `items`, `generations` and `free_list` is a pool allocator plus a handle table. See [[Handles]].
- ECS component pools are dense arrays (sparse sets), not pools. Removal is a swap-remove, so there are no holes.

Related: [[Stack Allocator]], [[Handles]].
