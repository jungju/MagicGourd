# Brief

## Title
Plaza ready-state clarity pass

## Why now
Recent refinement work already improved:
- payout-to-threshold meaning
- plaza role copy
- prompt ownership
- world-popup clutter control

The remaining low-scope completion gap is the moment when money crosses an upgrade threshold.
The game can now tell the player that a plaza buy is available, but the plaza/HUD package still lacks one especially crisp answer to:

`Which upgrade pad is ready right now, and how should that readiness read without adding noise?`

That gap weakens three feelings:
- reward feel after a payout that unlocks affordability
- quick plaza scanning under movement pressure
- completion polish when one row should obviously step forward and the others should step back

## Scope
This pass refines only the existing plaza/HUD/readability structure.

In scope:
- ready / not-ready / max row-state presentation rules
- single-owner readiness emphasis between HUD and plaza rows
- threshold-crossing follow-through behavior
- validation for one-affordable / many-affordable / maxed states

Out of scope:
- new upgrade mechanics
- new spend recommendation systems
- cost/reward rebalance
- extra panels, arrows, or tutorial overlays
- changing plaza layout

## Intended outcome
When affordability opens, the player should feel one clean read:
- `A buy is ready now.`
- `This row/pad is live.`
- `The others are comparison context, not equal-weight clutter.`

The result should strengthen reward satisfaction and plaza decisiveness without making the UI louder.