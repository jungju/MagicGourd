# Feature Brief

## Name

Heungbu Arcade Loop Hard-Cut Refactor

## Problem

The current game is built as a long story-heavy quest monolith with houses, tribute beats, endings, and growth stages all living in one server script. That makes the multiplayer loop too slow, too stateful, and too hard to repeat.

## Desired Player Experience

Players should spawn into one shared map, find an injured swallow, heal it, instantly turn that into a pumpkin hit-and-reward loop, buy a simple upgrade, and jump back into the next cycle without waiting on narrative state or farming timers.

## Why Now

- The existing project direction became too complex for fast multiplayer readability.
- The main loop needs to become obvious within the first minute.
- Future extensions will be easier if the base game is one clean arcade economy instead of a branching quest stack.

## Constraints
- Roblox constraints: keep AI simple, use prompt interactions, and avoid fragile map dependencies.
- Rojo constraints: runtime gameplay objects should stay under `Workspace/Map/Runtime`.
- Narrative constraints: keep the Heungbu folk-tale flavor through swallows, pumpkins, and Nolbu danger pressure without role-based story routing.
- Scope constraints: no houses, no building, no persistent land, no crop growth timers, no player roles.

## Existing Systems Touched

- `src/server/init.server.luau`
- `src/client/init.client.luau`
- `src/shared/*`
- `docs/pm/TASKS.md`
- `README.md`

## Success Signal

Players can complete the swallow -> seed -> pumpkin -> money -> upgrade -> repeat loop immediately in multiplayer, with ownership protected and old story-only systems no longer active.
