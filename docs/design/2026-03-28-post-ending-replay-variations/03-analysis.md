# Analysis

Scoring uses 1-5 for Theme Fit, Player Value, Implementation Confidence, Reusability, and Visual/Emotional Payoff.

| Candidate | Theme Fit | Player Value | Impl. Confidence | Reusability | Visual / Emotional Payoff | Notes |
|---|---:|---:|---:|---:|---:|---|
| 1. Branch-Specific Village Errands | 5 | 5 | 4 | 5 | 4 | Best balance of action, branch identity, and code-fit. Reuses `COMPLETE`, ending choice, existing delivery/prompt patterns. |
| 2. Rotating Support-Point Tasks | 4 | 4 | 4 | 4 | 4 | Good follow-up to retaliation recovery, but can feel too restoration-coded unless tribute variant work is added. |
| 3. Tribute Route Pressure Loop | 4 | 3 | 4 | 3 | 4 | Strong tribute identity, but weak symmetry. Better as a subcomponent of Candidate 1. |
| 4. Ending Echo Events | 4 | 3 | 2 | 3 | 5 | Flavorful, but cadence/timing logic risks hidden complexity and doc thrash. |

## Candidate 1 — Branch-Specific Village Errands
### Theme Fit
Strong. Heungbujeon's ending contrast is about what the harvest serves. Turning that into repeatable post-ending asks is thematically direct.

### Player Value
High. It gives the player something small but meaningful to *do* after the ending, instead of only re-reading dialogue.

### Implementation Difficulty
Manageable. Existing code already supports:
- branch state via `endingChoice`
- prompt interactions
- item counts for gourds / herbs / coins / seeds
- branch-aware signage/dialogue text

### Coupling / Risk
Low-medium. The main risk is accidentally inventing a full reputation/economy layer. Scope must stay at one tiny errand family per ending with simple reward caps.

### MVP / Expansion
Excellent MVP candidate. Can ship with one interaction node and a few variant lines, then expand later.

---

## Candidate 2 — Rotating Support-Point Tasks
### Theme Fit
Good, especially for restoration and continued stewardship.

### Player Value
Solid, but more spatially fiddly and potentially less legible than a direct branch errand.

### Implementation Difficulty
Reasonable because current code already uses temporary markers and simple repair interactions.

### Coupling / Risk
Medium. Without tribute-side equivalents it risks over-serving only one ending.

### MVP / Expansion
Better as a secondary extension once a clearer branch-specific action loop exists.

---

## Candidate 3 — Tribute Route Pressure Loop
### Theme Fit
Strong for the colder ending.

### Player Value
Moderate. Tribute players get stronger consequence, but restoration players get comparatively less to do.

### Implementation Difficulty
Quite feasible using existing delivery logic.

### Coupling / Risk
Asymmetry is the problem. If chosen alone, it makes the tribute branch mechanically richer than restoration.

### MVP / Expansion
Best absorbed into Candidate 1 rather than shipped standalone.

---

## Candidate 4 — Ending Echo Events
### Theme Fit
Good.

### Player Value
Moderate because surprise flavor is nice, but not as reliable as repeatable agency.

### Implementation Difficulty
Lower confidence. Even "small" event systems often create invisible state, cooldown, and reset questions.

### Coupling / Risk
Highest risk of hidden sprawl among the options.

### MVP / Expansion
Better after the game already has clear post-ending tasklets.

## Adoption Recommendation
Adopt **Candidate 1 — Branch-Specific Village Errands**, while borrowing a very small tribute-pressure flavor from Candidate 3 and leaving Candidate 2 as a likely future follow-up if the first pass feels too static.