---
tags: [concept, input]
source: GEA 9.5
---

# Input action mapping

"Every problem in computer science can be solved with a level of indirection" (Prof. Jay Black, quoted in GEA 9.5.7).

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{B/.style={draw, rounded corners, minimum height=0.8cm, align=center}}
\node[B] (dev) at (0,0) {SDL events\\(scancodes)};
\node[B] (st) at (3.4,0) {engine Input\\state + edges};
\node[B] (map) at (7,0) {binding table\\Action to Key};
\node[B] (act) at (10.4,0) {game actions\\End\_Turn, Pan, ...};
\draw[->, thick] (dev) -- (st);
\draw[->, thick] (st) -- (map);
\draw[->, thick] (map) -- (act);
\node[B] (own) at (7,-1.8) {ownership:\\editor / camera / game};
\draw[->] (own) -- (map);
\end{tikzpicture}
\end{document}
```

## What a HID system usually provides (GEA 9.5.1)
- **Dead zones** for analog sticks.
- **Analog filtering**: a low-pass filter `f = (1−a)·f_prev + a·u`, with `a = Δt / (RC + Δt)`, or a moving average.
- **Edge events** from bitmasks:
  - `changes = cur ^ prev`
  - `downs = changes & cur`
  - `ups = changes & ~cur`
  - Plotweaver's `bit_set` edges already do this.
- **Chords**, with some timing leeway: wait 2–3 frames, act on release, or let the single-button move be pre-empted by the chord.
- **Sequences and gestures**: a history buffer plus a time window (button tapping, A-B-A, stick rotation).
- Multiple devices, handling disconnects, and cross-platform abstract control ids.
- **Remapping**: a table from logical action to physical control, restricted to compatible input classes:
  - buttons: bits
  - one-way axes: [0, 1]
  - two-way axes: [−1, 1]
  - relative axes (mouse, wheel)
- **Context-sensitive controls**: a state machine, plus a priority rule when several objects are in range.
- **Control ownership / logical devices**: the player, the camera and the menu each own a subset of the inputs.
- **Disabling inputs**: better to do it in the *consumer* code than to mask the device. If you do mask, add a fail-safe reset.

## Plotweaver
The game currently reads `Key` values directly. Add a game-side `Action` enum and a binding table:
- rebindable keys;
- ImGui gets ownership while it wants the mouse or keyboard;
- an exploration context and a combat context (the same click means move or attack).

"The HID system forms the underpinnings of your game's most precious resource: its player mechanics" (GEA 9.6).

Related: [[Ch09 Human Interface Devices]].
