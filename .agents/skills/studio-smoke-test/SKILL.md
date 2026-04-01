---
name: studio-smoke-test
description: Define and run the current MagicGourd Studio smoke path using available Studio/MCP capabilities without hardcoding environment-specific bootstrap assumptions. Use when the active slice needs live runtime confidence.
---

# Studio Smoke Test

## Trigger

Use this skill when:
- gameplay or HUD behavior changed
- runtime world creation changed
- a slice needs live Studio confidence beyond static source checks

## Do Not Trigger

Do not use this skill when:
- the task is docs-only and no runtime truth is in question
- Studio/MCP is unavailable and only static repo checks are possible

## Input

- active slice scope
- `docs/testing_strategy.md`
- current Studio/MCP session availability

## Procedure

1. Confirm whether Studio/MCP is available in the current session.
2. If available, run the minimum smoke path:
   - check Studio mode
   - start play
   - confirm the game boots without immediate blockers
   - stop play
3. If the slice touches active gameplay, add a short loop walk:
   - heal a swallow
   - plant a pumpkin
   - break a pumpkin
   - buy an upgrade if affordable
4. Record observed errors, warnings, repro steps, and blockers.
5. If Studio/MCP is unavailable, say so explicitly and fall back to repo-local validation only.

## Output

- smoke result
- steps run
- observed runtime blockers or confidence notes
