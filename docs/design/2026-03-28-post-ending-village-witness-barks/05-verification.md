# Verification

## Design Checks
- [x] Feature answers a real next-gap in the current codebase
- [x] Theme remains strongly Heungbu/Nolbu aligned
- [x] Player interaction is concrete and optional
- [x] No new progression state is required
- [x] Roblox implementation path is realistic with existing prompt/dialogue patterns
- [x] Rojo-safe structure is preserved
- [x] Failure cases are bounded
- [x] Spam risk is explicitly controlled
- [x] MVP scope is small enough for a focused PM/Dev hand-off

## Walkthrough Test
1. Finish on restoration and enter `COMPLETE`.
2. Interact with two restoration witnesses.
3. Confirm their lines reflect restoration tone rather than generic village flavor.
4. Complete enough shared drops to rotate support points and reach Tier 1.
5. Re-check the same witnesses and confirm at least one line family now acknowledges stocking / shared-route normalization.
6. Repeat the flow on tribute and confirm the witness tone becomes orderly, colder, and more supervised.
7. Confirm no witness is confused with a new quest giver.

## Resolved Decisions
- Witnesses are **player-pulled**, not autoplay chatter.
- Two witness points per branch are enough for MVP.
- Point/tier variation is allowed, but only where it creates a noticeable read; base branch-aware lines are mandatory, deeper branching is optional.
- The feature reuses dialogue infrastructure and does **not** introduce a new reward loop.

## Final Decision
Ready for PM/Dev hand-off.
Preferred build order: witness interaction points -> branch-aware line pools -> tier-aware variants -> optional active-point-specific variants.