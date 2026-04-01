---
name: replication-remote-audit
description: Audit MagicGourd remotes, replicated attributes, trust boundaries, and exploit surface based on the current source. Use when a slice changes networked gameplay or when architecture/security confidence is needed.
---

# Replication Remote Audit

## Trigger

Use this skill when:
- a slice changes `RemoteEvent` usage
- replicated attributes or ownership markers change
- trust-boundary review is required before merge
- a gameplay system seems to rely too much on client trust

## Do Not Trigger

Do not use this skill when:
- the slice is unrelated to replication or authority
- the task is purely cosmetic documentation

## Input

- `src/server/*`
- `src/client/init.client.luau`
- `src/shared/ArcadeConfig.luau`
- active slice diff or touched files

## Procedure

1. Inventory current remotes and their purpose.
2. Inventory replicated attributes tied to gameplay state or ownership.
3. For each client-to-server action, answer:
   - what intent the client sends
   - what the server validates
   - what the client could lie about
4. Confirm the server, not the client, decides:
   - rewards
   - state mutation
   - ownership
   - cooldown enforcement
5. Record any exploit surface or ambiguous trust boundary as:
   - fixed now
   - safe enough for now
   - follow-up required

## Output

- remote inventory
- replicated attribute inventory
- trust-boundary assessment
- concrete exploit-surface findings or “no major issue found” statement
