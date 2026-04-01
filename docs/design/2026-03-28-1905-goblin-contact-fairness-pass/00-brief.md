# Brief

## Context
MagicGourd's arcade loop already has the right structure, but the biggest remaining live-feel risk is still goblin contact fairness inside Nolbu Area. The current game already improved signposting, danger-edge sightlines, retreat guidance, and slow recovery messaging, yet MG-PM-408 remains blocked because the exact chase/contact feel still needs a tighter completion contract.

## Refinement target
Refine the **highest-value precision gap** still inside the current loop:
- goblin approach readability
- first-contact fairness
- retreat-window clarity
- chase reset coherence

## Scope guard
Do not add new enemies, new warning UI, new combat systems, damage, stun chains, patrol trees, or alternate danger mechanics.

## Desired result
The player should feel:
- `I knew I was entering danger before I got tagged.`
- `That slow felt like readable pressure, not random body-check noise.`
- `Pulling back gives me a clear reset window.`
- `Re-entering danger feels deliberate, not messy.`

## Deliverable
A bounded design pass that turns goblin feel into a low-scope validation/tuning contract for the existing runtime, config, and world layout.