# Proposals

## Refine targets collected
1. Spawn view hierarchy is still vulnerable to plaza pads reading too loudly versus the first left-lane move.
2. Swallow prompt clusters can still feel spammy if several prompts share one camera slice.
3. The center planting lane risks accidental overlap with plaza `Buy` prompts.
4. Plaza pad signs can become a wall of equal-weight text if offsets and body length drift.
5. Danger-route warning can fail if the first goblin read happens too close to contact.
6. Popup readability depends on preserving clear vertical bands above active objects.

---

## Proposal A — Prompt competition budget
Define exact activation-distance and overlap rules so only one intended prompt dominates from ordinary approach positions.

**Strengths**
- directly targets interaction clarity
- low implementation risk
- helps village, plaza, and planting lane together

**Weaknesses**
- does not fully solve sign clutter or route sightlines by itself

---

## Proposal B — Billboard visual-band budget
Define sign width, height, copy length, and vertical offset rules so signs reinforce orientation without occupying the same visual band as prompts/popups.

**Strengths**
- improves readability across the whole map
- cheap to tune
- protects popup clarity

**Weaknesses**
- weaker on danger-route fairness unless paired with sightline rules

---

## Proposal C — Shared-lane spacing budget
Define minimum breathing room around the center lane so planted pumpkins, plaza pads, and route movement do not collapse into one noisy interaction strip.

**Strengths**
- highly relevant to the core loop
- protects the most repeated movement slice

**Weaknesses**
- more map-dependent than copy/prompt-only changes
- can drift into layout surgery if not constrained

---

## Proposal D — Combined spatial readability budget
Combine the smallest high-value rules from prompt competition, billboard bands, lane breathing room, and danger sightline fairness into one tuning contract.

**Strengths**
- closes the largest remaining polish gap
- gives Studio validation a concrete numeric/positional framework
- keeps scope in tuning, not expansion

**Weaknesses**
- must stay disciplined to avoid becoming a full map redesign