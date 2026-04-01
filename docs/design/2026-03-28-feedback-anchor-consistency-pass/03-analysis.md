# Analysis

## Scoring
1 = weak / risky / poor fit
5 = strong / safe / high value

| Candidate | Theme Fit | Player Value | Implementation Confidence | Reusability | Visual/Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| A — Whole-loop feedback anchor consistency | 4 | 5 | 5 | 5 | 5 | 2 | Best coverage-to-cost ratio. Uses current feedback remote and existing object positions. |
| B — Reward intensity hierarchy | 4 | 4 | 5 | 4 | 5 | 2 | Good support layer, but incomplete if anchor placement still drifts. |
| C — Plaza upgrade payoff presence | 3 | 3 | 5 | 3 | 4 | 1 | Useful patch, but too narrow for the current remaining polish gap. |
| D — Feedback overlap discipline | 3 | 4 | 4 | 5 | 3 | 3 | Important follow-through rule set, but should sit under a broader feedback map. |

## Candidate A — Whole-loop feedback anchor consistency
### Strengths
- Solves both placement consistency and reward-feel coherence together
- Covers the entire loop rather than one event slice
- Can be implemented mostly as payload rules and small client presentation tweaks
- Makes upgrades and goblin states feel as authored as swallow/pumpkin actions

### Weaknesses
- Requires clear restraint so it does not expand into a full VFX system
- Needs overlap rules to avoid turning every event into a popup spam source

### Fit
Very strong fit for refinement mode. This is not new content; it is authorial tightening.

---

## Candidate B — Reward intensity hierarchy
### Strengths
- Improves emotional pacing
- Easy to apply to existing text and tone buckets
- Helps players instantly parse whether an event was routine, good, or dangerous

### Weaknesses
- If the event still appears in the wrong place or on the wrong surface, the emotional hierarchy will only partially land

### Fit
Best as part of Candidate A rather than a standalone pass.

---

## Candidate C — Plaza upgrade payoff presence
### Strengths
- Targets a real current gap: plaza purchases happen in the world but do not create a matching local world celebration
- Cheap and highly implementable

### Weaknesses
- Leaves the rest of the loop on mixed rules
- Risks becoming a one-off exception instead of a systemized finish pass

### Fit
Good fallback if time is extremely tight, but not the best refinement choice.

---

## Candidate D — Feedback overlap discipline
### Strengths
- Prevents banner churn and stacked popup mush during fast play
- Valuable for repeated loop actions

### Weaknesses
- Secondary problem unless the base event-to-surface map is settled first
- Harder to judge without first deciding which events deserve simultaneous presence

### Fit
Needed as a section in the adopted design, not as the primary target.

## Adoption Decision
Adopt **Candidate A — Whole-loop feedback anchor consistency**.

## Why Adopted
It is the highest-value remaining precision pass inside the current structure because it improves:
- flow clarity
- reward feel
- placement consistency
- event coherence
without requiring any new mechanics.

## Why Rejected
- **B** was rejected as standalone because intensity without anchor rules only solves half the problem.
- **C** was rejected because upgrade-only polish is too local.
- **D** was rejected as primary because it is governance for a system, not the most important missing systemization itself.
