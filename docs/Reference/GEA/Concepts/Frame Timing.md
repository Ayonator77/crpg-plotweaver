---
tags: [concept, time, loop]
source: GEA 8.5, 13.5.2.2
---

# Frame timing

## Ways to choose Δt (GEA 8.5.2)
| Approach | Problem |
|---|---|
| Ignore Δt (speed in units per frame) | "CPU-dependent" games run in fast-forward on faster PCs (the Turbo button) |
| Measured last-frame Δt | It's only an estimate for *this* frame. A spike can start a vicious cycle (e.g., the physics takes two substeps, so the next frame is slow too) |
| Running average over a few frames | Smooths spikes but reacts slowly |
| **Frame-rate governing** (sleep to the target, or vsync) | Consistent Δt. Helps physics, avoids tearing, makes record/playback reliable |

> [!tip] Leave variable-Δt mode on during development. Switch on governing once the game hits its target consistently.

## Vsync
Vsync quantizes the frame time to multiples of the refresh interval (16.6, 33.3, 50 ms). Don't assume 60 Hz: PAL is 50 Hz and your monitor may be 144 Hz.

## Clock representation (GEA 8.5.3–8.5.4)
- Read the 64-bit tick counter (`QueryPerformanceCounter`, i.e. `sdl.GetPerformanceCounter`).
- **Subtract the 64-bit tick values *before* converting to float.**
- A 32-bit float clock in seconds is fine for short deltas, but it loses 1/30 s resolution after about 12 days (GEA 3.3.1.4). Store long-running time as `f64` or ticks. Plotweaver's `f64` total time is correct.
- Some games use an integer unit of 1/300 s, which divides both 50 and 60 Hz evenly. It's good for gameplay timers.
- High-resolution timers on different cores can drift apart (GEA 8.5.3.1).

## Breakpoint guard (GEA 8.5.5)
After you resume from a breakpoint, the measured Δt can be minutes long. If Δt is over about 1 s, set it to the target frame time.
Plotweaver's `Frame_Time` dt clamp already does this.

## Physics and fixed steps (GEA 13.5.2.2)
Integrators, collision and constraint solvers want a **constant Δt**. Step physics at 1/30 or 1/60 s. If the game falls behind,
let the physics *look* slower rather than feeding it a bigger Δt.

Related: [[Abstract Timelines]], [[Ch08 The Game Loop]].
