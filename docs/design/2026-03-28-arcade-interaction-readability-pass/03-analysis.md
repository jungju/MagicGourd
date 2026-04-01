# Analysis

Scoring: 1 (weak) to 5 (strong)

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — Contextual Next-Action HUD Guidance | 4 | 5 | 5 | 5 | 4 | 1 | Best immediate clarity gain for the current arcade loop. |
| B — Upgrade Readability Cards | 4 | 4 | 4 | 4 | 3 | 2 | Good polish, but mostly affects plaza decision moments. |
| C — Precision Feedback Taxonomy | 4 | 4 | 5 | 4 | 4 | 2 | Valuable supporting pass; weaker if loop priority is still fuzzy. |
| D — Prompt / Copy Consistency Pass | 4 | 3 | 5 | 4 | 2 | 1 | Cheap and useful, but too narrow for the next main refinement. |

## Candidate A — Contextual Next-Action HUD Guidance
- **Theme fit:** Strong. The arcade loop is fundamentally a chain of care, planting, harvest, and threat avoidance. Surfacing the next link in that chain makes the current design read as intended.
- **Player value:** Highest. It improves both onboarding and repeated-play readability without asking the player to memorize the loop.
- **Implementation confidence:** Very high. The client already has all major input signals through player attributes and a few authoritative states.
- **Code/map coupling:** Low. This mainly extends existing HUD text and state derivation.
- **Risk / dependency:** Main risk is over-chatty guidance. The design should use stable priority rules rather than constant text churn.
- **MVP vs expansion:** MVP can be a single derived guidance line + stronger status emphasis. Expansion can add richer upgrade affordability phrasing.

## Candidate B — Upgrade Readability Cards
- **Theme fit:** Good. Spending is core to the loop, but not the first problem the player hits.
- **Player value:** Good, especially after the player starts earning money reliably.
- **Implementation confidence:** Good. Still mostly client-side, but needs layout cleanup and a few helper functions.
- **Risk / dependency:** If this becomes too visual, it works against the current compact HUD.
- **MVP vs expansion:** Best handled as part of a broader readability pass, not as the only pass.

## Candidate C — Precision Feedback Taxonomy
- **Theme fit:** Good. The game benefits from sharper emotional punctuation when healing, planting, cashing out, or getting punished.
- **Player value:** Good. Players feel the loop more clearly when event outcomes are distinct.
- **Implementation confidence:** Very high. The project already uses a feedback remote and tone table.
- **Risk / dependency:** Feedback is reactive. It helps after actions happen, but does less to guide the next one.
- **MVP vs expansion:** Strong companion layer after the primary guidance rules are defined.

## Candidate D — Prompt / Copy Consistency Pass
- **Theme fit:** Good.
- **Player value:** Moderate. Cleaner wording helps, but it does not solve overall loop ranking by itself.
- **Implementation confidence:** Very high.
- **Risk / dependency:** Almost no risk, but also lower upside.
- **MVP vs expansion:** Best treated as a cut-across rule applied during implementation of the chosen pass.

## Conclusion
Adopt **Candidate A — Contextual Next-Action HUD Guidance**.

The current structure already works. The biggest remaining precision/completion gap is that the player still has to assemble the loop in their own head. A context-aware guidance layer fixes that cheaply, stays inside refinement mode, and creates a clean umbrella for smaller copy and feedback polish that can ride along without reopening scope.