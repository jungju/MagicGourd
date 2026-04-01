# Adopted Design

## Chosen Candidate
Candidate A — Full loop reset clarity contract

## Why Chosen
MagicGourd already teaches its moment-to-moment verbs well. The remaining completion gap is that the loop can still feel slightly **diffuse right after a successful or interrupted beat**, especially when the player has more than one valid option.

The game should not merely be readable at each node. It should also feel like it knows how to hand the player from one node to the next.

This pass finishes that handoff.

---

## Design Goal
Make every completed beat hand the player back to **one obvious default intention** inside the current loop.

Target beats:
- pumpkin payout
- upgrade purchase
- goblin slow recovery
- ambiguous states where both farming and buying are possible

The player should feel:
- `I got paid.`
- `I know what the game wants me to consider next.`
- `I can still choose differently, but the loop has a clean default rhythm.`

---

## Scope Boundary
This pass is **not**:
- a new tutorial system
- a new quest layer
- a new HUD surface
- a reward rebalance
- a map/layout change

This pass **is**:
- guidance priority refinement
- post-event handoff wording
- clearer default-next-step rules
- support-line discipline during ambiguous states

---

## Core Principle
At any normal moment, the loop should expose:
1. one **default next step**
2. one **supporting state summary**
3. one **short optional nuance** in the support line

If the game tells the player several equally valid things at once, the loop loses authored momentum.

### Read priority
1. immediate danger / recovery state
2. unresolved owned pumpkin
3. ready seed -> plant step
4. affordable plaza purchase
5. return-to-village reset

Why this order:
- danger changes survivability now
- an owned pumpkin is unfinished personal value already on the ground
- holding seeds means the setup step is ready now
- affordable plaza spend matters, but should not constantly outrank live owned-object follow-through
- village reset is the clean fallback when nothing more immediate is active

---

## Default Handoff Rules

### 1. After pumpkin payout
**Desired feeling:** reward resolves into a clean fork, not a vague lull.

#### If the player still has seeds
Default next step:
- `Next: Plant another pumpkin nearby.`

Support line style:
- remind that plaza is an option, but not the main headline
- example: `You can cash in at the plaza after one more setup.`

#### If the player has no seeds but can afford an upgrade
Default next step:
- `Next: Return to Central Plaza for an upgrade.`

Support line style:
- promise the next-run benefit, not generic bookkeeping
- example: `Spend now, then restart stronger from the village.`

#### If the player has neither seeds nor an affordable purchase
Default next step:
- `Next: Heal a swallow in Heungbu Village for seeds.`

Rule:
Payout should always collapse back into one loop continuation, not leave the player sitting in an earned-but-directionless state.

---

### 2. After upgrade purchase
**Desired feeling:** spending money should feel like a loop reset with momentum, not an accounting pause.

Default next step:
- if seeds == 0: `Next: Return to Heungbu Village for fresh seeds.`
- if seeds > 0: `Next: Plant a pumpkin and feel the upgrade on this run.`

Support line rule:
The support line should translate the purchase into the very next playable consequence.

Examples:
- Footwork: `Take the village route again and feel the lighter pace.`
- Quick Hands: `Plant now and cash out the next pumpkin faster.`
- Blessing: `Go heal again to turn one swallow into a bigger setup.`

Hard rule:
Do not let `Upgrade available` or other plaza-state summaries immediately steal back the read after a purchase success. The purchase should own the reset beat long enough to point toward the next run.

---

### 3. After slow recovery
**Desired feeling:** recovery is a reset cue, not a dead status cleanup.

Default next step:
- if an owned pumpkin exists: `Next: Break your pumpkin for money.`
- else if seeds > 0: `Next: Plant a pumpkin nearby.`
- else: `Next: Rejoin the loop from the safe side.`

Support line rule:
`Slow faded` should be brief, then the HUD should quickly restore a concrete action headline.

Hard rule:
Recovery language should not trap the player in generic safety messaging once the debuff is gone.

---

### 4. Ambiguous multi-valid states
These are the most important finishing cases.

#### Case A — player has seeds and can also afford an upgrade
Default next step:
- prefer `Plant` over `Buy`

Why:
- seeds mean the next action is locally available right now
- planting preserves loop momentum in the shared lane
- buying stays a valid side option, but should live in support copy rather than the main headline

Support line example:
- `Plant first, or swing by the plaza if you want a stronger next route.`

#### Case B — player owns a pumpkin and can afford an upgrade
Default next step:
- prefer `Break` over `Buy`

