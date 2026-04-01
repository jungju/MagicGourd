# Verification

- [x] Targets a real remaining refinement seam inside the current arcade loop
- [x] Does not add mechanics, systems, or scope
- [x] Covers user flow, state priority, UI surface ownership, edge cases, and validation scenes
- [x] Reuses existing prompt/CTA hierarchy instead of replacing it
- [x] Gives PM/dev a concrete mobile/touch interpretation layer for MG-PM-408

## Why this is worth keeping
The repo already has strong solo readability, feedback, and spatial contracts.
What was still slightly missing was a platform-specific completion rule for the one interaction channel that can still feel crowded even when the state logic is correct.

This artifact keeps the team from making ad hoc mobile tweaks later.

## What it should influence
- Studio/mobile validation under MG-PM-408
- any future CTA demotion tuning
- prompt-boundary tuning only when touch play proves unclear

## What it should not trigger
- no new control scheme
- no extra tutorial surface
- no touch-only mechanics
- no broader UI rewrite

## Hand-off
Use this only if the remaining blocked validation work reaches mobile/touch play.
If touch already reads cleanly in Studio, leave implementation as-is and keep this as a guardrail artifact, not a mandatory code task.
