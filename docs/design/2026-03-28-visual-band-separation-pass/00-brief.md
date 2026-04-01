# Brief

## Title
Visual Band Separation Pass

## Why now
Recent refinement passes already tightened:
- lane ownership
- prompt reach
- feedback anchors
- feedback cadence
- plaza choice roles

The main remaining completion gap inside the current structure is not a missing mechanic. It is the lack of a single authored rule set for how **signs, prompts, and world popups share the same camera slice** without fighting each other.

Several existing docs mention overlap as a symptom, but the project does not yet have one compact design artifact that defines the intended visual-band hierarchy.

## Target outcome
Create a small refinement-only contract so:
- prompts stay in the decision band
- world popups stay in a short feedback band
- billboards stay in a support band
- the player can parse action, payoff, and direction without text stacks collapsing together

## Scope boundary
In scope:
- billboard offset/size/copy discipline
- prompt vs sign vs popup layering rules
- scene-based validation criteria
- small world-placement tuning guidance

Out of scope:
- new UI surfaces
- new mechanics
- new VFX systems
- map expansion
- tutorial rewrites
- reward/economy changes
