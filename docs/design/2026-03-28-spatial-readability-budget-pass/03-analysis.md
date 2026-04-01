# Analysis

## Scoring
1 = weak / risky / low value
5 = strong / safe / high value

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A Prompt Competition Budget | 4 | 5 | 5 | 5 | 4 | 2 | Excellent clarity win, but incomplete without sign/popup rules. |
| B Billboard Band Budget | 4 | 4 | 5 | 4 | 4 | 2 | Cheap polish, but weaker on flow fairness and route reads. |
| C Shared Lane Breathing Room | 4 | 5 | 3 | 4 | 4 | 3 | Strong on the core loop, but can drift into over-tuning geometry. |
| D Combined Spatial Readability Budget | 4 | 5 | 4 | 5 | 5 | 3 | Best completion value if it stays small and rule-based. |

---

## Candidate A — Why not chosen alone
It would help a lot, especially in the plaza and swallow zones. But recent docs already capture prompt-readability intent at a high level. The remaining gap is not just activation distance; it is how prompts, signs, route lanes, and popup airspace interact in the same camera slice.

---

## Candidate B — Why not chosen alone
It would tighten the world presentation, but it does not fully protect the loop from accidental prompt conflict or unfair danger reads. On its own, it risks becoming a cosmetic-only cleanup.

---

## Candidate C — Why not chosen alone
This is one of the highest-value slices because the center lane is where planting, movement, and plaza spending meet. But if the pass only talks about lane clearance, it leaves village and danger readability under-specified.

---

## Candidate D — Why chosen
The current completion gap is fundamentally **spatial coherence**.

The loop already has the right actions and the right vocabulary. What can still make it feel rough is when too many authored surfaces speak at once in one view.

Candidate D is the best refinement choice because it:
- closes the gap between validation criteria and actual tuning decisions
- protects flow clarity, readability, reward feel, and placement consistency together
- stays inside the current map and current mechanics
- gives the dev a specific order for small fixes instead of ad hoc world nudges

## Risk control
To keep Candidate D from expanding scope:
- numeric budgets must be small and few
- copy shortening beats bigger signs
- prompt-distance tuning beats adding UI
- spacing tweaks beat route redesign
- sightline tweaks stay inside the current danger bounds