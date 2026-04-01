---
name: performance-budget-review
description: Review MagicGourd's current performance risk across HUD complexity, popup churn, runtime props, goblin loops, and traversal load. Use when a slice may affect frame cost, object count, or repeated runtime behavior.
---

# Performance Budget Review

## Trigger

Use this skill when:
- a slice changes HUD refresh frequency or feedback density
- runtime world object count changes
- goblin/NPC loops change
- prompt density or traversal surfaces get denser
- a release pass needs practical performance risk review

## Do Not Trigger

Do not use this skill when:
- the task is pure product planning
- the change is obviously docs-only

## Input

- relevant server/client files
- active slice scope
- current architecture and testing docs

## Procedure

1. Review the current known risk buckets:
   - HUD size and refresh behavior
   - world popup churn
   - prompt density and prompt tracking
   - goblin retarget loops
   - runtime prop accumulation
2. Identify what the current slice could worsen.
3. Prefer evidence-backed review over speculative optimization.
4. If live measurements are unavailable, produce a bounded risk review instead of pretending to benchmark.
5. Recommend follow-up only where impact is believable and tied to current code.

## Output

- performance risk summary
- hottest current buckets
- concrete follow-up recommendations, if any
