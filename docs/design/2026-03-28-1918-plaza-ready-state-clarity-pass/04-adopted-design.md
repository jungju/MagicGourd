# Adopted Design

## Chosen Candidate
Candidate A — Ready-state ownership contract

## Why chosen
MagicGourd's current loop already explains:
- what upgrades are
- how money is earned
- when a plaza return matters

The remaining precision gap is the exact instant affordability becomes true.
At that moment, the player should not need to re-parse three equal-weight upgrade rows.
The game needs one cleaner readiness grammar so the reward beat turns into an obvious spend opportunity.

This pass tightens that grammar without adding a new recommendation system.

---

## Design goal
Make plaza upgrade availability read instantly and quietly.

When affordability opens, the player should understand:
1. `A buy is ready now.`
2. `These rows are the ready choices.`
3. `Anything not ready or maxed is secondary context.`

The player should feel a satisfying unlock beat, then a calm choice moment.

---

## Scope boundary
This pass is **not**:
- a best-build recommender
- a new spend preview widget
- a cost rebalance
- a new plaza map layout
- extra tutorial copy

This pass **is**:
- upgrade-row readiness states
- threshold-crossing follow-through
- emphasis ownership rules between HUD and row text
- validation for multi-affordability without clutter

---

## Core principle
Affordability should create **one obvious state change** in the UI.

That state change must answer two different questions on two different surfaces:
- HUD: `Should I think about plaza spending now?`
- Upgrade rows: `Which pads are actually buyable right now?`

The HUD owns **timing**.
The upgrade rows own **choice set visibility**.

Neither surface should try to own both jobs equally.

---

## Ready-state contract

### 1. Each upgrade row lives in one of four states
For every row/pad, derive exactly one state:
- `LockedFar` — not affordable and not the nearest threshold of attention
- `LockedNear` — not affordable, but plausibly the next meaningful spend target / comparison point
- `ReadyNow` — currently affordable and not maxed
- `Maxed` — no further levels available

This is a presentation state only.
No new gameplay state is required.

### 2. State meanings
#### LockedFar
The row stays readable but quiet.
It should answer `what this upgrade does` and `what it costs next`, without competing with the ready layer.

#### LockedNear
The row can be slightly more legible than `LockedFar` when it is the nearest threshold line the HUD is referencing.
This is a support state, not a spotlight state.

#### ReadyNow
This is the key state of the pass.
A ready row must feel visibly live:
- benefit remains legible
- cost reads as already reachable / available now
- the row no longer reads like a future plan

#### Maxed
The row should feel resolved, not tempting.
It stays understandable but visibly retired from the active spend comparison set.

---

## Ownership rules

### HUD ownership
The HUD continues to own the high-level next-step read:
- before affordability: threshold progress or `one more pumpkin` style guidance
- after affordability: `return now` or `finish this action, then return`

The HUD must **not** try to enumerate every ready upgrade.
At most it says `Upgrade available` or an equivalent timing line.

### Row ownership
Upgrade rows own the detailed answer to `which pad is live right now?`
They do this through state contrast, not long extra explanation.

### Hard rule
Do not duplicate the same message in both places.
Example of failure:
- HUD says `Footwork ready now`
- row also loudly says `READY NOW`
- purchase prompt also says the same thing

That creates echo instead of clarity.

Preferred split:
- HUD: `Upgrade available.`
- row: shows which options are buyable through concise state styling/copy

---

## Row presentation rules

### ReadyNow rows
A ready row should become the clearest row in the stack, but still remain calmer than:
- the active plaza prompt
- purchase world popup
- top-banner purchase result

Desired read:
`This one is available right now.`

Presentation expectations:
- stronger text contrast than locked rows
- concise affirmative cost treatment such as `Ready now` or `Buy for 20`
- keep the benefit fantasy visible (`Run faster`, `Break faster`, `More seeds`)
- avoid adding a second sentence

### LockedNear rows
This state helps when no option is affordable yet.
The row may remain slightly brighter or cleaner than other locked rows if it aligns with the HUD's current threshold coaching.

Desired read:
`This is the next meaningful buy, but not yet.`

Presentation expectations:
- slightly stronger than `LockedFar`
- cost can read as `20 next` / `10 more` style support
- never brighter than a `ReadyNow` row

### LockedFar rows
Desired read:
`Useful later, not your current concern.`

Presentation expectations:
- quietest active comparison state
- preserve role clarity, reduce urgency
- do not let far future rows compete with the newly unlocked reward beat

### Maxed rows
Desired read:
`Done.`

Presentation expectations:
- resolved tone
- concise `MAX` treatment is enough
- lower urgency than both locked and ready rows

---

## Threshold-crossing handoff rule
When the player's money crosses from `no upgrades affordable` to `one or more upgrades affordable`, preserve a short handoff window where the affordability state stays especially easy to notice.

