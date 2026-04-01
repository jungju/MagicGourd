# Adopted Design

## Chosen Candidate
Candidate A — Threshold-first spend coherence

## Why chosen
MagicGourd already lands the major loop beats:
- heals give setup
- planting commits a seed
- cracking pays out
- plaza purchases improve the next run

The remaining polish gap is the **money meaning gap** between `I got paid` and `I know what that payment changed`.

Right now, that meaning exists, but it is spread across several places:
- the money counter
- upgrade rows
- next-step guidance
- purchase feedback after the buy

This pass gives them one shared authoring rule so payouts and plaza returns feel more coherent.

---

## Design goal
Make each money gain feel legibly closer to a meaningful spend, while preserving player freedom to finish the current local action before returning to plaza.

The player should feel:
- `That pumpkin payout moved me toward something specific.`
- `I know whether I should keep one more loop beat going or go spend now.`
- `The plaza feels like the payoff for progress, not a separate chore.`

---

## Scope boundary
This pass is **not**:
- an auto-buy system
- an upgrade recommendation engine
- a rebalance of costs or rewards
- a new spend preview panel
- a forced return-to-plaza mechanic

This pass **is**:
- a nearest-threshold decision contract
- copy and hierarchy rules for money-progress phrasing
- a soft return-now vs finish-first recommendation layer
- validation rules for payout-to-spend readability

---

## Core principle
At any moment, the UI should be able to answer one concise question:

`What is my nearest meaningful spend, and how close am I to it?`

That answer should be shared consistently across:
1. HUD next-step guidance
2. upgrade rows
3. payout follow-through copy when relevant
4. plaza-return support tips

---

## Threshold contract

### 1. Nearest threshold means nearest buyable next level
For each upgrade, evaluate only the **next available level**.
Ignore future levels beyond the immediate next step.

The active threshold is:
- the **cheapest next-cost the player has not yet reached**, if none are affordable
- otherwise, the **most immediately buyable next level the player is most likely to act on in the current moment**

In practice, this yields two states.

#### State A — No upgrade affordable yet
The nearest threshold is the lowest next cost among remaining upgrades.

Example:
- player has 10 money
- cheapest next cost is 20
- threshold read = `10 away from the next plaza buy`

#### State B — One or more upgrades affordable
The nearest threshold becomes `buy window is open`.
The UI should stop obsessing over exact gap math and switch to return-timing guidance.

---

## Guidance contract

### 2. Before affordability, speak in threshold progress
When no upgrade is affordable, the guidance layer should make money feel directional.

Preferred phrasing families:
- `Next: Break 1 more pumpkin to afford a plaza upgrade.`
- `Next: You are 10 money away from your next plaza buy.`
- `Status: Upgrade in reach soon.`

#### Rule
Prefer **pumpkin-count phrasing** only when it is exact, short, and immediately legible.
Because pumpkin reward is currently fixed at 10, this is often useful.

Use pumpkin-count language when:
- the gap divides cleanly into 10-coin harvest beats
- the phrase stays under one short clause

Use money-gap language when:
- the count would be awkward or too large
- multiple nearby meanings would muddy the line

Examples:
- good: `1 more pumpkin for Footwork.`
- good: `2 more pumpkins for your next buy.`
- weaker: `7 more pumpkins for a later upgrade.`

### 3. Once affordable, speak in return timing
When at least one upgrade is affordable, stop framing the next step as raw earning progress.
The question is no longer `how far am I?`
It becomes `should I return now or finish this local beat first?`

Preferred phrasing families:
- `Next: Return to Central Plaza after this safe action.`
- `Next: A plaza upgrade is ready when you step off this prompt.`
- `Status: Upgrade available.`

#### Return-now vs finish-first rule
If no stronger local commitment exists, the UI may suggest returning now.
If a stronger local commitment exists, the UI should suggest returning **after** that action.

Examples:
- affordable + no seeds + no prompt = `Return to plaza now.`
- affordable + owned pumpkin prompt = `Cash out this pumpkin, then return to plaza.`
- affordable + swallow prompt = `Heal first if you want a cleaner next setup, then spend.`

---

## Surface rules

### HUD next line
The `Next:` line is the main owner of threshold coaching.
It should express either:
- progress to threshold, or
- return timing after affordability

Never both at once.

### Status line
The `Status:` line should summarize spend state compactly.
Examples:
- `Status: 1 pumpkin from upgrade`
- `Status: Upgrade available`
- `Status: All upgrades maxed`

### Upgrade rows
Upgrade rows continue to answer local comparison questions.
They should not become the only place threshold progress is understandable.

Rule:
- rows explain **what each upgrade does** and **what it needs**
- HUD explains **what the player should care about next**

