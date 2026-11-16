---
tags: [concept, animation]
source: GEA 12.7, 12.11
---

# Motion extraction, constraints and IK

## Motion extraction (GEA 12.11.4.1)
A walk cycle is authored moving forward, but its origin stays behind. Played as a loop, it would pop back to the start.
1. **Zero the root's forward motion.** On its own, this makes the character moonwalk.
2. **Save that motion into an "extracted motion" channel first.**
3. In-game, apply the extracted motion to the character's origin each frame.

This keeps the authored non-constant speed (a limp, for example) and the planted feet.

The speed is controlled by the playback rate: a 4 ft/s clip at `R = 0.5` moves at 2 ft/s.

## Foot IK (GEA 12.11.4.2)
- Find the intervals where each foot is in contact with the ground.
- While a foot is planted, pin it to its world position with IK.
- It takes a lot of tuning. **For player-controlled characters, how it feels matters more than how it looks.**

## Two-bone IK, analytic (useful for M14; the book only describes IK generally)

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\coordinate (H) at (0,3); \coordinate (K) at (1.6,1.3); \coordinate (F) at (0.4,0);
\draw[very thick] (H) -- node[above right] {$a$ (thigh)} (K) -- node[below right] {$b$ (shin)} (F);
\draw[dashed] (H) -- node[left] {$c = |T - H|$} (F);
\fill (H) circle (2.5pt) node[above] {hip $H$};
\fill (K) circle (2.5pt) node[right] {knee};
\fill (F) circle (2.5pt) node[below] {target $T$};
\node[align=left, anchor=west] at (3.5,1.6) {law of cosines:\\knee angle: $\cos\theta_k = (a^2+b^2-c^2)/(2ab)$\\hip offset: $\cos\theta_h = (a^2+c^2-b^2)/(2ac)$\\clamp $c$ to $[\,|a-b|,\ a+b\,]$};
\end{tikzpicture}
\end{document}
```

General IK is **error minimization** over **configuration space**, which can have one solution, many, or none. It works best when the starting pose is already close (GEA 12.7.2).
- IK runs **after** the local and global poses are computed, **before** the palette (see [[Animation Pipeline]]).
- Most solvers only solve for position. Matching orientation needs extra work.

## Attachments and attach points (GEA 12.11.1)
- Parent–child joint constraint, e.g. a weapon's grip joint onto the hand. The parent is unaffected by the child.
- **Attach points** are extra transforms that the blending and palette stages ignore. They give you offsets without adding real joints. Designers define them, not riggers.

## Interobject registration (GEA 12.11.2)
A **reference locator** is stored in every actor's clip, relative to that actor. At runtime, all the actors are aligned so their locators meet at one world-space transform. That transform comes either from a fixed actor (a door) or from a placed locator.
- CRPG uses: backstabs, grapples, doors, cover entry, paired dialogue gestures.

## Other constraints
- Hand IK fixes two-handed grips that LERP blending breaks.
- Look-at: additive animation often looks best.
- Cover registration and traversal aids, both via reference locators.

## Procedural post-processing (GEA 12.7.1)
Multiply extra quaternions into local poses before the global pass: wheels, steering, foliage sway (sine or Perlin noise), grass pushed aside by characters.

Related: [[Action State Machines]], [[Animation Pipeline]].
