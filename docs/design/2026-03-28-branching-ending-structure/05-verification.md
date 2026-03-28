# Verification

## Design Checks
- [x] Theme is clearly Heungbu/Nolbu aligned
- [x] Player action loop is concrete
- [x] Reward loop is explicit
- [x] States and transitions are defined
- [x] Roblox implementation path is realistic
- [x] Rojo-safe structure is preserved
- [x] Fallback path exists for fragile assets
- [x] UI / dialogue requirements are specified
- [x] Failure cases are documented
- [x] MVP scope is bounded

## Walkthrough Test
1. Finish the current main story through bramble clearing.
2. Verify the player is redirected to a final audience instead of instantly flattening into generic complete/free-play text.
3. Verify speaking with Heungbu frames a real ending decision using only prompts/dialogue/banner support.
4. Choose the restoration ending and confirm the result sequence, reward, and world flavor updates all land exactly once.
5. Repeat from a fresh run, choose the tribute ending, and confirm the alternate resolution is equally complete and readable.
6. After either ending, confirm the patch remains usable for free play and the village signage reflects the chosen outcome.

## Open Questions
- Should tribute ending remain fully replayable free play, or should it slightly tax harvest rewards to make the consequence mechanical as well as narrative?
- Should the final choice UI be a true button modal, or should MVP stay fully diegetic through prompt routing?
- Do we want the eventual “best” ending to require both choosing restoration and having previously helped the swallow, or is that for a later expansion?

## Final Decision
- Ready for implementation