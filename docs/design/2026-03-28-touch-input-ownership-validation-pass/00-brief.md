# Touch Input Ownership Validation Pass

## Why this pass exists

MagicGourd's current arcade loop is already mechanically small and much more coherent than earlier passes:
- next-step HUD priority is defined
- prompt reach and plaza spacing are tighter
- world-popup / banner ownership is more disciplined
- local-vs-remote readability is authored for multiplayer overlap

The remaining under-specified gap is **touch/mobile input ownership during real play**.

Desktop readability has strong authored rules now.
Touch readability is still mostly implied.
That is risky because the live loop depends on a small set of repeated commitments:
- heal
- plant
- break
- buy
- retreat / recover

On touch, the player should never have to guess whether the bottom CTA or a nearby prompt is the intended commitment owner.

## Refine targets (3-7)
1. Bottom CTA vs local prompt ownership on touch
2. Prompt-entry grace timing while moving through village / plaza / center lane
3. Safe suppression rules when a touch player stands near multiple valid actions
4. Recovery-state clarity when slowed and the player still has a tappable CTA
5. Studio/mobile validation scenes for prompt/button competition

## Scope goal
Create a refinement-only design contract that makes touch/mobile play feel deliberate and readable **without**:
- adding a new control system
- adding tutorial overlays
- adding new mechanics
- changing the core arcade loop

## Desired outcome
A PM/dev tester should be able to run a short mobile-oriented Studio validation pass and answer:
- does the touch player always know which action owns the screen right now?
- does the CTA stay available when useful, but secondary when a stronger nearby commitment exists?
- do prompt/button collisions resolve with the smallest lever first?
