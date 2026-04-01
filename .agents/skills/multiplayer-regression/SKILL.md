---
name: multiplayer-regression
description: Validate MagicGourd multiplayer fairness when a slice changes remotes, ownership, shared runtime objects, or player cleanup. Use only for networked gameplay changes that could affect shared-world behavior.
---

# Multiplayer Regression

## Trigger

Use this skill when:
- remotes change
- pumpkin/swallow ownership changes
- shared runtime object behavior changes
- player leave cleanup changes
- multiplayer readability or fairness is part of the slice

## Do Not Trigger

Do not use this skill when:
- the task is purely single-player UI copy
- the task is docs-only
- no shared-world or replicated behavior changed

## Input

- active slice scope
- current remote and attribute contract
- runtime systems touched by the change

## Procedure

1. Identify the shared systems touched by the slice.
2. Verify server-authoritative ownership rules still hold.
3. Check at minimum:
   - shared swallows remain shared
   - pumpkins remain player-owned
   - one player cannot cash out another player's pumpkin
   - player leave cleanup removes only owned transient objects
4. If two-player runtime testing is possible, record concrete repro steps and outcomes.
5. If two-player runtime testing is not possible, document the gap explicitly and pair source-level authority review with the missing live test note.

## Output

- multiplayer regression verdict
- fairness findings
- missing coverage notes if paired runtime verification was not possible
