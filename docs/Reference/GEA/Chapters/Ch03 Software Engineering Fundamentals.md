---
tags: [chapter, gea]
chapter: 3
pages: 105-201
---

# Ch3: Fundamentals of software engineering for games

*Skimmed: 3.4 (CPU and assembly basics).*

## 3.1 C++ review and best practices
- OOP: classes, encapsulation, inheritance, the multiple-inheritance diamond, mix-ins, polymorphism.
- **Composition (has-a) over overusing is-a.** A Window *has* a Rectangle.
- Design patterns: singleton, iterator, abstract factory, and **RAII "janitors"**. ND uses a janitor to push and pop allocators. Odin's `defer` does the same job.
- Naughty Dog adopts new language features **conservatively**:
  - `auto` only where it clearly helps;
  - **no template metaprogramming in runtime code**, because "any programmer should be able to jump in and debug a problem on short notice".
- **Coding standards** (Gregory's priorities):
  - interfaces are king;
  - good names;
  - don't clutter the global namespace;
  - be consistent;
  - **make errors stick out** (Spolsky).

## 3.2 Errors
See [[Error Handling Policy]].
- The policy depends on who caused the error: player, developer/asset, or programmer.
- Exceptions are disabled at ND, EA, Midway and Insomniac.
- Two levels of assert. Never use asserts for user errors, and never make them skippable.
- Static asserts. The `if/else` trick that makes a macro safe to use inside other `if` statements.

## 3.3 Data, code and memory layout
- Number bases; two's complement; fixed point.
- **IEEE-754 floats**: `v = s · 2^(e−127) · (1+m)`.
  - Precision and magnitude trade off against each other.
  - Subnormal numbers fill the gap around zero.
  - Machine epsilon is 2⁻²³. A ULP (unit in the last place) scales with the exponent.
  - A float clock in seconds can't add 1/30 s any more after **about 12 days**.
- Sized types (`U32`, `F32`; `<cstdint>`). Odin has these built in.
- **Endianness**: tools byte-swap data to the target's order. Swap each field separately; use a union for floats (punning through pointers breaks strict aliasing).
- KiB vs kB.
- Declaration vs definition; linkage; inline functions in headers.
- Executable layout: **text / data / BSS / rodata**; stack frames (never return a pointer to a local); the heap.
- **Alignment and padding**:
  - every type has a natural alignment;
  - order struct members from largest to smallest;
  - add explicit `_pad` fields so the padding is visible;
  - a struct's alignment is the largest alignment of its members;
  - SIMD vectors need 16-byte alignment.
- C++ class layout: base-class members come first; a vtable pointer is added if there are virtual functions.

## 3.5 Memory architectures
- Memory-mapped I/O, VRAM, **virtual memory** (pages, MMU, page table, TLB, page faults).
- **The memory gap**: about 1–10 cycles for a register vs **about 500 cycles for main RAM** on an i7.
- **Caches**:
  - lines (spatial and temporal locality); direct-mapped vs set-associative; replacement policies;
  - L1/L2/L3; separate **I-cache and D-cache**; write-through vs write-back;
  - coherency protocols (MESI and its variants).
- **Avoiding D-cache misses**: keep data contiguous and small, and access it sequentially.
- **Avoiding I-cache misses**: keep hot loops small, avoid calls inside inner loops, inline judiciously.
- NUMA: the PS3's SPU local stores, the PS2 scratchpad.

## Plotweaver
- Data-oriented design (packed component pools, parents before children in arrays, `#soa` for surfaces) follows directly from 3.5.
- Use `#assert(size_of(T) == N)` for GPU-facing structs (std140) and for `Surface_Cell`.

Prev: [[Ch02 Tools of the Trade]] · Next: [[Ch04 Parallelism and Concurrency]]
