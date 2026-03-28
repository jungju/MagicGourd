# Design Templates

아래 템플릿을 복사해서 새 기능 설계 폴더에서 사용한다.

---

## 00-brief.md

```md
# Feature Brief

## Name

## Problem

## Desired Player Experience

## Why Now

## Constraints
- Roblox constraints:
- Rojo constraints:
- Narrative constraints:
- Scope constraints:

## Existing Systems Touched

## Success Signal
```

---

## 01-proposals.md

```md
# Proposals

## Proposal A
- Summary:
- Why it helps:
- Cost:
- Risk:

## Proposal B
- Summary:
- Why it helps:
- Cost:
- Risk:

## Proposal C
- Summary:
- Why it helps:
- Cost:
- Risk:
```

---

## 02-candidates.md

```md
# Candidate Set

## Candidate 1
- Core loop:
- Theme role:
- Expected payoff:

## Candidate 2
- Core loop:
- Theme role:
- Expected payoff:

## Candidate 3
- Core loop:
- Theme role:
- Expected payoff:
```

---

## 03-analysis.md

```md
# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Candidate 1 |  |  |  |  |  |  |  |
| Candidate 2 |  |  |  |  |  |  |  |
| Candidate 3 |  |  |  |  |  |  |  |

## Detailed Notes

### Candidate 1
- Strengths:
- Weaknesses:
- Dependencies:
- MVP path:
- Expansion path:

### Candidate 2
- Strengths:
- Weaknesses:
- Dependencies:
- MVP path:
- Expansion path:

### Candidate 3
- Strengths:
- Weaknesses:
- Dependencies:
- MVP path:
- Expansion path:
```

---

## 04-adopted-design.md

```md
# Adopted Design

## Chosen Candidate

## Why Chosen

## Why Others Were Rejected

## Player Flow
1.
2.
3.

## Quest / State Flow
- State A -> State B:
- State B -> State C:

## World Objects
- NPCs:
- prompts:
- map props:
- interaction points:

## Server Design
- systems:
- events:
- player state:
- persistence assumptions:

## Client Design
- HUD:
- dialogue:
- feedback:
- camera / effects:

## Data Model
- player attributes:
- counters:
- runtime folders:

## Failure / Edge Cases
- if player leaves:
- if NPC missing:
- if asset load fails:
- if quest is skipped:

## MVP Cut Line

## Future Extensions
```

---

## 05-verification.md

```md
# Verification

## Design Checks
- [ ] Theme is clearly Heungbu/Nolbu aligned
- [ ] Player action loop is concrete
- [ ] Reward loop is explicit
- [ ] States and transitions are defined
- [ ] Roblox implementation path is realistic
- [ ] Rojo-safe structure is preserved
- [ ] Fallback path exists for fragile assets
- [ ] UI / dialogue requirements are specified
- [ ] Failure cases are documented
- [ ] MVP scope is bounded

## Walkthrough Test
1.
2.
3.

## Open Questions
- 

## Final Decision
- Ready for implementation / Needs revision
```
