# MagicGourd

Roblox game project powered by Rojo.

## Structure

- `src/server` -> `ServerScriptService/Server`
- `src/client` -> `StarterPlayer/StarterPlayerScripts/Client`
- `src/shared` -> `ReplicatedStorage/Shared`
- `src/workspace` -> `Workspace/Map`

## Current Baseline

MagicGourd is currently a shared Heungbu-themed arcade loop, not a branching story prototype.

Current loop:
1. spawn in the Central Plaza
2. run to Heungbu Village and heal an injured swallow
3. gain seeds immediately
4. use a seed to spawn an owned pumpkin near the player
5. break the pumpkin for money
6. buy one of three plaza upgrades
7. repeat while avoiding goblins in the Nolbu danger zone

### Shared World Rules

- all players are Heungbu
- swallows and goblins are shared
- seeds, money, upgrades, and pumpkins are player-owned
- pumpkins expire automatically and are destroyed on player leave
- no building, no house ownership/management, no persistent land, and no farming growth timers

## Workspace Sync Contract

- `Workspace/Map` is partially managed by Rojo from `src/workspace`.
- `Workspace/Map/JoseonBase` remains the Rojo-managed backdrop map.
- `Workspace/Map/Runtime` is rebuilt at runtime into the live arcade loop arena.

## Current Server Modules

- `ArcadeRuntime.luau` wires the loop together
- `ArcadeWorld.luau` rebuilds the runtime arena
- `PlayerStateService.luau` owns player economy and upgrade state
- `SwallowService.luau` manages shared injured swallows
- `PumpkinService.luau` manages owned pumpkins and rewards
- `GoblinService.luau` manages danger-zone NPC pressure
- `UpgradeService.luau` handles prompt-based plaza upgrades

## Canonical Docs

- Overview: [docs/game_overview.md](docs/game_overview.md)
- PRD: [docs/prd.md](docs/prd.md)
- Architecture: [docs/architecture.md](docs/architecture.md)
- Testing: [docs/testing_strategy.md](docs/testing_strategy.md)
- Current active design baseline: `docs/design/2026-03-28-heungbu-arcade-loop/`
- Slice backlog: `.loop/tasks.json`

Historical design folders under `docs/design/` remain as reference, but they are not the default active canon unless the current code and PM state explicitly point back to them.

## Run

```bash
rojo serve
```

Then connect from the Rojo plugin in Roblox Studio.
