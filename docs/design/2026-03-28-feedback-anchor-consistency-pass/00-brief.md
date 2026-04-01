# Brief

## Context
The current arcade loop is mechanically coherent and the latest refinement passes already improved verb consistency, next-step clarity, and upgrade readability. The remaining visible polish gap is not what the player should do — it is **how strongly and where the game acknowledges each action**.

Right now:
- banner feedback exists and is readable
- world popups exist for swallow/pumpkin events
- some events have no world anchor at all (upgrade buy, upgrade fail, slow fade)
- some event categories share similar strength even when their emotional payoff should differ
- popup placement rules are implicit rather than authored

That creates a subtle completion problem: the loop works, but the reward feel and placement consistency are uneven.

## Refine Targets
1. Reward feedback placement consistency across swallow / pumpkin / upgrade / goblin events
2. Event intensity hierarchy so high-payoff moments land harder than routine state updates
3. World popup anchoring rules so text appears where players expect it
4. Banner/detail length discipline so reactive UI stays glanceable
5. Multi-event overlap behavior so repeated actions do not feel noisy or mushy

## Why This Matters Now
Refinement mode should avoid new systems and instead make the current loop feel authored. A feedback consistency pass improves:
- reward feel without rebalance
- readability without tutorial bloat
- polish across the whole loop
- perceived fairness because players can connect actions to results faster

## Scope Guard
This pass must stay inside the current structure.

### In scope
- feedback presentation rules
- event-to-surface mapping
- world anchor placement rules
- tone/intensity rules
- small data/schema additions only if they support existing feedback transport

### Out of scope
- new mechanics
- new currencies
- new progression systems
- persistent combat text system expansion
- screen shake / camera systems / particles unless already trivial and directly tied to current feedback payloads
