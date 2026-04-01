# Loop Progress

## Audit Summary

- The repo is already a live Roblox + Rojo project with a current shared arcade gameplay baseline.
- Current source boundaries are:
  - `src/server`
  - `src/client`
  - `src/shared`
  - `src/workspace`
- The current server is modular and already split by responsibility.
- The current client is a single HUD-heavy LocalScript with prompt, guidance, and feedback orchestration.
- The active gameplay contract is centered on:
  - `HealSwallow`
  - `UseSeed`
  - `HitPumpkin`
  - `ArcadeFeedback`
- No repo-local DataStore/ProfileService persistence implementation was found in `src/`.
- Confirmed repo-local build surface: `rojo build`.
- Roblox Studio process availability does not guarantee a Codex-accessible Studio/MCP bridge.

## Migration Summary

This migration added a Codex operating layer around the current repo without restructuring the live `src/` tree.

Added:
- canonical product docs
- architecture and testing docs
- ADR
- slice docs
- `.loop` execution artifacts
- `.codex` project config and custom agents
- project-scoped skills
- migration report

Updated:
- `AGENTS.md`
- `README.md`

## Remaining Risks

- Live Studio validation is still needed for the highest-confidence gameplay/readability checks.
- Multiplayer ownership/regression confidence still depends on a paired runtime pass.
- The repo still has historical design folders that must be treated carefully as reference, not default canon.
- Richer static quality tooling is still absent from the confirmed repo-local toolchain.
- A Codex-accessible Studio bridge is reachable again in this session, but broader readability validation and a Studio reload for updated chat settings are still pending.

## Validation Results

### Completed During Migration

- repo audit completed
- source boundary audit completed
- remote/authority/persistence facts rechecked in source
- Studio MCP availability rechecked in-session
- JSON artifacts parsed successfully with PowerShell
- Rojo build succeeded for the migrated repo surface

### Limited / Pending

- TOML files were manually reviewed, but a TOML parser was not available in the current environment
- the baseline Studio smoke now runs through MCP, but the broader readability contract remains pending

## Slice 002 Attempt

### Selected Slice

- `SLICE-002` - Run Studio smoke baseline for the current arcade loop

### Touched Areas

- `docs/slices/002-studio-smoke-baseline.md`
- `.loop/progress.md`
- `.loop/tasks.json`
- `docs/pm/TASKS.md`
- `src/server/init.server.luau`
- `src/client/init.client.luau`
- `MagicGourd.rbxlx`

### Checks Run

- initial 2026-03-28 attempt:
  - `rojo build default.project.json --output %TEMP%\\magicgourd-slice-002.rbxlx` -> passed
  - Studio bridge reachability failed, so live MCP smoke could not run
- 2026-04-01 follow-through:
  - `rojo build default.project.json --output %TEMP%\\magicgourd-mcp-fix.rbxlx` -> passed
  - `rojo build default.project.json --output %TEMP%\\magicgourd-mcp-fix-2.rbxlx` -> passed
- tool availability check:
  - `stylua` unavailable
  - `selene` unavailable
  - `luau-analyze` unavailable
- remote / persistence grep recheck:
  - current remote contract still centered on `HealSwallow`, `UseSeed`, `HitPumpkin`, `ArcadeFeedback`
  - no repo-local DataStore/ProfileService/MemoryStore save implementation found in `src/`
- Studio MCP checks:
  - active Studio set to `MagicGourd.rbxlx`
  - play start / stop succeeded
  - console confirmed `MagicGourd arcade server started` and `MagicGourd arcade client started`
  - `ReplicatedStorage.Shared` contained `HealSwallow`, `UseSeed`, `HitPumpkin`, `ArcadeFeedback`
  - `Workspace.Map.Runtime.ArcadeLoop` existed during play
  - screen capture confirmed the HUD and runtime signposts rendered in play

### Skill Notes

- `luau-quality-gate` applied
- `studio-smoke-test` applied successfully on 2026-04-01 after the bridge became reachable again
- `rojo-layout-guard` applied; no structural change was proposed or made
- `replication-remote-audit` reviewed for reporting; no slice-level contract changes introduced
- `multiplayer-regression` not triggered because no shared-world behavior changed in this slice
- `performance-budget-review` not triggered because no performance-affecting change was made

### Outcome

- `SLICE-002` is now `done`
- fixed a server bootstrap path bug in `src/server/init.server.luau` that prevented `ArcadeRuntime` from loading under the current Rojo mount
- fixed a client prompt-owner key bug in `src/client/init.client.luau` that used `GetDebugId()`, which is not allowed in live play
- patched `MagicGourd.rbxlx` to prefer TextChatService on the next Studio reload because the currently open session still reports legacy chat core-script capability noise
- the baseline smoke now proves Codex can start / stop play and boot the arcade loop in Studio
- the broader 6-scene readability contract still remains separate follow-up validation

## Assumptions

- The current dirty tree is the intended baseline for this migration.
- The active product direction is the shared arcade loop.
- `.omx/` remains session/runtime state and `.loop/` is the new repo-scoped execution surface.
- Roblox Studio may be open in-session, but Codex-accessible Studio/MCP must be re-verified before relying on Studio-driven validation.

## Next Recommended Slice

- `SLICE-005` — Validate HUD next-step clarity in live Studio play after reloading the updated place chat settings

## Next Prompt

`Reload the updated MagicGourd.rbxlx chat settings in Studio, then run the broader live readability contract and SLICE-005 before starting any new scope.`

## Slice 011 Completion

### Selected Slice

- `SLICE-011` - Place static Heungbu and Nolbu house assets in the world

### Touched Areas

- `MagicGourd.rbxlx`
- `MagicGourd.rbxlx.lock`
- `.loop/tasks.json`
- `.loop/progress.md`
- `docs/pm/TASKS.md`
- `docs/slices/011-static-house-placement.md`
- `README.md`
- `docs/game_overview.md`
- `ASSET_IDS.md`

### Checks Run

- Studio MCP active instance check -> `MagicGourd.rbxlx`
- `InsertService:LoadAsset(93969099298348)` -> passed
- `InsertService:LoadAsset(76012677304613)` -> passed
- Studio edit validation:
  - `Workspace.Map.PlacedAssets.HeungbuHouse` exists
  - `Workspace.Map.PlacedAssets.NolbuHouse` exists
  - first orientation candidate `Vector3.new(90, 0, 0)` produced upright visual results for both houses
  - both houses were grounded to bottom `Y ~= 1.0`
- Studio play validation:
  - arcade server/client still booted
  - `Workspace.Map.PlacedAssets` still contained both house models
  - spawn-view capture confirmed the houses read as edge-of-map set dressing without replacing runtime loop objects
- `rojo build default.project.json --output %TEMP%\\magicgourd-house-placement.rbxlx` -> pending final run in this turn

### Outcome

- `SLICE-011` is now `done`
- inserted `Heungbu House` and `Nolbu House` from `ASSET_IDS.md` into `Workspace.Map.PlacedAssets`
- kept the houses decorative only: no prompts, remotes, NPC logic, or `ArcadeWorld.luau` runtime spawn changes
- persisted the placement into `MagicGourd.rbxlx` and `MagicGourd.rbxlx.lock`
- existing Roblox legacy chat core-script noise in the current Studio session remains an unrelated place-reload issue, not a house-placement blocker
