# Brief

## Why now
The core blessed seed payoff loop is already implemented, but the emotional peak is still underpowered. Current client UI only shows a short banner/flash, while `docs/pm/TASKS.md` still marks **MG-PM-204 Stronger cinematic payoff UI/effects** as `new`.

## Implementation opportunity
This is a near-term, low-friction follow-up because:
- server already emits `StoryEffectEvent`
- client already has a story banner + flash scaffold
- no save schema change is required
- it upgrades an existing P1/P2 story beat instead of introducing a brand-new system

## Design goal
Define a focused presentation pass that makes the blessed seed -> true magic gourd -> Heungbu reward -> Nolbu retaliation sequence feel memorable without requiring fragile cutscene tech, camera rails, or large asset dependencies.

## Non-goals
- full branching ending system
- major economy rebalance
- replacing the current dialogue framework
- Studio-only cinematic tooling that blocks Rojo iteration
