# Slice Rules

## Definition

One slice equals one shippable vertical increment.

A good slice:
- changes one coherent outcome
- has clear acceptance criteria
- has a concrete validation plan
- can be reviewed without reopening the whole repo

## Required Sections

Every slice doc should include:
- title
- goal
- scope
- touched areas
- acceptance criteria
- validation plan
- risks / follow-ups

## Operating Rules

- Only one slice should be active at a time.
- Do not start the next slice until the current one is done or explicitly blocked.
- Keep slice scope small enough to preserve current playability.
- Prefer additive work over broad structural churn.

## Sync Rules

When a slice becomes active or completes, review:
- `.loop/tasks.json`
- `.loop/progress.md`
- `docs/pm/TASKS.md`
- any docs changed by the slice

## Validation Rule

Each slice must define:
- what proves it worked
- what commands/checks were run
- what remains unverified
