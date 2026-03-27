# MagicGourd

Roblox game project powered by Rojo.

## Structure

- `src/server` → `ServerScriptService/Server`
- `src/client` → `StarterPlayer/StarterPlayerScripts/Client`
- `src/shared` → `ReplicatedStorage/Shared`
- `src/workspace` → `Workspace/Map`

## Workspace Sync Contract

- `Workspace/Map` is partially managed by Rojo from `src/workspace`.
- `Workspace/Map/JoseonBase` is the Rojo-managed base map for the project.
- Other `Workspace/Map` children can stay Studio-managed as long as they do not reuse the `JoseonBase` name.
- The live-synced base terrain is built from parts and models instead of Roblox Terrain voxels.
- Runtime-spawned houses/NPCs now live under `Workspace/Map/Runtime` so the village loop can survive flaky InsertService loads without fighting Rojo.

## Current Gameplay Slice

- Heungbu house and Nolbu house attempt to load from asset ids, but fall back to simple local builds if loading fails.
- Two Nolbu patrol NPCs wander around the estate using pathfinding.
- Players can collect seeds, grow a gourd, harvest it, and deliver it to Heungbu for coins.
- Village prompt markers and lightweight decor are present even without Studio-only setup.

## Run

```bash
rojo serve
```

Then connect from the Rojo plugin in Roblox Studio.
