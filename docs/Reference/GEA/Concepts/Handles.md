---
tags: [concept, memory, architecture]
source: GEA 6.2.2.2, 16.5
---

# Handles

A **handle** is an index into a table that holds the actual pointers or slots. Code keeps the handle, never
the pointer (GEA 16.5.3).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\node[draw, rounded corners, align=center] (h) at (0,1.5) {Handle\\index = 2\\gen = 5};
\foreach \i/\g/\o in {0/3/obj A,1/1/null,2/5/obj C,3/2/obj D,4/7/null} {
  \draw (2.5,3-\i*0.7) rectangle (4.0,3.6-\i*0.7);
  \node at (3.25,3.3-\i*0.7) {gen \g};
  \draw (4.0,3-\i*0.7) rectangle (5.5,3.6-\i*0.7);
  \node at (4.75,3.3-\i*0.7) {\o};
  \node[left] at (2.5,3.3-\i*0.7) {\i};
}
\node[above] at (4,3.7) {handle table};
\draw[->, thick] (h) -- (2.45,1.9);
\node[draw, rounded corners] (c) at (7.5,1.9) {object C};
\draw[->, thick] (5.55,1.9) -- (c);
\node[align=left, anchor=west] at (0,-1.3) {Deref: if table[index].gen equals handle.gen, return the object, else nil (stale).\\Destroy: increment gen and push index on the free list. Old handles now fail safely.};
\end{tikzpicture}
\end{document}
```

## Why handles beat pointers
- **Raw pointers** can be orphaned, stale or invalid. They also break when memory is moved, for example during defragmentation (GEA 16.5.1).
- **Smart pointers** are hard to get right. Gregory: "stay away from smart pointers; if you must, use a mature implementation" (GEA 16.5.2).
- **Handles**:
  - survive relocation (GEA 6.2.2.2);
  - become null automatically when the object dies;
  - make the table a free list of every live object.

The book detects stale handles by storing a **unique object id** in the handle. Plotweaver uses a
**generation counter** instead. It is the same idea, and smaller.

## Plotweaver
- `Entity :: struct { index: u32, generation: u32 }` (§2.5 of the plan).
- Use the same pattern for mesh, texture, skeleton and animation handles (M3, M11).
- Script and data references should be handles or names, never pointers (GEA 16.9.5.2).

Related: [[Pool Allocator]], [[Object Models]], [[String IDs]].
