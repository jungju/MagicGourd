# Verification

## Design Checks
- [x] Stays inside the current shared arcade loop
- [x] Does not add new mechanics or scope
- [x] Defines the player-visible problem clearly
- [x] Explains local-vs-remote readability priority
- [x] Covers village, center lane, plaza, and danger overlap
- [x] Uses existing ownership semantics instead of replacing them
- [x] Gives Studio-paired validation scenes
- [x] Keeps Roblox / Rojo implementation expectations realistic

## Walkthrough Test
1. Spawn player A at plaza and let player B already cross center-lane space.
2. Confirm A still reads village-first as the correct zero-resource move.
3. Move A and B into village and confirm one swallow prompt still feels like A's commitment at approach distance.
4. Let A plant in the center lane while B triggers a nearby payout; confirm A's pumpkin still reads as A's next job.
5. Let B buy an upgrade while A approaches another plaza pad; confirm A can still parse one clear `Buy` commitment.
6. Push both players into Nolbu-side traffic and confirm a slowed player still gets one readable safe retreat lane.

## Failure Signals
- Another player's popup or purchase beat becomes the strongest local read too often.
- Shared prompts flatten into several equal choices from one stopping point.
- Center-lane ownership becomes vague when two players overlap around pumpkins.
- Retreat clarity collapses once multiple players and goblins share the same corridor.

## Final Decision
- Ready as a low-scope multiplayer completion contract under the current refinement mode.
- If Studio validation exposes a real failure, fixes should remain limited to copy/priority/offset/distance/spacing tuning before any heavier changes are considered.
