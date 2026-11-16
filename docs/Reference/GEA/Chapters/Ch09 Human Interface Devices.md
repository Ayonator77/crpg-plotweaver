---
tags: [chapter, gea, m1]
chapter: 9
pages: 559-587
---

# Ch9: Human interface devices (HID)

## 9.1–9.4 Devices, interfaces, inputs, outputs
*Skimmed; listed by section title.*
- 9.1 Device types: joypads (Xbox 360, PS3, DualShock 4), the Wiimote, the Wii U controller, arcade sticks and buttons, specialized devices (guitars, wheels, dance pads).
- 9.2 Interfacing with a HID
- 9.3 Types of inputs
- 9.4 Types of outputs
- 9.5.7 groups inputs into these classes: digital buttons, one-way and two-way absolute axes, and relative axes.

## 9.5 Engine HID systems
See [[Input Action Mapping]] for the details:
- dead zones; low-pass filtering and moving averages;
- XOR edge detection;
- chords and their timing leeway;
- sequences and gestures (button tapping, A-B-A, stick rotation);
- multiple devices and disconnects;
- abstract control ids for cross-platform input;
- **remapping tables**; input classes;
- context-sensitive controls; control ownership and logical devices;
- disabling inputs safely.

## 9.6 In practice
Expect to spend real engineering time on input. It is "the underpinnings of your game's most precious resource: its player mechanics."

## Plotweaver
- M1 L1 covered edges, focus loss and wheel input.
- **Still missing**: an action-mapping layer and input ownership (game vs editor vs camera).

Prev: [[Ch08 The Game Loop]] · Next: [[Ch10 Debugging and Development Tools]]
