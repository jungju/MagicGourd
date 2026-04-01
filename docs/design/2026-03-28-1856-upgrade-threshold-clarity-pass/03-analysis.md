# Analysis

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A — Threshold-first spend coherence | 4 | 5 | 5 | 5 | 4 | 2 | Best refinement-to-cost ratio; connects payout, route choice, and plaza meaning without new systems. |
| B — Pumpkin-count progress phrasing | 4 | 4 | 4 | 3 | 4 | 3 | Nice tactile layer, but too narrow if not grounded in a broader threshold rule first. |
| C — Multi-affordable plaza choice emphasis | 3 | 3 | 4 | 3 | 3 | 2 | Useful, but existing plaza readability work already covers much of this slice. |

## Candidate A — Threshold-first spend coherence
- **Heungbu theme fit:** strong enough. It supports the humble loop of earning, carrying, and spending without introducing a modern-feeling optimization layer.
- **Player improvement:** high. It sharpens the emotional meaning of each 10-coin payout and reduces vague wandering between lane and plaza.
- **Implementation difficulty:** low-medium. Mostly derived client logic and copy discipline.
- **Coupling:** good fit with current `money`, upgrade rows, guidance text, and purchase feedback.
- **Risk:** low, as long as it stays advisory instead of bossy.
- **Completion gain:** high. This feels like a missing authoring layer rather than a new feature.

## Candidate B — Pumpkin-count progress phrasing
- **Theme fit:** good because it speaks in the game's natural unit: one more harvest.
- **Player improvement:** moderate-high, especially early game.
- **Implementation difficulty:** straightforward, but requires rules about when to show money math vs harvest-count phrasing.
- **Coupling:** decent, though it depends on pumpkin reward staying stable enough to avoid confusing edge cases.
- **Risk:** medium. If every surface talks in pumpkin-count language, the copy may feel repetitive.
- **Completion gain:** moderate. Better as a supporting tactic inside Candidate A.

## Candidate C — Multi-affordable plaza choice emphasis
- **Theme fit:** acceptable, but less central to the loop's core rhythm.
- **Player improvement:** moderate once the player is already prosperous.
- **Implementation difficulty:** manageable.
- **Coupling:** overlaps with prior plaza billboard/choice role passes.
- **Risk:** low.
- **Completion gain:** moderate-low for the current moment.

## Adopt
Adopt **Candidate A — Threshold-first spend coherence**.

## Rejected for now
- **B** is folded in only where it strengthens threshold readability.
- **C** stays secondary because the higher-value gap happens before the player even arrives at the plaza.