This handoff should:
- reinforce that the latest payout changed something real
- support the existing `return to plaza` guidance
- fade back into ordinary row states after a short beat

### Constraints
- the handoff must yield to stronger local commitments
- it must not override danger/recovery ownership
- it must not keep repeating every frame while money remains affordable

### Desired feel
The player feels:
`That pumpkin unlocked a real buy.`
not
`The UI is suddenly nagging me to leave.`

---

## Multiple-affordable contract
When two or more upgrades are affordable:
- all affordable rows may enter `ReadyNow`
- one of them may be visually first only by spatial/order convention, not by strategic recommendation
- the system must not invent a hidden `best choice` message

Desired read:
`I have real options.`
not
`The game picked my build for me.`

This keeps player agency intact while still making the choice set legible.

---

## Plaza prompt relationship
Prompt ownership still outranks passive row readability.
If the player walks onto a specific pad:
- the prompt becomes the commitment owner
- the row remains supporting context
- row emphasis should not fight the prompt's local action clarity

In other words:
- rows help scanning before commitment
- prompt helps acting after commitment

---

## User flows

### Flow 1 — Crossing the first threshold
1. Player has 10 money.
2. HUD says one more pumpkin reaches a plaza buy.
3. Player breaks a pumpkin and reaches 20.
4. HUD flips to upgrade-available timing guidance.
5. At least one row now clearly reads as live.

Desired feel:
The payout feels like an unlock, not just a number increase.

### Flow 2 — Affordable while still locally occupied
1. Player can afford a buy.
2. They are still on a pumpkin or swallow beat.
3. HUD says return after this action.
4. Rows remain ready, but do not shout over the local commitment.

Desired feel:
The game is informative, not pushy.

### Flow 3 — Return to plaza with multiple options ready
1. Player comes back with enough money for several upgrades.
2. Multiple rows read as `ReadyNow`.
3. Locked/maxed rows stay quieter.
4. Stepping onto a pad hands local ownership to that prompt.

Desired feel:
The plaza reads as a clean choice moment instead of a text wall.

### Flow 4 — Late game maxed state
1. One or more upgrades are maxed.
2. Those rows feel resolved.
3. Remaining ready/locked rows still compare cleanly.

Desired feel:
Finished upgrades no longer pollute the active decision set.

---

## Server logic
No new server systems required.
No new economy state required.
No new remotes required.

All needed data already exists in current structure:
- money
- upgrade levels
- next costs
- affordability by upgrade
- active prompt ownership
- recent upgrade purchase context

---

## Client logic follow-through
Helpful derived helpers:
- `getUpgradeRowState(upgradeId, playerState)`
- `getAffordableUpgradeIds(playerState)`
- `hasJustCrossedAffordability(previousMoney, currentMoney, upgradeState)`
- `getNearestLockedThresholdId(playerState)`

### Derivation order
1. if upgrade maxed -> `Maxed`
2. else if affordable -> `ReadyNow`
3. else if it matches the current nearest-threshold support target -> `LockedNear`
4. else -> `LockedFar`

### Copy discipline
Keep row state language short.
Avoid stacking:
- long benefit sentence
- exact level ladder
- exact affordability delta
- recommendation phrasing
in one line.

Preferred pattern:
- role / benefit
- one compact state read

Examples:
- `Footwork — Ready now`
- `Quick Hands — 10 more`
- `Blessing — MAX`

---

## Failure / edge cases
- **All three options affordable:** acceptable; all may read ready if contrast remains controlled.
- **Player has affordability but never returns to plaza:** acceptable; rows should inform, not coerce.
- **Threshold handoff fires during a stronger prompt-owned beat:** local ownership still wins.
- **Future reward tuning changes cost cadence:** row states must derive from actual cost/level data, not hard-coded assumptions.
- **Mobile / small screen:** brevity matters more than extra styling.

---

## Validation method
1. Start below first threshold and confirm one row can read as the nearest future buy without becoming louder than the HUD.
2. Cross into first affordability and confirm at least one row/pad becomes obviously live.
3. Cross into affordability while standing on a local prompt and confirm local commitment still owns the action read.
4. Return to plaza with multiple affordable rows and confirm the choice set feels open but not noisy.
5. Max one row and confirm it recedes cleanly from active comparison.
6. Buy an upgrade and confirm the purchase popup still feels stronger than passive ready-row styling.
7. Run repeated loops and confirm reward feel improves because `money gained` more clearly turns into `spend now possible`.

---

## PM handoff
Use this as a low-scope completion pass underneath the existing threshold-clarity and plaza-role-clarity work.
It closes the final readability gap between `upgrade available` guidance and a fast visual answer to `which plaza choices are live right now?`.