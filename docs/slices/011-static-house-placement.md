# Slice 011 - Static House Placement

## Goal

Place the `Heungbu House` and `Nolbu House` assets from `ASSET_IDS.md` into the current world as static decorative landmarks without changing the live arcade loop logic.

## Scope

- insert the two house assets by exact asset ID
- place them under `Workspace.Map.PlacedAssets`
- ground and orient them using the archived house-placement baseline
- keep the change decorative only with no prompts, NPCs, remotes, or runtime spawn code
- update the slice/progress/PM/docs surfaces to reflect the new world state

## Touched Areas

- `MagicGourd.rbxlx`
- `MagicGourd.rbxlx.lock`
- `.loop/tasks.json`
- `.loop/progress.md`
- `docs/pm/TASKS.md`
- `README.md`
- `docs/game_overview.md`
- `ASSET_IDS.md`

## Acceptance Criteria

- `Workspace.Map.PlacedAssets.HeungbuHouse` and `Workspace.Map.PlacedAssets.NolbuHouse` exist in Studio edit mode
- both houses are upright, grounded to the village floor, and compositionally aligned to the Heungbu and Nolbu sides
- no gameplay/runtime code path is changed to spawn or control the houses
- `rojo build default.project.json --output <temp>` still succeeds
- play mode still boots the arcade loop and keeps prompts/signs readable around the central route

## Validation Plan

1. Confirm the active Studio instance is `MagicGourd.rbxlx`.
2. Load the two house assets by exact ID through Studio.
3. Place, scale, orient, and ground the houses under `Workspace.Map.PlacedAssets`.
4. Capture edit-time views to confirm upright silhouettes and composition.
5. Start play and confirm the current arcade loop still boots with the houses present.
6. Run `rojo build default.project.json --output <temp>` as the repo-local build gate.

## Risks / Follow-Ups

- The currently open Studio session still has legacy chat core-script noise until the place reloads with the updated chat settings.
- If future readability validation shows houses stealing focus from prompts/signs, retune placement rather than moving them into runtime logic.
- `Nolbu` NPC placement remains explicitly out of scope for this slice.
