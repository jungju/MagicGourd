# Adopted Design

## Chosen Candidate
Candidate 1 — Branch-Specific Landmark Accrual Tiers

## Why Chosen
This is the best next implementation opportunity after support-point rotation because it answers the next obvious player question: **does repeating these post-ending errands actually change anything I can see?**

Right now, the project already has the right foundation:
- branch-aware endings
- ambient aftermath
- repeatable branch errands
- milestone escalation
- a support-point rotation design and partial code scaffold

What is still missing is persistent-looking local payoff. Landmark accrual solves that without starting a bigger system. It turns repeated help into visible village state.

## Why Others Were Rejected
- **Candidate 2 — Helper NPC Barks:** useful as polish, but too text-heavy to serve as the next primary feature.
- **Candidate 3 — Rare Micro-Events:** attractive later, but hidden cadence logic is not the right next step while the replay loop is still being physically grounded.
- **Candidate 4 — Route Cue Props:** good support-rotation garnish, but weaker and less cumulative than landmark accrual.

## Design Summary
Add a small **landmark accrual layer** to post-ending free play.

As players complete branch-specific errands in `COMPLETE`, the village's active support landmarks gradually change in visible, branch-specific ways:
- **Restoration** landmarks gain stocked communal signs of recovery
- **Tribute** landmarks gain stricter, more normalized signs of counting and control

This is not a new questline. It is a cosmetic + readability system that makes repeated post-ending actions feel authored and cumulative.

---

## Player Experience Goal
### Restoration should feel
- increasingly shared
- lightly stocked and lived-in
- like the valley's help is spreading beyond one prompt

### Tribute should feel
- increasingly formalized
- tidier but colder
- like the road's demand is becoming routine and institutional

### Shared goal
After several errands, the player should be able to walk by the support landmarks and immediately feel that the ending is still shaping the village.

---

## Scope Boundary
This design is **not**:
- a new reward economy
- a new quest stage
- a build mode
- a persistent settlement simulation
- a heavy art pass with imported assets

This design **is**:
- 2-3 small visual tiers per branch
- sign/prompt copy upgrades tied to existing counters
- primitive/runtime-authored prop clusters per support point
- a world-state polish layer that remains optional for exact support-point count values

---

## Player Flow
1. Player reaches `COMPLETE` with a resolved ending.
2. Player completes branch errands at active support points as already designed.
3. After small thresholds, nearby support landmarks visually step up.
4. Signs and hint text acknowledge the village's growing pattern of sharing or tribute.
5. The player keeps farming and sees the world hold onto that repeated effort.

---

## Landmark Tier Rules

### MVP threshold recommendation
Use thresholds aligned to existing errand rhythm so the system reads naturally:
- **Tier 0:** default post-ending state
- **Tier 1:** after 3 branch errands
- **Tier 2:** after 6 branch errands

These numbers fit the current escalation cadence and are easy to communicate in signs/hints without explicit progress bars.

### Authority recommendation
Use **per-player read logic** for prompts/hints and allow **shared/default sign flavor** to remain safe if no player-specific context is available.

If per-player landmark visibility becomes too expensive/confusing for world props, props may be village-global and driven by aggregate branch counts, while prompt copy remains player-aware. The design should prefer clarity over perfect simulation.

---

## World Objects

### Restoration accrual set
Apply to the restoration support points:
1. **Shared Basket**
2. **Well Pantry Drop**
3. **Yard Relief Mat**

#### Restoration Tier 1 examples
- one extra produce crate or folded cloth mat
- warmer sign copy about the village keeping each other fed
- small stacked gourd or seed sack accent

#### Restoration Tier 2 examples
- second crate/basket cluster
- lantern or banner accent already aligned with restoration mood
- sign copy that implies the valley now returns food or seed more confidently

### Tribute accrual set
Apply to the tribute support points:
1. **Road-Due Stand**
2. **Gate Tally Point**
3. **Tribute Route Marker**

#### Tribute Tier 1 examples
- ledger stack / tally stones / rope guide accent
- sign copy about steadier counting or expected due
- slightly more formal route marker presentation

#### Tribute Tier 2 examples
- second tally prop cluster
- stricter marker cloth or rope segment
- sign copy that implies the road now expects tribute as routine order

### Presentation rule
Keep all props primitive-based, runtime-authored, and optional. If a point loses readability, cut props before adding bespoke art.

---

## Quest / State Flow
- `COMPLETE` + restoration errand count 0-2 -> restoration Tier 0
- `COMPLETE` + restoration errand count 3-5 -> restoration Tier 1
- `COMPLETE` + restoration errand count 6+ -> restoration Tier 2

- `COMPLETE` + tribute errand count 0-2 -> tribute Tier 0
- `COMPLETE` + tribute errand count 3-5 -> tribute Tier 1
- `COMPLETE` + tribute errand count 6+ -> tribute Tier 2

No new quest state is introduced. This is presentation state derived from existing post-ending counters.

---

## Server Design
### New helper concepts
Add a tiny derived-state layer, for example:
- `getEndingLandmarkTier(profile, errandKind)`
- `refreshEndingLandmarkPresentation(player)` or shared equivalent
- `updateEndingSupportSigns(player)` extended to read tier + active point

### Data model
Prefer **derived state** over new saved state.

