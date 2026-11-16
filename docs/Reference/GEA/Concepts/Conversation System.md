---
tags: [concept, gameplay, dialogue, m19]
source: GEA 14.6.2
---

# Conversation system (Naughty Dog, *The Last of Us*)

Speech is how players read AI intent. In Halo, grunts fled when their Elite leader died, but playtesters only understood
why once the grunts *said* so: "Leader dead, run away!" (GEA 14.6.2).

## Lines
- **A logical line id** (a hashed string) maps to a **pool of clips for each character's voice**, e.g. `'line-out-of-ammo`, with clips for Drake, Elena, pirates and so on.
- Split the data by character and by level, for memory and so people don't edit the same files.
- Avoid repeats with a **shuffle bag**: shuffle the indices, cycle through them, and when you reshuffle, make sure the last line played doesn't come first.
- The API is **fire-and-forget**: `npc.PlayDialog(SID("line-player-seen"))`. If speaking is hard to trigger, the characters end up silent.
- Priorities decide which line wins. TLOU simply cuts the current line and plays the new one.

## Conversations are first-class
- Chains of **segments**: each segment is one logical line plus `next-seg`.
- **Priority applies to the whole conversation.** Participants count as busy even while silent, so "Look, a shiny object!" can't interrupt mid-conversation, but "He's pointing a gun at us!" can.
- **Exclusivity** settings:
  - non-exclusive (can overlap other speech);
  - faction-exclusive (silences others in the same faction);
  - global (silences everyone).

## Branching with rules over fact dictionaries

```tikz
\begin{document}
\begin{tikzpicture}[font=\small]
\tikzset{S/.style={draw, rounded corners, minimum width=3.2cm, minimum height=0.8cm, align=center}}
\node[S] (a) at (0,0) {speaker: ``Are you OK?''};
\node[S] (b1) at (-3,-1.8) {rule: shot-recently = false\\``Yeah, I'm fine.''};
\node[S] (b2) at (3,-1.8) {rule: shot-recently = true\\``Not exactly.''};
\node[S] (c1) at (-3,-3.6) {``Keep your head down!''};
\node[S] (c2) at (3,-3.6) {``You're bleeding!''};
\draw[->, thick] (a) -- node[left, font=\footnotesize] {next-speaker = listener} (b1);
\draw[->, thick] (a) -- (b2);
\draw[->, thick] (b1) -- (c1);
\draw[->, thick] (b2) -- (c2);
\end{tikzpicture}
\end{document}
```

- Each segment has **alternatives**. Each alternative has a **rule**: a list of criteria that are ANDed together. An empty rule acts as "else".
- A criterion looks like `('health < 25)` or `(('speaker 'shot-recently) == true)`.
- **Fact dictionaries** hold values of mixed types (variants). There is one per character, one per faction and one global. Lookups search self → faction → global.
- **Speaker and listener are abstract roles.** `:next-speaker 'listener` swaps them, so the same conversation works for any pair of characters. That's essential for enemy banter.
- **Context-sensitive callouts**: regions in the world are tagged with general and specific location names ("in the store", "behind the counter"). The NPC says the specific name if it's in the same general region as the player, otherwise the general one.
- **Dialog actions**: additive gesture animations synced to the line's audio timeline.
- Inspiration: Elan Ruskin (Valve), *Rule Databases for Contextual Dialog and Game Logic*, GDC 2012.

## Plotweaver M19
- Store dialogue in JSON as **segments**: `{id, alternatives: [{rule, line_id, next_seg, next_speaker}]}`.
- Facts come from components (`Stats`, Focus as social HP), faction data, and global quest flags.
- Endeavor thresholds and Plotweaver skill checks (d20 + skill vs DC) can be *rules* that read the result of a roll.
- Text lives in a localized string table keyed by line id ([[String IDs]]).

Related: [[Events and Messaging]], [[Ch14 Audio]].
