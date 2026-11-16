---
tags: [concept, time]
source: GEA 8.4, 10.5, 12.4.1–12.4.2
---

# Abstract timelines

A **timeline** is a one-dimensional time axis with its own origin and rate. The engine can run several at once (GEA 8.4):
- **Real time**: the CPU's high-resolution counter.
- **Game time**: can be paused, slowed down, sped up or single-stepped.
- **Local clip time**: each animation or audio clip has its own `t`, which runs from 0 to T.

Playing a clip means **mapping its local timeline onto a global timeline** with a start time `τ_start` and a rate `R`:

```tikz
\begin{document}
\begin{tikzpicture}[font=\small, x=0.9cm]
\draw[->, thick] (0,0) -- (12,0) node[right] {$\tau$ (global)};
\foreach \k in {100,102,...,110} { \draw (\k-99,0.1) -- (\k-99,-0.1) node[below] {\k}; }
\draw[fill=gray!20] (3,0.5) rectangle (8,1.1); \node at (5.5,0.8) {clip A, $R = 1$};
\draw[->] (3,1.25) -- (8,1.25); \node[above] at (3,1.25) {$t=0$}; \node[above] at (8,1.25) {$t=5$};
\draw[fill=gray!35] (3,1.9) rectangle (5.5,2.5); \node at (4.25,2.2) {$R = 2$};
\draw[fill=gray!10] (3,3.0) rectangle (8,3.6); \node at (5.5,3.3) {$R = -1$ (reverse)};
\draw[->] (8,3.75) -- (3,3.75);
\node[anchor=west, align=left] at (0,-1.3) {$t = (\tau - \tau_{start})\,R$, then clamp to $[0,T]$ (one-shot), mod $T$ (loop), or clamp to $[0,NT]$ then mod $T$ ($N$ loops)};
\end{tikzpicture}
\end{document}
```

## Why it matters
- **Pause, slow-motion, single-step.** Stop or scale the **game** clock while rendering and the debug fly camera keep running on real time (GEA 10.5).
  - Single-stepping the game clock by 1/30 s is *not* the same as stepping through the main loop in a debugger. Both are useful.
- **Normalized time (phase)**: `u = t/T` ∈ [0, 1]. Use it to keep clips of different lengths in sync, e.g. a run cycle with a walk cycle (GEA 12.4.1.5). This is the plan's M13 "phase sync".
- **Frames vs samples**: a 1 s clip at 30 fps is 30 frames long and has **31 samples**. A looping clip drops the last sample because it repeats the first (GEA 12.4.1.3–12.4.1.4).
- Animation time is **continuous**: always a float (or a fine-grained integer), never a whole-frame index.

## Plotweaver
Add a `Game_Clock` next to `Frame_Time`:
- `scale`: 0 means paused, 0.25 means slow-motion;
- `step_requested`.

Systems receive game dt. The editor, camera and ImGui use real dt. This is the cheapest debugging tool you'll ever build for combat.

Related: [[Animation Clocks]], [[Frame Timing]], [[Ch08 The Game Loop]].
