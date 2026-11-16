---
tags: [gate, stage-0, module-a]
---

# Gate A — Hex dump

**Stage 0 · Module A** · Previous: [[0.6 Arrays, slices and strings]] · [[Curriculum Map]]

A gate has three parts: a project with no hints, an oral exam, and a code review. See [[How This Course Works#Gates]]. Do them in order. When all three are done, tick the row in [[Progress]].

## Before you start

Redo the *Check yourself* of all six lessons from memory. If any lesson gives you trouble, go back to its lab before attempting the gate. The gate assumes all six.

## Part 1 — The project

Build a **hex dump** tool: a program that shows the raw bytes of any file. It's a real tool that programmers use constantly, and you'll use yours in Stage 4 to read glTF files by hand.

There are no hints here. Everything it needs is in Lessons 0.1 to 0.6, apart from reading a file and reading command-line arguments, which you look up yourself in the `core:os` package docs or its source in `F:\odin\core\os`. Finding and reading that documentation is part of the gate.

Reading a file hands you its bytes as a `[]u8` in memory that was allocated for you. Who should free that memory, and when, is the subject of Module B. For this gate, don't worry about it.

### Requirements

1. It lives in `labs/gate_a_hexdump/` and builds with `-vet` with no errors.
2. The file to dump is given on the command line: `bin\hexdump.exe some_file`. With no argument, or a file that can't be read, it prints a clear message and exits. It must not crash.
3. Output is one line per 16 bytes, in three columns: the offset of the line's first byte in hex, the 16 bytes in hex with an extra space after the eighth, and the same bytes as text, with a `.` for every byte that isn't a printable ASCII character.

   ```
   00000000  4d 5a 90 00 03 00 00 00  04 00 00 00 ff ff 00 00  MZ..............
   00000010  b8 00 00 00 00 00 00 00  40 00 00 00 00 00 00 00  ........@.......
   ```

4. The last line of a file is usually shorter than 16 bytes. The text column must still line up.
5. An optional second and third argument give a starting offset and a byte count, so you can look at part of a large file. Bad values get a message, not a crash.
6. The work is split into small procedures that each take a `[]u8`. `main` only handles arguments and the file.
7. Formatting a byte as two hex digits is done by **your own procedure** using shifts and masks. `%x` is allowed everywhere else.

### Then use it

1. Dump the first 128 bytes of one of your own executables in `bin/`. The first two bytes should be `MZ`. Find the readable sentence a little further in.
2. Add a procedure `read_u32_le(bytes: []u8, offset: int) -> u32` that assembles a little-endian 32-bit value from four bytes. Use it to read the `u32` stored at offset `0x3C` of the executable. That value is the offset of another header. Dump four bytes there. You should see `PE` followed by two zero bytes.
3. Write down, in your notebook, how you'd explain to someone why the four bytes at `0x3C` have to be read "backwards".
4. Optional, if you have a `.glb` model from one of the asset packs in [[Assets]]: its first twelve bytes are the text `glTF`, then a `u32` version, then a `u32` total length. Read all three with your tool and check the length against the file's size on disk.

### It passes when

- All seven requirements hold.
- It handles: an empty file, a file of exactly 16 bytes, a file of 17 bytes, a missing file, and no arguments.
- You found `MZ`, the sentence, and `PE`.

## Part 2 — The oral exam

Open Claude Code in this repo and send the block below. The `socratic-tutor` skill takes it from there. It asks one question at a time and won't explain until you've tried. Expect it to ask you to predict the output of short snippets and to describe memory drawings.

You pass when every subskill is at 4 out of 5. At the end say **"save state"** and paste what it gives you over the block below, so a later session can resume.

```
Quiz me to mastery on this topic. Use the socratic-tutor skill.

Topic: Plotweaver course, Stage 0 Module A, "Programs and bytes", in Odin.
Target level: 4/5 on every subskill.

Subskills:
1. The compile, link and run model. Reading compiler and linker errors.
2. Using a debugger with a method: breakpoints, stepping, call stack,
   and hypothesis, prediction, observation.
3. Binary and hex. Integer types, overflow, two's complement, conversions,
   integer division.
4. Bit operations, masks, packing fields into an integer, bit_set.
5. Floating point: layout, why values are inexact, growing gaps,
   comparison, NaN.
6. Addresses and pointers: value vs. pointer parameters, aliasing, nil,
   byte order.
7. Fixed arrays, slices and strings: layout, views, bounds checks, UTF-8.

Context for the examiner: I am learning to program without AI help.
Do not write code for me and do not give me solutions to course labs.
Prefer questions where I predict what a short Odin snippet prints,
find the bug in a plausible snippet, or describe how memory is laid out.
I come from Python and NumPy.
```

## Part 3 — The code review

Ask Claude: **"Review my Gate A project in `labs/gate_a_hexdump`."**

The review follows these rules, which are also in the repo's `CLAUDE.md`:

- It asks questions about specific lines and cases. It doesn't rewrite your code.
- It names what it would reconsider and the principle behind it, and leaves the change to you.
- It says plainly what is good, so you keep doing it.

Answer its questions in writing, decide what to change, and change it yourself.

## After the gate

Module B, *Memory*, is next: struct layout, the stack, the heap, lifetimes, and building your own dynamic array, arena and pool. Ask Claude to write Module B when you've passed this gate. It'll be shaped by what the exam and review showed.
