# Feature Brief

## Name
House Placement / Orientation Final Polish

## Problem
The current runtime village slice is playable, but the two key houses are still the weakest visual read in the whole map. PM already flags this as `MG-PM-103 rebuild`, and recent notes confirm the imported house assets may be effectively upside down relative to the placement assumptions. Right now the code hard-rotates both houses by `X=90`, which is functional guessing, not a stable placement contract.

## Desired Player Experience
- Heungbu's home should read as humble but welcoming.
- Nolbu's home should read as larger, more imposing, and intentionally oriented toward the estate road.
- Houses should sit cleanly on their pads without looking buried, floating, or flipped.
- If Roblox asset loading fails, the fallback houses should still preserve the same composition and facing.

## Why Now
- The story loop and ending shell already exist; environment credibility is now the clearest player-facing weakness.
- This is the next likely Dev/PM handoff item because it directly improves first impression and supports every existing story beat.
- A focused design can replace trial-and-error rotation tweaks with a small explicit placement system.

## Constraints
- Roblox constraints: imported models may have inconsistent pivots, bottoms, and authoring orientation.
- Rojo constraints: runtime-spawned houses must remain code-driven and safe to tune in source.
- Narrative constraints: Heungbu/Nolbu visual contrast matters more than photoreal accuracy.
- Scope constraints: this is a placement/presentation rebuild, not a full map remake or bespoke house builder.

## Existing Systems Touched
- `src/server/init.server.luau` asset definitions
- `applyPlacement()` runtime placement logic
- fallback house generation
- `villageLayout` yard/pad positions
- PM task `MG-PM-103`

## Success Signal
A Dev agent can implement this without Studio guesswork loops beyond final visual confirmation, and the resulting houses consistently land upright, grounded, and compositionally readable.