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
  9. inspect the injured swallow and gather healing herbs
  10. receive Heungbu's blessed seed
  11. grow and harvest the true magic gourd
  12. trigger Heungbu's magic payoff
  13. hear Nolbu's retaliation, clear brambles from the patch, and repair the damaged yard marker
  14. resolve the ending, then replay it through a branch-specific shared basket or road-due hand-in loop
- A lightweight client HUD shows the current quest title, objective, and normal/blessed crop counts.
- Dialogue popups fire from server-side interactions so the story stays readable even with basic placeholder assets.
- Story beat banners and flash feedback make the blessed seed payoff and retaliation more visible.
- Village billboards update with delivery / tribute / magic totals to make the reward loop feel more explicit.
- After the ending, Heungbu and Nolbu's own talk-node billboards also shift with the branch, village tier, and active support point so the aftermath reads before you even click them.
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

## PM Agent Workflow

- PM review workflow is defined in `PM_AGENT.md`.
- Task tracking lives in `docs/pm/TASKS.md`.
- PM Agent compares adopted design vs current code and classifies work as:
  - `done`
  - `rebuild`
  - `new`
  - `blocked`

This is intended to keep the project honest about what is actually finished, what needs rework, and what should be built next.

## Developer Agent Workflow

- Developer workflow is defined in `DEV_AGENT.md`.
- Developer Agent reads `docs/pm/TASKS.md`, selects a high-priority build/rebuild item, and implements it.
- Developer Agent should consult design docs before larger feature work.
- Developer Agent is responsible for actual delivery while preserving playability.

## Loop Agent Workflow

- Long-running orchestration is defined in `LOOP_AGENT.md`.
- Loop Agent rotates through Design -> PM -> Dev -> Review.
- This is the repo's default autonomous continuation mode when ongoing progress is desired.

## Meta Agent Workflow

- Meta/pipeline upgrade workflow is defined in `META_AGENT.md`.
- Meta Agent scans the agent system itself and improves the pipeline.
- It should run in maintenance mode so it does not interfere with active feature-development windows.

## Run

```bash
rojo serve
```

Then connect from the Rojo plugin in Roblox Studio.
