# Analysis

## Candidate A — Ready-state ownership contract

### Theme Fit
4/5 — fits the plaza-as-choice fantasy without changing the folklore/gameplay frame.

### Player Value
5/5 — directly improves the feel of `I earned enough` and `I know what I can do now`.

### Implementation Confidence
5/5 — can ride existing HUD rows, prompt labels, and current upgrade state.

### Reusability
4/5 — creates a stable row grammar for future polish.

### Visual / Emotional Payoff
4/5 — makes affordability feel cleaner and more satisfying.

### Risk
Low.
Main risk is making rows too loud and undoing earlier clutter cleanup.

### Notes
Best as the base contract. It clarifies without forcing a recommendation.

---

## Candidate B — Threshold-crossing flash handoff

### Theme Fit
3/5 — neutral, mostly a presentation support rule.

### Player Value
4/5 — helps the reward beat land when affordability changes mid-loop.

### Implementation Confidence
4/5 — existing purchase/payout guidance and short-lived state already suggest a feasible path.

### Reusability
3/5 — useful but secondary.

### Visual / Emotional Payoff
5/5 — strong contributor to `that payout mattered`.

### Risk
Medium-low.
If too sticky, it could nag or fight prompt ownership.

### Notes
Excellent supporting layer, but should sit under a broader readiness contract.

---

## Candidate C — Comparison quieting

### Theme Fit
3/5 — presentation-only, but coherent.

### Player Value
4/5 — lowers scan friction in plaza.

### Implementation Confidence
5/5 — mostly text/color/emphasis discipline.

### Reusability
4/5 — useful for all plaza states.

### Visual / Emotional Payoff
3/5 — subtle but worthwhile.

### Risk
Low.
Too much quieting could make rows feel dead rather than intentionally secondary.

### Notes
Strong complement to Candidate A, but not enough alone.

---

## Decision
Adopt Candidate A as the main pass.
Fold in:
- Candidate B as a short-lived handoff rule
- Candidate C as supporting row quieting discipline

Reject any recommendation logic that tells the player which upgrade is strategically best. This pass is about readability and reward feel, not build optimization.