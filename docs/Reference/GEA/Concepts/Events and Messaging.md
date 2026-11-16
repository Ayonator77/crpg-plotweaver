---
tags: [concept, architecture, gameplay]
source: GEA 16.8
---

# Events and messaging

## Why not virtual handlers?
With a virtual `OnExplosion()` per event type, the base class has to declare **every event in the game**. Every object then knows about every event, and new events can't be defined in data (GEA 16.8.1).

**Encapsulate the event as data** instead. This is the Command pattern: `{type, args}` (GEA 16.8.2). Benefits:
- one handler function;
- **persistence**: an event can be queued, copied or broadcast;
- **blind forwarding**: a vehicle can pass a `Dismount` event to its passengers without understanding it.

## Types and arguments (GEA 16.8.3–16.8.6)
- **Event type as an enum**: fast. But the list is centralized and **order-dependent**, so don't store the ordinal in data files.
- **Event type as a string id**: flexible (Naughty Dog uses these). Risk of typos and name conflicts, which a tool-side database can catch.
- **Arguments**:
  - a struct per event type;
  - a fixed array of variants;
  - **key-value pairs** (order-independent, optional arguments).
- A single `OnEvent` with a `switch` is fine. MFC's message maps are "probably not worth the hassle".

> [!tip] Odin
> A tagged union, `Event :: union { Explosion, Hit, Turn_Started, Anim_Event }`, gives you typed arguments with no variants and no casts.

## Routing (GEA 16.8.7–16.8.8)
- **Chain of responsibility** through relationship graphs (attachments, components, teams). A handler returns "handled" to stop the forwarding.
- **Multicast** to everything within a radius by using a world query.
- **Registering interest** (lists or a bitmask per event type) avoids calling uninterested handlers.

## Queue or not (GEA 16.8.9–16.8.10)

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\foreach \i/\d/\n in {0/0.98/Hit,1/1.00/Turn\_End,2/1.00/Status\_Tick,3/1.50/Fuse,4/6.00/Surface\_Decay} {
  \draw (\i*2.1,0) rectangle (\i*2.1+2,1);
  \node at (\i*2.1+1,0.7) {\n};
  \node at (\i*2.1+1,0.3) {t = \d};
}
\draw[very thick] (6.25,-0.4) -- (6.25,1.4) node[above] {now = 1.00};
\node[anchor=west] at (0,-0.8) {dispatch from the front while delivery time is at or before now; same time: higher priority first};
\end{tikzpicture}
\end{document}
```

| | Queued | Immediate |
|---|---|---|
| Control over **when** it's handled | ✓ at chosen points in the loop | ✗ handlers run in the middle of anything |
| Post into the future (timers, periodic tasks) | ✓ sort by delivery time, then by priority | ✗ |
| Cost | deep-copy the arguments (pool or small allocator) | arguments can live on the stack |
| Debugging | no call stack to the sender (keep a trail) | easy |
| Hazards | placing dispatch points to avoid one-frame delays | deep call stacks; **every handler must be re-entrant**; infinite send loops |

**Ordering example**: advance animation clocks (may send `EndOfAnimation`) → dispatch events (a handler starts the next clip) → blend. No gap between the two clips.

## Data-driven events (GEA 16.8.11)
In increasing order of power:
1. Per-object response dropdowns in the editor.
2. Scripts (Naughty Dog).
3. Flowchart GUIs (UE4 Blueprints).
4. **Data pathways**: typed input and output ports wired together in the editor. Example: an EMP gun's `Fire` output wired to animals' `Scare`, to foliage's `Sway`, and through an invert node to radios' `TurnOn`.

GUI systems are friendlier. Text is simpler, searchable and less buggy.

## Plotweaver
- Per-frame event arrays (in the frame allocator), written by producer systems and read by consumer systems at fixed points in the schedule. That's a queue without deep copies.
- A **future-dated event queue in game time** for combat:
  - turn start and end;
  - status effects ticking each round;
  - surfaces decaying per round or per 6 s.
- `Element_Event` (M18) and animation hit-frame events (M14) are both event types.

Related: [[Game Object Updates]], [[String IDs]], [[Animation Pipeline]].
