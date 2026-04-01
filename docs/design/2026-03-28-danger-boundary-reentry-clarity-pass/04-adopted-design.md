# Adopted Design

## Chosen Candidate
Candidate D — Combined Danger Re-entry Completion Pass

## Why Chosen
MagicGourd already tells the player:
- danger exists
- goblins slow you
- safe loop steps still matter

The remaining completion gap is more specific:
**the game needs to feel like it knows exactly when danger has ended and how the player cleanly rejoins the main loop.**

Right now, the danger edge can still risk three small forms of looseness:
1. the safe/danger transition reads as a soft gradient instead of a clear lane handoff
2. retreat can briefly blur into plaza / center-lane noise
3. slow recovery can clear correctly, but the return beat may not feel fully authored

This pass finishes that boundary.

---

## Design Goal
Make the Nolbu boundary feel like a clean arcade transition:
- push in knowingly
- get interrupted clearly
- retreat along an obvious safe-side line
- regain one authored next step as soon as pressure meaningfully ends

The player should feel:
- `I crossed into danger.`
- `I got clipped and need to get out.`
- `I am back on the safe side now.`
- `The loop has re-formed around one clear next action.`

---

## Scope Boundary
This pass is **not**:
- a new safe-zone mechanic
- invulnerability frames
- a new danger tutorial
- a map expansion
- a goblin AI rework

This pass **is**:
- boundary readability rules
- retreat-lane protection rules
- recovery feedback ownership rules
- safe-side re-entry guidance rules

---

## Core Principle
Danger should behave like a readable lane state, not a vague atmosphere.

That means the game must clearly author three moments:
1. **commitment** — the player enters danger knowingly
2. **escape** — the player can read how to leave immediate pressure
3. **re-entry** — the player quickly regains one clear loop intention on the safe side

If danger ends but the next safe-side read is mushy, the interruption beat feels unfinished.

---

## Boundary State Contract

### 1. Danger-entry read
The player should cross a boundary that feels intentional, not accidental.

#### Required reads
Before meaningful goblin contact, at least two of these should usually be legible:
- hostile lane landmark or warning sign
- rock / prop rhythm shift
- visible goblin silhouette or motion
- reduced visual ambiguity with plaza / village-purpose props

#### Rule
The first danger cue should say `this lane is for risk`, not merely `there is clutter here`.

---

### 2. Immediate retreat read
Once slowed or pressured, the player should be able to tell which side is the retreat direction without mentally re-solving the whole map.

#### Retreat rule
From ordinary first-contact positions, the safest readable exit line should point back toward the center / plaza side, not deeper into danger clutter.

#### World-side implications
- the danger lane should taper toward a readable safe-side corridor
- retreat-facing landmarks should be simpler and more reassuring than danger-entry landmarks
- retreat route should not visually merge with optional plaza-choice reading too early

#### Hard rule
Do not solve this with extra overlay UI first.
The lane itself should do most of the work.

---

### 3. Safe-side confirmation read
The player needs a visible sense that they are no longer inside the primary danger beat.

This does **not** require a literal safe-zone system.
It requires a readable authored threshold.

#### Confirmation cues may come from
- clearer landmark rhythm on the safe side
- reduced rock / hostile clutter density
- renewed visibility of center-lane / plaza route intent
- danger feedback yielding once the threat beat has ended

#### Player feeling target
`I am back in the loop space, not half-stuck in danger.`

---

## Retreat Lane Spatial Budget

### Goal
Protect one readable retreat corridor between the Nolbu edge and the center/plaza side.

### Budget rules
1. retreat route should preserve a clearer travel slice than adjacent clutter pockets
2. danger-edge props should frame the lane, not pinch it into a guess
3. plaza prompts or billboards should not reclaim the read until the player is meaningfully back on the safe side
4. owned-pumpkin activity near the center should read as loop continuation, not as danger-edge clutter

### Fail conditions
- slowed players visually face several equally plausible return paths
- the first safe-side space immediately collapses into pad-choice noise
- danger props continue to dominate the frame even after the player has retreated to the intended recovery side

### Fix order
1. trim or reposition occluding edge props
2. reinforce retreat-facing landmark grammar
3. keep plaza commitment prompts slightly deferred from the raw retreat edge
4. only then adjust wording/timing if spatial ambiguity remains

---

## Feedback Ownership Contract

### Slow applied
Slow applied remains the dominant interruption beat.

Rule:
- player-anchored popup + banner may strongly interrupt lower-tier positive beats
- immediate message is survival/reposition, not optimization

### Slow active
While slow is active, `Next:` may point to escape / regroup only if that remains the most truthful local instruction.

