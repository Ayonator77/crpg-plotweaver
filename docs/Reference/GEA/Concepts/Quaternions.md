---
tags: [concept, math, animation]
source: GEA 5.4, 5.5
---

# Quaternions

A unit quaternion `q = [a·sin(θ/2), cos(θ/2)]` represents a rotation by θ about the unit axis `a`.
- The book writes it as **xyzw**. Many papers use **wxyz**, so check before copying a formula.
- Odin's `quaternion128` has real part `w`.

## Operations
- **Composition:** `pq` means rotation Q first, then P. To apply q1, then q2, then q3, use `q_net = q3 q2 q1`.
- **Inverse:** for a unit quaternion, the inverse is the conjugate: `[−v, s]`. This is cheaper than inverting a matrix.
- **Rotating a vector:** `v' = q v q*`, with v written as the quaternion `[v, 0]`.
- **To and from a 3×3 matrix:** GEA 5.4.4 gives both conversions (written for row vectors).

## Interpolation: LERP vs SLERP

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[gray] (0,0) circle (3);
\coordinate (A) at (-2.6,1.5);
\coordinate (B) at (2.6,1.5);
\draw[thick] (A) -- (B);
\draw[very thick] (-2.6,1.5) arc (150:30:3);
\fill (A) circle (2pt) node[left] {$q_A$};
\fill (B) circle (2pt) node[right] {$q_B$};
\fill (-0.52,1.5) circle (2pt) node[below] {LERP 0.4 (chord, needs renormalize)};
\fill (-0.62,2.94) circle (2pt) node[above] {SLERP 0.4 (on arc)};
\draw[->] (-0.52,1.55) -- (-0.6,2.85);
\end{tikzpicture}
\end{document}
```

- **LERP**: `normalize((1−β) qA + β qB)`. The angular speed is not constant (slower at the ends).
- **SLERP**: weights `sin((1−β)θ)/sin θ` and `sin(βθ)/sin θ`, with `cos θ = qA·qB`. Constant angular speed.
- Jonathan Blow: "understand SLERP, then don't use it". Naughty Dog measured 20 vs 16 cycles per joint. **Profile first** (GEA 5.4.5.2).

> [!important] Hemisphere check (not in the book's blend equations)
> `q` and `−q` are the same rotation. If `dot(qA, qB) < 0`, negate one of them before interpolating or
> accumulating, or the joint spins the long way round. The plan's M12/M13 pseudocode already does this.

## Comparing rotation representations (GEA 5.5)
| Representation | Floats | Notes |
|---|---|---|
| Euler angles | 3 | Gimbal lock; depends on rotation order; depends on how axes map to F/U/L |
| 3×3 matrix | 9 | No gimbal lock; hard to interpolate |
| Axis + angle | 4 | Intuitive; must convert before applying or interpolating |
| Quaternion | 4 | Concatenates, rotates vectors, interpolates |
| **SRT / SQT** | 8–10 | Scale + quaternion + translation. Used for joint poses and `Local_Transform` |
| Dual quaternion | 8 | Rigid blending (Kavan) |

Degrees of freedom = parameters − constraints. Every rotation representation comes out at 3.

Related: [[Animation Blending]], [[Row vs Column Vectors]], [[Ch05 3D Math]].
