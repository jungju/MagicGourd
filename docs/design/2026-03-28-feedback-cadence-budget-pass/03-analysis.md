# Analysis

Scoring: 1-5, higher is better. Risk is noted separately.

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Total | Risk |
|---|---:|---:|---:|---:|---:|---:|---|
| A — Popup Lifetime and Suppression Budget | 4 | 4 | 5 | 4 | 3 | 20 | Low |
| B — Reward Beat Hierarchy Contract | 4 | 4 | 4 | 4 | 5 | 21 | Low-Med |
| C — Combined Feedback Cadence Budget | 4 | 5 | 4 | 5 | 5 | 23 | Low-Med |
| D — Purchase-Only Reward Emphasis Pass | 3 | 3 | 5 | 3 | 4 | 18 | Low |

## Candidate A Notes
Good surgical anti-noise pass. It is likely part of the right answer, but by itself it mainly says what to trim, not what should feel important.

## Candidate B Notes
Useful because the loop now depends on quick emotional reads. Still, a hierarchy without yield windows would leave Studio tuning too interpretive.

## Candidate C Notes
Best fit for the current state. Existing design docs already cover copy, anchors, and spatial budgets. The missing piece is the authored rhythm between those surfaces during rapid play. This candidate closes that gap without introducing any new system.

## Candidate D Notes
Valuable only as a subset. Upgrade purchase already got an anchor consistency pass; the bigger unfinished issue is full-loop cadence under repetition.

## Adoption Decision
Adopt **Candidate C — Combined Feedback Cadence Budget**.

## Rejection Summary
- Reject A because it is necessary but incomplete.
- Reject B because it still needs concrete suppression rules.
- Reject D because it over-focuses on one reward beat while the blocked validation issue is loop-wide.
