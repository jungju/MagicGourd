# Verification

## Completeness Check
- Covers user flow from swallow heal to upgrade buy.
- Defines exact canonical verbs for every repeated loop action.
- Covers HUD, prompts, buttons, signs, banners, and popups.
- Stays within existing systems and avoids scope expansion.
- Identifies the one small runtime follow-through needed for slow-cleared feedback.

## Why This Is Needed Now
The live arcade loop is already mechanically small. In small loops, wording carries more weight because players see the same surfaces repeatedly. Inconsistent wording makes repetition feel rough instead of polished.

## Fun / Feel Check
This pass should improve:
- confidence about what to do next
- reward feel when converting seeds into money
- sense of completion when buying upgrades
- readability of danger interruption vs safe farming
- overall perception that the game is intentionally authored

## Conflict Check
- No new feature scope.
- No new economy rules.
- No story-system revival.
- No dependence on persistent data.
- Compatible with the existing top-left HUD pass and PM rebuild targets.

## Roblox / Rojo Feasibility
- Very feasible with the current codebase.
- Mostly string and formatting updates.
- Prompt text updates are local to existing generation sites.
- Billboard text remains runtime-generated and Rojo-safe.

## Implementation Checklist
- [ ] Canonical verbs (`Heal`, `Plant`, `Break`, `Buy`, `Avoid/Recover`) replace mixed synonyms in visible copy.
- [ ] Action button text teaches planting instead of generic seed usage.
- [ ] Pumpkin prompt changes from `Hit` to `Break`.
- [ ] Upgrade prompt changes from generic `Upgrade` to `Buy` + specific upgrade name.
- [ ] Zone and spawn billboards become shorter and purpose-first.
- [ ] Banner and popup messages are rewritten by event bucket.
- [ ] Slow-applied and slow-cleared language both exist and feel coherent.
- [ ] Low-priority HUD support line reinforces the same verb chain.

## Final Verdict
Adopted.

This is a tight refinement artifact: it improves flow clarity, readability, reward feel, interaction polish, and coherence inside the current game without inventing a larger design surface.