Why:
- unresolved owned objects should finish before the spend fork dominates
- this keeps the loop from feeling like it abandons live payoff objects in favor of bookkeeping

Support line example:
- `Cash out first, then decide whether this is the plaza trip.`

#### Case C — player has no seeds, no pumpkin, but can afford an upgrade
Default next step:
- prefer `Buy`

Why:
- this is the cleanest low-friction reset available
- otherwise the player is sent back to village while sitting on a valid progression spend

---

## Surface Contract

### `Next:` line
The `Next:` line should only carry the default action.
It should not attempt to explain the whole fork.

Rule:
- one action
- one destination/object if useful
- no sentence chaining unless the second clause is inseparable from the first

Preferred examples:
- `Next: Break your pumpkin for money.`
- `Next: Plant another pumpkin nearby.`
- `Next: Return to Central Plaza for an upgrade.`
- `Next: Heal a swallow in Heungbu Village for seeds.`

Avoid:
- long dual-intent headlines
- hedged phrasing like `you can` unless the step is optional by design

### `Status:` line
`Status:` should summarize what is currently true, not what the player should do.

Preferred jobs:
- slowed / safe / seed-ready / pumpkin-ready / upgrade-ready

Rule:
Do not let `Status:` become a second `Next:` instruction.

### Support line
The support line may contain the secondary option or emotional framing.

Rule:
If there is a default step plus a valid alternative, the alternative belongs here, not in the main headline.

---

## Reward Feel Rules

### Payout -> next step
Payout should feel like a completed harvest beat, followed by a quick rhythm reset.
The next headline should avoid sounding administrative.

### Purchase -> next step
The first post-purchase guidance should make the upgrade feel immediately playable.
This is where progression becomes felt improvement rather than just a stat increase.

### Recovery -> next step
Recovery should restore agency fast.
The player should not sit in a vague `you are okay now` state longer than necessary.

---

## Client / Runtime Follow-through
No new data model is required.
No new remote is required.
No new world object is required.

This pass can be implemented through existing client guidance functions and current feedback timing.

Likely touchpoints if implementation follow-through is needed:
- primary `Next:` guidance priority logic
- support-tip logic for ambiguous states
- brief purchase-afterglow handling so the buy moment can point toward the next run before normal state summaries fully retake control

### Optional lightweight implementation note
A very small transient client-side `recentPurchaseUpgradeId` / short-lived purchase-afterglow timer would be acceptable **only if needed** to preserve the post-buy reset read for a moment.
This remains refinement, not a new system.

---

## Failure / Edge Cases
- **Player intentionally ignores the default step:** acceptable; the goal is clarity, not forcing behavior.
- **Player has multiple seeds and lots of money:** default action still prefers the most local unfinished loop beat; support copy carries the alternative.
- **Player recovers from slow while already near the plaza:** recovery still yields back to owned-pumpkin / seed / buy priority in that order.
- **Busy multiplayer frame:** this pass only needs to clarify the local player's next read, not globally silence all ambient opportunities.
- **Very fast purchase -> plant behavior:** acceptable; the point is to make that transition feel authored, not slower.

---

## Validation Plan
1. Break a pumpkin while still holding seeds and confirm the next headline returns to `Plant`, not a vague mixed instruction.
2. Break a pumpkin with zero seeds but enough money and confirm the next headline cleanly points to the plaza.
3. Buy Footwork with zero seeds and confirm the next read points back to village rather than leaving the player in plaza bookkeeping.
4. Buy Quick Hands while holding seeds and confirm the next read points toward planting so the upgrade feels immediately testable.
5. Get slowed, recover, and confirm the HUD promptly restores a concrete action instead of lingering on generic recovery language.
6. Stand in a state with both a ready pumpkin and an affordable upgrade and confirm `Break` remains the main headline.
7. Stand in a state with seeds plus affordable upgrade and confirm `Plant` remains the main headline while `Buy` is only secondary.

---

## Recommended Hand-off
### PM
Use this as a low-scope completion pass under MG-PM-408/MG-PM-409 whenever live validation shows the loop is readable but still slightly indecisive after reward or recovery moments.

### Dev
If follow-through is needed, implement in this order:
1. lock default-next-step priority for ambiguous states
2. trim support lines so the alternative stays secondary
3. preserve post-buy re-entry momentum for a short moment if normal state polling steals the read too quickly
4. only then retune wording length if the HUD feels chatty

This keeps the project inside refinement mode: same loop, clearer handoffs, better completion feel.