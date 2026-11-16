---
tags: [chapter, gea, phase-5, m19]
chapter: 14
pages: 911-1011
---

# Ch14: Audio

*Skimmed: 14.1–14.4 (the physics of sound, signal processing (linear time-invariant systems, convolution, Fourier), analog and digital audio technology, 3D audio rendering: distance attenuation, panning, propagation, reverb, Doppler). Read: 14.5–14.6.*

## 14.5 Audio engine architecture
- The model is a **mixing console**: many inputs, filters and effects, a mix, outputs to speakers.
- **Per-voice pipeline**:
  1. codec (decodes to PCM);
  2. gain;
  3. **pre-send filter** (affects the sound at its source, e.g. a gas mask);
  4. **aux send**, which splits the signal into a dry path and a wet path that goes to reverb;
  5. **post-send filter** on the dry path only (occlusion muffling, absorption by air);
  6. **pan pots** (the wet signal is panned more widely);
  7. master mixer.
- **Master output bus**: pre-amp, low-frequency (subwoofer) generator, EQ, **compressor**, master gain.
- 2D sounds (music, UI) skip panning and join just before the mixer.
- Digital buses use **ring buffers**. Smaller buffers mean lower latency but more CPU. A game can tolerate about 16 ms, or about 48 ms with triple buffering.
- **Assets**:
  - **clip**: one sound with its own timeline;
  - **sound cue**: clips plus metadata (random or sequential selection, looping, an interrupt "tail" sound, 2D or 3D, falloff, group). **Cues are the game-facing API**;
  - playing a cue returns a **sound handle**, an index into a table, so it becomes null automatically when the sound ends ([[Handles]]);
  - **banks**: some resident, some per level (TLOU's rain and creaking sounds only in one building); can be relocatable;
  - streaming through ring buffers.
- **Mixing your game** (the mix is what separates good from great):
  - **groups** with their own gain (music, SFX, weapons, speech);
  - **ducking** (lower one group while another plays, e.g. via side-chain compression);
  - bus presets and mix snapshots;
  - **instance limiting** per group;
  - **virtual voices and voice stealing**, by radius, priority and minimum play time;
  - cinematics may break physical realism on purpose.
- Engines: Windows UAA/WASAPI, XAudio2, Sony's Scream and BoomRangBuss (ND adds stochastic occlusion and portal-based audio), ALSA, OpenAL, FMOD, Miles, **Wwise**, Unreal.

## 14.6 Game-specific audio features
- Split-screen, physics-driven sounds, dynamic music, dialogue, synthesis (instruments, physically based sound, vehicle engines, speech), crowd sound.
- **Character dialogue**: see [[Conversation System]]. This is the most important part of the chapter for Plotweaver.
- **Music**: streamed playlists per tension level (calm → tense → combat), **stingers**, transitions that respect tempo and beat, ducking, pausing.

## Plotweaver
- `vendor:miniaudio` in Phase 5.
- Design the game API around **cues, groups and handles** from the start.

Prev: [[Ch13 Collision and Rigid Body Dynamics]] · Next: [[Ch15 Introduction to Gameplay Systems]]
