# World Popup Readability Pass - Adopted Design

## Why now

The current arcade loop already ships world-anchored feedback for heals, planting, breaks, payouts, upgrades, and goblin slows.
That improves locality, but repeated loop actions can stack multiple billboard popups in nearly the same place and make short feedback harder to read during fast play.

This is a refinement problem, not a feature gap.

## Chosen refinement

Improve only the client-side world popup presentation.

### In scope
- keep the existing server feedback payload contract unchanged
- keep banner + world-popup split unchanged
- reduce overlap when multiple events fire from the same local area in quick succession
- allow slightly larger popup bounds for longer short-text labels

### Out of scope
- no economy changes
- no quest/progression changes
- no new remotes or gameplay state
- no timing/cadence retune for reward values

## UX intent

When several popups appear from the same anchor area:
- the first popup should appear in the usual local spot
- later popups should stack upward instead of fully colliding
- small left/right staggering is acceptable if it improves legibility
- longer labels should wrap instead of shrinking into mush

## Implementation plan

In `src/client/init.client.luau`:
1. Bucket nearby popup positions into a coarse world-space key.
2. Track how many popups are currently active in that bucket.
3. Spawn each new popup with:
   - a higher Y offset based on active bucket count
   - a small alternating lateral offset
4. Increase billboard size for longer popup text.
5. Preserve automatic cleanup and decrement the bucket count when the popup finishes fading.

## Failure / edge cases

- If bucket tracking fails, popups should still appear normally.
- If the same area gets spammed, only presentation shifts; gameplay remains unchanged.
- If a popup text is short, it should retain a compact footprint.

## Validation

- Trigger repeated pumpkin hit feedback in one area and confirm labels no longer fully overlap.
- Trigger repeated upgrade/heal interactions and confirm the first popup still appears near the anchor.
- Confirm cleanup does not leave orphaned anchors or growing counters.
