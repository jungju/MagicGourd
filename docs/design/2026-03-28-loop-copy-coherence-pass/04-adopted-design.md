# Adopted Design

## Chosen Candidate
Candidate D — Combined Loop Copy Coherence Pass

## Why Chosen
The current arcade loop is already compact and understandable after a minute of trial. The biggest remaining completion gap is that the game uses **multiple languages for the same loop** depending on where the player looks.

That weakens:
- flow clarity
- perceived polish
- reward feel
- trust in prompts and signs

A dedicated copy coherence pass is the highest-value refinement because it improves the whole play surface without changing any mechanics.

---

## Design Goal
Make the current loop read like one authored system.

The player should see the same conceptual sequence everywhere:
1. **Heal** a swallow
2. **Plant** a pumpkin
3. **Break** the pumpkin
4. **Buy** an upgrade
5. **Avoid / Recover from** goblin pressure

This sequence should be legible in HUD text, prompts, world signs, feedback banners, and floating popups.

---

## Scope
### In scope
- canonical verb map
- exact prompt wording
- exact button wording
- exact billboard wording guidance
- exact feedback bucket wording guidance
- popup wording guidance
- short status/support text rules

### Out of scope
- new tutorial flows
- new map landmarks
- rebalancing costs or rewards
- adding new replicated data
- changing core mechanics

---

## Canonical Verb Map
Use these verbs consistently in all player-facing text.

| System Surface | Canonical Verb | Notes |
|---|---|---|
| Injured swallow interaction | `Heal` | Keep warmth/kindness framing. |
| Seed action / Q button | `Plant` | Better than `Use` because it says what happens. |
| Pumpkin interaction | `Break` | Better than `Hit` because it states the goal, not the input motion. |
| Plaza upgrade interaction | `Buy` | Better than `Upgrade` for prompt/action text because the player is spending currency. |
| Goblin hazard | `Avoid` / `Recover` | `Avoid` before impact, `Recover` during slow. |

### Hard Rule
Do not use `Use Seed`, `Hit Pumpkin`, or generic `Upgrade` in visible player copy once this pass ships.

Internal remote names and module names may remain unchanged.

---

## User Flow Copy by Step

### Step 1 — Swallow phase
**Prompt**
- `Heal`
- object: `Injured Swallow`

**HUD / guidance style**
- `Next: Heal a swallow in Heungbu Village.`

**Banner success**
- `Swallow healed! +1 seed`
- pluralized as needed

**Popup success**
- `+1 Seed`

### Step 2 — Plant phase
**Button ready state**
- `Plant Pumpkin [Q]`
- second line: `Spend 1 seed to plant an owned pumpkin nearby`

**Button empty state**
- `Need Seeds`
- second line: `Heal a swallow first`

**HUD / guidance style**
- `Next: Plant a pumpkin nearby.`

**Banner success**
- `Pumpkin planted.`
- detail: `Break it before it fades for a coin payout.`

**Popup success**
- `Planted`

### Step 3 — Pumpkin break phase
**Prompt**
- `Break`
- object: `Owned Pumpkin`

**HUD / guidance style**
- `Next: Break your pumpkin for money.`

**Banner progress**
- `Pumpkin cracked. 2 hits left.`
- final-hit variant: `Pumpkin cracked. One hit left.`

**Banner success**
- `Pumpkin broken! +10 money`
- detail: `Bring your money back to the plaza for upgrades.`

**Popup progress**
- `2 Left`
- final-hit popup: `Final Hit`

**Popup success**
- `+10 Money`

### Step 4 — Plaza buy phase
**Prompt format**
- action: `Buy`
- object: specific item name, for example `Footwork`

**HUD / guidance style**
- `Next: Return to Central Plaza — you can buy an upgrade.`

**Banner success**
- `Bought Footwork Lv.1 (-20 money)`

**Banner cannot afford**
- `Need 20 money for Footwork`

**Banner maxed**
- `Footwork is maxed`

### Step 5 — Goblin pressure phase
**Zone sign language**
- emphasize danger and slowdown, not lore padding

**HUD / guidance style**
- `Next: Recover from the goblin slow before pushing deeper.`

**Status examples**
- `Status: Safe to farm`
- `Status: Upgrade available`
- `Status: Goblin slow active`

**Banner on slow applied**
- `Goblin hit — movement slowed.`
- detail: `Recover, then jump back into the loop.`

**Banner on slow cleared**
- `Slow faded.`
- detail: `You are back to full pace.`

**Popup on slow applied**
- `Slowed`

**Popup on slow cleared**
- no popup required; banner is enough

---

## Billboard / Signage Rules
The current world already uses billboard signs. Keep them, but tighten each sign so it answers one purpose quickly.

### Zone sign rule
Each zone sign gets:
- short title
- one clear purpose sentence
- at most one optional warning/reward clause

