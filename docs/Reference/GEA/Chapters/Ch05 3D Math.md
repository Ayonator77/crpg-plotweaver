---
tags: [chapter, gea, m2]
chapter: 5
pages: 359-414
---

# Ch5: 3D math for games

> [!warning] The book uses row vectors. See [[Row vs Column Vectors]] before you copy any matrix.

## 5.1–5.2 Points and vectors
- Solve 3D problems in 2D first.
- **Choose the coordinate system that fits the problem.** Crank the Weasel's loot spirals in *cylindrical* coordinates.
- **Handedness** only affects how we visualize; the math doesn't change (except cross products, which are pseudovectors).
- Graphics usually uses a left-handed view space (+z into the screen). OpenGL's view space is right-handed, looking down −z.
- Points vs directions; Cartesian basis vectors.
- **Operations**:
  - scale; Hadamard product (non-uniform scale); add and subtract;
  - magnitude: **use the squared magnitude when you can**;
  - normalize.
- **Dot product**:
  - projection;
  - tests: collinear, perpendicular, same or opposite side;
  - is the enemy in front or behind: `(E−P)·f`;
  - height above a plane: `h = (P−Q)·n`.
- **Cross product**:
  - a perpendicular vector;
  - triangle area;
  - **build a basis**: `i = normalize(up × fwd)`, then `j = fwd × i`;
  - triangle normals;
  - torque `r × F`.
- **LERP** is a weighted average whose weights sum to 1.

## 5.3 Matrices
- Affine `[U t; 0 1]`. Multiplication is concatenation and isn't commutative.
- Identity; inverse (`(ABC)⁻¹ = C⁻¹B⁻¹A⁻¹`); transpose (a rotation's inverse is its transpose).
- **Homogeneous coordinates**: points have w = 1, directions w = 0.
- Atomic transforms: translation, rotation about x, y, z (the y-axis rotation matrix looks transposed relative to the other two), and scale. **Uniform scale commutes with rotation**, which is why many engines allow only uniform scale.
- 4×3 matrices save memory.
- **Coordinate spaces and change of basis**: see [[Coordinate Spaces]]. You can extract the facing vector straight from a matrix.
- Moving points vs moving axes are inverse views of the same thing.
- **Normals transform by the inverse transpose.**
- Memory layout check: build a translation of (4, 3, 2) and see where the numbers land.

## 5.4–5.5 Quaternions and comparing rotation representations
See [[Quaternions]]: composition order, conjugate = inverse, `qvq*`, conversion to and from matrices, LERP vs SLERP, Euler/matrix/axis-angle/quaternion/SRT/dual quaternions, degrees of freedom.

## 5.6 Other objects
- Lines, rays and segments: `P0 + tL` with t ∈ [0, 1].
- Spheres (pack into a vec4); planes `(n, d)` in a vec4, transformed by the inverse transpose.
- AABB (fast early-out); OBB; **frustum** (6 planes; transform into clip space and it becomes an AABB test); convex regions (trigger volumes, Quake brushes).

## 5.7 Random numbers
- Linear congruential generators are poor quality.
- Better: Mersenne Twister (and SFMT), Marsaglia's Mother-of-All, Xorshift, KISS99, **PCG**.
- **The same seed gives the same sequence.**
- Plotweaver: dice should come from a seeded, deterministic RNG *resource*. That makes replays and tests reproducible.

Prev: [[Ch04 Parallelism and Concurrency]] · Next: [[Ch06 Engine Support Systems]]
