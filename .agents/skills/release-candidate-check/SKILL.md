---
name: release-candidate-check
description: Run MagicGourd's release-candidate readiness checklist using the repo's real build, doc, and validation surfaces. Use when a slice or milestone needs a go/no-go review with explicit blockers.
---

# Release Candidate Check

## Trigger

Use this skill when:
- a milestone or slice is being considered “ready”
- a broad validation pass is needed before handoff
- docs, gameplay, and build confidence need to be summarized together

## Do Not Trigger

Do not use this skill when:
- the work is still obviously mid-implementation
- the task is only early planning

## Input

- active slice or milestone scope
- changed files
- `docs/testing_strategy.md`
- `.loop/progress.md`

## Procedure

1. Run the confirmed repo-local build gate:
   - `rojo build default.project.json --output <temp>`
2. Confirm docs changed by the slice were updated.
3. Confirm PM/loop state is aligned with what actually shipped.
4. If Studio/MCP is available, include the smoke path.
5. If multiplayer risk exists, include the multiplayer regression check or document why it is blocked.
6. Report blockers explicitly rather than implying readiness.

## Output

- release-candidate verdict
- checks run
- blockers
- next required action before release confidence is acceptable
