# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Candidate 1 | 5 | 5 | 4 | 5 | 4 | medium | Best match for the new product direction |
| Candidate 2 | 3 | 2 | 3 | 2 | 3 | high | Keeps too much of the old confusion alive |
| Candidate 3 | 4 | 2 | 4 | 2 | 4 | medium | Safer technically, but fails the immediate-loop goal |

## Detailed Notes

### Candidate 1
- Strengths: fully aligns gameplay, docs, and multiplayer expectations around one loop.
- Weaknesses: archives a large amount of previous story scaffolding.
- Dependencies: runtime map rebuild, remote reset, HUD replacement.
- MVP path: three zones, swallows, owned pumpkins, goblins, upgrades, cleanup.
- Expansion path: add combo scoring, variant goblins, or cosmetic reward beats later.

### Candidate 2
- Strengths: lower rewrite pressure and more content reuse.
- Weaknesses: mixed-mode design still confuses new players.
- Dependencies: compatibility routing between two systems.
- MVP path: large because both systems must stay alive.
- Expansion path: limited, because the architecture stays split.

### Candidate 3
- Strengths: easiest to build on the old code without a full cutover.
- Weaknesses: does not actually enforce an arcade loop.
- Dependencies: existing story state machine remains central.
- MVP path: smaller technical change, weaker design change.
- Expansion path: future simplification still required later.
