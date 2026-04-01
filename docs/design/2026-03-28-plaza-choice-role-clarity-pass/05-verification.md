# Verification

## Checklist
- [x] Stays inside the current arcade loop
- [x] Adds no new upgrade types, currencies, or systems
- [x] Focuses on flow clarity, readability, reward feel, and coherence
- [x] Reuses current plaza pads, HUD rows, prompt structure, and feedback architecture
- [x] Defines concrete wording/role rules that implementation can follow directly
- [x] Avoids duplicating the earlier generic verb-consistency pass by targeting upgrade-role differentiation specifically

## Why this pass is safe
This refinement does not ask the game to grow.
It only makes the existing **buy** step as self-explanatory as the heal / plant / break steps already are.

## Expected improvement
If followed, players should:
- identify each plaza choice faster
- feel more confident about why they bought a given upgrade
- read purchase feedback as a meaningful route decision rather than pure accounting
- carry a clearer expectation into the very next loop

## Remaining boundaries
This pass intentionally does **not** solve:
- live Studio pathing validation
- goblin movement fairness tuning
- broad map geometry changes
- new tutorial or onboarding systems

Those remain separate and should only be touched if later validation proves they are needed.

## Final verdict
**Passes verification.**

This is a high-value refinement artifact because it closes a small but central completion gap: the plaza spend step now has a clearer authored identity within the existing arcade structure.
