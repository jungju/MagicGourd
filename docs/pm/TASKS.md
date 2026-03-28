# MagicGourd Task Checklist

The live PM checklist is now aligned to the shared Heungbu arcade loop in `docs/design/2026-03-28-heungbu-arcade-loop/`.

## Legend
- `done` = implemented and aligned with the current arcade direction
- `rebuild` = implementation exists but no longer matches the active direction
- `new` = planned but not yet built
- `blocked` = needs Studio/live validation or external confirmation

---

## Arcade Loop

| ID | Name | Design Source | Status | Evidence | Recommended Action | Priority |
|---|---|---|---|---|---|---|
| MG-PM-401 | Shared three-zone runtime arena | 2026-03-28 heungbu arcade loop | done | `ArcadeWorld.luau` builds Central Plaza, Heungbu Village, Nolbu Area, paths, upgrade pads, and runtime folders under `Workspace/Map/Runtime` | Maintain and tune in Studio if needed | P1 |
| MG-PM-402 | Swallow heal -> seed reward loop | 2026-03-28 heungbu arcade loop | done | `SwallowService.luau` keeps a fixed shared swallow count and rewards seeds on valid heal | Maintain | P1 |
| MG-PM-403 | Seed use -> owned pumpkin -> money loop | 2026-03-28 heungbu arcade loop | done | `PumpkinService.luau` spawns owned pumpkins, validates owner-only hits, pays money, times out, and cleans on leave | Maintain | P1 |
| MG-PM-404 | Prompt-based plaza upgrades | 2026-03-28 heungbu arcade loop | done | `UpgradeService.luau` spends money on movement, attack speed, and seed multiplier upgrades | Maintain | P1 |
| MG-PM-405 | Goblin danger-zone slowdown pressure | 2026-03-28 heungbu arcade loop | done | `GoblinService.luau` spawns shared goblins, chases nearby players, and applies a temporary slow on touch | Maintain and verify live feel | P1 |
| MG-PM-406 | Compact arcade HUD + seed action | 2026-03-28 heungbu arcade loop | done | `src/client/init.client.luau` replaces quest/dialogue UI with a loop HUD and visible seed-use control | Maintain | P1 |
| MG-PM-407 | Legacy story architecture retired from live flow | 2026-03-28 heungbu arcade loop | done | `init.server.luau`, `init.client.luau`, `README.md`, and this checklist no longer present the old branching quest slice as the live game | Keep archived docs as historical reference only | P1 |
| MG-PM-408 | Studio validation pass for traversal, goblin movement, and prompt readability | 2026-03-28 heungbu arcade loop | blocked | Code path is in place, but movement feel and readability still need a live Studio pass | Run one Studio validation session and adjust spacing only if clarity suffers | P1 |
| MG-PM-409 | Contextual next-step HUD guidance and upgrade readability pass | 2026-03-28 arcade interaction readability pass | done | `init.client.luau` now ships dedicated `Next:` / `Status:` lines, deterministic guidance priority, affordability-aware upgrade rows, `MAX` handling, and planting-focused action button text | Maintain and only tune if live readability testing exposes edge-case confusion | P1 |
| MG-PM-410 | Planting / prompt / feedback copy consistency | 2026-03-28 arcade interaction readability pass | done | `init.client.luau`, `SwallowService.luau`, `PumpkinService.luau`, `UpgradeService.luau`, `ArcadeWorld.luau`, and `ArcadeConfig.luau` now align on `Heal` / `Plant` / `Break` / `Buy` wording, purpose-first zone signage, and event-specific slow / reward feedback | Maintain the canonical verb map and only clean up if a new player-facing string drifts | P2 |
| MG-PM-411 | Event feedback anchor consistency pass | 2026-03-28 feedback anchor consistency pass | done | `UpgradeService.luau` now emits plaza-anchored upgrade purchase popups, `SwallowService.luau` / `PumpkinService.luau` keep object-anchored world feedback, `GoblinService.luau` anchors slow feedback to the affected player root, and `init.client.luau` keeps slow recovery banner-only while rendering short world popups from shared payloads | Maintain the current banner + world-popup split and only retune if live overlap/readability testing shows clutter | P2 |
| MG-PM-412 | Plaza prompt reach follow-through for spatial readability budget | 2026-03-28 spatial readability budget pass | done | `ArcadeConfig.luau` now defines a dedicated `config.Upgrades.PromptDistance = 9`, and `ArcadeWorld.luau` passes that value into plaza `Buy` prompts instead of reusing the shared 12-stud default used by swallow/pumpkin interactions | Maintain the tighter plaza commitment distance and only revisit spacing if live Studio validation still shows multi-pad ambiguity | P2 |
| MG-PM-413 | Feedback cadence / intensity budget for fast loop readability | 2026-03-28 feedback cadence budget pass | done | `ArcadeConfig.luau` now defines per-intensity banner/world-popup timing profiles, `init.client.luau` consumes those intensity tiers for banner linger and popup size/rise/duration, and `PumpkinService.luau` / `UpgradeService.luau` assign lighter setup-bookkeeping beats (`T1`), medium crack beats (`T2`), and stronger payout / buy beats (`T3`) while slow recovery stays a short banner-only `T1` event | Maintain the current cadence ladder and only retune if Studio shows payout/buy/danger still blending together under fast repeated play | P2 |
| MG-PM-414 | Plaza choice role clarity follow-through | 2026-03-28 plaza choice role clarity pass | done | `ArcadeWorld.luau` keeps the three plaza roles distinct, HUD rows preserve role-defining units, and `UpgradeService.luau` now maps Footwork / Quick Hands / Blessing purchases to upgrade-specific next-run promise detail lines instead of a shared generic banner | Maintain the current role-specific promise copy unless live testing shows one upgrade still reads ambiguously | P2 |

## Next PM Recommendation

### Keep as done
- the full swallow -> seed -> pumpkin -> money -> upgrade loop
- shared-world multiplayer ownership rules
- prompt-based plaza economy
- runtime arena rebuild and zone flavor scaffolding
- HUD guidance / affordability readability pass
- player-facing verb consistency across button, prompts, and feedback
- event feedback anchor consistency for heals, planting, break progress, payouts, upgrades, and goblin slow
- tighter plaza `Buy` prompt reach so Central Plaza requires deliberate pad commitment instead of broadcasting at the same 12-stud range as swallow/pumpkin prompts

### Rebuild next
- none inside the current non-Studio code path; the highest-value follow-through remains live readability validation rather than another wording pass

### Blocked pending live validation
- goblin pathing feel in Studio
- traversal readability between the three zones
- prompt readability on desktop/mobile in real play
- popup overlap/readability under repeated fast loop play in live Studio

### Refinement mode priorities
1. Studio validation for pathing, traversal, prompt readability, and popup overlap noise
2. collision / spacing polish only where that validation shows confusion or friction
3. small event feedback timing/intensity tuning only if live cadence feels noisy
4. keep documentation synchronized when a validation result causes a real status change
5. only then consider additional arcade-simple polish or money sinks
