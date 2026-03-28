# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Candidate 1 | 5 | 5 | 4 | 4 | 4 | Medium | Best immediate answer to visible world credibility issue. |
| Candidate 2 | 3 | 3 | 5 | 3 | 2 | Low | Robust, but feels like giving up on the authored homes too early. |
| Candidate 3 | 3 | 4 | 3 | 5 | 2 | Medium-High | Great tooling direction, but too broad for the next implementation window. |

## Detailed Notes

### Candidate 1
- Strengths:
  - Fixes the actual problem instead of masking it.
  - Keeps imported assets when they work, while preserving fallback parity.
  - Creates a small reusable placement vocabulary (`orientationCorrection`, `anchorMode`, `facingTarget`, `groundOffset`).
- Weaknesses:
  - Still requires at least one visual validation pass in Studio.
  - Bounding-box anchoring can still be imperfect for badly authored models.
- Dependencies:
  - current `applyPlacement()` flow
  - house asset ids and runtime pads
- MVP path:
  - add per-house placement metadata
  - convert hardcoded rotations into named correction fields
  - align both imported/fallback houses to pad-facing rules
- Expansion path:
  - extend same contract to NPC staging, gates, and future hero props

### Candidate 2
- Strengths:
  - Very stable.
  - Easy for Dev to ship quickly.
- Weaknesses:
  - Weakest visual payoff.
  - Makes the village feel more placeholder exactly when polish should improve it.
- Dependencies:
  - fallback house art quality
- MVP path:
  - improve fallback geometry and signage context
- Expansion path:
  - could remain a safe fallback tier even if not the final target

### Candidate 3
- Strengths:
  - Most reusable technical foundation.
  - Helps future runtime placement debugging.
- Weaknesses:
  - Too much tooling for a two-house problem.
  - Risks spending the cycle on helpers instead of visible improvement.
- Dependencies:
  - extra debug visualization / metadata work
- MVP path:
  - add calibration markers and compare footprints
- Expansion path:
  - could become a broader runtime layout system later, after the houses are fixed first