Recommended primary inputs:
- `profile.sharedHarvestDrops`
- `profile.tributeDuesPaid`
- `profile.endingChoice`
- active support point index where relevant

Optional only if needed for readability:
- `runtimeFolder.EndingLandmarkTier`
- small tables describing per-point tier props and sign bodies

### Completion behavior
On successful post-ending errand completion:
1. increment the existing branch counter
2. recompute the branch landmark tier
3. refresh relevant support-point signs/props
4. if a new tier was reached, optionally fire one small effect pulse or stronger dialogue line

### Sign / hint behavior
Hints should remain lightweight and branch-aware.

Example restoration hint progression:
- Tier 0: `Shared harvests are being gathered near the well.`
- Tier 1: `The village pantry is starting to stay stocked between shared drops.`
- Tier 2: `The restored valley now keeps visible stores near its shared drop points.`

Example tribute hint progression:
- Tier 0: `The next road due is being counted nearby.`
- Tier 1: `Nolbu's tally points are settling into a stricter routine.`
- Tier 2: `The road's due now reads like a standing village habit.`

### Implementation decisions for the next pass
To keep the build small and avoid ambiguity, the following decisions are adopted for MVP:

1. **Prompt routing stays per-player, landmark props/signs stay village-global.**
   - Active support-point acceptance continues to depend on the player's own branch + rotation state.
   - Landmark tier presentation is driven by existing village counters (`villageState.sharedHarvestDrops`, `villageState.tributeDuesPaid`) so the world reads consistently from a distance.
   - Player-facing hint text may still mention the player's current active point when needed.

2. **Tier-crossing full-screen pulses are cut from MVP.**
   - Tier changes should read through sign copy, passive HUD hint copy, and visible prop clusters.
   - Reuse of existing effect/dialogue hooks is allowed only if a later implementation pass finds Tier transitions too subtle.

3. **Two-point prop coverage is enough for first implementation.**
   - If all three support points per branch are stable, tier props may cover all three.
   - If not, implement tier props on the two clearest points first and leave the third point as sign-copy-only flavor.

### Recommended concrete tier mapping
#### Restoration
- **Tier 0 (0-2 drops):** baseline shared basket / pantry / relief read, no extra stock cluster.
- **Tier 1 (3-5 drops):** add one visible communal stock accent at the shared basket and well pantry.
- **Tier 2 (6+ drops):** add a second stock accent at the shared basket and well pantry, and optionally a lighter relief-mat accent near Heungbu's repaired marker.

#### Tribute
- **Tier 0 (0-2 dues):** baseline road-due / gate / route-marker read, no extra tally cluster.
- **Tier 1 (3-5 dues):** add one visible tally/ledger accent at the road-due stand and gate tally point.
- **Tier 2 (6+ dues):** add a second stricter tally accent at the road-due stand and gate tally point, and optionally a lighter route-marker accent if that lane already reads clearly.

---

## Client Design
- No new panel.
- Existing HUD hint area and dialogue/effect hooks are sufficient.
- Optional one-time effect pulse only when first entering Tier 1 or Tier 2.
- Avoid spam on every errand; the point is persistent world read, not repeated banners.

---

## Failure / Edge Cases
- **Support rotation is not finished yet:** keep this design queued behind rotation completion; baseline points can still host Tier 0-2 if needed, but the full value comes after rotation lands.
- **One support point prop cluster is unclear:** keep the sign copy tiering and cut the extra clutter.
- **Mixed/global village state is hard to represent:** let signs stay generic and only make player-facing prompts/hints tier-aware.
- **Players rejoin mid-tier:** derived tiers should recompute from saved counters.
- **Errand counts are reset or rebalanced later:** thresholds should be centralized constants, not hard-coded into scattered props.

---

## Validation Plan
1. Finish on restoration.
2. Complete 3 shared-harvest errands and confirm Tier 1 restoration props/signs appear.
3. Complete 6 total and confirm Tier 2 appears without breaking readability.
4. Repeat on tribute and confirm the tone feels stricter, not just cosmetically different.
5. Confirm ordinary farming, support-point rotation, and milestone rewards still behave normally.
6. Rejoin after reaching Tier 2 and confirm the presentation recomputes correctly.

---

## MVP Cut Line
- 2 tiers beyond baseline per branch
- 2 support points per branch minimum, 3 preferred if rotation already feels stable
- one sign-copy tier upgrade per branch
- one small prop-cluster upgrade per tier
- optional tier-crossing effect pulse only once per new tier

## Future Extensions
- tie helper NPC barks to landmark tier
- add rare micro-events only at Tier 2+
- let support points borrow tiny route cues once accrual makes them feel worth following
- let aggregate village counts influence global idle signage later

## Recommended PM / Dev Hand-off
### PM should break this into
1. restoration landmark tiering
2. tribute landmark tiering
3. shared threshold rules
4. sign/hint upgrade copy
5. prop cut-line for readability

### Dev should implement in this order
1. derived tier helper from existing counters
2. sign/hint tier updates
3. one prop-cluster upgrade at two support points
4. extend to the remaining point only if the first pass reads clearly
5. optional tier-crossing effect pulse

This keeps the next design tightly tied to actual implementation opportunities already present in the project, instead of jumping to a larger simulation feature.