# Brief

## Feature
Arcade Interaction Readability Pass

## Problem
The current playable structure is the arcade loop, and it already works at a mechanical level:
- heal swallows for seeds
- use seeds to spawn owned pumpkins
- break pumpkins for money
- buy plaza upgrades
- avoid goblin slow

What under-delivers now is not scope. It is **moment-to-moment readability**.

The current HUD and prompt layer still asks the player to infer too much:
- the top-left panel is dense and static
- the bottom `Use Seed [Q]` button helps, but the next-best action is still not always obvious
- upgrade costs/progression read more like raw text than quick decisions
- feedback banners are generic and short-lived
- zone identity, danger state, and loop priority are present, but not cleanly ranked

## Goal
Design a focused readability/completion pass that makes the existing arcade loop easier to parse in the first 60 seconds and cleaner to read during repeated play, **without adding new systems or reopening story-mode scope**.

## Constraints
- Refinement mode only: no new progression tracks, combat systems, quests, or branch layers.
- Reuse the current HUD, prompt, remote, and attribute architecture.
- UI must remain lightweight and Rojo-safe.
- Prefer text hierarchy, state emphasis, and contextual hints over more widgets.
- Changes should be implementable inside the current `src/client/init.client.luau` and existing runtime prompt flow.

## Affected Areas
- arcade HUD layout and copy hierarchy
- contextual next-action guidance
- upgrade panel readability
- feedback banner semantics
- danger / slowed-state readability
- prompt naming consistency

## Success Signal
A new player can enter the arcade map and, with almost no trial and error:
1. identify the first action,
2. understand why seeds and money matter,
3. notice when goblins are the current threat,
4. compare upgrade options quickly,
5. keep playing repeated loops without feeling the HUD is fighting them.