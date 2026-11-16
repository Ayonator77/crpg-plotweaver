---
tags: [chapter, gea]
chapter: 17
pages: 1161-1165
aliases: [Ch17 You Mean There's More]
---

# Ch17: You mean there's more?

## Engine systems the book didn't cover
- **Movie player**: streaming I/O, a codec (MPEG-4, H.264, WMV, **Bink**), and sync with audio.
- **Multiplayer networking**: see Armitage et al., *Networking and Online Games*.

## Gameplay systems
- **Player mechanics** are the most important gameplay system. Study one genre at a time, reverse-engineer the mechanics, then try implementing them.
- **Cameras**:
  - look-at;
  - follow (collision avoidance; lags behind the player);
  - first-person;
  - **RTS**: floats above the terrain looking down at an angle, pans, with no direct control of pitch or yaw. Plotweaver's tactical camera is a variant of this;
  - cinematic.
- **AI**, in layers:
  - foundations: **A\***, perception (line of sight, vision cones), memory and knowledge;
  - **character control** (locomotion, terrain, weapons, cover), see [[Action State Machines]];
  - goals and decision making, emotion, group behaviours, learning.
- "Game AI is always more of a smoke-and-mirrors job… if the player cannot perceive the characters' motivations, it's all for naught" (cf. Halo's grunts in [[Conversation System]]).
- Reading suggested by the book: Bungie's GDC 2002 talk *The Illusion of Intelligence*; aigamedev.com, gameai.com.

## For Plotweaver
- Nav, A\*, turn structure and grids (M15–M18) are **not covered by this book**. Use other sources. My suggestions, not from the book: Amit Patel's Red Blob Games pages on A\* and grids, and *Game AI Pro*.

Prev: [[Ch16 Runtime Gameplay Foundations]] · Back: [[GEA Index]]
