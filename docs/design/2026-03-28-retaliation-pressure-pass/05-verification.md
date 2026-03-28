# Verification

## Design Checks
- [x] Theme is clearly Heungbu/Nolbu aligned
- [x] Player action loop is concrete
- [x] Reward loop is explicit
- [x] States and transitions are defined
- [x] Roblox implementation path is realistic
- [x] Rojo-safe structure is preserved
- [x] Fallback path exists for fragile assets
- [x] UI / dialogue requirements are specified
- [x] Failure cases are documented
- [x] MVP scope is bounded

## Walkthrough Test
1. Finish the swallow healing and blessed harvest arc.
2. Deliver the true magic gourd to Heungbu and trigger the ceremony.
3. Speak with Nolbu and trigger retaliation.
4. Return to the patch and confirm both brambles and a disrupted support point are visible.
5. Clear the brambles.
6. Confirm the quest now asks for valley stabilization instead of jumping straight to the final audience.
7. Repair the support point.
8. Confirm restoration feedback plays and the quest advances to `FINAL_AUDIENCE`.
9. Finish the ending choice flow and verify nothing in the new pressure pass breaks the finale.

## Open Questions
- Should the MVP support point be the yard lantern, well-side frame, or story stone marker?
- Does PM want the repair beat counted as pure story progression only, or also tracked in village counters for signage?
- Is one extra restoration banner enough, or should the support-point repair rely mostly on dialogue/world-state change?

## Final Decision
- Ready for implementation