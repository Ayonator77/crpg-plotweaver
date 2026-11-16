---
tags: [concept, animation, time, decision]
source: GEA 12.4.3, 12.10.1.1–12.10.1.2
---

# Animation clocks: local vs global

The engine has to track the time index of every clip that's playing. There are two ways to do it (GEA 12.4.3).

| | Local clock | Global clock |
|---|---|---|
| Stored per clip | `t` (or phase), advanced by `dt·R` each frame | `τ_start` and `R`. `t` is derived from the character's or game's clock |
| Simplicity | simplest | slightly more math |
| Sync between clips started by different systems | **depends on update order**: off by a frame | trivial: give them the same `τ_start` |
| Used by | OGRE (`AnimationState.mTimePos`, which has *no* playback rate) | **Granny** ("where Granny really shines is in its handling of time") |

## The problem with local clocks
The player's punch is started by the player code, and the NPC's hit reaction by the AI code. If the AI updates first,
the reaction starts a frame late. A message system can add another frame.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\draw[->] (0,0) -- (9,0) node[right] {frames};
\draw (3,0.1) -- (3,-0.1) node[below] {N};
\draw (6,0.1) -- (6,-0.1) node[below] {N+1};
\node[anchor=east] at (-0.1,1.2) {local:};
\draw[fill=gray!30] (3,1.0) rectangle (8.5,1.4); \node at (5.75,1.2) {player punch};
\draw[fill=gray!10] (6,0.5) rectangle (8.5,0.9); \node at (7.25,0.7) {NPC reaction};
\node[anchor=east] at (-0.1,2.6) {global:};
\draw[fill=gray!30] (3,2.8) rectangle (8.5,3.2); \node at (5.75,3.0) {player punch, $\tau_{start}$};
\draw[fill=gray!10] (3,2.3) rectangle (8.5,2.7); \node at (5.75,2.5) {NPC reaction, same $\tau_{start}$};
\draw[dashed] (3,0.3) -- (3,3.4);
\end{tikzpicture}
\end{document}
```

With a global clock, the AI code can start the reaction a frame later but give it the **punch's start time**,
so the two clips stay locked together with no drift.

## Plotweaver (D13 / M12)
The plan's `Control` stores `clock: f32`, which is a local clock. Combat sync matters a lot in a turn-based game: attack, hit reaction, and the damage number on the hit frame.
- Consider storing `start_time`, `speed` and `loop_count` in each control.
- Derive `t` from a per-character clock (or the game clock, see [[Abstract Timelines]]).
- Pausing a character then means pausing its clock.

**Decision to make before M12.**

Related: [[Animation Blending]], [[Action State Machines]], [[Events and Messaging]].
