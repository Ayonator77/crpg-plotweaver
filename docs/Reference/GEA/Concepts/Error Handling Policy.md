---
tags: [concept, engineering]
source: GEA 3.2, 10.1.5, 10.9
---

# Error handling policy

## Three kinds of error (GEA 3.2.1–3.2.2)
| Who caused it | Policy |
|---|---|
| **Player** (e.g., reloading with no ammo) | Handle inside the game: a sound or animation, never leave the game |
| **Developer / asset** (wrong skeleton, missing mesh) | **Make it obvious, keep working.** Example: draw a big red box with "Mesh X failed to load". One person's bad asset shouldn't stop the whole team |
| **Programmer** (a bug) | Assert and halt, with detailed information |

## Assertions (GEA 3.2.3.3)
- They are land mines for bugs: they check assumptions at the moment those assumptions are broken.
- Use two levels: `ASSERT` stays in dev builds, `SLOW_ASSERT` is debug-only.
- **Never use an assert for user errors.** **Never make asserts skippable**, or they lose their meaning ("the boy who cried wolf").
- Use static asserts for struct sizes. In Odin: `#assert(size_of(T) == N)`.

## Exceptions
Naughty Dog, EA, Midway and Insomniac turn exceptions off. The reasons:
- hidden control flow ("worse than goto");
- every function must stay valid when unwinding;
- code size and I-cache cost.

Odin has no exceptions. It uses multiple return values with `or_return`, which matches the book's preference.

## Fallback visuals for missing assets (GEA 10.9)
- A missing model shows bright red 3D text.
- A missing texture shows an ugly pink (magenta) texture.
- A missing animation shows a special (possibly funny) pose with the asset name above the head.

## Crash reports (GEA 10.1.5)
Include:
- the level;
- the player position;
- the animation or action state;
- running scripts;
- a stack trace;
- allocator state (free memory, fragmentation);
- a screenshot.

## Plotweaver
- The shader and texture loaders should fall back to a magenta default and log a warning, rather than returning failure up to `main`.
- Keep `log.panic` and asserts for programmer errors only.

Related: [[Debug Draw]], [[Ch03 Software Engineering Fundamentals]].
