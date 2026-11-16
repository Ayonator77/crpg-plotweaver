---
tags: [reference, assets]
---

# Assets

Back to [[Home]]. These are the temporary assets you chose. They stand in until the game has its own art.

| Asset | Used for | Notes for the engine |
|---|---|---|
| **Universal Base Characters** (Quaternius) | Party members and humanoid NPCs | The reference skeleton. Every humanoid animation ends up playing on this rig |
| **Universal Animation Library 2** (Quaternius) | Idle, walk, run, attack, hit, death clips | Made for the Universal Base Characters rig. Check that on import, don't assume it |
| **Mixamo** (Adobe) | Extra animations | Arrives as FBX with `mixamorig:` bone names. Convert to glb in Blender. A different skeleton, so it needs retargeting (Lesson 5.12). Choose "In Place" or root motion on purpose |
| **Bestiary – Dungeon Monsters Kit** | Enemies | Likely one skeleton per monster. The animation system must handle many skeletons |
| **Medieval Village MEGAKIT** (Quaternius) | The slice map: buildings, props | Modular pieces that repeat. This is the instancing and grid-snapping test |
| **Modular Sci-Fi Megakit** (Quaternius) | A second look | Proves the engine isn't tied to one setting |
| **ambientCG** | Material textures | Use **NormalGL** maps, not NormalDX. The Color map is sRGB. Every other map is linear |

## Pipeline

```
source asset  →  Blender (only if not already glTF)  →  .glb in assets/models/  →  engine import  →  cached runtime asset
```

glTF 2.0 binary (`.glb`) is the only format the engine reads (decision S6 in [[Decisions]]).

## Before trusting any pack

Do this once per pack, in Stage 4, with your hex dump tool and Blender:

- Which formats does it ship in, and what does its licence allow?
- Units and up axis. The engine is metres, Y up.
- For characters: the bone hierarchy, bone names, and the bind pose.
- For animations: which skeleton each clip targets, and whether clips move the root.
- For materials: which texture maps are present and how they're packed.

Two packs having matching bone names doesn't make them compatible. Open them and look.

## Where files go

```
assets/
  shaders/      GLSL, loaded at run time
  models/       .glb
  textures/     material maps
  data/         game data (actions, conditions, encounters, dialogue)
```

Large binary assets shouldn't go into git as ordinary files. Decide how to handle them (git LFS, or a download script) when the first pack goes in.
