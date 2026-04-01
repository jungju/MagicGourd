# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Lane Landmark Grammar | 5 | 5 | 5 | 5 | 4 | Low | Best whole-map refinement contract; enables later small tuning without drift |
| Center Lane Ownership Contract | 4 | 4 | 5 | 3 | 3 | Low | Strong local fix but too narrow for overall coherence |
| Danger Telegraph Contract | 5 | 4 | 4 | 3 | 4 | Low-Med | Important, but already partly covered by prior validation/readability docs |

## Detailed Notes

### Lane Landmark Grammar
- Strengths:
  - Covers village-first read, center-lane ownership, plaza calm, and danger identity in one bounded pass.
  - Helps placement consistency without adding objects or mechanics.
  - Gives future Studio tuning a durable authoring rule set.
- Weaknesses:
  - More design-language heavy than immediately measurable geometry-only changes.
- Dependencies:
  - Current zone pads, paths, lanterns, rocks, and signs already exist.
  - Should align with spatial readability and Studio validation contracts.
- MVP path:
  - Define visual role per lane.
  - Define what cues dominate and what cues must stay secondary.
  - Define allowed micro-tuning levers.
- Expansion path:
  - If the game later adds more detail, new props can inherit this grammar instead of creating noise.

### Center Lane Ownership Contract
- Strengths:
  - Practical and easy to action.
  - Directly addresses pumpkin/plaza overlap risk.
- Weaknesses:
  - Does not solve the larger coherence issue across left/center/right reads.
- Dependencies:
  - Current plaza pad spacing and center-lane planting positions.
- MVP path:
  - Tune spacing and prompt commitment around the center route.
- Expansion path:
  - Could become one subsection of a broader landmark grammar.

### Danger Telegraph Contract
- Strengths:
  - Clear player-value impact because unfair first contact feels bad fast.
  - Strong thematic fit.
- Weaknesses:
  - Some of its core concerns are already covered in the Studio validation contract and spatial readability pass.
- Dependencies:
  - Goblin spawn spread, danger rocks, sign readability.
- MVP path:
  - Define silhouette, warning beat, and retreat-lane rules.
- Expansion path:
  - Could later support variant danger encounters, but that is outside current scope.