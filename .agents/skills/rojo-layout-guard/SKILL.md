---
name: rojo-layout-guard
description: Review MagicGourd changes against the current Rojo mapping and prevent misguided folder moves or client/server/shared placement drift. Use when files are added, moved, or refactored around src or workspace structure.
---

# Rojo Layout Guard

## Trigger

Use this skill when:
- a change adds or moves files under `src/`
- a slice proposes new shared contracts, runtime world code, or Rojo structure changes
- someone suggests reorganizing client/server/shared layout

## Do Not Trigger

Do not use this skill when:
- the task only edits copy or docs outside structural concerns
- the task is a pure QA verification pass

## Input

- `default.project.json`
- `src/` tree
- `docs/architecture.md`
- proposed or recent file changes

## Procedure

1. Read the live mapping from `default.project.json`.
2. Confirm whether the proposed file belongs in:
   - `src/server`
   - `src/client`
   - `src/shared`
   - `src/workspace`
3. Check whether the change respects current runtime layering:
   - `JoseonBase` as Rojo-managed backdrop
   - `Workspace/Map/Runtime` as server-authored gameplay layer
4. Reject source-tree moves that only serve an idealized architecture and not a concrete repo need.
5. If a move is necessary, document exactly why the existing mapping is insufficient.

## Output

- verdict on correct placement
- concrete guardrails for the change
- warnings about any Rojo mapping or runtime layering drift
