# Verification

## Design Checklist
- [x] Why this pass is needed now is explicit
- [x] Player action ownership is described, not just copy polish
- [x] Previous and next loop steps are preserved
- [x] Failure / recovery cases are covered
- [x] Roblox-feasible follow-through is identified without inventing a new system
- [x] Rojo-safe scope is maintained
- [x] No new economy/story/system expansion was introduced

## Fun / Flow Check
This pass improves the feeling that the arcade loop is not merely understandable but **well-held together under repetition**.

What gets better if implemented:
- less visual argument between global CTA and local commitments
- stronger sense that unfinished value should be completed before bookkeeping steals attention
- better plaza intentionality
- cleaner recovery from danger pressure

## Conflict Check
No conflict with:
- current heal -> plant -> break -> buy loop
- shared-world ownership rules
- existing plaza role clarity pass
- existing loop-reset clarity pass
- current prompt-distance tuning

Instead, this pass explains how those pieces should cooperate at the input-surface layer.

## Risk Check
Primary risk:
- overcomplicating a simple arcade loop with too much stateful button logic

Mitigation:
- keep implementation to lightweight emphasis/suppression states only
- do not add new controls
- do not hide valid options for long durations

## Final Verdict
Adopted as a strong refinement-mode artifact.

It addresses a remaining completion gap that is small in scope, high in repeat-play value, and consistent with the current arcade direction.