### Purchase feedback
Purchase feedback remains benefit-first.
But after a buy, follow-through support text should briefly re-anchor the player in the upgraded loop.
This already exists and should remain compatible with this pass.

---

## Decision priority
Use this order when deriving spend guidance:

1. all upgrades maxed
2. recent upgrade purchase follow-through
3. slowed / danger recovery state
4. active local prompt ownership
5. affordable upgrade available
6. no affordable upgrade, nearest threshold progress
7. seedless village fallback / ordinary loop fallback

This preserves the refinement work already done around prompt ownership and recovery.
Threshold coaching should never bulldoze a more urgent local state.

---

## Player flows

### Flow 1 — Early game, one pumpkin away
1. Player has 10 money.
2. No upgrade is affordable yet.
3. HUD reads that one more pumpkin reaches a plaza buy.
4. Player breaks a pumpkin and reaches 20.
5. HUD switches cleanly from threshold-progress language to upgrade-available return language.

Desired feel:
The second payout feels like it unlocked a concrete next move.

### Flow 2 — Affordable but in a local commitment
1. Player can afford an upgrade.
2. Player is standing by their owned pumpkin or in swallow range.
3. HUD says the plaza buy is ready, but frames it as `after this action`.
4. The player does not feel punished for finishing the local beat first.

Desired feel:
The game suggests without nagging.

### Flow 3 — Multiple upgrades affordable
1. Player can afford two or more upgrades.
2. HUD still says `Upgrade available` rather than trying to compare everything in one line.
3. Upgrade rows carry the local comparison.

Desired feel:
The plaza is readable, not over-directed.

---

## Server logic
No new server state required.
No new remote required.
No economy rebalance required.

This pass should derive from existing client-visible state:
- money
- current upgrade levels
- known next costs
- owned pumpkin count
- prompt ownership
- slowed / recovery state

---

## Client logic
Helpful derived helpers:
- `getNearestUpgradeThreshold(money)`
- `getThresholdGap(money)`
- `getPumpkinsToThreshold(money)`
- `getSpendGuidanceState(playerState)`

### Derivation rule
If `gap > 0` and `gap % PumpkinReward == 0`, pumpkin-count phrasing is allowed.
Otherwise use money-gap phrasing.

### Copy discipline
Keep threshold lines short.
Do not stack:
- exact cost
- missing amount
- pumpkin count
- upgrade name
all in one sentence.

Preferred compactness:
- one target
- one distance signal
- one action suggestion

---

## Example copy set

### No upgrade affordable
- `Next: Break 1 more pumpkin for your next plaza buy.`
- `Next: 10 money more unlocks a plaza upgrade.`
- `Status: Upgrade in reach soon.`

### Affordable, no stronger commitment
- `Next: Return to Central Plaza and buy an upgrade.`
- `Status: Upgrade available.`

### Affordable, prompt-owned moment
- `Next: Cash out this pumpkin, then return to plaza.`
- `Next: Finish this heal, then spend in the plaza.`
- `Status: Upgrade ready after this action.`

### All maxed
- `Next: Keep the farming loop moving.`
- `Status: All upgrades maxed.`

---

## Failure / edge cases
- **Player can afford several upgrades:** do not force a single recommendation unless another design pass explicitly chooses that behavior.
- **Threshold gap is awkward:** use money phrasing instead of pumpkin-count phrasing.
- **Player ignores affordable upgrades:** acceptable; guidance is advisory.
- **Reward values change later:** pumpkin-count phrasing must be derived from actual reward config, not hard-coded copy assumptions.
- **Prompt-heavy moment near plaza:** prompt ownership still outranks spend coaching.

---

## Validation method
1. Start with 0 money and confirm the loop falls back to ordinary guidance.
2. Reach 10 money and confirm the HUD clearly says one more pumpkin reaches a buy threshold.
3. Reach 20 money and confirm the guidance flips cleanly to upgrade-available language.
4. Stay near an owned pumpkin while affordable and confirm the wording becomes `finish this action, then spend` rather than generic plaza nagging.
5. Stand with no local prompt while affordable and confirm the UI cleanly invites a plaza return.
6. Accumulate enough money for multiple upgrades and confirm the HUD stays simple while the rows carry comparison.
7. Max all upgrades and confirm threshold coaching disappears.
8. Confirm the result feels like stronger reward-to-spend coherence, not extra UI chatter.

---

## Recommended tuning order
If Studio still feels muddy, tune in this order:
1. simplify threshold copy
2. reduce named-upgrade specificity in generic threshold lines
3. preserve prompt-ownership priority
4. only then consider a subtle cheapest-affordable highlight in upgrade rows

This keeps the pass inside refinement mode: same economy, clearer meaning.
