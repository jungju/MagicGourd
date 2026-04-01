# Testing Strategy

This strategy is based on the tools and workflows that are actually confirmed in the repo and current session.

## Confirmed Validation Surfaces

### Repo-Local

- `rojo build default.project.json --output <temp>` is the primary confirmed build check.
- Source inspection and grep-based audits are available and already useful for:
  - remote inventory
  - attribute inventory
  - persistence boundary checks
  - doc/code drift checks

### Session-Available

- Roblox Studio process availability and Codex-accessible Studio/MCP reachability are separate checks.
- During `SLICE-002` on 2026-03-28, `RobloxStudioBeta` was running with `MagicGourd.rbxlx` open, but the expected bridge at `http://localhost:13469/studio` was unreachable from Codex.
- Confirm Studio/MCP bridge reachability before assuming Codex can:
  - read Studio mode
  - start play
  - stop play
  - run benign code in Studio

## Static Quality Gates

### Required

1. Rojo build must succeed.
2. Changed docs must match current behavior.
3. Remote and authority changes must be reviewed against current server validation.

### Optional / Availability-Based

The repo does not currently prove the presence of these tools:
- `stylua`
- `selene`
- `luau-analyze`
- dedicated Luau test framework config

If one of these is installed in the working environment, it may be used. If not, do not pretend it is part of the guaranteed repo-local gate.

## Smoke Test

### Baseline Smoke

Use this after meaningful gameplay or UX changes:

1. Build with Rojo.
2. Open/attach Roblox Studio.
3. Confirm Studio mode is reachable.
4. Start play.
5. Verify the game boots without immediate errors.
6. Stop play cleanly.

### Arcade Loop Smoke

When a slice touches active gameplay:

1. Spawn into the plaza.
2. Heal a swallow.
3. Receive seed gain.
4. Plant a pumpkin.
5. Break the pumpkin.
6. Gain money.
7. Buy an upgrade if affordable.
8. Confirm the loop remains playable afterward.

## Multiplayer Regression

Run this when a slice changes remotes, ownership, shared objects, player cleanup, or feedback tied to multiplayer state.

Checklist:
- two players can see shared-world actors
- one player cannot cash out another player’s pumpkin
- player leave cleanup does not delete shared world systems
- replicated prompts and feedback do not mislead ownership

## Performance Review

Current likely hotspots:
- HUD complexity in `src/client/init.client.luau`
- feedback popup churn
- prompt density and prompt state tracking
- goblin retarget loops
- runtime prop accumulation

Performance review should focus on:
- frame hitches during repeated feedback bursts
- excessive runtime object growth
- prompt overlap or clutter in dense camera slices

## Assumptions

- There is no repo-local automated unit/integration test framework configured today.
- Studio/MCP may be useful in some sessions, but it should be treated as an optional session capability that must be re-verified before a Studio-driven slice.

## TODO

- If the project later adopts `stylua`, `selene`, `luau-analyze`, or a Roblox test framework, add them here only after they exist in repo or are consistently available in project tooling.
