# Analysis

Scoring: 1-5 (higher is better, Risk noted separately)

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| A — Full loop reset clarity contract | 4 | 5 | 5 | 5 | 4 | Low | Best completion value because it covers the exact moments where the loop can still feel diffuse without changing systems. |
| B — Plaza-only re-entry contract | 3 | 4 | 5 | 3 | 4 | Low | Good, but too localized; does not solve slow-recovery or post-buy handoff. |
| C — Recovery-only momentum contract | 3 | 3 | 5 | 2 | 3 | Low | Useful for danger feel, but not the highest-value remaining loop-wide refinement. |

## Why Candidate A wins
The repo has already spent several passes on:
- verb consistency
- lane clarity
- plaza role clarity
- feedback cadence
- band separation

That means the next highest-value precision gain is not another surface-specific pass. It is the **relationship between surfaces when the player has just completed something**.

Candidate A is the only option that:
- improves completion feel across the whole loop
- strengthens reward-to-next-action continuity
- keeps scope tightly within existing HUD/banner logic
- complements MG-PM-408 live validation instead of creating a parallel design lane

## Why others are rejected
### Candidate B
Useful, but it mistakes one visible symptom (plaza decision) for the broader completion gap (loop re-entry after several different beats).

### Candidate C
Danger recovery matters, but by itself it does not improve the most common reset beats: payout and purchase.