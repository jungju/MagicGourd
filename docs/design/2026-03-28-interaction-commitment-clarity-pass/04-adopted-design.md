# Adopted Design

## Chosen Candidate
Candidate A — Whole-loop interaction commitment hierarchy

## Why Chosen
MagicGourd already has much better **loop clarity** than it did earlier in the day. The remaining gap is more physical than conceptual:

The player can usually tell what the next good action is, but the **interaction surfaces** do not yet have one explicitly authored commitment contract.

That matters because repeated arcade play is judged less by document-level logic and more by whether the game feels clean in the hand:
- Does the right action own the moment?
- Does a nearby alternative stay secondary?
- Does the plaza require deliberate commitment instead of ambient accidental influence?
- Does the global seed button stay helpful without stealing local object follow-through?

This pass finishes that layer.

---

## Design Goal
Make every loop state expose one clear **interaction owner**.

The player should feel:
- local unfinished work is primary
- plaza spending is deliberate, not ambient
- the seed button helps when planting is truly the right local move
- danger/recovery states temporarily override normal convenience surfaces only as long as needed

This is an interaction-feel pass, not a mechanics pass.

---

## Scope Boundary
This pass is **not**:
- a new input abstraction system
- a new radial menu
- a prompt rewrite across all Roblox defaults
- a new lock-on / targeting mechanic
- a device-specific branch of the game loop

This pass **is**:
- authored priority rules for interaction surfaces
- commitment semantics for prompt distances
- CTA discipline for the bottom seed button
- overlap handling when multiple valid actions coexist

No new verbs. No new economy. No new world system.

---

## Core Principle
The game should not only tell the player what to do next.
It should also make the **most local, highest-value current action** feel like the natural thing their hands will do.

### Interaction owner order
At any moment, the loop should prefer interaction ownership in this order:
1. immediate danger/recovery state that changes safe agency
2. unfinished owned-object follow-through
3. nearby authored world prompt tied to the current loop step
4. global convenience CTA
5. secondary alternatives

### Why this order
- danger changes what is safe right now
- owned objects represent unfinished personal value already created by the player
- nearby prompts should feel local and spatially authored
- the bottom CTA is useful, but should not dominate over a stronger local commitment beat

---

## Surface Roles

### Surface A — Local world prompt
Examples:
- swallow `Heal`
- plaza `Buy`

**Role:** deliberate object/zone commitment

**Rule:**
When the player steps into a prompt's authored distance, that prompt should feel like a local invitation with more authority than a generic global CTA.

Prompt surfaces are where the world says:
- `If you are here, this is what this place is for.`

---

### Surface B — Local object action without prompt
Example:
- breaking an owned pumpkin by attack input / hit remote

**Role:** unfinished personal work

**Rule:**
If the player already owns a nearby pumpkin that is the active value source, that object's completion should outrank remote/plaza/global alternatives in both guidance and CTA styling.

The loop should not visually imply `go buy` or `go plant` as the lead read while an unresolved owned pumpkin is the most immediate local payout.

---

### Surface C — Global convenience CTA
Example:
- bottom `Use Seed` button

**Role:** keep planting accessible without requiring the player to hunt for a special object prompt

**Rule:**
This surface is valuable because planting is a repeat action.
But it is a **support convenience**, not a universal owner.

The seed button should only feel primary when planting is the currently authored best local commitment.

---

## Seed Button Discipline

### Primary state
The seed button may present as primary when all are true:
- player has seeds
- player is not slowed in a way that currently demands retreat/recovery messaging
- player does not have an unresolved owned pumpkin that should be finished first
- player is not currently standing inside a stronger authored local prompt that represents the current step

**Desired feeling:**
`I have seeds. Planting is the right active move. The game is helping me do it quickly.`

### Secondary state
The seed button should remain available but visually secondary when:
- the player has seeds **and** can also afford an upgrade
- the player has seeds near the plaza but the authored local pad prompt is the commitment beat
- the player is in a mild ambiguous state where planting is valid but not the only sensible action

**Secondary treatment can mean:**
- quieter copy
- reduced emphasis color/scale
- brief support phrasing rather than headline phrasing
- if needed, temporary de-emphasis rather than disappearance

### Suppressed state
The seed button should be hidden or strongly suppressed when:
- the player is slowed and the retreat/recovery read should own the moment
- the player has an unresolved owned pumpkin and the main beat is to finish/cash out
- the player is inside a swallow/plaza prompt and that local authored commitment is the current step

**Hard rule:**
Do not let the global seed CTA visually argue with an active local commitment beat.

---

## Prompt Commitment Contract

### Swallow prompt
Current broader reach is correct.

**Meaning:**
This is a welcoming reset/start action.
Village interactions should be easy to acquire because the village is the loop reset/source step.

**Feel target:**
low-friction kindness/start-of-chain commitment

### Plaza prompt
Current tighter reach is correct and should be treated as authored design, not an arbitrary number tweak.

**Meaning:**
Buying is a deliberate spend choice.
The plaza should not broadcast buy authority into the whole center lane.

**Feel target:**
intentional commitment only after the player actually steps onto a specific pad

### Contract summary
Prompt distance is not only technical readability.
It is also **interaction meaning**:
- wider = welcoming/source/reset action
- tighter = deliberate fork/commitment action

