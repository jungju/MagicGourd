# Verification

## Completeness Check
- Includes player flow for onboarding and repeated arcade play.
- Defines guidance priority, status hierarchy, upgrade readability, feedback semantics, and copy consistency.
- Reuses existing client attributes, upgrade config, and feedback remote.
- Avoids new replicated state, new systems, or story expansion.

## Why this is needed now
The arcade loop is already playable. The bigger risk now is that players understand it too slowly or feel low-grade friction every minute because the UI ranks information poorly. This pass improves comprehension and completion value without touching scope.

## Fun / Feel Check
- Stronger "I know what to do" feeling.
- Cleaner spend decisions in plaza.
- Better danger interruption read when goblins slow the player.
- More satisfying reward feel through clearer feedback wording.

## Conflict Check
- No economy change.
- No new world-state logic.
- No networking rewrite.
- No collision with current prompt flow because the design only sharpens client-facing presentation.

## Roblox / Rojo Feasibility
- Fully realistic with the current `init.client.luau` structure.
- Table/helper-driven copy changes are Rojo-safe.
- No dependence on heavy UI frameworks, animation systems, or Studio-authored cutscenes.

## Implementation Checklist
- [ ] `Next:` guidance line added with deterministic priority rules.
- [ ] `Status:` line rewritten to summarize current condition.
- [ ] Upgrade rows show level progression, affordability, and max state clearly.
- [ ] Bottom button copy shifts from generic seed use to planting clarity.
- [ ] Feedback banner uses event-specific copy buckets.
- [ ] Verb naming stays consistent across button, prompts, and feedback.
- [ ] Slow state visually and textually overrides ordinary farming guidance.

## Final Verdict
Adopted and ready for PM/Dev hand-off.

This is the right refinement because it improves flow clarity, readability, interaction polish, and coherence exactly where the current playable structure is weakest — and it does so without inventing a bigger game.