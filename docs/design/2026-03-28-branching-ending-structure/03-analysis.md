# Candidate Analysis

| Candidate | Theme Fit | Player Value | Impl Confidence | Reusability | Emotional Payoff | Risk | Notes |
|---|---:|---:|---:|---:|---:|---|---|
| Candidate 1 - Final Audience Choice | 5 | 5 | 4 | 4 | 5 | Medium | Best balance of clarity, agency, and near-term buildability. |
| Candidate 2 - Hidden Moral Score Ending | 4 | 3 | 5 | 4 | 3 | Low | Cheap to build, but likely too opaque for players in the current lightweight slice. |
| Candidate 3 - Ceremony Plus Timed Recovery | 4 | 4 | 3 | 3 | 5 | Medium-High | Strong presentation upside, but depends on more bespoke staging and timing work. |
| Candidate 4 - Epilogue Reputation Loop | 4 | 4 | 2 | 5 | 4 | High | Good long-term system seed, wrong size for the next implementation opportunity. |

## Detailed Notes

### Candidate 1 - Final Audience Choice
- Strengths:
  - gives `COMPLETE` a true narrative landing instead of a soft stop
  - uses existing Heungbu/Nolbu prompts and current dialogue/effect infrastructure
  - easy for PM to break into actionable tasks
  - can expose future branching state cleanly for later chapter work
- Weaknesses:
  - explicit choice can feel gamey if not supported by prior story context
  - needs careful wording so Nolbu's branch is understandable without endorsing cruelty
- Dependencies:
  - small quest-stage extension after bramble clear
  - one lightweight choice UI or sequential prompt interaction flow
  - ending result tracking in player state
- MVP path:
  - one final audience with two choices
  - two ending variants plus a shared epilogue free-play unlock
- Expansion path:
  - blend explicit choice with prior kindness/greed score modifiers
  - add more than two outcomes later

### Candidate 2 - Hidden Moral Score Ending
- Strengths:
  - simplest server implementation
  - preserves folktale tone by making actions speak louder than menu choices
- Weaknesses:
  - current game does not yet have enough varied moral actions to make this feel earned
  - result may seem arbitrary without visible scoring language
- Dependencies:
  - kindness/greed counters across existing quest beats
  - clearer feedback on value shifts during play
- MVP path:
  - derive ending from tribute/help/retaliation counters
- Expansion path:
  - support nuanced endings once more optional actions exist

### Candidate 3 - Ceremony Plus Timed Recovery
- Strengths:
  - strongest audiovisual ending candidate
  - makes restoration active rather than purely conversational
- Weaknesses:
  - adds new mini-goal pressure immediately after recent retaliation content
  - likely overlaps with prior payoff-presentation work instead of extending the story structure first
- Dependencies:
  - extra world props or timed event logic
  - more authored presentation sequencing
- MVP path:
  - one short festival prep task plus two resolution banners
- Expansion path:
  - village NPC reactions, prop rebuilding, music cues

### Candidate 4 - Epilogue Reputation Loop
- Strengths:
  - best foundation for longer-term farming/story hybrid progression
  - highly reusable for later systems
- Weaknesses:
  - too diffuse for a clean next sprint
  - delays the immediate need for a defined ending beat
- Dependencies:
  - repeatable task catalog
  - stable post-story economy tuning
  - reputation accumulation and reward thresholds
- MVP path:
  - not recommended for immediate implementation
- Expansion path:
  - likely a chapter-two or systems-pass target, not the next feature