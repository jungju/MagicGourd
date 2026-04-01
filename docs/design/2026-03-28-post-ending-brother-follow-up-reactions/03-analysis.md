# Analysis

Scoring: 1 (weak) to 5 (strong)

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — Brother Follow-Up Reactions | 5 | 4 | 5 | 4 | 4 | 1 | Best next fit now that village/world readability layers are already in place. |
| B — Shared Summary Board Refresh | 4 | 3 | 4 | 3 | 3 | 2 | Still useful, but more recap than emotional payoff. |
| C — Tier-Triggered Micro Moments | 4 | 3 | 3 | 3 | 4 | 3 | Can help later, but risks event spam if stacked on rare-event beats. |
| D — End-Branch Ambient Duet Lines | 5 | 3 | 4 | 3 | 4 | 2 | Strong flavor idea, but narrower and easier to blur together with existing ambient lines. |

## Candidate A — Brother Follow-Up Reactions
- **Theme fit:** Extremely high. Heungbu and Nolbu are the emotional anchors of the game, so post-ending replay should continue to pass through them.
- **Player value:** Solid. This directly improves the feeling that continued labor still means something.
- **Implementation confidence:** High. Existing dialogue routing already branches by quest stage and ending choice.
- **Code/map coupling:** Low risk because it mainly extends line-selection logic instead of adding world-state complexity.
- **Risk / dependency:** Main risk is over-talking and making the brothers feel like repetitive recap machines.
- **MVP vs expansion:** MVP can be simple tier-aware line pools; point-specific and rare-event-aware mentions can be layered on later.

## Candidate B — Shared Summary Board Refresh
- **Theme fit:** Good, but less characterful.
- **Player value:** Moderate. Helpful as a recap node, weaker in moment-to-moment emotion.
- **Implementation confidence:** Good.
- **Risk / dependency:** Could duplicate Story Stone or existing sign readability instead of adding a new type of value.
- **MVP vs expansion:** Better as a fallback if center-village readability still feels thin after character passes.

## Candidate C — Tier-Triggered Micro Moments
- **Theme fit:** Good.
- **Player value:** Moderate.
- **Implementation confidence:** Medium because one-shot beats need careful gating and state memory.
- **Risk / dependency:** Higher chance of spam/conflict with rare-event cadence, witness barks, and existing completion feedback.
- **MVP vs expansion:** Better once the conversation layer is stable.

## Candidate D — End-Branch Ambient Duet Lines
- **Theme fit:** Very strong.
- **Player value:** Useful but subtle.
- **Implementation confidence:** Good.
- **Risk / dependency:** Easy to under-deliver because it may read as just "more ambient lines" rather than a real feature.
- **MVP vs expansion:** Good garnish after brother-specific revisit logic exists.

## Comparative Read
- **Best immediate emotional payoff:** Candidate A
- **Best recap backup:** Candidate B
- **Best ceremony layer:** Candidate C
- **Best flavor extension:** Candidate D

## Conclusion
Adopt **Candidate A — Brother Follow-Up Reactions**.

The project has already done the harder systemic work to make post-ending free play legible and varied. The next best use of design bandwidth is to let the two brothers actually notice that continued work. This improves the story core without reopening quest structure or creating more environmental clutter.
