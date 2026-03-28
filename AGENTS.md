# AGENTS.md - MagicGourd

This file defines how agents should work inside the `MagicGourd` repository.

## Project Identity

- **Project:** MagicGourd
- **Theme:** 흥부전 / Heungbu & Nolbu inspired Roblox game
- **Engine:** Roblox
- **Sync:** Rojo
- **Primary goal:** Build a playable, expandable story game around the Heungbu/Nolbu tale with clear progression, strong atmosphere, and robust fallbacks.

## Working Priorities

When choosing what to work on next, prefer this order unless the user overrides it:

1. **Keep the game playable**
2. **Advance the main Heungbu story content**
3. **Improve visible player experience**
4. **Stabilize fragile Roblox/runtime behaviors**
5. **Improve internal structure/documentation**

## Operating Rule

The user has delegated day-to-day development authority for this repo.

Agents should:
- make small and medium product decisions directly
- implement features proactively
- commit meaningful increments
- ask only for:
  - major direction changes
  - destructive/rewrite-heavy decisions
  - ambiguous aesthetic choices that materially affect the game identity

## Design Workflow

For meaningful features, use the repository design workflow:

- `DESIGN_AGENT.md`
- `docs/design/README.md`
- `docs/design/TEMPLATES.md`

Default design stages:
1. propose
2. candidates
3. analyze
4. adopt
5. design spec
6. final verification

For tiny fixes, this can be compressed.
For major features, this should be documented explicitly under:
- `docs/design/YYYY-MM-DD-<feature-slug>/`

## PM Workflow

The repository also has a PM review layer:

- `PM_AGENT.md`
- `docs/pm/README.md`
- `docs/pm/TASKS.md`

PM Agent compares:
- fixed/adopted design
- current code and project state
- existing gameplay behavior

Then it updates work items into:
- `done`
- `rebuild`
- `new`
- `blocked`

Agents should use this PM layer to avoid assuming old work is fully complete just because code exists.

## Developer Workflow

The repository also has a Developer Agent layer:

- `DEV_AGENT.md`
- `docs/dev/README.md`

Developer Agent should:
- read `docs/pm/TASKS.md`
- choose the highest-value build/rebuild task
- consult design docs as needed
- implement the task
- keep the project playable
- commit meaningful progress

In short:
- Design Agent decides what should exist
- PM Agent judges what state work is in
- Developer Agent actually builds it

## Loop / Orchestrator Workflow

The repository also has a loop orchestrator layer:

- `LOOP_AGENT.md`

Loop Agent keeps the project moving by rotating:
- Design
- PM
- Dev
- Review

This is the default long-running autonomous mode for MagicGourd unless the user pauses or redirects it.

## Roblox / Rojo Rules

- Prefer **Rojo-safe** structures.
- Keep base world content under `src/workspace` whenever practical.
- Avoid brittle solutions that depend entirely on Studio-only manual state.
- If external asset loading is flaky, provide local/fallback behavior so gameplay still works.
- Runtime-created content should be organized and named clearly.
- Do not create chaos under `Workspace`; use the project’s existing structure conventions.

## Runtime Content Guidelines

Current project direction:
- `Workspace/Map/JoseonBase` = Rojo-managed base village/map
- `Workspace/Map/Runtime` = runtime-spawned or fallback gameplay objects

Agents should preserve this separation.

## Story Direction

MagicGourd should continue expanding in this narrative order unless a better structured variation is justified:

1. village introduction
2. Heungbu request/help loop
3. seed / planting / harvest
4. Nolbu demand / tribute
5. swallow injury / healing
6. magical reward escalation
7. Nolbu retaliation / consequence
8. stronger payoff events / endings / replay loop

## Gameplay Direction

Prefer features that improve one or more of these:
- clear quest progression
- meaningful NPC interactions
- visible world state change
- better reward loops
- emotional / narrative payoff
- replayable farming / delivery / event loop

## Quality Bar

Before considering work "done", check:
- Is it visible to the player?
- Does it help the Heungbu/Nolbu fantasy?
- Does it keep or improve playability?
- Is there a fallback if Roblox asset/runtime behavior fails?
- Is the implementation understandable by the next agent?

## Commit Policy

- Commit meaningful, scoped changes.
- Avoid bundling unrelated dirty/generated files unless the task explicitly requires them.
- Prefer descriptive commit messages like:
  - `feat: add swallow healing story slice`
  - `fix: prevent village ground z-fighting`
  - `docs: add design agent workflow`

## Files to Treat Carefully

These may be generated, Studio-touched, or noisy depending on workflow and should not be casually bundled:
- `MagicGourd.rbxlx`
- `MagicGourd.rbxlx.lock`
- `sourcemap.json`
- Studio-generated or unrelated dirty files outside the task scope

## Preferred Work Style

When continuing autonomously:
- inspect current state
- choose the next meaningful vertical slice
- design if needed
- implement
- keep the game playable
- commit
- leave the repo in a coherent state

## Next Good Directions

If no fresh instruction is given, good default expansions are:
- blessed seed / magical gourd payoff
- gourd opening or striking event sequence
- Nolbu retaliation event
- richer dialogue/UI polish
- village environmental storytelling
- stronger NPC behavior/state handling
- clearer progression/reward feedback

## Success Definition

MagicGourd succeeds if it becomes:
- immediately playable
- emotionally recognizable as a Heungbu/Nolbu story game
- robust under imperfect Roblox asset/runtime conditions
- easy for future agents to extend without breaking structure
