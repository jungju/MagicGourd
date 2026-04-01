# Feature Brief

## Name
Lane Landmark Consistency Pass

## Problem
The current arcade loop already has the correct macro structure, but its lane identity is still authored mostly by zone pads, prompts, and a few props. That is enough for function, but not yet a full consistency contract.

Without a specific landmark rule set, small future tuning can drift:
- the village lane can lose its "go here first" readability
- the center lane can feel half-plaza, half-planting route
- the danger route can read as merely darker space instead of deliberate risk
- props and signs can solve local problems while weakening whole-map coherence

The current project needs refinement inside the existing layout, not more systems.

## Desired Player Experience
A player should be able to feel the route logic from the environment even before reading full sign text:
- left lane feels like the kindness / healing path
- center lane feels like the plant-and-cash corridor
- right lane feels like a knowingly risky detour
- plaza feels like a reset / spend island, not a spillover of every other action

## Why Now
Most major readability passes already improved prompts, HUD guidance, and popup discipline. The remaining high-value completion gap is spatial coherence across the whole route. This is especially relevant because the blocked Studio validation bucket still depends on whether movement lanes read cleanly in live play.

## Constraints
- Roblox constraints: Use current world parts, signs, lanterns, paths, rocks, and pads. No new systems.
- Rojo constraints: Keep changes representable as small world-authoring adjustments inside existing `ArcadeWorld` structure.
- Narrative constraints: Stay aligned with Heungbu kindness / harvest / Nolbu danger framing.
- Scope constraints: No new mechanics, no extra branches, no new resource types, no onboarding overlay.

## Existing Systems Touched
- `ArcadeWorld.luau`
- existing zone billboards
- existing lantern / rock / path placement
- existing validation contract docs

## Success Signal
A future Studio pass can judge lane clarity using a stable landmark grammar instead of ad hoc taste, and small placement tweaks will preserve whole-map coherence rather than solving only local clutter.