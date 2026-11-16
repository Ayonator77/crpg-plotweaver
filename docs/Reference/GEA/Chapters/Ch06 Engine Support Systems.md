---
tags: [chapter, gea, m1, m3]
chapter: 6
pages: 417-479
---

# Ch6: Engine support systems

## 6.1 Subsystem start-up and shut-down
- C++ initializes static objects in an unpredictable order. Construct-on-demand singletons hide their cost and still don't let you control destruction order.
- **Brute force always wins**: explicit `startUp()` and `shutDown()` calls in `main`, with shut-down in reverse order. It's simple, explicit and debuggable: to change the order, "just move one line of code".
- OGRE's `Root` and Naughty Dog's `BigInit()` both do it this way.
- Plotweaver goes one step further: an explicit `^State` per subsystem, and no globals.

## 6.2 Memory management
- `malloc` is slow: it's general-purpose and can involve a switch into the kernel. **"Keep heap allocations to a minimum, and never allocate from the heap within a tight loop."**
- [[Stack Allocator]]: markers, the double-ended stack (Hydro Thunder), single-frame and double-buffered allocators.
- [[Pool Allocator]]: free list stored inside the free blocks.
- **Aligned allocation**: `(addr + align−1) & ~(align−1)`. Allocate `align` extra bytes and store the shift in the byte just before the returned pointer, so free can undo it.
- **Fragmentation**: stack and pool allocators avoid it. Otherwise **defragment** by sliding blocks down to close holes. Moving blocks requires relocating pointers → use [[Handles]] wherever possible (ND). Spread the cost over frames (move N blocks per frame).

## 6.3 Containers
- The usual list: array, dynamic array, linked list, stack, queue, deque, tree, BST, heap, priority queue, dictionary, set, graph, DAG.
- Big-O notation **plus the memory layout**: arrays beat linked lists for cache behaviour.
- Reasons to write your own containers: control, optimization, custom algorithms, no external dependencies, control over concurrency.
- **ND bans STL containers in runtime code** (allowed in tools). Boost, Folly and Loki discussed.
- Dynamic arrays grow to a high-water mark. **Once you know your budgets, preallocate.**
- **Hash tables**:
  - open (chaining) vs **closed** (open addressing; fixed memory; linear or quadratic probing; prime table sizes; Robin Hood hashing);
  - fast hashes: xxHash, MurmurHash3.

## 6.4 Strings
See [[String IDs]].
- `strcmp`/`strcpy` were the top entries in one shipped game's profile.
- String classes have hidden costs. A Path class is justified.
- **String ids**: interning, compile-time hashing, debug-only reverse table.
- **Localization**: Unicode (UTF-8, UTF-16, UTF-32, UCS-2), `char` vs `wchar_t`, a string database keyed by id, *never display raw strings to the player*. ND's localization tool is a web front end over MySQL.

## 6.5 Engine configuration
- Where options come from: INI or JSON files, compressed binary, the Windows registry (not recommended), the command line, environment variables, online profiles.
- Per-user options go in AppData.
- **Quake cvars**: name, value and flags; `CVAR_ARCHIVE` persists the value to `config.cfg`.
- **ND's in-game debug menu** binds menu items to the *addresses* of globals. A saved value overrides the programmer's default. This is what ImGui panels give us.
- **ND's Scheme data definitions**:
  - compiled to binary, with generated C headers;
  - looked up with `LookupSymbol<T>(SID("anim-walk"))`;
  - hot-reloadable as long as the layout doesn't change. Plotweaver's D9 hot reload has the same caveat.

Prev: [[Ch05 3D Math]] · Next: [[Ch07 Resources and the File System]]
