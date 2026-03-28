# Verification

## Design Checks
- [x] Theme is clearly Heungbu/Nolbu aligned
- [x] Player action loop is concrete
- [x] Reward loop remains explicit and unchanged in scope
- [x] States and transitions are defined as derived presentation tiers
- [x] Roblox implementation path is realistic with runtime-authored props
- [x] Rojo-safe structure is preserved
- [x] Fallback path exists if props are noisy or omitted
- [x] UI / dialogue requirements are minimal and specified
- [x] Failure cases are documented
- [x] MVP scope is bounded

## Walkthrough Test
1. Finish the game on restoration and enter `COMPLETE`.
2. Confirm support-point hints/signs begin at Tier 0.
3. Complete 3 restoration errands and verify Tier 1 sign/prop updates.
4. Complete 6 restoration errands and verify Tier 2 updates.
5. Repeat on tribute and confirm the village reads more regulated rather than communal.
6. Rejoin after Tier 2 and confirm presentation is recomputed from saved counters.

## Resolved Decisions
- Landmark props/signs are **village-global for readability**, while active support-point acceptance remains **per-player**.
- Tier transitions remain **environmental in MVP**; stronger one-time pulses are deferred unless playtest readability is poor.
- If three-point coverage feels noisy, landmark accrual may ship with **two prop-bearing points per branch** and leave the third point as sign-only flavor.

## Final Decision
- Ready for implementation.
- Preferred build order: derived tier helper -> sign/hint tiering -> two-point prop clusters per branch -> optional third-point accents only if readability remains strong.
