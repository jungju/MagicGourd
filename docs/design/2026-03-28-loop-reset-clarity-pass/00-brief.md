# Brief

## Opportunity
The current arcade loop now reads cleanly at the action level (`Heal`, `Plant`, `Break`, `Buy`, `Recover`), but the **handoff between one completed beat and the next loop start** is still the most under-authored precision gap.

The project already improved:
- verb consistency
- plaza role clarity
- event anchor consistency
- feedback cadence
- visual band separation
- Studio readability contracts

What still risks feeling slightly loose is the **reset moment** after:
- a pumpkin payout
- an upgrade purchase
- a slow recovery
- a state where the player could do more than one valid thing next

This is not a mechanics gap. It is a completion/polish gap.

## Refinement targets (3-7)
1. Clarify which action should feel like the default next step after payout.
2. Clarify how a purchase should hand the player back into the loop.
3. Prevent post-slow recovery from feeling like a dead informational beat.
4. Reduce vague "you can do several things" states inside HUD support copy.
5. Keep reward feel strong without turning guidance into tutorial spam.

## Scope
In scope:
- HUD `Next:` / `Status:` / support-tip wording contract
- post-payout / post-buy / post-recover handoff rules
- guidance priority rules for ambiguous states
- short validation checks for loop re-entry clarity

Out of scope:
- new mechanics
- new rewards or upgrades
- new map objects
- new tutorial flows
- rebalance

## Success bar
A player finishing any single beat should regain one obvious next intention within a glance, without needing extra UI surfaces or more verbose copy.