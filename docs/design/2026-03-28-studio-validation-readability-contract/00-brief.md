# Brief

## Refinement Target
Turn the remaining blocked Studio-readability work into a concrete validation-and-tuning contract for the current arcade loop.

## Why This Pass Exists
Most high-value authored refinements are already documented and, per PM, largely implemented:
- next-step HUD guidance
- copy coherence
- event feedback anchor consistency

The biggest remaining completion risk is softer and easier to miss in doc review:
- prompt competition at close range
- billboard readability while moving
- plaza/village/danger lane clarity
- popup overlap during repeated fast loops
- goblin pressure readability near the route edge

Right now those items live as a broad blocked bucket in PM. That makes it too easy for future work to either drift into expansion or stall because no one knows what "good enough" means.

## Design Goal
Define exact validation scenes, pass/fail rules, and low-scope tuning levers so the team can refine the shipped arcade structure without inventing new mechanics.

## Scope
### In scope
- traversal readability between the three existing zones
- prompt visibility / competition rules
- billboard legibility rules
- popup overlap / cadence rules
- goblin pressure edge readability
- exact order of operations for live tuning

### Out of scope
- new zones
- new tutorial systems
- new map landmarks
- new UI surfaces
- combat or economy rebalance
- expanding goblins into a larger enemy system
