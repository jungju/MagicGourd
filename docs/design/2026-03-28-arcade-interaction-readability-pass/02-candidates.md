# Candidates

## Candidate A — Contextual Next-Action HUD Guidance
Direction: flow clarity + live priority ranking

Add a small but high-authority guidance layer inside the existing HUD that derives the player's best next action from current state.

Examples:
- `No seeds -> Heal an injured swallow in Heungbu Village.`
- `Have seeds -> Press Q or tap Use Seed to plant your pumpkin nearby.`
- `Have money but can't afford upgrades yet -> Break more pumpkins for 20 coins.`
- `Can afford one or more upgrades -> Return to Central Plaza and buy an upgrade.`
- `Slowed -> Leave Nolbu Area or dodge goblins before planting again.`

Expected payoff:
- best first-session readability gain
- better loop continuity during repeated play
- minimal systems risk

## Candidate B — Upgrade Readability Cards
Direction: spending clarity + comparison speed

Refactor the upgrade rows so each one reads as:
- current level
- next value/benefit
- cost
- affordability
- maxed state

Expected payoff:
- helps decision speed in plaza
- makes upgrades feel more polished
- narrower impact than full-loop guidance

## Candidate C — Precision Feedback Taxonomy
Direction: reward feel + action consequence clarity

Expand the feedback system into clearer event buckets:
- swallow heal
n- seed use success / fail
- pumpkin break reward
- upgrade purchase / cannot afford / maxed
- goblin slow warning / recovery

Expected payoff:
- stronger action feedback
- better reward feel
- still secondary if the player is unclear what to do next

## Candidate D — Prompt / Copy Consistency Pass
Direction: interaction polish + naming coherence

Standardize interact text and nearby copy across prompts, zone labels, button text, and feedback so the game's verbs stay consistent:
- heal
- plant
- break
- buy
- avoid

Expected payoff:
- easy polish win
- low technical risk
- good supporting pass, but not the highest-value standalone refinement