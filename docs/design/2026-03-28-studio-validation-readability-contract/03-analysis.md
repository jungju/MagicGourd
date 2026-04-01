# Analysis

## Scoring
1-5 scale. Higher is better except Risk, where a higher note means more caution.

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual / Emotional Payoff | Risk / Scope Drift | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A — Prompt Competition + Lane Readability | 4 | 5 | 5 | 4 | 4 | Low | Directly improves the current physical loop and keeps work inside polish territory. |
| B — Popup Cadence + Reward Noise | 4 | 4 | 5 | 4 | 5 | Low | Important, but narrower than the full blocked bucket. |
| D — Unified Studio Validation Contract | 4 | 5 | 5 | 5 | 4 | Low | Best PM/dev handoff because it turns the vague validation bucket into a concrete refinement checklist. |

## Candidate A
### Strengths
- attacks core prompt-driven interaction clarity
- directly improves flow readability in all three zones
- easy to validate in Studio without new systems

### Weaknesses
- under-specifies feedback noise unless combined with popup cadence rules
- risks becoming purely movement-focused instead of full completion polish

## Candidate B
### Strengths
- sharpens reward feel during fast repeated runs
- complements the existing feedback-anchor design cleanly
- very cheap to tune

### Weaknesses
- does not fully resolve traversal/prompt readability
- too small to stand alone as the next best design artifact

## Candidate D
### Strengths
- matches the current PM blocked state exactly
- captures prompt readability, route readability, and popup overlap in one pass
- gives future live testing a stable definition of done
- constrains tuning levers so the team does not add scope while polishing

### Weaknesses
- broader than a single micro-pass, so it must stay disciplined and concrete
- could become vague if it only says "test everything" instead of defining scenes and thresholds

## Decision Read
The repo no longer needs another speculative system design. It needs a practical refinement contract for the exact things that still require human eyes in Studio.

That makes Candidate D the best choice, with Candidate A and Candidate B folded in as sections rather than separate workstreams.
