# Verification

## Completeness Check
- Includes player flow for ordinary post-ending revisits.
- Defines dialogue selection inputs, runtime rules, and scope limits.
- Reuses existing branch, tier, support-point, and rare-event state instead of adding another system.
- Leaves quest structure, economy, and map layout unchanged.

## Why this is needed now
The project's post-ending stack has become world-readable. What still under-delivers is emotional continuity with the story's two main figures. This pass fixes that without reopening core quest production.

## Fun / Feel Check
- Makes repeat play feel personally acknowledged.
- Reinforces the moral contrast between restoration and tribute.
- Gives the player a reason to check back with the brothers occasionally, without making those revisits mandatory.

## Conflict Check
- No collision with quest progression because all logic is gated to `COMPLETE`.
- No economy inflation because the feature adds no rewards.
- No readability conflict if point-aware references stay sparse and witnesses remain the more local flavor layer.

## Roblox / Rojo Feasibility
- Table-driven dialogue additions fit the current server-authoritative pattern.
- No new assets, rigging, or client-only systems required.
- Safe to manage in Rojo because it is mostly line-table and branch-selection work.

## Implementation Checklist
- [ ] Heungbu has restoration + tribute `COMPLETE` line pools.
- [ ] Nolbu has restoration + tribute `COMPLETE` line pools.
- [ ] Tier 1 / Tier 2 tone upgrades are represented.
- [ ] Rotation avoids immediate repeats.
- [ ] Optional support-point mentions stay occasional.
- [ ] Optional rare-event echoes do not spam.
- [ ] Existing pre-`COMPLETE` dialogue remains untouched.

## Final Verdict
Adopted and ready for PM/Dev hand-off.
This is a focused next step that strengthens the story core, respects the existing replay-loop architecture, and avoids more document churn than the implementation opportunity warrants.
