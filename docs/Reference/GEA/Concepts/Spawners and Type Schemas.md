---
tags: [concept, data, editor, serialization]
source: GEA 16.3, 15.4
---

# Spawners and type schemas

## Ways to store objects in a world chunk (GEA 16.3)
| Format | Verdict |
|---|---|
| Binary object images | Fast but fragile: pointers, vtables and endianness all need handling. Fine for **stable** data such as meshes and collision, bad for gameplay data that changes constantly |
| Serialization (JSON or XML) | Hand-written `SerializeIn`/`Out` per type, or **reflection-driven generic code**. Needs a **class factory** (type id → constructor), because C++ can't construct a type from its name |
| **Spawners + schemas** | The editor deals only in key-value pairs and schemas. Robust, and decoupled from the runtime code |

## Spawner
A data-only record:
- the object's tool-side **type id**;
- key-value **attributes**, including the transform.

A spawner can spawn its object on load, or wait until something asks it to.
**Locator spawners** just mark positions or frames:
- AI points of interest;
- reference frames for synced animations;
- where an effect or sound originates;
- waypoints.

## Type schema
```
type Light {
    LightType  Type;
    Vector     Pos;
    Quaternion Rot;
    Float      Intensity : min(0.0), max(1.0);
    ColorARGB  DiffuseColor;
}
```
- Every attribute has a type, plus **hints for the editor's widgets** (min/max, enum choices).
- Schemas can inherit (`Motorcycle` overrides `Vehicle.TopSpeed`).

## Defaults that propagate (GEA 16.3.3.2)
**Leave out any key whose value equals the default.** Then when designers change Orc HP from 20 to 30,
every Orc that was placed earlier and never customized picks up the new value automatically.

## Robustness (GEA 16.3.3.3)
- Unknown keys are ignored, and missing keys fall back to defaults.
- Designers can add types before the runtime code exists, and code can exist before any data uses it.

## Plotweaver (M6, M21)
- Odin reflection **is** the schema: field types plus struct tags such as `` `editor:"min=0,max=999"` `` (§2.6).
- A scene file could be a list of entities, each holding components by **registered name**, each with only its **non-default fields**.
- The registered names are also needed for hot reload (D9).
- Prefab or archetype files with per-instance overrides fit the same pattern.
- Remap `Entity` references to file-local ids on save (§M6).

Related: [[Saved Games]], [[Object Models]], [[String IDs]], [[Ch15 Introduction to Gameplay Systems]].
