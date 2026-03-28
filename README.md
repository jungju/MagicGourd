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
- Runtime-spawned houses, prompts, patrol nodes, and fallback props live under `Workspace/Map/Runtime` so the village slice survives flaky InsertService loads without fighting Rojo.

## Current Gameplay Slice

- Heungbu house and Nolbu house attempt to load from asset ids, but fall back to simple local builds if loading fails.
- Two Nolbu patrol NPCs wander around the estate using pathfinding with slightly sturdier collision/network setup.
- Players now get a clearer quest chain:
  1. read the Story Stone / meet Heungbu
  2. collect a seed
  3. plant and wait for the vine
  4. harvest a gourd
  5. deliver the first gourd to Heungbu
  6. return for bonus seeds and story progression
  7. hear Nolbu's demand
  8. grow a tribute gourd for Nolbu's basket
- A lightweight client HUD shows the current quest title, objective, and seed/gourd/coin counts.
- Dialogue popups fire from server-side interactions so the story stays readable even with basic placeholder assets.
- Village billboards update with delivery / tribute totals to make the reward loop feel more explicit.
- Runtime placement is organized through a small layout table so village tuning can happen in code without Studio-only setup.

## Design Agent Workflow

- Project-level design workflow is defined in `DESIGN_AGENT.md`.
- Feature designs should be recorded under `docs/design/YYYY-MM-DD-<slug>/`.
- Default stages:
  1. propose
  2. candidates
  3. analyze
  4. adopt
  5. design spec
  6. final verification
- Templates live in `docs/design/TEMPLATES.md`.

This is intended to make MagicGourd's future features more deliberate, better justified, and easier to validate before implementation.

## Run

```bash
rojo serve
```

Then connect from the Rojo plugin in Roblox Studio.
