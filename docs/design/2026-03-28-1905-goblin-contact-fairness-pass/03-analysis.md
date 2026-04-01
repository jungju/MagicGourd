# Analysis

## Scoring
1 = weak / risky, 5 = strong / favorable.

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual / Emotional Payoff | Risk | Total |
|---|---:|---:|---:|---:|---:|---:|---:|
| A. Contact fairness budget | 5 | 5 | 5 | 4 | 4 | 2 | 23 |
| B. Geometry-first danger readability | 4 | 4 | 4 | 3 | 4 | 3 | 19 |
| C. Chase cadence / leash polish | 4 | 4 | 4 | 4 | 3 | 3 | 19 |

## Candidate A — Contact fairness budget
### Why it scores highest
- Best matches the real remaining blocker: not mechanics, but whether danger feels fair and legible in motion.
- Covers both world-read and behavior-read without requiring new systems.
- Gives PM/dev a concrete Studio acceptance target for MG-PM-408.
- Preserves current loop structure and recent retreat/recovery work.

### Risks
- If written too vaguely, it could become a duplicate of the existing general Studio validation contract.
- Must stay specific enough to drive tuning order, not just describe a wish.

## Candidate B — Geometry-first danger readability
### Strengths
- Easy to apply with low implementation risk.
- Fits recent sightline work and may solve a visible share of the problem quickly.

### Weaknesses
- Too narrow if the real live issue is chase retarget weirdness or touch cadence after contact.
- Could lead to map nudging when the sharper fix is logic discipline.

## Candidate C — Chase cadence / leash polish
### Strengths
- Addresses the part of goblin feel that geometry alone cannot solve.
- Keeps solutions inside existing config and service boundaries.

### Weaknesses
- Too NPC-centric if the player's first impression problem is still danger-lane readability.
- Easy to over-tune AI behavior without improving the overall decision read.

## Adopt decision
Choose **Candidate A — Contact fairness budget**.

## Rejection reasons
- Reject B because geometry-only tuning is a tool inside the chosen pass, not the whole pass.
- Reject C because chase logic should be tuned in service of player-readable fairness, not as an isolated AI polish exercise.