Rule:
Do not surface upgrade temptation or secondary optimization as the headline while the player is still inside the meaningful interruption window.

### Slow faded
Slow recovery should remain a quiet bridge, not a lingering mode.

Rule:
- banner-only is still correct
- it should yield quickly into a concrete re-entry action
- it must not leave the player suspended in generic safety language after the danger beat is effectively over

---

## Safe-Side Re-entry Priority
Once the player is meaningfully back out of immediate danger, default-next-step priority should restore the normal loop in this order:
1. owned pumpkin to break
2. available seed to plant
3. affordable plaza purchase if no more local farming beat is active
4. village reset for fresh seeds

### Why this order still holds
Danger is an interruption, not a new branch.
Once danger has cleared, the game should reconnect the player to the strongest unfinished local loop beat.

### Re-entry examples

#### Case A — retreat with owned pumpkin waiting
`Next: Break your pumpkin for money.`

Support idea:
`You made it out — cash in before heading back.`

#### Case B — retreat with seeds but no pumpkin
`Next: Plant a pumpkin on the safe side.`

Support idea:
`Reset the loop nearby before risking another push.`

#### Case C — retreat with no seeds/pumpkin but enough money
`Next: Return to Central Plaza for an upgrade.`

Support idea:
`Spend while the lane is clear, then re-enter stronger.`

#### Case D — retreat with nothing local ready
`Next: Heal a swallow in Heungbu Village for seeds.`

Support idea:
`Rebuild from the village side, then come back prepared.`

---

## Landmark / Placement Grammar

### Danger-entry landmarks
Should read:
- risk-forward
- sharper / more warning-like
- visually tied to hostile territory

### Safe-return landmarks
Should read:
- simpler
- directional
- recovery-friendly
- closer to route reassurance than threat broadcast

### Coherence rule
The same landmark language should not try to do both jobs equally.
If entry and exit cues feel identical, the boundary loses authored shape.

---

## Service / World Follow-through

### ArcadeWorld
Potential low-scope follow-through if Studio confirms the issue:
- slightly clarify the retreat corridor silhouette
- trim edge clutter that hides the safe-side line
- keep plaza prompts from reclaiming the frame too early after retreat

### GoblinService
No new AI system required.
Only preserve the current contract that danger is readable before contact and recoverable after contact.

### Client HUD / feedback
Potential low-scope follow-through if needed:
- ensure `slow faded` quickly yields to re-entry guidance
- keep re-entry support copy secondary to one authored headline
- do not let plaza bookkeeping outrank a more local unfinished farming beat just because the player has money

### Data model
No new persistent state required.
No new economy state required.
No new remote required.

---

## Failure / Edge Cases
- **Player retreats only one step, then re-engages immediately:** acceptable; the design should clarify the lane, not forbid aggression.
- **Player exits danger directly into plaza proximity:** purchase may become the next headline only once immediate danger pressure is honestly over and no closer farming beat outranks it.
- **Busy multiplayer slice near center:** ambient activity is acceptable as long as one safe-side route and one local next step stay readable.
- **Fast upgraded movement:** the retreat corridor still matters because higher speed increases the need for clear lane ownership, not less.
- **Player intentionally lingers at the boundary:** acceptable; the pass is about clarity, not hard gating.

---

## Validation Plan
1. Enter Nolbu Area from the safe side and confirm the danger commitment reads before contact.
2. Get slowed near the first meaningful contact point and confirm the retreat direction is obvious without camera hunting.
3. Retreat to the intended safe-side corridor and confirm the frame stops feeling like danger clutter before full loop guidance returns.
4. Let slow fade while an owned pumpkin exists and confirm `Break` quickly reclaims the headline.
5. Let slow fade while holding seeds and confirm `Plant` quickly becomes the default next step.
6. Retreat with enough money but no seeds/pumpkin and confirm the plaza read returns only after immediate interruption meaning has ended.
7. Confirm plaza prompts do not visually steal the retreat beat too early.
8. Confirm the overall experience feels like one authored interruption-and-return cycle, not several disconnected messages.

---

## Recommended Hand-off
### PM
Use this as a completion pass underneath MG-PM-408 whenever Studio shows that goblin danger is understandable but retreat-and-return still feels slightly loose.

### Dev
If follow-through becomes necessary, implement in this order:
1. protect the retreat corridor visually
2. differentiate danger-entry vs safe-return landmark grammar
3. ensure `slow faded` yields back to normal loop priority quickly
4. only then trim copy/timing if the handoff still feels chatty

This keeps the game inside refinement mode: same loop, clearer interruption, cleaner recovery, better coherence.