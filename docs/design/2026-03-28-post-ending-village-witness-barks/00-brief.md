# Brief

## Feature
Post-Ending Village Witness Barks

## Why now
The current post-ending stack is finally solid in code:
- branch-aware aftermath
- repeatable branch errands
- support-point rotation
- landmark accrual tiers

What still feels thin is **social acknowledgment**. The player can now walk a more varied replay loop, but most of that meaning is still carried by signs, prompt text, and the two core brothers. The next high-value pass should make the wider village visibly and audibly notice what the player keeps doing.

## Problem
Post-ending free play has structure, but not enough witness. Repeating shared drops or road dues can still feel like servicing prompts instead of shaping a lived-in village.

## Goal
Add a small, implementation-friendly ambient layer where nearby villagers / support witnesses comment on:
- the chosen ending branch
- the currently active support point
- landmark tier progression

## Constraints
- No big NPC schedule system
- No imported art dependency
- No quest-state expansion beyond `COMPLETE`
- Must stay readable and low-spam
- Should piggyback on existing prompt/dialogue/runtime prop patterns

## Success signal
After 2-6 post-ending errands, the player should hear or trigger branch-specific witness lines near the active support loop and feel that the village is reacting, not just updating counters.