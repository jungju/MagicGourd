# Verification

## Design Checks
- [x] Addresses a real next-gap in the implemented post-ending loop
- [x] Keeps strong Heungbu/Nolbu branch identity
- [x] Improves player readability without adding new progression rules
- [x] Stays compatible with existing support rotation and landmark accrual systems
- [x] Uses realistic Roblox-friendly primitive/runtime-authored props
- [x] Avoids HUD or VFX bloat
- [x] Defines clear overlap-cut rules when clutter appears
- [x] Keeps MVP scope small and implementation-ready

## Walkthrough Test
1. Reach `COMPLETE` on restoration.
2. Verify the restoration active point has a visible route-cue cluster.
3. Rotate to the next restoration support point and confirm the cue emphasis moves with it.
4. Confirm the old point no longer reads as the primary active node.
5. Repeat at landmark Tier 1 or Tier 2 and confirm clutter remains controlled.
6. Repeat the same loop on tribute and confirm the path feels more formal and constrained.
7. Confirm the player can still rely on signs/hints as fallback, but no longer needs them as the first read.

## Resolved Decisions
- Route cues are environmental emphasis, not objective arrows.
- Landmark accrual props remain the persistent layer; route cues remain the active-point layer.
- If per-player prop presentation is awkward, route cues may stay branch-global and act as supportive flavor rather than exact routing authority.
- One readable cue cluster per point is enough for MVP.

## Final Decision
Ready for PM/Dev hand-off.
Preferred build order: cue clusters per point -> active-point toggling -> clutter trim against landmark props -> optional short approach cues only if needed.