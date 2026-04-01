# Analysis

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A. Touch-first input ownership contract | 4 | 5 | 5 | 5 | 4 | 2 | Best completion value because it turns the mobile blocker into a concrete ownership rule set instead of guesswork. |
| B. Plaza-only mobile spend pass | 3 | 3 | 5 | 3 | 3 | 1 | Safe, but too narrow for the current blocked bucket. |
| C. Recovery-state touch clarity pass | 4 | 4 | 4 | 3 | 4 | 2 | Good tactile polish, but it should live inside a broader touch ownership layer. |
| D. Mobile validation checklist only | 3 | 2 | 5 | 2 | 2 | 1 | Easy to run, but under-authored and likely to create ad hoc fixes. |

## Candidate A — Touch-first input ownership contract
- **Theme fit:** Good. It protects the small arcade loop's kindness/farming/risk rhythm without changing the fiction.
- **Player value:** Highest. If touch ownership is vague, the whole loop feels less finished even when the rules are correct.
- **Implementation confidence:** High. The repo already has CTA demotion and prompt tracking logic; this pass just makes mobile expectations explicit.
- **Coupling:** Strongly aligned with existing HUD/prompt/client work.
- **Risk:** Low. The main risk is overfitting to touch and accidentally making desktop worse, which can be mitigated by keeping touch-specific rules minimal.

## Candidate B — Plaza-only mobile spend pass
- Helpful if validation proves the plaza is the only bad slice.
- Rejected because the remaining blocker still spans village, center lane, and recovery behavior too.

## Candidate C — Recovery-state touch clarity pass
- Valuable because danger pressure is where touch ambiguity feels worst.
- Rejected as primary because it solves one pressure state, not the broader ownership grammar.

## Candidate D — Mobile validation checklist only
- Too weak for the lead pass.
- The project already has validation structure; the missing value is a stable interpretation layer for touch ownership.

## Adoption recommendation
Adopt **Candidate A — Touch-first input ownership contract**.

Reason:
The repo has already authored general readability, spatial, and commitment rules. The best next precision move is not another broad readability document. It is a small, specific completion layer for the one remaining interaction channel that still risks ambiguity during real play.
