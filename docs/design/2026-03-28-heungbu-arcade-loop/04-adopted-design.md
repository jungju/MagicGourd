# Adopted Design

## Chosen Candidate

Candidate 1: hard-cut shared arcade loop.

## Why Chosen

It is the only option that fully removes the old product ambiguity and makes the multiplayer fantasy readable in seconds instead of after a guided quest chain.

## Why Others Were Rejected

- Candidate 2 keeps two games inside one repo and preserves confusion.
- Candidate 3 trims pacing but leaves the old monolithic quest architecture alive.

## Player Flow
1. Spawn in Central Plaza.
2. Run into Heungbu Village and find an injured swallow.
3. Heal the swallow and gain seeds immediately.
4. Use a seed to spawn an owned pumpkin near the player.
5. Hit the pumpkin until it breaks and pays money.
6. Buy a movement, attack-speed, or seed-yield upgrade in the plaza.
7. Re-enter the loop while avoiding goblins in the Nolbu danger area.

## Quest / State Flow

- No story quest chain.
- Session state is only seeds, money, upgrade levels, slowdown state, and owned pumpkins.

## World Objects
- NPCs: two goblins with simple nearest-player chase.
- prompts: swallow heal, pumpkin hit, three upgrade pads.
- map props: three zone pads, pathing, lanterns, danger rocks, pumpkin statue.
- interaction points: swallow roots and pumpkin roots carry interaction attributes for the client prompt router.

## Server Design
- `init.server.luau` becomes a thin bootstrap.
- `ArcadeWorld` builds the runtime arena under `Workspace/Map/Runtime`.
- `PlayerStateService` owns seeds, money, upgrades, speed application, and slowdown recovery.
- `SwallowService` maintains a fixed active swallow count and rewards seeds on heal.
- `PumpkinService` handles seed use, ownership, hit validation, rewards, timeout cleanup, and player-leave cleanup.
- `GoblinService` runs minimal `Humanoid:MoveTo` chase logic and applies slowdown on touch.
- `UpgradeService` spends money through plaza prompts.

## Client Design
- Replace quest/dialogue UI with one compact HUD showing seeds, money, three upgrade levels, and current debuff state.
- Add a visible seed-use button plus `Q` keyboard shortcut.
- Route prompt triggers through the three allowed remotes: `HealSwallow`, `UseSeed`, `HitPumpkin`.

## Data Model
- player attributes: `Seeds`, `Money`, `MoveSpeedLevel`, `AttackSpeedLevel`, `SeedMultiplierLevel`, `IsSlowed`
- pumpkin attributes: `owner`, `Health`, `ExpiresAt`
- runtime folders: `Runtime/ArcadeLoop/Static`, `Swallows`, `Pumpkins`, `Goblins`

## Failure / Edge Cases
- if player leaves: destroy owned pumpkins and clear transient hit state.
- if goblin pathing drifts or falls: reset toward home point and keep the loop running.
- if multiple players target one swallow: server grants the reward only once because the swallow is destroyed on the first valid heal.
- if another player hits a pumpkin: server rejects the damage because ownership is checked against `owner`.

## MVP Cut Line

Ship only the shared loop, prompt upgrades, basic goblin pressure, and cleanup guarantees. Do not add persistence, building, dialogue, endings, or alternate modes in this pass.

## Future Extensions

- cosmetic feedback for successful heals and pumpkin breaks
- additional swallow spawn variety
- stronger goblin zone presentation
- extra money sinks that do not reintroduce construction complexity
