# Brief

## Pass Name
Billboard Typography / Density Pass

## Why This Pass Exists
The arcade loop already has:
- canonical verbs
- prompt ownership rules
- popup headroom rules
- lane/sign placement guidance
- Studio validation scenes

But `ArcadeWorld.luau` still renders most support signs with nearly the same billboard treatment:
- same frame size
- `AlwaysOnTop = true`
- `TextScaled = true` for both title/body
- similar vertical offset

That means the remaining readability risk is no longer mainly **where signs are**, but **how dense they read once they are on screen together**.

This pass stays inside refinement mode and focuses on a small completion gap:
- make support signage feel quieter and more intentional
- reduce “text wall” risk in plaza / lane overlap cases
- protect prompts and world popups without adding new UI

## Refine Targets Collected
1. Support sign title/body hierarchy is too uniform across spawn, lane, zone, and plaza pads.
2. `TextScaled` on both title and body risks unstable perceived emphasis at varying camera distances.
3. Plaza pads can read like three equal billboard blocks instead of one current choice plus two supporting options.
4. World signs may still feel louder than they need to because `AlwaysOnTop` + equal visual treatment removes depth cues.
5. Loop readability now depends on typography discipline more than on adding more spacing passes.

## Candidate Compression Goal
Refine the visual grammar of existing billboards only. No new mechanics, no new UI surfaces, no new landmarks.