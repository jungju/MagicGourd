# ADR 0001: Codex + Rojo + Roblox Workflow

## Status

Accepted

## Context

`MagicGourd` is already an active Roblox + Rojo project with:
- a live `src/` tree
- a working Rojo mapping
- existing repo-native workflow docs
- a current shared arcade gameplay baseline

The repo needed a stronger Codex operating structure, but a full source-tree rewrite or idealized greenfield scaffold would have created unnecessary risk and drift.

## Decision

Adopt an additive Codex-ops migration:
- preserve the current Rojo mapping and gameplay module layout
- add canonical docs, loop artifacts, project-scoped workflow surfaces, and project-scoped skills
- document current truth rather than inventing a future architecture
- enforce one-slice-at-a-time iteration with validation and doc sync

## What We Kept

- current `src/server`, `src/client`, `src/shared`, `src/workspace` layout
- current arcade-loop gameplay baseline
- the repo's documented workflow baseline at migration time, later consolidated into `AGENTS.md` and `docs/*`
- Rojo as the primary confirmed build surface

## What We Added

- canonical overview / PRD / pillars / testing / architecture docs
- `.loop/*` execution artifacts
- `.codex/*` project config and custom agents
- project-scoped skills under `.agents/skills/*`
- migration reporting

## Tradeoffs

### Benefits

- lower risk to current gameplay behavior
- less churn in the live source tree
- operations and docs become truthful and repeatable quickly
- future slices can be executed with clearer validation and ownership

### Costs

- some current architecture rough edges stay visible instead of being hidden behind a large refactor
- client orchestration remains concentrated in one large script for now
- the repo will temporarily contain both older historical design material and newer canonical ops material

## Consequences

- operators must treat historical design folders as reference unless current code and PM state point back to them
- Codex work should prefer additive slices over structural upheaval
- persistence, richer quality gates, and broader gameplay shifts should be introduced as explicit later slices
