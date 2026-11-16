---
tags: [plan]
---

# North Star and MVP

Back to [[Home]].

## The two goals

**Goal 1: become a programmer who doesn't need AI.** By the end you can sit in front of an empty file and a compiler and build low-level systems, graphics code and tools. You can also look at a problem, lay out several ways to structure the solution, and pick one for reasons you can defend. This goal outranks the other. If a shortcut would get the engine further but teach you less, we don't take it.

**Goal 2: build the Plotweaver CRPG.** An engine, an editor and a game, written in Odin, with the Plotweaver tabletop rules as the game layer. Combat is turn-based, never real-time-with-pause.

## What kind of game

| Aspect | Target | Reference |
|---|---|---|
| Combat | Turn-based, party vs. groups, Plotweaver fast and slow turns | DOS2, BG3, Rogue Trader |
| World | **Large continuous areas** you walk across without loading screens | Larian. Not Owlcat's small discrete maps |
| Systems | Elements react with each other on surfaces and on characters | DOS2, BG3 |
| Space | Real height: cliffs, rooftops, multi-storey interiors, and ways to move between them | BG3 |
| Look | Good lighting and atmosphere: shadows, many lights, fog, time of day | BG3, PoE2 |
| Speed | Performance is a feature. It gets measured from the start | — |

## The MVP

The MVP is done when **one playable slice** exists that shows every item below, and every piece of content in it was made in your own tools. Each item names the stage of the [[Roadmap]] that delivers it.

### Engine

| # | Capability | Done means | Stage |
|---|---|---|---|
| E1 | **Asset loading** | glTF models with materials and textures load through a cache. A missing or broken asset shows a visible placeholder and logs an error. It never crashes the program | 4 |
| E2 | **Animation system** | Skinned characters play, blend and layer clips. A state machine drives them. Clips carry events ("hit lands here") | 5 |
| E3 | **Animation editor** | Preview any clip on any compatible character, scrub a timeline, place events, set up states and transitions, save | 5 |
| E4 | **Level editor** | Place, move, rotate, scale, duplicate and delete objects. Paint walkable and blocked areas. Undo and redo. Save and load | 4, 6 |
| E5 | **Large open areas** | One continuous map of at least 500 m × 500 m with dense props, streamed in pieces, with no loading screen while walking | 6 |
| E6 | **Verticality** | At least three walkable height levels that overlap (a bridge over a road, a building with floors). The camera copes with roofs and upper floors | 6 |
| E7 | **Lighting and atmosphere** | Physically based materials, sun shadows, dozens of local lights, HDR, fog, a sky, time of day | 7 |
| E8 | **Performance** | The slice holds its frame budget in a release build on your machine, and you can show where every millisecond goes. The budget itself is a decision you make in Stage 6 | 6, 9 |

### Game (all rules come from Plotweaver)

| # | Capability | Done means | Stage |
|---|---|---|---|
| G1 | **Party of n** | A party whose size is data, not code. Select one or several members. The rest follow | 3, 8 |
| G2 | **NPCs in the world** | NPCs that stand, wander or follow simple routines, can be talked to, and can join a fight | 3, 8 |
| G3 | **Exploration** | Click to move, interact with objects, skill tests in the world, and Plotweaver *endeavors* (collective successes vs. failures). Characters are animated | 8 |
| G4 | **Traversal** | Jump, fly and teleport between height levels, each with a cost and an animation | 6, 8 |
| G5 | **Combat** | Fast and slow turns, actions and reactions, attacks, conditions, line of effect, area effects. Animations play, and damage lands on the hit frame | 3, 8 |
| G6 | **Encounter design** | An encounter editor: place combatants, set factions and triggers, save, and play it from the editor | 8 |
| G7 | **Elemental interactions** | Surfaces and clouds on the ground, and statuses on characters, that react. The required cases are in the table below | 8 |
| G8 | **Dialogue** | Plotweaver *conversations*: branching lines, skill tests, influence resisted by spending focus. A dialogue editor | 8 |

### Required elemental cases (G7)

| Start | Add | Result |
|---|---|---|
| Poison surface or cloud | Fire | Explosion |
| Oil surface | Fire | Fire surface |
| Wet character | Ice | Frozen |
| Dry character | Ice | Chilled |
| Water surface | Lightning | Electrified water, stuns everyone standing in the connected body |
| Fire surface | Water | Steam cloud |

More reactions are welcome. These six prove the system handles surface-to-surface, surface-to-cloud, and character-status cases, on any height level.

### The acceptance walk-through

One sitting, release build, no restarts:

1. Open the editor. Load the slice map. Fly the camera over it to show its size and height levels.
2. Press play. Walk a party of four across the map with NPCs going about their routines. No loading screens.
3. Jump a gap. Fly or teleport to a rooftop.
4. Pass or fail a skill test to open something. Complete a short endeavor.
5. Talk to an NPC. Win or lose the conversation through focus.
6. Trigger the encounter. Fight it with fast and slow turns, animated attacks, and at least three elemental reactions from the table.
7. Show the frame-time panel during the fight.
8. Stop play. In the editors, change the level, the encounter, a dialogue line and an animation event. Play again and see all four changes.

## Not in the MVP

These are deliberately left out so the MVP stays reachable. They can come after.

- Character creation, levelling, inventory beyond weapons, crafting, resting, injuries beyond the basics
- Quests, journal, a full save system for a long campaign (the MVP saves a level and a mid-fight state, nothing more)
- Audio beyond a few test sounds
- Cinematic dialogue cameras, voice, lip sync
- Multiplayer
- A Vulkan backend
- Physics simulation beyond what movement and traversal need

## How long this takes

Years of part-time work, not months. The engines behind the reference games were built by teams over a decade. A single person can reach this MVP because it is one slice, not a full game, and because every stage ends with something that runs. Each stage in the [[Roadmap]] is worth having finished even if you stopped there.
