# Slice 001 - Bootstrap Foundation

## Goal

Finish the post-migration operating foundation so future Codex work can proceed one slice at a time with clear docs, backlog, validation, and trust-boundary awareness.

## Scope

- establish canonical product/architecture/testing docs
- establish `.loop` backlog/progress/result contract
- establish `.codex` project config and custom agents
- establish project skills for planning, validation, remote audit, multiplayer regression, and release checks
- avoid broad gameplay refactors

## Touched Areas

- `AGENTS.md`
- `README.md`
- `docs/*`
- `.loop/*`
- `.codex/*`
- `.agents/skills/*`

## Acceptance Criteria

- every required migration file exists and contains first-version content
- docs describe the current arcade baseline truthfully
- `.loop/tasks.json` contains realistic slice seeds
- `.codex/agents/*.toml` roles are non-overlapping and repo-specific
- skills are usable as first-version operating guides, not TODO stubs
- no large `src/` reorganization occurs

## Validation Plan

1. confirm required files exist
2. validate JSON/TOML syntax
3. run `rojo build default.project.json --output <temp>`
4. confirm docs/skills do not claim nonexistent repo-local tooling
5. confirm current remote and persistence language matches source

## Risks

- existing docs may still contain historical references that need careful normalization
- session-available MCP capability must be documented carefully without becoming a hard project dependency
- future slices still need live Studio verification for gameplay feel
