# Analysis

## Scoring
1-5 scale. Higher is better except Risk, which is noted separately.

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual / Emotional Payoff | Notes |
|---|---:|---:|---:|---:|---:|---|
| A — Hierarchy contract only | 4 | 4 | 5 | 4 | 4 | Good low-risk cleanup, but still leaves some billboard depth/priority rules implicit. |
| B — Plaza-only quieting | 4 | 4 | 5 | 3 | 4 | Useful hotspot fix, but too localized for the number of support signs already in the world. |
| C — Full billboard presentation contract | 4 | 5 | 4 | 5 | 5 | Best completion move if tightly scoped to existing sign classes and no new UI systems. |

## Theme Fit
All candidates preserve the Joseon / Heungbu arcade tone because they refine authored signage rather than replacing it with abstract HUD-first teaching.

## Player Value
Candidate C wins because the player experiences billboard density in multiple places:
- spawn first read
- village approach
- center lane near plaza spill
- plaza choice moment
- danger-edge warning

A reusable contract improves all of them.

## Implementation Confidence
Candidate A/B are slightly safer because they are narrower.
Candidate C is still realistic because the current world-building path is centralized in `ArcadeWorld.luau`, so sign presentation rules can remain local and Rojo-safe.

## Coupling to Current Code/Map
High and healthy. Existing sign creation is already funneled through `attachBillboard()` and `createSignPost()` plus the zone/pad build paths. That means a presentation contract can be applied without changing gameplay architecture.

## Risks / Dependencies
- Risk: accidentally expanding into a full UI art pass.
- Risk: over-tuning sign visuals before Studio confirms an actual readability issue.
- Dependency: must remain subordinate to prompt and popup readability rules already established.

## Why Candidate C Is Still Best
The project already has strong rules for:
- verbs
- prompt distance
- popup intensity
- visual band separation

What is still under-authored is the **internal visual grammar of support billboards themselves**. Candidate C closes that gap while staying inside the existing structure.