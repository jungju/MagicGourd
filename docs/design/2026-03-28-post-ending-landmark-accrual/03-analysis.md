# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Candidate 1 — Landmark accrual tiers | 5 | 5 | 4 | 5 | 5 | Medium | Best match for current counters, signs, and support-point prop surface. |
| Candidate 2 — Helper barks | 4 | 3 | 5 | 3 | 3 | Low | Useful garnish, but not enough as the next primary feature. |
| Candidate 3 — Rare micro-events | 4 | 4 | 3 | 4 | 5 | Medium-High | Better after the replay loop feels spatially and visually grounded. |
| Candidate 4 — Route cue props | 4 | 4 | 4 | 4 | 4 | Medium | Good complement to support rotation, but weaker persistent payoff than visible accrual. |

## Detailed Notes

### Candidate 1 — Landmark accrual tiers
- Strengths:
  - Reuses current branch errand counts and milestone thinking
  - Creates immediate visual read without new quest states
  - Naturally layers on top of support-point rotation instead of competing with it
  - Can be data-driven per support point and per branch
- Weaknesses:
  - Needs restraint to avoid clutter or readability loss
  - Requires a clear rule for which props/sign lines unlock at each tier
- Dependencies:
  - Support-point locations should be finalized first
  - Existing branch counters and sign refresh logic should remain stable
- MVP path:
  - 2 visual tiers per branch across 2 support points
  - one sign text upgrade tier and one small prop cluster per tier
- Expansion path:
  - 3 tiers, more point-specific prop variants, branch helper barks tied to accrual level

### Candidate 2 — Helper barks
- Strengths:
  - Very cheap to ship
  - Easy to author with current dialogue systems
- Weaknesses:
  - Mostly text after several text-forward passes
  - Does not make replay feel physically cumulative
- Dependencies:
  - Ambient/support-point interaction hooks
- MVP path:
  - 2 bark sets per branch
- Expansion path:
  - tie bark sets to support points and accrual tiers

### Candidate 3 — Rare micro-events
- Strengths:
  - Strong surprise value
  - Can punctuate long free-play sessions
- Weaknesses:
  - Hidden timing rules are harder to read and test
  - Risks feeling random before the village has stronger persistent state cues
- Dependencies:
  - Stable counters, cadence rules, and effect hooks
- MVP path:
  - one event per branch every N errands
- Expansion path:
  - multiple event tables per branch and support point

### Candidate 4 — Route cue props
- Strengths:
  - Works well with rotating support points
  - Makes local walking feel more authored
- Weaknesses:
  - More staging work for less durable payoff than landmark accumulation
  - Easy to become set dressing rather than stateful feedback
- Dependencies:
  - final support-point map locations
- MVP path:
  - one cue per branch between two locations
- Expansion path:
  - point-to-point route variants and active-point highlighting

## Recommendation
Adopt Candidate 1 as the next focused follow-on after support-point rotation is completed. Keep Candidate 2 as optional garnish to fold into the same pass only if the prop/state work lands cleanly.