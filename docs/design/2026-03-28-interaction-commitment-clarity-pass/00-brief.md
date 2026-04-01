# Brief

## Refinement Goal
Tighten **interaction commitment clarity** inside the existing arcade loop so repeated play feels deliberate instead of slightly mushy whenever multiple valid inputs are nearby.

This is not about adding new verbs. It is about making current verbs feel more intentional:
- `Heal`
- `Plant`
- `Break`
- `Buy`

## Current Completion Gap
Recent passes already improved:
- HUD next-step clarity
- plaza role clarity
- feedback anchor consistency
- spatial readability budgets

The remaining polish gap is more tactile than textual:
- the bottom `Use Seed` button can stay visible in states where the authored default beat lives elsewhere
- swallow / plaza / pumpkin interactions all use ProximityPrompt, but their commitment feel is not yet described as a single contract
- the loop has good **decision clarity**, but weaker **input clarity** when the player is physically near multiple opportunities

The game currently teaches the right loop, but some moments may still feel like:
- `I know the plan, but the interaction surface is a little too eager/noisy.`
- `The game says break first, but the always-present plant button still competes for my eye.`
- `Plaza buy is intentionally tighter than other prompts, but that commitment hierarchy is not yet formalized as a design rule.`

## Desired Player Feeling
The player should feel:
- `When I approach something, the right interaction feels deliberate.`
- `Urgent/local actions win the read.`
- `Secondary options stay available without stealing the moment.`
- `The loop feels authored even when several valid actions coexist.`

## Scope Boundary
This pass is **not**:
- a control remap system
- a new tutorial layer
- a new targeting mechanic
- a new action queue
- a new UI surface

This pass **is**:
- input-surface hierarchy
- commitment-distance coherence
- support-button discipline
- local interaction ownership rules
- edge-case guidance for overlapping opportunities

## Refine Targets
1. Seed button competition against local object work
2. Prompt commitment hierarchy across village / pumpkin / plaza
3. Break-vs-buy ownership when both are available
4. Safe-side recovery interaction feel after goblin slow
5. Repeated loop readability on desktop/mobile touch

## Success Condition
A repeat player should be able to move through heal -> plant -> break -> buy without feeling like the UI or nearby prompts are arguing about which action currently owns the moment.