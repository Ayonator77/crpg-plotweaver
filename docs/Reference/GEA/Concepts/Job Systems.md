---
tags: [concept, concurrency, phase-5]
source: GEA 4.1, 4.8, 8.6, 16.7
---

# Job systems

## Ways to use multiple cores (GEA 8.6)
- **One thread per subsystem**: doesn't work well. Core counts don't match, loads are uneven, and the subsystems depend on each other.
- **Scatter/gather**: split data-parallel work into batches with a per-worker output buffer, then wait for all of them. Use a thread pool, because spawning threads is expensive.
- **Job system**: many small jobs scheduled onto worker threads, about one per core and pinned to it.

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\node[anchor=east] at (-0.1,2.25) {main};
\node[anchor=east] at (-0.1,1.5) {worker 1};
\node[anchor=east] at (-0.1,0.75) {worker 2};
\node[anchor=east] at (-0.1,0) {worker 3};
\draw[fill=gray!15] (0,2) rectangle (2,2.5); \node at (1,2.25) {game sys};
\draw[fill=gray!40] (2,2) rectangle (3.5,2.5); \node at (2.75,2.25) {kick};
\foreach \y in {0,0.75,1.5} { \draw[fill=gray!25] (2.2,\y-0.25) rectangle (5.2,\y+0.25); \node at (3.7,\y) {pose blend batch}; }
\draw[fill=gray!40] (3.5,2) rectangle (5.4,2.5); \node at (4.45,2.25) {other work};
\draw[fill=gray!40] (5.4,2) rectangle (6.4,2.5); \node at (5.9,2.25) {wait};
\draw[fill=gray!15] (6.4,2) rectangle (9,2.5); \node at (7.7,2.25) {skin matrices};
\draw[dashed] (5.4,-0.4) -- (5.4,2.8) node[above] {sync point (counter = 0)};
\end{tikzpicture}
\end{document}
```

## Interface (GEA 8.6.4)
- A job declaration: `{entry(uintptr param), param, priority, counter*}`.
- `KickJob` / `KickJobs` start jobs. `WaitForCounter` waits for a group: kicking increments the counter, finishing decrements it.
- A job running on a plain thread pool can't sleep partway through. Coroutines or **fibers** can; Naughty Dog uses fibers.
- Synchronization: spin locks, plus a job-aware mutex that puts the job to sleep under heavy contention.
- Tools: a **job timeline visualizer**, and a **profile trap** that pauses the game automatically when a frame takes more than 35 ms.

## Design rules (GEA 4.8, 16.7.3)
- Impose a global ordering. A doubly linked list isn't a concurrent data structure.
- Think in transactions. Minimize contention, e.g. a per-thread bucket of results collated afterwards.
- Don't make every interface "thread-safe". Design for concurrency explicitly.
- **Degree of parallelism** = the number of leaves in the job dependency graph. Every dependency is a sync point. **Defer sync points**: "the secret of optimized concurrent design is delay" (Mike Acton).
- Data parallelism (e.g. 1000 skinning matrices split over 4 cores) usually beats task parallelism.

## Plotweaver (Phase 5)
- The explicit schedule in `main.odin` makes data dependencies visible, which is the prerequisite for doing any of this.
- Odin's `core:thread` has a pool.
- First candidates:
  - per-character animation sampling and blending;
  - skin matrices;
  - surface cellular-automaton rows (double-buffered, so they're race-free).

Related: [[Game Object Updates]], [[Ch04 Parallelism and Concurrency]].
