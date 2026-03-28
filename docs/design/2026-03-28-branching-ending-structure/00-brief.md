# Feature Brief

## Name
Branching Ending Structure

## Problem
The current story loop ends at `COMPLETE` with free-play farming, but the game does not yet convert the Heungbu/Nolbu conflict into a clear ending stance. Players finish the retaliation cleanup and then just continue harvesting. That weakens the emotional landing of the folktale and leaves no authored bridge into future story expansion.

## Desired Player Experience
After clearing Nolbu's brambles, the player should feel that they are making a meaningful final statement about what kind of village story they helped create. The ending should be small enough for the current slice, but distinct enough that players understand there are different moral outcomes growing from the same core loop.

## Why Now
- The current story arc now reliably reaches blessed payoff -> retaliation -> recovery.
- PM already marks ending / branching structure as the highest-priority new story work.
- A lightweight ending structure gives upcoming PM/Dev work a concrete target without requiring a full chapter-two rewrite.

## Constraints
- Roblox constraints: keep flow prompt-driven and UI-driven; avoid long cutscenes or fragile animation dependencies.
- Rojo constraints: new logic should live in current server/client scripts or compact helpers; no Studio-only branching setup.
- Narrative constraints: ending must stay faithful to Heungbu's kindness vs Nolbu's greed dynamic.
- Scope constraints: MVP should reuse existing NPCs, patch, basket, swallow, HUD, dialogue, and story effect channels.

## Existing Systems Touched
- Quest stage progression after `CLEAR_BRAMBLES`
- Heungbu / Nolbu interaction prompts
- StoryEffectEvent presentation beats
- player attributes / transient profile state
- village billboards and reward counters

## Success Signal
A player who finishes bramble clearing is funneled into a short ending choice/resolution sequence, receives a distinct ending label and reward framing, and can clearly tell which village outcome they achieved.