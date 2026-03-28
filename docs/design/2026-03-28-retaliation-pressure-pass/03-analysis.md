# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Candidate 1 - Compact Retaliation Pressure Loop | 5 | 5 | 4 | 4 | 5 | Medium | Best balance of stronger play and manageable scope |
| Candidate 2 - Retaliation Patrol Lockdown | 4 | 4 | 2 | 3 | 4 | High | Strong mood, but risky with current patrol/pathfinding setup |
| Candidate 3 - Communal Recovery Marker System | 5 | 4 | 4 | 4 | 4 | Medium | Good thematic support, but slightly softer conflict beat |
| Candidate 4 - Dialogue-Heavy Retaliation Reframe | 3 | 2 | 5 | 2 | 2 | Low | Safe, but too close to what already exists |

## Detailed Notes

### Candidate 1 - Compact Retaliation Pressure Loop
- Strengths:
  - directly addresses the current weak spot in the story arc
  - fits existing prompt/dialogue/effect architecture
  - adds real play without opening a large system
- Weaknesses:
  - needs one extra quest stage or sub-step coordination
  - can drag if expanded beyond a tight 2-3 action loop
- Dependencies:
  - existing bramble props/prompts
  - one added support-point interaction or repair prompt
  - updated quest text and sign refresh rules
- MVP path:
  - add one sabotage inspection beat and one repair follow-through after bramble clear
- Expansion path:
  - branch-specific recovery flavor, repeated sabotage variants, stronger village-state aftermath

### Candidate 2 - Retaliation Patrol Lockdown
- Strengths:
  - immediately visible and threatening
  - gives Nolbu's estate more gameplay identity
- Weaknesses:
  - pathfinding/patrol bugs would cheapen the moment fast
  - easy to turn frustration into the dominant emotion
- Dependencies:
  - more robust patrol state changes and safe collision tuning
- MVP path:
  - temporary patrol radius warning only
- Expansion path:
  - branch-aware security vs intimidation loop

### Candidate 3 - Communal Recovery Marker System
- Strengths:
  - aligns strongly with Heungbu's communal theme
  - environmental changes are reusable for later aftermath systems
- Weaknesses:
  - retaliation itself can still feel toothless if conflict lands too softly
  - without villagers, communal repair risks feeling abstract
- Dependencies:
  - 2-3 simple runtime props/prompts and updated signs
- MVP path:
  - restore one landmark near patch or yard
- Expansion path:
  - multi-point village recovery / ending-specific world cleanup

### Candidate 4 - Dialogue-Heavy Retaliation Reframe
- Strengths:
  - cheapest to ship
  - low engineering risk
- Weaknesses:
  - mostly doc/text polish, not a stronger game beat
  - unlikely to materially change player memory of the arc
- Dependencies:
  - dialogue and banner copy only
- MVP path:
  - rewrite presentation beats
- Expansion path:
  - minimal; likely replaced later