### Recommended copy

#### Central Plaza
**Title:** `Central Plaza`
**Body:** `Buy upgrades here. Reset your pace before the next run.`

#### Heungbu Village
**Title:** `Heungbu Village`
**Body:** `Heal injured swallows here to earn seeds.`

#### Nolbu Area
**Title:** `Nolbu Area`
**Body:** `Goblins slow careless players. Enter for risk, not for safety.`

#### Spawn sign
**Title:** `Arcade Loop`
**Body:** `Heal -> Plant -> Break -> Buy.`

### Upgrade pad billboard rule
Pad billboards should describe the reward, not list the whole cost ladder as a static block if HUD rows now cover cost detail better.

Recommended body style:
- `Run faster between loop steps.`
- `Break pumpkins faster.`
- `Gain more seeds per swallow.`

If cost remains on the pad billboard, keep it secondary and one-line.

---

## HUD Support Copy Rules
The low-priority support line should reinforce the canonical loop, not explain the entire map every frame.

### Preferred support line
`Loop: heal -> plant -> break -> buy.`

### Optional danger-aware variant
When slowed:
`Loop paused: recover, then restart the chain.`

### Rule
Do not let the support line introduce alternate verbs like `use`, `hit`, or `cash in`.

---

## Feedback Tone Taxonomy
Each event should sound like a different kind of moment.

| Event Type | Tone Goal | Rule |
|---|---|---|
| swallow heal | kindness + gain | Warm, immediate, encouraging |
| plant success | ownership + setup | Short and anticipatory |
| pumpkin progress | progress tension | Crisp countdown wording |
| pumpkin payout | harvest + reward | Strong gain framing |
| purchase success | empowerment | Spend acknowledged, benefit implied |
| cannot afford | informative friction | Specific requirement, no scolding |
| maxed | completion | Short and conclusive |
| slowed | interruption / danger | Urgent but not noisy |
| slow cleared | relief | Short recovery confirmation |

### Copy style rules
- Prefer consequence over instruction repetition.
- Keep banners readable in one glance.
- Use detail lines only when they improve next-step clarity.
- Floating popup text should be 1-2 words or a numeric reward phrase.

---

## State / Runtime Implications
No new persistent state is needed.

### Existing systems this design relies on
- client attribute reads for seeds, money, upgrades, slow state
- prompt generation in `SwallowService`, `PumpkinService`, and `ArcadeWorld`
- feedback remote payloads in swallow, pumpkin, and upgrade flows
- goblin slow state in `PlayerStateService`

### Small implementation follow-through required
To fully realize the copy pass, the slow end event needs one visible client-facing feedback moment. That can be done by:
- adding one feedback dispatch when `IsSlowed` changes from true to false on the client, or
- routing a short server feedback event when slow duration resolves

This is a refinement detail, not a new mechanic.

---

## World Object Impact
No new object classes required.

Possible small object adjustments only if needed for readability:
- widen billboard width slightly if revised copy wraps poorly
- shorten upgrade billboard bodies to avoid crowding

No new sign locations are required.

---

## Failure / Edge Cases
- **Player can plant while slowed:** allowed; copy still prioritizes recovery because danger is the highest-value read.
- **All upgrades maxed:** plaza guidance drops out; core loop language remains unchanged.
- **Pluralization:** reward lines must support `seed / seeds` and consistent `money` wording.
- **Copy drift over time:** future additions should inherit the canonical verb map instead of inventing synonyms.
- **Prompt character limits / small screens:** use short action verbs first; keep object text concise.

---

## Validation Plan
1. Spawn fresh and confirm the game teaches `Heal`, not mixed synonyms.
2. Gain one seed and confirm the button now teaches `Plant Pumpkin [Q]`.
3. Approach a pumpkin and confirm the prompt uses `Break`.
4. Reach the plaza and confirm prompts use `Buy` plus specific upgrade names.
5. Read zone signs and confirm each zone has one clear purpose.
6. Trigger swallow, pumpkin, and upgrade feedback and confirm banners feel semantically distinct.
7. Enter goblin danger, get slowed, and confirm the danger language shifts to `Recover`.
8. Confirm slow end feedback exists and does not feel spammy.
9. Scan the whole surface once more and confirm no visible `Use Seed`, `Hit`, or generic `Upgrade` wording remains where player-facing text can be made specific.

---

## Recommended Hand-off
### PM
Use this document as the vocabulary source of truth for MG-PM-409 and MG-PM-410.

### Dev
Implement in this order:
1. button + HUD support line
2. prompts in swallow / pumpkin / upgrade generation
3. sign body/title cleanup
4. feedback bucket text cleanup
5. slow-cleared message

This keeps the pass cheap, coherent, and fully inside refinement mode.
