# Brief

## Design Goal
Refine the highest-value remaining completion gap inside the current arcade loop: **shared-world readability when multiple players occupy the same slice**.

The solo readability passes already define:
- prompt distance discipline
- billboard support-band discipline
- popup cadence / intensity
- danger-entry fairness
- one-default-next-step HUD guidance

What is still under-specified is what should happen when another player is present in the same lane and their swallows, pumpkins, popups, and movement briefly share the frame.

This pass does **not** add new systems. It defines low-scope refinement rules so the existing shared multiplayer loop keeps its authored clarity under overlap.

## Why Now
The repo baseline is already in refinement/completion mode. Most single-player readability gaps have a contract. The next precision opportunity is making sure that the same authored loop survives:
- two players healing near the village
- one player planting while another is buying in plaza-adjacent space
- multiple pumpkin feedback beats appearing in the center lane
- goblin pressure happening while another player crosses the same retreat lane

If this is not authored, the game can feel "finished on paper" but noisy in real shared play.

## Scope Boundary
In scope:
- prompt ownership expectations in shared slices
- local-vs-remote feedback priority
- safe visual/pop-up expectations when several players overlap
- Studio validation scenes for 2-player readability

Out of scope:
- new HUD widgets
- player outlines / nameplate systems
- private instances or lane splitting
- party systems / co-op rules changes
- new onboarding/tutorial features
