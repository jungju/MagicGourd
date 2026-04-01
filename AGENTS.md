# AGENTS.md - MagicGourd

This file is the canonical Codex operating contract for the `MagicGourd` repository.

`MagicGourd` is an already-running Roblox + Rojo project. Treat it as a live brownfield repo whose current gameplay baseline is the shared arcade loop in `src/`, not as a blank scaffold and not as the older archived branching-story prototype.

## Project Identity

- Project: `MagicGourd`
- Engine: Roblox
- Sync model: Rojo
- Live gameplay baseline: shared Heungbu-themed arcade loop
- Canonical operating surfaces already present:
  - `AGENTS.md`
  - `docs/design/*`
  - `docs/pm/TASKS.md`
  - `.loop/*`

## Truth Sources

When there is doubt, trust sources in this order:

1. Source code in the repo
2. Git history
3. Rojo project files
   - `default.project.json`
   - `sourcemap.json`
4. `docs/*`
5. `.loop/*`

Interpretation rules:
- The current gameplay truth lives in `src/server`, `src/client`, `src/shared`, and `src/workspace`.
- The current active direction is what code + current README + active PM/docs agree on.
- Historical design folders under `docs/design/` are reference material unless they match the live code and PM baseline.
- `.omx/` is runtime/session tooling state, not a replacement for repo canon.

## Current Repo Baseline

### Rojo Mapping

- `src/server` -> `ServerScriptService/Server`
- `src/client` -> `StarterPlayer/StarterPlayerScripts/Client`
- `src/shared` -> `ReplicatedStorage/Shared`
- `src/workspace` -> `Workspace/Map`

### Current Gameplay Architecture

- `src/server/init.server.luau` is a thin bootstrap.
- `src/server/ArcadeRuntime.luau` wires the current loop together.
- The server is split into focused services such as:
  - `ArcadeWorld.luau`
  - `PlayerStateService.luau`
  - `SwallowService.luau`
  - `PumpkinService.luau`
  - `GoblinService.luau`
  - `UpgradeService.luau`
- `src/client/init.client.luau` is currently the main HUD/input/feedback orchestration surface.
- `src/shared/ArcadeConfig.luau` is the current shared gameplay contract for remotes, attributes, zone tuning, upgrade values, and feedback behavior.
- `src/workspace/JoseonBase` is the Rojo-managed base map.
- `Workspace/Map/Runtime` is the server-authored runtime gameplay layer.

### Active Remote Surface

Document and preserve the current remote contract unless a slice explicitly changes it:

- `HealSwallow`
- `UseSeed`
- `HitPumpkin`
- `ArcadeFeedback`

### Persistence Boundary

- No repo-local DataStore/ProfileService save implementation currently exists in `src/`.
- Do not write docs or agent guidance that imply a live persistence layer unless one is actually added.

## One Slice Rule

- Work on exactly one feature slice at a time.
- Do not start the next slice until the current slice is either:
  - done, or
  - explicitly blocked with evidence.
- A slice must be a shippable vertical increment, not an open-ended category of work.
- Keep `.loop/tasks.json`, `.loop/progress.md`, PM state, and slice docs aligned with the single active slice.

## Additive Migration Rule

- Prefer additive migration over large rewrites.
- Do not reorganize `src/` just to satisfy an ideal structure.
- Do not remap Rojo paths unless the slice explicitly requires it and the benefit is proven.
- Do not casually move or rename runtime/gameplay modules that the current repo already uses coherently.
- Existing reasonable structure should be preserved and documented rather than “fixed” by force.

## Client / Server / Shared Boundary Rules

### Client

Client code may:
- own HUD, local readability logic, input routing, prompt visibility handling, and client-side feedback presentation
- read replicated attributes and react to replicated runtime objects
- fire remotes with user intent only

Client code must not:
- grant rewards
- decide authoritative ownership
- decide final hit/heal validity
- mutate authoritative game economy state on its own

### Server

Server code should:
- validate all gameplay intent
- mutate player economy and runtime state
- create/destroy runtime gameplay objects
- own shared-world NPC behavior
- enforce multiplayer fairness

### Shared

Shared code should be limited to:
- stable contracts
- names/constants/tuning
- data that both client and server must agree on

Do not put server-only authority logic into `src/shared`.

## Remote / Authority / Trust Boundary Rules

- Treat every client remote as untrusted input.
- The client may request an action; the server decides whether it is valid.
- Validate at minimum:
  - distance/range
  - ownership
  - cooldowns / action cadence
  - object existence / liveness
  - current state compatibility
- Prefer Attributes for replicated read models and object ownership markers, but do not treat client-visible attributes as secure proof by themselves.
- When changing remotes or replicated attributes:
  - update `docs/architecture.md`
  - update any affected skills
  - update `.loop/progress.md` if the contract meaningfully changes

## Validation Rules

### Always Required

- Read the current slice and current PM state before editing.
- Keep the game playable.
- Run the primary repo-local build gate after meaningful changes:
  - `rojo build default.project.json --output <temp>`
- Record what was actually validated.

### Required When Gameplay Changes

If a slice changes gameplay behavior:
- verify the server/client/shared contract touched by the change
- verify the current loop still works end-to-end
- update product/architecture docs if player-facing behavior changed

### Required When UI Changes

If a slice changes UI/HUD/feedback:
- verify player-facing copy and layout still match the current loop
- verify next-step guidance and prompt/readability behavior remain coherent
- use Studio/MCP validation when available for final confidence

### Required When Replication Changes

If a slice changes remotes, ownership, shared runtime objects, or multiplayer behavior:
- perform a remote/trust-boundary audit
- document server authority and client assumptions
- run multiplayer regression steps, or mark exactly why that validation is blocked

## Documentation Update Rules

Update docs when you change the behavior they describe.

At minimum, behavior-changing slices must review:
- `README.md`
- `docs/game_overview.md`
- `docs/prd.md`
- `docs/architecture.md`
- `docs/testing_strategy.md`
- `docs/pm/TASKS.md`
- `.loop/progress.md`

Do not leave repo docs knowingly describing an older baseline after changing live behavior.

## PM / Loop Coordination Rules

- `docs/pm/TASKS.md` is the current implementation-facing task ledger.
- `.loop/tasks.json` is the Codex execution/backlog surface.
- Keep them consistent in direction even if they use different granularity.
- Treat `README.md`, the latest adopted design, and `docs/pm/TASKS.md` as the current execution baseline; use `.loop/*` to support that baseline, not to contradict it.

## Files To Treat Carefully

- `MagicGourd.rbxlx`
- `MagicGourd.rbxlx.lock`
- `sourcemap.json`

Only touch them when the slice truly requires it.

## Default Development Heuristic

If the user does not override direction, prefer:
1. keeping the current shared arcade loop correct and readable
2. validating blocked Studio/MCP confidence gaps
3. tightening multiplayer fairness and remote authority
4. improving visible player clarity and feel
5. only then expanding scope

## Success Condition

Good work in this repo:
- preserves playability
- respects the current Rojo mapping
- keeps one active slice in motion
- records truth in docs and loop artifacts
- improves the live arcade baseline without speculative rewrites
