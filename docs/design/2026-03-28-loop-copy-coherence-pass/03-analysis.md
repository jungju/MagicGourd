# Analysis

Scoring: 1 (low) to 5 (high)

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A. Verb Map Unification | 4 | 4 | 5 | 5 | 3 | 1 | Fast win, but too narrow if signs and feedback stay inconsistent. |
| B. Zone Sign + HUD Support Tightening | 4 | 3 | 5 | 4 | 3 | 1 | Helpful, but secondary if action verbs still disagree. |
| C. Reward / Warning Feedback Taxonomy | 4 | 4 | 4 | 4 | 4 | 2 | Good feel improvement, especially for rewards and danger interruptions. |
| D. Combined Loop Copy Coherence Pass | 5 | 5 | 4 | 5 | 4 | 2 | Best completion gain because it makes all visible text feel authored by one system. |

## Candidate A Notes
- Strong because current inconsistencies are obvious (`Use`, `Hit`, `Upgrade`).
- Weak because the world still talks in a different voice than the prompts if applied alone.

## Candidate B Notes
- Useful for first-read orientation.
- Lower value than full copy coherence because signs are only one part of the readability problem.

## Candidate C Notes
- Good payoff for reward feel.
- Also exposes a missing recovery message for goblin slow ending, which would sharpen loop rhythm.
- Still partial if prompts and signs remain generic.

## Candidate D Notes
- Best fit for refinement mode.
- Does not expand scope; it simply makes the current game read consistently.
- Helps MG-PM-409 and MG-PM-410 at the same time by giving the HUD and prompt work an exact vocabulary source.
- Keeps implementation cheap because most changes are string tables and prompt title formatting.

## Adoption Recommendation
Adopt **Candidate D — Combined Loop Copy Coherence Pass**.

## Rejection Summary
- Reject A because it is too narrow for the current completion gap.
- Reject B because sign cleanup without action-text cleanup leaves the loop half-polished.
- Reject C because feedback alone cannot fix comprehension drift across the whole play surface.
