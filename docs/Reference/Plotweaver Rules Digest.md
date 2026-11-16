---
tags: [reference, rules]
---

# Plotweaver Rules Digest

Back to [[Home]].

A working summary of *Plotweaver Condensed Rules Overview* (8 pages), written for implementing the rules in code. The PDF is at `C:\Users\ayode\OneDrive\Documents\Plotweaver_Condensed_Rules_Overview.pdf`. **The PDF is the authority.** This digest was made from its extracted text, where icons and some table cells didn't survive. Those spots are marked ⚠️. Check them against the PDF before coding them.

The overview is a condensed version. The full Plotweaver Guidebook has more: weapons, armour, talents, paths, ancestries. Where this page is silent, don't invent a rule. Look it up or decide it as a design choice and record it.

## Skill tests

The core of everything.

1. Pick a skill. Roll a **d20**.
2. Add the skill's **modifier** and any bonuses or penalties.
3. Compare the total with the **DC**. Equal or higher succeeds.

**Skill modifier** = the skill's attribute + ranks in the skill.

### Advantage and disadvantage

- Each advantage cancels one disadvantage.
- **For each advantage:** choose one die in the roll, roll two of that die, and choose which result to keep.
- **For each disadvantage:** the GM chooses one die, you roll two of it, and the GM chooses which result to keep.

Note "one die in the roll": this can be the d20, a damage die, or the plot die. That is unusual and needs UI.

### Raising the stakes and the plot die

For important tests, the GM raises the stakes: the **plot die** (a d6) is rolled along with the d20. Once per test, before the d20 is rolled.

| Plot die face | Result |
|---|---|
| 1 | **Complication**, and add **+2** to the d20 result ⚠️ |
| 2 | **Complication**, and add **+4** to the d20 result ⚠️ |
| 3, 4 | Nothing |
| 5, 6 | **Opportunity** |

⚠️ The faces and the +2/+4 bonuses come from an icon graphic. Confirm which face carries which bonus.

A natural **20** on the d20 also gives an Opportunity. A natural **1** also gives a Complication.

**Spending an Opportunity** (player chooses one):

- **Aid an ally:** the next test by an ally of your choice gains an advantage.
- **Collect yourself:** recover 1 health, focus or essence.
- **Critically hit:** change a hit into a critical hit (maximum damage).
- **Influence the narrative:** a positive plot twist.

**Facing a Complication** (GM chooses one):

- **Hinder an ally:** the next test by a PC gains a disadvantage.
- **Become distracted:** lose 1 focus.
- **Influence the narrative:** a negative plot twist.

## Characters

Statistics come in three categories: **physical, mental, spiritual**.

### Attributes

| Category | Attributes |
|---|---|
| Physical | **Strength** (power, toughness), **Speed** (quickness, dexterity) |
| Mental | **Intellect** (applied intelligence), **Willpower** (determination) |
| Spiritual | **Awareness** (wisdom, connection), **Presence** (charisma) |

### Defenses

One per category: **Physical, Mental, Spiritual**. A defense sets the DC for tests of that category that target you.

⚠️ How defenses are calculated isn't in the extracted text.

### Skills

| Skill | Used to |
|---|---|
| Agility | jump, balance, ride, pilot, tumble |
| Athletics | lift, run, wrestle, climb, endure |
| Finesse | steal, escape, physically manipulate |
| Heavy Weaponry | wield or understand large weapons |
| Light Weaponry | wield or understand delicate weapons |
| Stealth | hide, sneak, feint, avoid |
| Crafting | create, repair, design, engineer |
| Deduction | analyse, reason, infer, interpret evidence |
| Discipline | resist, concentrate, keep composure |
| Intimidation | scare, threaten, dominate, mock |
| Knowledge | remember, recognise, access information |
| Medicine | heal, diagnose, ease pain |
| Deception | mislead, trick, disguise |
| Insight | intuit, empathise, see through deception |
| Leadership | inspire, command, coordinate |
| Perception | sense, detect, search, spot |
| Persuasion | convince, negotiate, flatter |
| Survival | track, forage, connect with animals |

⚠️ Which attribute each skill uses is on the character sheet graphic, not in the extracted text.

### Resources and other statistics

| Statistic | Meaning |
|---|---|
| **Health** | Stamina and resistance to minor wounds. Damage reduces it |
| **Focus** | Mental resolve. Spent on talents and reactions, and to resist influence |
| **Essence** | Capacity to channel the setting's magic. Spent on magical abilities |
| **Deflect** | Reduces incoming impact, keen and energy damage |
| **Movement** | Distance you can move in about 3 seconds, which is one action in combat |
| **Recovery die** | Rolled to recover health and focus on a rest or a Recover action |
| **Senses range** | How far you perceive when your senses are obscured |

