# Verification

## Checklist
- [x] Stays inside current arcade loop structure
- [x] Does not add a new recommendation/build system
- [x] Improves readability and reward feel rather than scope
- [x] Preserves prompt ownership over passive row readability
- [x] Works with existing HUD / upgrade rows / purchase feedback
- [x] Covers single-affordable, multi-affordable, and maxed states
- [x] Gives a concrete validation method for Studio and live iteration

## Why this pass clears the bar
This refinement answers a very practical player question that still costs too much attention right now:
`I can buy something now — what is actually live?`

It does so without reopening economy balance or adding a new widget stack.
That keeps the pass aligned with refinement mode.

## Expected player-visible improvement
- payout thresholds feel more satisfying
- plaza scanning becomes faster
- ready choices feel deliberate
- maxed / future choices stop competing as hard with immediate action

## Failure condition
Reject or revise this pass if implementation pressure starts pulling toward:
- explicit build recommendation logic
- large new HUD elements
- duplicated `ready now` messaging across HUD, prompts, and rows
- louder UI that reintroduces clutter solved by earlier passes

## Final verdict
Adopt.
This is a bounded completion move with strong payoff-to-effort value inside the current design structure.