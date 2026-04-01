---
name: feature-slice-planner
description: Break MagicGourd's current PRD and PM state into small shippable vertical slices with acceptance criteria, touched areas, validation plans, and backlog entries. Use when backlog work needs to be sliced for one-at-a-time implementation.
---

# Feature Slice Planner

## Trigger

Use this skill when:
- `docs/prd.md` exists but work is still too broad
- `.loop/tasks.json` or `docs/slices/*` need new vertical slices
- the current backlog needs smaller acceptance-driven increments

## Do Not Trigger

Do not use this skill when:
- the slice already exists and only needs implementation
- the task is a pure QA pass
- the task is a low-level code cleanup without product impact

## Input

- `docs/prd.md`
- `docs/game_overview.md`
- `docs/pm/TASKS.md`
- current codebase constraints
- current active slice status

## Procedure

1. Start from the live arcade baseline, not from archived scope.
2. Define one slice as one shippable vertical increment.
3. Keep each slice small enough to preserve playability and reviewability.
4. For each slice, include:
   - goal
   - scope
   - touched areas
   - acceptance criteria
   - validation plan
   - main risks
5. Sync the proposed slice with `.loop/tasks.json` and `docs/slices/`.

## Output

- small, actionable slice docs
- backlog entries with clear acceptance and validation
- a recommended next slice order