**Expertises** are single-word niches (a culture, a craft, a weapon type). They grant automatic knowledge, allow otherwise impossible tests, unlock expert traits on weapons and armour, and cover languages.

**Purpose, obstacle and goals** are roleplaying hooks. Goals have three milestone boxes and give a reward when complete.

**Talents and abilities** come from ancestry, path and rewards. Each is always on, or activates at a stated time.

## Combat

Combat runs in **10-second rounds**. Each round, every character takes one turn.

### Turn order

Each character chooses a **fast turn (2 actions)** or a **slow turn (3 actions)**. The round goes:

1. Fast PCs
2. Fast NPCs
3. Slow PCs
4. Slow NPCs

Every character also gets **one reaction** at the start of their turn, and one at the start of the scene.

Within a group (for example, all fast PCs), the order isn't specified in the overview. That's a design choice for the game.

### Actions

Each action can be used once per turn unless it says otherwise. The number is the action cost.

| Cost | Action | Effect |
|---|---|---|
| 1 | **Brace** | Take cover or raise a shield. All attacks against you until your next turn gain a disadvantage |
| 1 | **Disengage** | Move 5 feet without triggering Reactive Strikes |
| 1 | **Gain Advantage** | Test a skill against the target's matching defense. On success, gain an advantage on your next test against them that uses a *different* skill |
| 1 | **Interact / Use a Skill** | Interact with an object or use a non-attack skill |
| 1 | **Move** | Move up to your movement rate. Can be used several times per turn |
| 1 | **Strike** | One attack with a wielded weapon, using its skill, damage and range. Can be used once more per turn for each weapon wielded. An offhand weapon costs 2 focus |
| 1 ⚠️ | **Ready** | Prepare a 1-action action to use in response to a trigger |
| 2 | **Grapple** | Athletics vs. the target's Physical defense. On success they're Restrained while within your reach |
| 2 | **Recover** | Once per scene. Roll your recovery die and regain that much health and/or focus |
| 2 | **Shove** | Athletics vs. the target's Physical defense. On success, move the target 5 feet |
| 0 | **Banter** | Talk, with no test |
| 0 | **Drop** | Release something you're holding |

⚠️ Ready is printed as "1\*". Confirm its exact cost.

### Reactions

Usable at any time after the trigger.

| Reaction | Trigger and effect |
|---|---|
| **Aid** | Before an ally makes a test you could help with: spend 1 focus, they gain an advantage |
| **Avoid Danger** | Test Agility to avoid a collision, fall or similar. DC 15, or the result of an enemy's test |
| **Dodge** | When targeted by an attack: spend 1 focus, the attack gains a disadvantage |
| **Reactive Strike** | When an enemy leaves your reach: spend 1 focus to make a melee or unarmed attack against them |

### Attacking

1. Choose targets within **range** and **line of effect**. Within long range but beyond short range, the attack gains a disadvantage.
2. Roll the skill test and the damage dice together.
3. **Miss** if the test fails: no damage. **Hit** if it succeeds: damage = damage dice + the skill modifier used.

Improving a result:

- **Graze:** spend 1 focus per missed target to deal damage equal to the damage dice only.
- **Critical hit:** spend an Opportunity to turn a hit into a critical. Damage dice are maximised.

### Damage

Reduce incoming damage by your **Deflect**, then subtract the rest from Health.

| Damage type | Reduced by Deflect |
|---|---|
| Impact, keen, energy | Yes |
| Spirit, vital | No |

### Injuries

When reduced to 0 health, when taking damage at 0 health, or when told to suffer an injury: roll a d20, add armour deflect and ability modifiers, subtract 5 for each injury you already have.

| Injury roll | Result |
|---|---|
| −6 or lower | Death |
| −5 to 0 | Permanent injury |
| 1 to 5 | Vicious injury, 6d6 days |
| 6 to 15 | Shallow injury, 1d6 days |
| 16+ | Flesh wound, rest of the day |

Then choose an effect, or roll a d8:

| d8 | Effect |
|---|---|
| 1–2 | Exhausted [−1] |
| 3 | Exhausted [−2] |
| 4–5 | Slowed |
| 6 | Disoriented |
| 7 | Surprised |
| 8 | Can only use one hand |

## Conditions

