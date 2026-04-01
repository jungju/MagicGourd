# Verification

## Checklist
- [x] The pass refines existing feedback surfaces instead of inventing a new system
- [x] The chosen target improves reward feel, placement consistency, and coherence together
- [x] The design defines exact event-to-surface rules
- [x] The design defines anchor rules for object events vs player-state events
- [x] The design keeps no-money / maxed / slow-faded states intentionally low-noise
- [x] The design stays compatible with current payload structure (`text`, `detail`, `worldText`, `worldPosition`, `tone`)
- [x] The design gives a concrete fix for the current missing plaza purchase presence
- [x] The design includes overlap discipline so repeated loop play does not become spammy
- [x] The design remains Roblox-safe and cheap to implement inside current services

## Why This Pass Clears the Quality Bar
### Why needed now
The loop already teaches itself reasonably well. The missing polish is that rewards and warnings do not always feel spatially or emotionally authored.

### What the player does
The player still heals, plants, breaks, buys, and avoids goblins exactly as before. Only the acknowledgment layer becomes more precise.

### Previous and next step
Previous passes clarified wording and guidance priority. This pass completes that work by making the feedback appear in the right place with the right strength.

### Failure recovery
Failure and low-value states remain mostly banner-only, so the game stays readable even during repeated loop actions.

### Implementation realism
The design is grounded in the current client/server architecture and does not require new persistence or a new rendering stack.

## Suggested next refinement after this
If this pass is implemented cleanly, the next strongest refinement target is likely **live traversal / prompt readability tuning in Studio**, since that is the main remaining blocked feel issue outside pure authored text/presentation.
