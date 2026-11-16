---
tags: [course]
---

# How This Course Works

Back to [[Home]]. The lesson list is in the [[Curriculum Map]].

## Why a vault of lessons, and not a chatbot or a website

You asked to learn to program **without AI assistance**. A tutor that is always in the room works against that. When the answer is one message away, you ask before you've struggled, and the struggling is where the skill is built. So the teaching is written down. You read it, close it, and work alone with a compiler, a debugger and the documentation, which is exactly the situation you want to become good in.

It lives in Obsidian because you already use it, it works offline, hints can be folded shut, lessons can link to each other and to the book notes, and you can write your own notes next to them. A quiz website would add nothing that matters here. The feedback that teaches programming comes from the compiler and the debugger, and the quizzing is handled by the examiner described below.

## The rules

1. **You write every line.** Nothing is pasted from an AI, and nothing is typed out from an AI's answer.
2. **You debug every bug.** Errors and broken code never go into a chatbot. They go into the debugger.
3. **Turn off AI completion in your editor** for this repo. The Odin language server (`ols`) is fine. It reports errors and shows types, and it doesn't write code.
4. **What you may use, in this order:** your own notes, the compiler's messages, the debugger, the official docs, the source code of Odin's own libraries, books, and articles written by people. Search engines are fine. Skip their AI summaries.
5. **Lessons never contain the answer to a lab.** They contain explanations, complete worked examples on a *neighbouring* problem, a specification of what to build, and hints.

## What Claude does

| Role | When | What it looks like |
|---|---|---|
| **Author** | Before a stage | Writes the lessons. Later modules are written when you get near them, so they can account for how the earlier gates went |
| **Examiner** | At a gate | Questions you with the `socratic-tutor` skill, one question at a time. It doesn't explain until you have tried two or three times |
| **Reviewer** | After a gate | Reads your code and asks about it: "what happens here when the array is empty?" It names risks and the principle behind them. It doesn't rewrite your code |

If you ask Claude for a fix mid-lesson, it should answer with a question that moves you one step. You can override this by saying "just tell me". Use that when a tool or setup problem is blocking you (a broken install, a linker flag), not for the content of a lab.

## What changes when you come from notebooks

These five shifts explain most of the early confusion.

| In a notebook | In a compiled program |
|---|---|
| State lives on between cells. You poke at it | The program starts from nothing every run. To look inside, you use a **debugger** |
| A variable is a name stuck on an object that lives somewhere | A variable **is** a specific run of bytes at a specific place in memory |
| Memory is somebody else's job | You decide where every piece of data lives and when it dies |
| Types are checked when the line runs | Types are checked **before** anything runs. The compiler is your first test |
| NumPy hides the loops and the layout | You write the loops, and the layout of your data decides how fast they run |

Your ML background helps more than you'd think. A NumPy array is a pointer, a length and a data type, which is what Lesson 0.6 calls a slice. A view that shares memory with another array is the same idea. You already think in matrices, which is half of graphics.

## Shape of a lesson

Every lesson has the same parts, in the same order.

1. **Why this matters for Plotweaver.** Where this shows up in the engine or game.
2. **Warm-up.** A few questions from earlier lessons. Answer from memory before unfolding.
3. **The idea.** The explanation, from zero, with diagrams.
4. **Worked example.** Complete code for a problem *next to* the lab's problem, with its real output.
5. **Predict.** Questions about what some code will do. Write your prediction down, then run it. A wrong prediction is the most useful thing that can happen in a lesson, because it shows you exactly where your picture of the machine is off.
6. **Lab.** What to build, how to tell it works, and folded hints.
7. **Check yourself.** Questions you should be able to answer with the lesson closed.
8. **Explain-back.** A short piece you write in your own words.
9. **Go deeper.** Reading, with exact chapters.

A lesson is finished when the lab works, you pass the check with the lesson closed, and the explain-back is written. Reading it is not finishing it.

## Working a lab

- Lab code goes in `labs/`, one folder per lab: `labs/a03_bits/main.odin`. Run it with `odin run labs/a03_bits`.
- Keep a notebook for predictions, explain-backs and things that surprised you. A paper one works well. If you prefer the vault, make a `Notebook/` folder with one note per lesson.
- Type the worked examples in yourself. Don't copy and paste them. Typing is slow enough that you notice each token.
- Commit after every lab. Small commits make it cheap to go back.

### The hint ladder

Each lab task has hints folded shut, ordered from a nudge to nearly-the-idea. None of them is code for the answer.

> [!hint]- This is what a folded hint looks like
> Click the title to open it. Open one, close the lesson, and try again before opening the next.

### When you are stuck

Go down this list in order. Most problems end by step 3.

1. **Write the problem down in one sentence.** "I expected X, I got Y." If you can't write that sentence, you aren't stuck on the bug yet. You're stuck on what the program should do.
2. **Shrink it.** Make the smallest program that still goes wrong.
3. **Watch it run.** Put a breakpoint before the problem and step. Compare each value with what you expected. The first one that differs is where to look.
4. **Read the docs or the source** for the thing you're calling. `odin doc`, <https://pkg.odin-lang.org>, or the file itself in your Odin install.
5. **Open one hint.**
6. **Stop for the day.** A night's sleep solves a surprising share of bugs.
7. **Ask Claude,** and say what you tried at steps 1 to 4. You'll get a question back.

Give a task at least **45 minutes of real effort** before the first hint. Being stuck is uncomfortable, and it's also the part that builds the skill, so the time isn't wasted.

## Gates

Each module and stage ends with a gate. It has three parts, in this order.

1. **Gate project.** A small program that needs everything in the module, built with no hints.
2. **Oral exam.** Open Claude Code in this repo and say, for example, *"quiz me on Stage 0 Module A"*, and paste the state block from the gate page. The `socratic-tutor` skill (from Jane Street, installed in `.claude/skills/`) runs a short diagnostic, keeps a skill map from 0 to 5 per topic, and asks one question at a time. You pass when every topic is at 4 ("can do independently"). Say *"save state"* at the end and paste the block back into the gate page so the next exam can pick up where this one stopped.
3. **Code review.** Ask Claude to review the gate project. You answer its questions and decide what to change.

Failing a gate just tells you which lesson to redo.

## Remembering it

Understanding something today does not mean you'll have it in a month. Two things fix that, and both are built in.

- **Spaced review.** Redo a lesson's *Check yourself* a day later, a week later and a month later, from memory. Tick the boxes in [[Progress]]. This takes five minutes and does more than re-reading the lesson for an hour.
- **Warm-ups** at the top of every lesson pull in questions from older lessons on purpose.

## A sitting

- 60 to 90 minutes is plenty. Three of those a week beats one long Saturday.
- Start with the warm-up or a due review.
- End by writing one line in your notebook: the very next thing to do. Starting is then easy next time.

## How to read code and docs

Reading is a skill this course trains deliberately, since it is how you'll learn everything that no lesson covers.

- **Odin overview:** <https://odin-lang.org/docs/overview/>. Lessons point at specific sections.
- **Package docs:** <https://pkg.odin-lang.org>. Every `core:` and `vendor:` package.
- **The source itself.** Your Odin install has it all: `F:\odin\core\`, `F:\odin\base\`, `F:\odin\vendor\`. When a lesson says "find out how `append` works", it means open the file and read it.
- **`F:\odin\examples\demo\demo.odin`** is a tour of the language in one file.
- The rest is in [[Sources]].
