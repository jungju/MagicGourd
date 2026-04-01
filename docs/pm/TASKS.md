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
| MG-PM-408 | Studio validation pass for traversal, goblin movement, and prompt readability | 2026-03-28 heungbu arcade loop | blocked | `SLICE-002` now reaches Studio MCP, starts/stops play cleanly, and boots the arcade loop after fixing the server bootstrap and prompt-owner runtime blockers, but the broader 6-scene readability contract still has not been run; the currently open Studio session also still carries legacy chat core-script noise until the updated `MagicGourd.rbxlx` chat settings are reloaded | Reopen Studio with the updated place settings, then run the full traversal / goblin / prompt readability contract and only tune spacing/timing if that live pass actually finds confusion | P1 |
| MG-PM-409 | Contextual next-step HUD guidance and upgrade readability pass | 2026-03-28 arcade interaction readability pass | done | `init.client.luau` now ships dedicated `Next:` / `Status:` lines, deterministic guidance priority, affordability-aware upgrade rows, `MAX` handling, and planting-focused action button text | Maintain and only tune if live readability testing exposes edge-case confusion | P1 |
| MG-PM-410 | Planting / prompt / feedback copy consistency | 2026-03-28 arcade interaction readability pass | done | `init.client.luau`, `SwallowService.luau`, `PumpkinService.luau`, `UpgradeService.luau`, `ArcadeWorld.luau`, and `ArcadeConfig.luau` now align on `Heal` / `Plant` / `Break` / `Buy` wording, purpose-first zone signage, and event-specific slow / reward feedback | Maintain the canonical verb map and only clean up if a new player-facing string drifts | P2 |
| MG-PM-411 | Event feedback anchor consistency pass | 2026-03-28 feedback anchor consistency pass | done | `UpgradeService.luau` now emits plaza-anchored upgrade purchase popups, `SwallowService.luau` / `PumpkinService.luau` keep object-anchored world feedback, `GoblinService.luau` anchors slow feedback to the affected player root, and `init.client.luau` keeps slow recovery banner-only while rendering short world popups from shared payloads | Maintain the current banner + world-popup split and only retune if live overlap/readability testing shows clutter | P2 |
| MG-PM-412 | Plaza prompt reach follow-through for spatial readability budget | 2026-03-28 spatial readability budget pass | done | `ArcadeConfig.luau` now defines a dedicated `config.Upgrades.PromptDistance = 9`, and `ArcadeWorld.luau` passes that value into plaza `Buy` prompts instead of reusing the shared 12-stud default used by swallow/pumpkin interactions | Maintain the tighter plaza commitment distance and only revisit spacing if live Studio validation still shows multi-pad ambiguity | P2 |
| MG-PM-413 | Feedback cadence / intensity budget for fast loop readability | 2026-03-28 feedback cadence budget pass | done | `ArcadeConfig.luau` now defines per-intensity banner/world-popup timing profiles, `init.client.luau` consumes those intensity tiers for banner linger and popup size/rise/duration, and `PumpkinService.luau` / `UpgradeService.luau` assign lighter setup-bookkeeping beats (`T1`), medium crack beats (`T2`), and stronger payout / buy beats (`T3`) while slow recovery stays a short banner-only `T1` event | Maintain the current cadence ladder and only retune if Studio shows payout/buy/danger still blending together under fast repeated play | P2 |
| MG-PM-414 | Plaza choice role clarity follow-through | 2026-03-28 plaza choice role clarity pass | done | `ArcadeWorld.luau` keeps the three plaza roles distinct, HUD rows preserve role-defining units, and `UpgradeService.luau` now maps Footwork / Quick Hands / Blessing purchases to upgrade-specific next-run promise detail lines instead of a shared generic banner | Maintain the current role-specific promise copy unless live testing shows one upgrade still reads ambiguously | P2 |
| MG-PM-415 | Lane landmark consistency follow-through | 2026-03-28 lane landmark consistency pass | done | `ArcadeConfig.luau` now defines dedicated lane landmarks plus center work-lane lantern anchors, and `ArcadeWorld.luau` instantiates short village-first / work-lane / slow-zone signposts so spawn, center, and danger route intent read more clearly without new UI | Maintain the one-beat landmark grammar and only retune positions/copy if Studio validation still shows lane ownership ambiguity | P2 |
| MG-PM-416 | Post-event loop reset clarity follow-through | 2026-03-28 loop reset clarity pass | done | `src/client/init.client.luau` now enforces danger -> owned pumpkin -> seed -> upgrade guidance priority, keeps `Status:` descriptive instead of duplicating `Next:`, preserves a short upgrade-purchase afterglow via `recentLoopReset`, and support tips keep secondary choices out of the headline during ambiguous states | Maintain the current one-default-next-step contract and only retune if live Studio validation still shows indecisive post-payout / post-recovery / post-buy reads | P2 |
| MG-PM-417 | Danger boundary retreat/re-entry clarity follow-through | 2026-03-28 danger boundary re-entry clarity pass | done | `ArcadeConfig.luau` now adds distinct `Slow Zone` and `Reset Lane` landmarks, while `init.client.luau` promotes plaza-side retreat guidance during slow pressure, shows safe-side planting guidance after recovery, and emits a short `Slow faded.` recovery beat | Keep the authored danger -> retreat -> safe-side re-entry flow unless Studio shows the corridor/read still feels loose | P2 |
| MG-PM-418 | Interaction commitment hierarchy follow-through | 2026-03-28 interaction commitment clarity pass | done | `init.client.luau` now tracks active swallow/plaza prompt ownership with grace timing, demotes the global seed CTA while stronger local prompt commitments are active, and keeps slow / owned-pumpkin / recovery states ahead of convenience planting emphasis | Maintain the current prompt-owner + seed-CTA discipline unless live Studio validation shows lingering prompt/button competition on desktop or mobile | P2 |
| MG-PM-419 | Shared-slice multiplayer readability follow-through | 2026-03-28 shared slice readability pass | done | `src/client/init.client.luau` now hides non-owner pumpkin prompts locally and keeps local prompt ownership ahead of ambient overlap, while `src/server/PumpkinService.luau` defaults pumpkin prompt labeling to neutral `Pumpkin` so remote pumpkins no longer advertise a misleading local `Break` commitment | Maintain the current local-first ownership read and only retune if paired Studio validation still shows remote pumpkin/payout noise stealing the local beat | P2 |
| MG-PM-420 | Touch-first CTA vs prompt ownership follow-through | 2026-03-28 touch input ownership validation pass | done | `src/client/init.client.luau` already applies touch-primary button sizing, prompt-owner priority tracking with exit grace, and context-driven CTA demotion/copy shifts for swallow / pumpkin / plaza / slow-recovery states so the bottom plant button stops reading as a co-equal action when a stronger local prompt owns the moment | Maintain the current touch ownership hierarchy and only retune grace/demotion strength if live mobile Studio validation still shows CTA-vs-prompt tug-of-war | P2 |
| MG-PM-421 | Whole-map decision / feedback / support band separation follow-through | 2026-03-28 visual band separation pass | done | `src/server/ArcadeWorld.luau` keeps sign billboards in a consistent higher support band (`StudsOffsetWorldSpace = Vector3.new(0, 5, 0)`), while `src/client/init.client.luau` keeps short object-anchored world popups staggered by local bucket so fresh prompts and event beats do not fully collide with support signage in ordinary loop slices | Maintain the current band separation contract and only adjust sign copy/offsets or popup headroom if Studio still finds overlap in specific lanes | P2 |
| MG-PM-422 | Billboard typography / density presentation follow-through | 2026-03-28 billboard typography density pass | done | `src/server/ArcadeWorld.luau` now ships billboard-role presets (`Loop` / `Zone` / `Lane` / `Plaza`) with class-specific size, offset, `AlwaysOnTop`, and title/body emphasis, while `src/shared/ArcadeConfig.luau` trims plaza and support-copy bodies to the shorter presentation budgets from the adopted pass | Maintain the new sign-class presentation contract and only retune in Studio if a specific slice still reads as billboard-wall noise | P2 |
| MG-PM-423 | Upgrade threshold clarity follow-through | 2026-03-28 upgrade threshold clarity pass | done | `src/client/init.client.luau` now derives nearest next-buy thresholds from live upgrade levels/costs, surfaces `1-2 pumpkins from upgrade` or `X money from upgrade` status states before affordability, gives owned-pumpkin guidance a short threshold-aware `break N more pumpkins` phrasing when the next spend is close, and cleanly falls back to `All upgrades maxed` once every upgrade row is capped | Maintain the threshold-first reward-to-spend contract and only retune if live Studio play shows the extra coaching competing with stronger local prompt ownership or danger recovery beats | P2 |
| MG-PM-424 | Goblin entrance reach fairness follow-through | 2026-03-28 goblin contact fairness pass | done | `ArcadeConfig.luau` now defines asymmetric `Goblins.ChaseZonePadding` (`Front = 4`, `Back = 10`, `Side = 8`) and `GoblinService.luau` consumes that split padding when deciding who can be chased, which narrows plaza-side forward reach without reopening the rest of the goblin loop | Keep the tighter entrance reach unless live Studio validation shows first-contact ambiguity somewhere else in the lane; fold any further changes back into MG-PM-408 validation notes | P2 |
| MG-PM-425 | Static Heungbu / Nolbu house placement pass | 2026-04-01 asset placement pass | done | `MagicGourd.rbxlx` now persists `Workspace.Map.PlacedAssets.HeungbuHouse` and `Workspace.Map.PlacedAssets.NolbuHouse` from `ASSET_IDS.md`, grounded and oriented from the prior house-placement baseline so the village/danger sides read more clearly without adding gameplay logic | Maintain the current decorative placement and only retune if future readability validation finds house occlusion near prompts/signs/paths | P2 |

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
- lane landmark grammar follow-through so village-first, center work-lane, danger-entry, and retreat-side recovery intent are reinforced by short world signposts instead of extra HUD load
- danger boundary retreat/re-entry follow-through so slow pressure hands the player back to one authored safe-side next step instead of vague recovery copy
- local-first multiplayer/shared-slice readability so remote pumpkins no longer present as misleading local `Break` commitments during overlap
- static Heungbu/Nolbu house silhouettes that reinforce the village-vs-danger first read without reopening house gameplay systems

### Rebuild next
- no code-side rebuild item currently outranks live validation; keep rebuild work scoped to any specific readability failure found in Studio

### Blocked pending live validation
- `MG-PM-408` remains blocked because `SLICE-002` only cleared the smoke baseline; the broader traversal / goblin / prompt readability pass and a Studio reload for updated chat settings are still pending
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
