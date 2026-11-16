---
tags: [chapter, gea, m1]
chapter: 8
pages: 525-558
---

# Ch8: The game loop and real-time simulation

## 8.1–8.2 Render loop and game loop
- **Render loop**: update the camera → update the scene → render to the back buffer → swap.
- The **game loop** services every subsystem, each at its own rate. Pong is the minimal example: read input → move paddles → move ball → collide → score → render.

## 8.3 Architectural styles
- **Windows message pump**: drain all pending OS messages, then run one game iteration. Side effect: dragging the window freezes the game.
- **Callback frameworks**: OGRE's `FrameListener::frameStarted` / `frameEnded`.
- **Event-based updating**: post events into the future to schedule periodic work.

## 8.4 Abstract timelines
Real time, game time and local clip timelines. See [[Abstract Timelines]].

## 8.5 Measuring time
See [[Frame Timing]].
- Frame rate and Δt; explicit Euler `x += v·Δt`.
- **CPU-dependent games** vs measuring Δt; running averages; **frame-rate governing**.
- **Record and playback** needs consistent timing *and* the same random seed, or the replay drifts.
- Tearing and vsync.
- High-resolution timer; clock drift between cores; 64-bit tick clocks; 32-bit deltas; float clocks only for short spans; the 1/300 s integer unit.
- **Breakpoint guard**: clamp very large Δt.

## 8.6 Multiprocessor game loops
See [[Job Systems]].
- Task decomposition: task parallelism vs data parallelism.
- One thread per subsystem doesn't work well.
- **Scatter/gather** with a thread pool.
- **Job systems**: job declarations, counters, why a thread-pool job can't sleep partway through, **coroutines and fibers**, job synchronization (spin locks, a job mutex), the **visualizer** and the **profile trap**.
- Naughty Dog's fiber-based system: one worker per core (affinity), a pre-spawned fiber pool, waiting on counters puts the fiber on a wait list. Christian Gyrling's GDC 2015 talk, *Parallelizing the Naughty Dog Engine*.

## Plotweaver
- M1 L3 already implements measured Δt, vsync and a Δt clamp.
- **Add a game clock** for pause, step and slow-motion.

Prev: [[Ch07 Resources and the File System]] · Next: [[Ch09 Human Interface Devices]]
