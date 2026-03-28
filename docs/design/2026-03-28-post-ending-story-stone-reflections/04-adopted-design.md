# Adopted Design

## Chosen slice
Branch-aware Story Stone aftermath reflections

## Why chosen
The highest-value non-blocked follow-up is to make an already-important world object carry more of the post-ending narrative load. This keeps the loop readable for players who revisit the center of the village and ties together signs, support-point rotation, landmarks, and rare-event texture.

## Player flow
- Player reaches `COMPLETE`.
- Player reads the Story Stone again.
- The stone speaks differently for restoration vs tribute.
- The text lightly reflects current landmark tier and active support-point rotation.
- If the latest replay-loop rare event happened recently, the stone can echo that memory once as part of the valley's changing folklore.

## Server logic
- Keep the intro / mid-story Story Stone behavior intact before `COMPLETE`.
- Add a helper that builds Story Stone lines from:
  - ending branch
  - branch landmark tier
  - current active support point
  - latest rare-event memory for that branch (optional)
- Do not add quest state, rewards, or timers.

## Data model
Add lightweight profile memory fields for the latest post-ending rare event:
- lastEndingRareEventTitle
- lastEndingRareEventBranch

These are runtime-only and safe to ignore if absent.

## Validation
- Before ending: Story Stone still advances intro and gives base theme lines.
- Restoration complete: Stone speaks warmly about shared harvest, current support-point routing, and stronger communal tone at higher tiers.
- Tribute complete: Stone speaks more formally/coldly about due counts, current tally routing, and stricter road tone at higher tiers.
- Rare-event memory is additive flavor only and never blocks or replaces core guidance.
