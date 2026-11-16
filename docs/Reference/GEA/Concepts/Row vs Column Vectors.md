---
tags: [concept, math, warning]
source: GEA 5.3.2, 5.3.10.4, 5.3.12
---

# Row vs column vectors

> [!warning]
> GEA uses **row vectors** throughout. Plotweaver (D3) uses **column vectors**, the same as OpenGL, glTF and
> Odin's `matrix` type. **Transpose every matrix you take from the book**, and reverse every product.

The choice is arbitrary, but it fixes the multiplication order. **The matrix closest to the vector is applied first.**

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\node[anchor=west] at (0,1.6) {Row vectors (book):};
\node[anchor=west] at (4.2,1.6) {$v' = v\,M_1\,M_2\,M_3$};
\draw[->, thick] (4.9,1.2) -- (7.3,1.2) node[right] {read left to right};
\node[anchor=west] at (0,0) {Column vectors (Plotweaver):};
\node[anchor=west] at (4.2,0) {$v' = M_3\,M_2\,M_1\,v$};
\draw[->, thick] (6.6,-0.4) -- (4.3,-0.4) node[left] {read right to left};
\end{tikzpicture}
\end{document}
```

## What changes when you transpose
| Thing | Book (row) | Plotweaver (column) |
|---|---|---|
| Point transform | `v' = v M` | `v' = M v` |
| Translation | bottom **row** `[tx ty tz 1]` | last **column** |
| Child basis vectors `i, j, k` in a change-of-basis matrix | rows | columns |
| Model-to-view | `M_model * M_view` | `V * M` |
| Skinning matrix | `K = B⁻¹ C` | `K = C B⁻¹` |
| Additive difference pose | `D = S R⁻¹`, `A = D T` | `D = R⁻¹ S`, `A = T D` (check: T = R gives back S) |
| Transpose identity | `(ABC)ᵀ = CᵀBᵀAᵀ` | same |

Rules that hold under both conventions:
- `(ABC)⁻¹ = C⁻¹B⁻¹A⁻¹`
- The inverse of a pure rotation is its transpose.
- Normals transform by the **inverse transpose** (GEA 5.3.11).

## Checking memory layout
GEA 5.3.12: build a translation matrix with `(4, 3, 2)` and look at where the 4, 3 and 2 end up in memory.
- Odin's `matrix[4,4]f32` indexes as `m[row, col]` and stores data **column-major**.
- So `&m[0,0]` can be passed to `UniformMatrix4fv(..., transpose = false)`.

Related: [[Coordinate Spaces]], [[Quaternions]], [[Ch05 3D Math]].
