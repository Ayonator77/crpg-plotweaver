---
tags: [concept, data]
source: GEA 6.4.3, 6.4.4, 16.8.3, 16.9.5.2
---

# String IDs

Strings make readable identifiers but slow comparisons. On one shipped game, `strcmp` and `strcpy` were the
**top two functions in the profile** (GEA 6.4.1). The fix is to **hash the string to an integer**.

## How it works
- Hash the string with CRC32. Naughty Dog moved to a 64-bit hash for TLOU2 to avoid collisions.
- Compare the ids like integers.
- **Intern** each string into a global table (id → string) so you can turn ids back into text when debugging.
- Hash at **compile time** where you can. Naughty Dog's `"foo"_sid` literal can be used as a `switch` case label.
- Intern each string once and store the result, rather than calling `intern("foo")` on every call.
- Keep the reverse-lookup table in **debug-only memory**. Production code must never depend on it (`ToDebugString()`).
- Unreal's version is `FName`. Naughty Dog's Scheme symbols `'foo` map to `SID("foo")`.

## Where you meet them in the book
| Use | Section |
|---|---|
| Joint names | GEA 12.2.2 |
| Event types (ND uses string ids, not enums) | GEA 16.8.3 |
| Dialogue line ids | GEA 14.6.2.2 |
| Object names in scripts, with 'self as a magic name | GEA 16.9.5.2 |
| Resource GUIDs | GEA 7.2.2.4 |

> [!warning] Don't serialize enum ordinals
> Enum values are just indices. Inserting a member in the middle renumbers everything after it and
> silently breaks data files (GEA 16.8.3). Store names or hashed ids in JSON.

## Localization
- Use UTF-8 everywhere (ND).
- **Never display a raw string to the player.** Look up a localized string by id (GEA 6.4.4.5).
- Plotweaver M19/M20: dialogue and UI text live in a string table keyed by id.

## Plotweaver
Action, status, surface, element, faction and dialogue-line names in JSON should be hashed ids, with names kept for debugging.
- Odin can hash at compile time with `#hash("name", "fnv32a")`.

Related: [[Events and Messaging]], [[Conversation System]], [[Spawners and Type Schemas]].
