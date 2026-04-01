# Slice 002 - Studio Smoke Baseline

## Goal

Run the first post-migration Studio smoke baseline for the current arcade loop and either:
- clear the live validation blocker, or
- record a concrete environment blocker with evidence.

## Scope

- validate the current arcade loop without changing gameplay rules
- use repo-local checks first, then attempt Studio/MCP-backed smoke
- keep any fix inside low-scope readability tuning only
- update slice, PM, and progress artifacts to match the real outcome

## Touched Areas

- `docs/slices/002-studio-smoke-baseline.md`
- `.loop/progress.md`
- `.loop/tasks.json`
- `docs/pm/TASKS.md`
- `src/server/init.server.luau`
- `src/client/init.client.luau`
- `MagicGourd.rbxlx`

## Acceptance Criteria

- `rojo build default.project.json --output <temp>` succeeds
- Studio play can start and stop cleanly from the available validation surface
- the arcade loop can be smoke-checked without immediate blocker errors
- validation notes are recorded in `.loop/progress.md`

## Validation Plan

1. `luau-quality-gate`
   - run `rojo build default.project.json --output <temp>`
   - check `stylua`, `selene`, `luau-analyze` availability
   - grep current remote and persistence facts so the slice does not drift contract language
2. `studio-smoke-test`
   - confirm whether a Codex-accessible Studio/MCP bridge is actually reachable
   - if reachable, run baseline play start/stop and the 6-scene readability contract
3. `rojo-layout-guard`
   - confirm this slice does not move files or change Rojo/runtime layering
4. `replication-remote-audit`
   - recheck remote and attribute truth for reporting
   - do not treat this as a contract-changing slice
5. `multiplayer-regression`
   - only required for live shared-world verification if the slice changes shared runtime behavior
6. `performance-budget-review`
   - only required if the slice changes HUD refresh, popup churn, goblin loops, or prompt density

## Result

### Status

`done`

### Checks Run

- `rojo build default.project.json --output %TEMP%\\magicgourd-mcp-fix.rbxlx` -> passed
- `rojo build default.project.json --output %TEMP%\\magicgourd-mcp-fix-2.rbxlx` -> passed
- tool availability:
  - `stylua` unavailable
  - `selene` unavailable
  - `luau-analyze` unavailable
- static inspections:
  - remote contract still centered on `HealSwallow`, `UseSeed`, `HitPumpkin`, `ArcadeFeedback`
  - no repo-local DataStore/ProfileService/MemoryStore implementation found in `src/`
- Studio MCP checks:
  - active Studio set to `MagicGourd.rbxlx`
  - play start / stop succeeded
  - `ReplicatedStorage.Shared` contained `HealSwallow`, `UseSeed`, `HitPumpkin`, `ArcadeFeedback`
  - `Workspace.Map.Runtime.ArcadeLoop` existed during play
  - screen capture confirmed HUD and runtime signage rendered in play
- runtime fixes applied:
  - `src/server/init.server.luau` now requires `ArcadeRuntime` from the bootstrap Script itself instead of `ServerScriptService`
  - `src/client/init.client.luau` no longer calls `GetDebugId()` for prompt-owner tracking and uses the prompt instance as the stable key
- place-setting follow-through:
  - the currently open Studio session still reported legacy chat core-script capability noise
  - `MagicGourd.rbxlx` now sets `Chat.LoadDefaultChat = false`, `TextChatService.ChatVersion = TextChatService`, and `TextChatService.IsLegacyChatDisabled = true` for the next Studio reload

### Smoke Verdict

- The Codex-accessible Studio/MCP bridge was reachable in-session.
- Studio play now starts and stops cleanly through Codex.
- The arcade loop boots in play with runtime folders and remote events present.
- Two immediate MagicGourd runtime blockers were fixed:
  - the server bootstrap was waiting in the wrong parent for `ArcadeRuntime`
  - the client HUD prompt-owner path used `GetDebugId()`, which is not allowed in live play
- The broader 6-scene readability contract is still a separate follow-up and was not completed in this slice.
- The currently open Studio session still logs legacy chat core-script capability noise until the updated place chat settings are reloaded.

### Skill Outcome

- `luau-quality-gate`: applied
- `studio-smoke-test`: applied successfully for play start / stop, runtime boot, and HUD confirmation
- `rojo-layout-guard`: applied; no structural drift introduced
- `replication-remote-audit`: reviewed for reporting; no slice-level contract changes introduced
- `multiplayer-regression`: not triggered because no shared-world behavior changed in this slice
- `performance-budget-review`: not triggered because no performance-affecting change was made

## Risks / Follow-Ups

- Reopen Studio with the updated place chat settings before treating the legacy chat core-script noise as resolved.
- Run the separate 6-scene readability contract before clearing `MG-PM-408`.
- Continue with the next live-validation slice only after the readability contract has evidence.
