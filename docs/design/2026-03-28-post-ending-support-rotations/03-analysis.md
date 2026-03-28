# Analysis

Scoring uses 1-5 for Theme Fit, Player Value, Implementation Confidence, Reusability, and Visual/Emotional Payoff.

| Candidate | Theme Fit | Player Value | Impl. Confidence | Reusability | Visual / Emotional Payoff | Notes |
|---|---:|---:|---:|---:|---:|---|
| A. Rotating Support-Point Tasks | 5 | 5 | 4 | 5 | 4 | Best fit for current code. Makes endings feel spatially lived-in without adding new economy depth. |
| B. Branch Helper NPC Barks | 4 | 3 | 5 | 3 | 2 | Safe and cheap, but too text-only as the next main step. |
| C. Tiny Branch Route Obstacles | 4 | 4 | 3 | 3 | 5 | Strong visual value, but easier to over-author than to replay. |
| D. Ending Echo Event Pings | 4 | 3 | 2 | 3 | 4 | Flavorful, but cadence/cooldown logic risks hidden complexity. |

## Candidate A — Rotating Support-Point Tasks
### Theme Fit
Very strong. The ending should not only change what the harvest means, but where that meaning shows up in the village.

### Player Value
High. A short walk between support points makes each harvest cycle feel more authored while staying legible.

### Implementation Difficulty
Manageable. The project already has:
- branch-gated errand logic
- runtime interaction nodes
- repair-marker support-point tech
- sign refresh hooks
- per-player post-ending counters

### Coupling / Risk
Low-medium. The main risk is over-rotating and turning a tiny replay loop into busywork. The active point count must stay at one per branch.

### MVP / Expansion
Excellent MVP. Start with fixed nearby points and threshold-based rotation. Later expansions could add branch-specific bark lines or prop accents at each location.

## Candidate B — Branch Helper NPC Barks
### Theme Fit
Good, but too slight on its own.

### Player Value
Modest. Players notice it once, then it becomes background texture.

### Implementation Difficulty
Very safe.

### Risk
Low.

### MVP / Expansion
Better as garnish packaged with Candidate A, not as the headlining feature.

## Candidate C — Tiny Branch Route Obstacles
### Theme Fit
Good. Physical route cues can sell the branch difference.

### Player Value
Potentially good, but only if the interaction loop already asks the player to move.

### Implementation Difficulty
Moderate. World clutter and collision annoyance are real risks.

### Risk
Medium.

### MVP / Expansion
Better after support-point rotation proves the routes matter.

## Candidate D — Ending Echo Event Pings
### Theme Fit
Good.

### Player Value
Moderate.

### Implementation Difficulty
Lowest confidence because event cadence is where small systems quietly get messy.

### Risk
Highest of the set.

### MVP / Expansion
Save for later once the village already has more stable post-ending movement patterns.

## Adoption Recommendation
Adopt **Candidate A — Rotating Support-Point Tasks**.

It is the best next feature because it attacks the real remaining weakness in the current post-ending layer: the player now understands the branch, but the branch still lives in only one repeated interaction point. Rotating the active support point adds pathing variety, stronger village presence, and better reuse of already-authored landmarks without reopening quest structure or reward balance.
