# Analysis

Scoring: 1 (weak) to 5 (strong)

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A — Ambient Ending Mood Layer | 5 | 5 | 5 | 5 | 4 | 2 | Best fit for current architecture. Makes endings linger without new quest sprawl. |
| B — Ending-Specific Free-Play Tasks | 4 | 4 | 3 | 4 | 4 | 3 | Strong follow-up, but adds economy/state logic and more balancing surface. |
| C — Conflict Echo Layer | 5 | 4 | 4 | 4 | 4 | 3 | Good story continuity, but can feel negative/repetitive if not paired with clearer world read. |
| D — Branch-Aware Ambient Dialogue Pack | 4 | 3 | 5 | 3 | 2 | 1 | Cheap and safe, but too small on its own; mostly text-only payoff. |
| E — Ending Landmark Prop | 4 | 4 | 3 | 3 | 5 | 3 | Nice screenshot value, but can become a one-off prop instead of a systemic village tone. |

## Candidate A — Ambient Ending Mood Layer
- **Heungbujeon theme fit:** very strong; the valley should visibly reflect whether kindness or tribute won.
- **Player value:** high because the ending becomes persistent, readable, and screenshot-able.
- **Implementation:** high confidence using current attributes, billboards, patch mood, and branch-aware dialogue hooks.
- **Risk:** low; mostly additive and does not require rebasing the questline.
- **MVP vs expansion:** MVP can be signage + patch + prompt text + NPC ambient responses. Expansion can add repeatable tasks later.

## Candidate B — Ending-Specific Free-Play Tasks
- **Theme fit:** strong; each ending should imply a different "what now?"
- **Player value:** high if done well, because it gives mechanical replay.
- **Implementation:** moderate; requires reward rules, gating, and anti-spam handling.
- **Risk:** medium because post-ending economy can distort the core loop.
- **MVP vs expansion:** better as phase 2 once the village mood layer is solid.

## Candidate C — Conflict Echo Layer
- **Theme fit:** strong, especially for Nolbu's continuing pressure.
- **Player value:** good, but could feel like repeating retaliation if overused.
- **Implementation:** moderate-high confidence.
- **Risk:** medium; needs careful tone so completion still feels complete.
- **MVP vs expansion:** useful as a sub-layer under Candidate A, not as the whole feature.

## Candidate D — Branch-Aware Ambient Dialogue Pack
- **Theme fit:** good.
- **Player value:** modest by itself.
- **Implementation:** very safe.
- **Risk:** minimal.
- **MVP vs expansion:** should be included inside a larger adopted candidate, not chosen alone.

## Candidate E — Ending Landmark Prop
- **Theme fit:** decent.
- **Player value:** visually satisfying.
- **Implementation:** moderate.
- **Risk:** if the prop is the only consequence, the ending still feels thin in motion.
- **MVP vs expansion:** optional garnish after the mood layer is in place.

## Recommendation
Adopt **Candidate A — Ambient Ending Mood Layer**.

It is the best next implementation target because it closes the biggest remaining experiential gap in the current slice: endings exist, but they do not yet fully inhabit the village. It also creates a clean foundation that later systems can build on:
- Candidate B can layer repeatable tasks on top of ending mood
- Candidate C can add conflict echoes where appropriate
- Candidate D becomes part of the content pack
- Candidate E can become a visual accent rather than the whole solution