This explains why swallow and plaza should not share the same activation feel even if both use ProximityPrompt.

---

## Ownership Rules for Ambiguous States

### 1. Pumpkin owned + upgrade affordable
Primary owner:
- owned pumpkin completion

Why:
- the player already created value on the ground
- cash-out is the most local unresolved beat
- plaza spending should follow the completed payout, not interrupt it

Result:
- HUD `Next:` already prefers break; interaction surfaces should match that authored choice
- seed CTA should not present as strong primary here even if seeds remain

---

### 2. Seeds held + plaza nearby + upgrade affordable
Primary owner:
- context-sensitive, but default to the stronger local physical commitment

Rules:
- if the player is actually inside a plaza pad prompt, `Buy` owns the local moment
- if the player is not yet committed to a pad and planting remains the stronger loop continuation, the seed CTA may stay available as primary/secondary depending on state

Meaning:
The game can still prefer `Plant` as loop momentum **without** pretending that a physically entered plaza prompt is not happening.

This resolves the gap between decision priority and local interaction ownership.

---

### 3. Slowed + seeds available
Primary owner:
- retreat/recovery state

Rule:
Do not sell planting as the main active interaction while the player is under fresh slow pressure.
The seed button should yield until safe-side agency is restored.

After recovery:
- quickly restore the normal owner order
- owned pumpkin > seed planting > buy > village reset, matching the existing loop-read contract

---

### 4. Swallow prompt entered while seeds still remain
Primary owner:
- swallow prompt only if the authored intention is genuinely another heal beat
- otherwise keep it readable but do not let village prompt presence rewrite the whole loop if the player's more valuable local unfinished step is elsewhere

Interpretation:
Prompt entry matters, but it should not erase the broader ownership contract.
A prompt is a strong local invitation, not an absolute override of all authored game state.

---

## UI / Client Contract

### `Next:` line
`Next:` stays responsible for the default loop intention.
It does not need to mirror the exact prompt/button currently nearest the player if that would break the authored loop rhythm.

### Button styling
The seed button should communicate one of three clear states:
1. **Primary** — plant now is the best local commitment
2. **Secondary** — valid, but not the moment owner
3. **Suppressed** — currently not the action that should lead the player's hands

### World prompts
Do not try to hide every alternative from the player.
The goal is not restriction.
The goal is **surface discipline**.

The player may still choose differently.
The authored read should simply be cleaner.

---

## World Object / Placement Implications
No new world objects required.
No map rebuild required.

This pass only formalizes meanings already emerging from the current map:
- village prompt = generous restart/source beat
- work lane = object follow-through and local action ownership
- plaza pads = deliberate spend commit points
- danger edge = temporary interruption of convenience surfaces

That makes current placement decisions feel intentional rather than incidental.

---

## Server / Data Model
No new persistent state required.
No new remote required.

Possible implementation touchpoints if follow-through is needed later:
- client seed-button emphasis state machine
- client detection of active nearby prompt ownership
- preserving current guidance priority while allowing local prompt presence to temporarily own button emphasis/styling

This should remain a client polish pass layered on the existing runtime.

---

## Failure / Edge Cases
- **Player intentionally ignores the moment owner:** acceptable; clarity is the goal, not force.
- **Multiple players cluster near the plaza/work lane:** local player CTA discipline still helps even if shared prompts create ambient noise.
- **Player enters a plaza pad while holding seeds:** buy may own the local moment, but planting can remain the loop-default headline if the player is not yet committed or immediately leaves the pad.
- **Prompt flicker at distance boundary:** if de-emphasis relies on prompt presence, use small hysteresis/grace timing so the seed CTA does not flash between states.
- **Mobile touch:** this pass should be validated against bottom-button competition, but does not require a mobile-only design fork.

---

## Validation Plan
1. Hold seeds with no pumpkin and no prompt nearby; confirm the seed button reads as the main action.
2. Hold seeds while standing on a plaza pad; confirm `Buy` feels like the local commitment and the seed button stops visually competing.
3. Own a pumpkin and also have enough money for upgrades; confirm object follow-through still owns the read.
4. Get slowed while seeds are available; confirm planting CTA yields during the interruption.
5. Recover from slow with seeds and no pumpkin; confirm planting quickly regains ownership.
6. Stand near swallow prompts while still in an alternate-valid state and confirm prompt presence does not completely break the broader loop ownership rules.
7. Repeat the loop several times and confirm the interaction surfaces feel deliberate rather than eager/noisy.
8. Check desktop and mobile/touch in Studio and confirm the bottom CTA does not crowd active prompt-based commitments.

---

## Recommended Hand-off
### PM
Track this as a refinement-only completion pass under the blocked validation bucket if Studio shows the loop is understandable but interaction surfaces still feel a bit competitive.

### Dev
If implementation follow-through is needed, do it in this order:
1. define 3-state seed button emphasis (`primary / secondary / suppressed`)
2. let active local prompt ownership suppress or demote the seed CTA when appropriate
3. ensure unresolved owned pumpkin state outranks convenience CTA styling
4. add small grace timing to avoid flicker near prompt boundaries
5. validate touch/desktop without adding new surfaces

This keeps the work small, tactile, and fully inside refinement mode.