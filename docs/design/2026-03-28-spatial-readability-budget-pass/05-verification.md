# Verification

## Completeness check
- **User flow:** covered by spawn -> village -> center lane -> plaza -> danger applications
- **State transitions:** no new gameplay states; only readability/tuning rules for existing interactions
- **World objects:** signs, prompts, pads, pumpkins, swallows, goblins, rocks all covered where relevant
- **Server logic:** only minor tuning implications called out; no new systems required
- **Client UI/HUD/feedback:** protected through prompt/billboard/popup hierarchy rules
- **Data model:** unchanged
- **Failure cases:** included for prompt overlap, sign clutter, lane bleed, popup headroom, and danger first-contact fairness
- **Validation method:** explicit Studio checks included

## Scope check
This pass stays inside refinement mode because it does **not** introduce:
- new mechanics
- new resources or rewards
- new progression systems
- new tutorial surfaces
- new map branches

## Fun / feel check
This pass improves completion by making the current loop feel more intentional:
- movement reads faster
- rewards remain cleaner
- plaza spending feels more deliberate
- danger feels fairer without becoming softer

## Collision check with existing docs
This design is compatible with:
- `2026-03-28-loop-copy-coherence-pass`
- `2026-03-28-feedback-anchor-consistency-pass`
- `2026-03-28-studio-validation-readability-contract`

It does not replace them; it gives them a tighter spatial tuning layer.

## Implementation realism check
Everything here is achievable with current Roblox authoring levers:
- prompt distance
- billboard offset/copy size discipline
- small part/sign spacing changes
- small goblin/rock placement adjustments

No new architecture is required.

## Adoption verdict
Adopt as a supporting refinement artifact for live Studio tuning.

If Studio validation finds no visible confusion, leave the map as-is.
If confusion appears, use this budget to choose the smallest fix that restores one clear read at a time.