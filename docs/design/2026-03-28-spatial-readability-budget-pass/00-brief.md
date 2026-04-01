# Brief

## Pass Name
Spatial Readability Budget Pass

## Mode
Refinement / completion only

## Why this pass exists
Recent refinement work already improved:
- loop copy coherence
- event feedback anchor consistency
- Studio validation criteria

What is still under-authored is the **spatial budget** that keeps those wins stable in practice.

The current arcade loop depends on a few shared spaces doing a lot of work at once:
- spawn sign vs visible plaza pads
- village swallow prompts vs support signs
- center planting lane vs plaza buy prompts
- danger route telegraph vs first goblin contact

Right now the docs describe the desired feel, but not the tighter placement rules that keep prompt competition and visual crowding under control.

## Design goal
Define a small set of **placement / distance / visual-band rules** that protect readability inside the existing map.

This pass should help answer:
- how close prompts are allowed to compete
- when a sign is too tall / too wide / too central
- how much breathing room the planting lane needs from plaza pads
- how much sightline warning the danger route needs before the first slow

## Constraints
Do not add:
- new mechanics
- new UI systems
- new props just to solve readability
- new tutorial layers
- new traversal branches

Prefer:
- small spacing adjustments
- prompt distance tuning
- billboard offset/size tuning
- copy shortening before layout growth

## Expected output
A concrete readability-budget design that a dev can use during Studio tuning without re-litigating the whole loop.