| Condition | Effect |
|---|---|
| **Afflicted** | At the end of each of your turns, take the stated amount and type of damage |
| **Determined** | When you fail a test, you can add an Opportunity to it, then lose this condition |
| **Disoriented** | No reactions. Perception and similar sense tests gain a disadvantage |
| **Enhanced** | Gain the stated attribute bonus. Doesn't change defenses, health, focus or essence |
| **Exhausted** | Each test takes the stated penalty. Cumulative. A long rest reduces it by 1 |
| **Focused** | Abilities cost 1 fewer focus |
| **Immobilized** | Movement rate 0. Can't move or be moved |
| **Prone** | You're Slowed. Melee attacks against you gain an advantage. You can Brace without cover. Standing up costs a free action and 5 feet of movement ⚠️ |
| **Restrained** | Movement rate 0. Disadvantage on all tests except to escape |
| **Severed** | Can't recover the stated resource |
| **Slowed** | Movement rate halved |
| **Stunned** | On your turn, gain two fewer actions and no reaction |
| **Surprised** | No reaction at the start of combat, can't take a fast turn, gain one fewer action |
| **Unconscious** | Movement rate 0 and Prone. No interaction, actions or reactions. You can end it when healed or at the end of any of your turns |

⚠️ Prone's stand-up cost is printed with an icon. Confirm it's a free action.

Afflicted is the hook for burning and poison. Slowed, Immobilized, Stunned and Prone are the hooks for chilled, frozen, electrified and slippery ice.

## Conversations

A scene where characters try to get what they want through talk.

- Characters **contribute** one at a time. When everyone has had the chance, that's one round.
- Ways to contribute:
  - **Influence a person:** a skill test to change someone's mind, unless they resist.
  - **Help or hinder:** give an ally an advantage, or an opponent a disadvantage, on their next test.
  - **Bolster an ally:** they recover some focus.
  - **Gather information:** a skill test.
  - **Interject flavour.**
- **Resisting influence:** an influenced character can spend focus to resist. Usually **2**, or **4** against a particularly persuasive argument. The GM may have an NPC not resist at all.
- **Out of focus:** an NPC at 0 focus can't resist and may leave the conversation. A PC at 0 focus can't resist, but can still walk away, go silent, start a fight or change tactic.
- Focus can be spent to resist influence in any scene type.

**A conversation succeeds** when a contribution fits an NPC's goals so well that no test is needed, when a test succeeds and the NPC doesn't or can't resist, or when the party otherwise gets what it came for.

**It fails** when the party fails several tests, when someone provokes hostility, when a central PC drops out for lack of focus, or when the party otherwise fails its aim.

## Endeavors

Exploration, investigation, pursuit, infiltration: any goal pursued through a mix of roleplay and tests.

- Time is flexible. Rounds are informal, and each party member can contribute once per round.
- **Collective thresholds:** the party needs a number of **successes** before it collects a number of **failures**. A success can be a passed test or a win by other means (essence, items, abilities).

| Complexity | Example | Successes | Failures |
|---|---|---|---|
| Simple | Apprehending a common criminal | 4 ⚠️ | 3 ⚠️ |
| Basic | Working out a mysterious device | ⚠️ | 4 ⚠️ |
| Average | Infiltrating an occupied base | 8 | 4 ⚠️ |
| Intricate | Locating a lost ancient city | 9 | 4 ⚠️ |
| Insurmountable | Evacuating thousands of civilians | 11 | 5 ⚠️ |

⚠️ This table's columns were scrambled in extraction. Re-read it from the PDF.

## Resting

- **Short rest (1 hour):** roll your recovery die and recover that much, split between health and focus as you like.
- **Long rest (8 hours):** recover all health and focus.
- **Downtime:** crafting, recuperation, research, training, self-reflection, pursuing goals.

## What the rules leave to you

The MVP needs these, and the overview doesn't define them. They're game design decisions, and they're yours. Write each one down when you make it.

- **Surfaces and elements.** Plotweaver has damage types (impact, keen, energy, spirit, vital) and conditions, but no fire, water, ice, poison or electricity, and no surfaces. You're designing that layer and mapping it onto conditions: what does Burning do each turn, what test keeps you standing on ice, how long does Frozen last.
- **Height.** Jump distance, fall damage, the cost of climbing, flying and teleporting. Avoid Danger (Agility, DC 15) is the natural hook for falls.
- **Order within a turn group,** and how the player chooses fast or slow each round.
- **Numbers:** movement rates, weapon ranges and damage, enemy statistics, DCs.
- **The GM.** The tabletop rules lean on a GM's judgment: raising the stakes, choosing complications, deciding when a conversation ends, whether an NPC resists. The game needs explicit rules or authored data for every one of those.
- **Cover.** Brace mentions taking cover. How cover is found on a map is up to you.
