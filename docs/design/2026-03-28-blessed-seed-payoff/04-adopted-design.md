# Adopted Design

## Chosen Candidate
Candidate 1: blessed seed -> true magic gourd payoff -> Nolbu retaliation -> quick recovery action.

## Why Chosen
It hits the highest-priority story blocker, preserves the Heungbu/Nolbu rhythm, and fits the current code architecture with low fragility.

## Why Others Were Rejected
- Candidate 2: better spectacle, but too presentation-heavy for the immediate P1 need.
- Candidate 3: good conflict, but skips the iconic magical reward.

## Player Flow
1. Finish swallow healing.
2. Heungbu grants a blessed seed.
3. Plant the blessed seed in the patch.
4. Wait for the glowing vine, then harvest the true magic gourd.
5. Bring the magic gourd to Heungbu for a larger reward burst.
6. Visit Nolbu and hear his jealous retaliation.
7. Clear brambles from Heungbu's patch to restore hope.

## Quest / State Flow
- Bring Herbs -> Blessed Seed:
- Blessed Seed -> Grow Blessed Gourd:
- Grow Blessed Gourd -> Harvest Blessed Gourd:
- Harvest Blessed Gourd -> Deliver / Open Magic Gourd:
- Magic Payoff -> Hear Nolbu Retaliation:
- Nolbu Retaliation -> Clear Brambles:
- Clear Brambles -> Continue free play / resolved state:

## World Objects
- NPCs: Heungbu, Nolbu
- prompts: patch, Heungbu talk, Nolbu talk, bramble clear prompt
- map props: glowing patch tint, bramble barrier parts
- interaction points: existing runtime patch area reused

## Server Design
- Extend quest stages after swallow healing.
- Track `BlessedSeeds`, `BlessedGourds`, `MagicPayoffDone`, and retaliation flags in player state.
- Use one crop state machine with `cropType = normal | blessed`.
- Reward payoff via dialogue + stats + client effect remote.
- Retaliation spawns visible brambles that temporarily block planting.

## Client Design
- HUD adds blessed seed / magic gourd counts.
- Lightweight event banner/effect channel for the payoff and retaliation beats.
- Dialogue stays server-authored.

## Data Model
- player attributes: Seeds, Gourds, Herbs, Coins, BlessedSeeds, BlessedGourds, QuestTitle, QuestObjective
- counters: village magic payoff count, retaliation count
- runtime folders: existing `PlacedAssets` and `InteractionNodes`

## Failure / Edge Cases
- if player leaves: profile resets like current session-only progression
- if NPC missing: prompts still drive core flow
- if asset load fails: fallback props remain sufficient
- if quest is skipped: stage guards keep interactions coherent
- if brambles active: patch planting is blocked until cleared

## MVP Cut Line
Blessed seed growth, reward burst, Nolbu retaliation dialogue, visible brambles, clear-brambles recovery step.

## Future Extensions
- full gourd-opening particles / treasure spawns
- retaliating patrol behavior changes
- branching endings based on kindness vs greed counters