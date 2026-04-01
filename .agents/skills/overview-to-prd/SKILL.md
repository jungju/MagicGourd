---
name: overview-to-prd
description: Refine MagicGourd's current overview, codebase truth, and assumptions into canonical product docs such as game_overview, prd, pillars, monetization guardrails, and testing assumptions. Use when overview-level understanding exists but product docs need to be normalized or refreshed.
---

# Overview To PRD

## Trigger

Use this skill when:
- the repo has gameplay truth but product docs are weak or drifting
- `docs/game_overview.md`, `docs/prd.md`, or `docs/pillars.md` need to be created or refreshed
- a high-level overview needs to be turned into planning-ready product documentation

## Do Not Trigger

Do not use this skill when:
- the task is a narrow code fix
- the task is a remote or replication audit
- the task is already a well-scoped implementation slice

## Input

- current repo truth from `src/`
- `README.md`
- `docs/pm/TASKS.md`
- active design docs under `docs/design/`
- explicit user direction, if present

## Procedure

1. Read the current gameplay baseline from source before trusting older docs.
2. Separate confirmed facts from assumptions.
3. Write or refresh:
   - `docs/game_overview.md`
   - `docs/prd.md`
   - `docs/pillars.md`
   - related guardrails if requested
4. Keep the docs grounded in the current MagicGourd arcade baseline unless the user explicitly redirects the project.
5. Avoid inventing systems or persistence layers that do not exist yet.

## Output

- normalized overview and PRD docs
- explicit assumptions list
- product language that matches current repo truth
