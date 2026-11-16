---
tags: [chapter, gea, phase-5]
chapter: 4
pages: 203-358
---

# Ch4: Parallelism and concurrent programming

*Skimmed: 4.2–4.7 and 4.9–4.11. Read: 4.1 and 4.8. Relevant from Phase 5 on.*

## 4.1 Definitions
- **Concurrency** means several flows of control reading and writing **shared data**. Independent flows working on separate data aren't concurrent in this sense.
- The central problem is the **data race**.
- **Parallelism** means hardware running more than one thing at the same time:
  - **implicit** (instruction-level): pipelining, superscalar, VLIW;
  - **explicit**: hyperthreading, multicore, multiprocessor, clusters, cloud.
- **Task parallelism** (animation on one core, collision on another) vs **data parallelism** (1000 skinning matrices split over 4 cores).
- **Flynn's taxonomy**: SISD, MIMD, SIMD, MISD. GPUs are **SIMT**.
- Concurrency and parallelism are orthogonal: concurrent code can run on one core, and parallel hardware also speeds up serial code.

## Rest of the chapter (skimmed; listed by section title)
- 4.2 Implicit parallelism (pipelined, superscalar and VLIW CPUs)
- 4.3 Explicit parallelism
- 4.4 Operating system fundamentals (threads; fibers and coroutines, which 8.6 builds on)
- 4.5 Introduction to concurrent programming
- 4.6 Thread synchronization primitives
- 4.7 Problems with lock-based concurrency
- 4.9 Lock-free concurrency (includes MESI coherency, 4.9.4.2)
- 4.10 SIMD/vector processing
- 4.11 GPGPU programming. What I saw: SIMD units time-slice between *wavefronts* and keep a large register file so switching costs nothing.

## 4.8 Rules of thumb
- **Global ordering rules.** A doubly linked list can't be shared between threads, because program order no longer equals data order.
- **Transactions**: an operation gets all its resources or none of them (the central-waiter solution to the dining philosophers).
- **Minimize contention**: give each thread its own repository, then collate.
- **Don't wrap everything in thread-safe interfaces.** Acknowledge the concurrency and design for it explicitly. Prefer fewer locks.

See [[Job Systems]], [[Game Object Updates]].

Prev: [[Ch03 Software Engineering Fundamentals]] · Next: [[Ch05 3D Math]]
