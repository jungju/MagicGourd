# Adopted Design

## Chosen Candidate
Candidate 1 - Compact Retaliation Pressure Loop

## Why Chosen
It is the best next implementation target because it strengthens the weakest remaining story transition without dragging the game into a new chapter. The project already has:
- blessed payoff presentation
- a working retaliation trigger
- bramble props and prompt flow
- ending choice + post-ending ambience

What is missing is a short span where the player actually feels Nolbu's retaliation ripple through the village before the finale. Candidate 1 fixes that with a small, implementation-ready loop instead of a large new system.

## Why Others Were Rejected
- **Candidate 2 - Retaliation Patrol Lockdown:** visually strong, but too risky for the current patrol/pathfinding stack and too easy to make annoying.
- **Candidate 3 - Communal Recovery Marker System:** thematically good, but too soft if used alone; better folded into a tighter retaliation loop.
- **Candidate 4 - Dialogue-Heavy Retaliation Reframe:** safe, but not enough actual gameplay gain.

## Design Summary
Turn the current retaliation beat into a **three-part pressure sequence**:
1. **Sabotage Reveal** - Nolbu's threat lands and the player returns to find the patch and one nearby support point disrupted.
2. **Immediate Recovery** - the player clears the brambles to reopen the patch.
3. **Stabilize the Valley** - the player performs one short repair interaction at a nearby village support point before the story can proceed to the final audience.

This keeps the finale compact. The player still resolves retaliation quickly, but not instantly. Nolbu's spite now leaves a visible mark, and Heungbu's answer becomes active repair rather than a single click.

---

## Player Flow
1. Player completes the blessed harvest ceremony and is sent to Nolbu.
2. Nolbu delivers the retaliation threat.
3. The patch becomes bramble-blocked and a nearby support point is marked as disrupted.
4. Player returns to Heungbu's side of the village and sees both the patch sabotage and the secondary disruption.
5. Player clears the brambles first to reopen the patch.
6. Heungbu (or the repaired landmark prompt) directs the player to stabilize the nearby support point.
7. Player completes one quick repair interaction.
8. Restoration presentation plays.
9. Quest advances to the final audience.

---

## Quest / State Flow
### Existing stages reused
- `NOLBU_RETALIATION`
- `CLEAR_BRAMBLES`
- `FINAL_AUDIENCE`

### New stage
- `STABILIZE_VALLEY` - after brambles are cleared, the player restores one damaged support point near Heungbu's yard / village well / story stone approach.

### Transition rules
- `NOLBU_RETALIATION -> CLEAR_BRAMBLES`: when Nolbu triggers the sabotage beat
- `CLEAR_BRAMBLES -> STABILIZE_VALLEY`: after the brambles are removed
- `STABILIZE_VALLEY -> FINAL_AUDIENCE`: after the player repairs the selected support point
- `FINAL_AUDIENCE -> CHOOSE_ENDING`: unchanged

### Authority rule
Quest stage remains authoritative. The new support-point repair should not be inferred only from world props; it should set a dedicated profile flag and stage transition.

---

## World Objects
### Reused
- patch
- bramble parts + prompt
- Heungbu prompt
- village billboards
- story effect banner channel

### New or adjusted objects
- one `SupportRepairPrompt` at a high-read landmark near the village core
- one lightweight disrupted prop state for that landmark
- optional billboard/body text update during retaliation pressure

### Recommended support-point options
Choose only one for MVP:
1. **Patch lantern / yard marker** - easiest, very local to Heungbu
2. **Village well herb frame** - ties back to an existing landmark
3. **Story stone banner / sign** - narratively symbolic, but slightly less concrete

### Preferred MVP choice
**Patch lantern / yard marker** near Heungbu's side of the village.
It is easy to notice, easy to author with runtime props, and clearly reads as the miracle's surrounding warmth being targeted.

---

## Server Design
### New profile fields
- `valleyStabilized = false | true`
- optional `retaliationSupportPoint = "yardLantern"` for future variation, but fixed for MVP is acceptable

### New quest constant
- `STABILIZE_VALLEY`

### Responsibilities
#### On retaliation trigger
- set brambles visible
- switch support point into disrupted state
- update relevant sign / patch text
- move player to `CLEAR_BRAMBLES`

#### On bramble clear
- reopen patch
- do **not** advance directly to final audience
- advance to `STABILIZE_VALLEY`
- point the player toward the disrupted support point

#### On support-point repair
- mark `valleyStabilized = true`
- swap landmark from disrupted -> restored state
- play short restoration effect/dialogue
- advance to `FINAL_AUDIENCE`

### Design rule
The support-point repair should be one interaction, not a resource turn-in, timer, or scavenger loop. The value comes from pacing and consequence, not complexity.

### Sign / world text hooks
During retaliation pressure, at least one sign should acknowledge unrest, for example:
- `The patch is open again, but the yard still needs steady hands.`
- `Nolbu's envy reached farther than the vines.`

After stabilization, copy can shift to:
- `The yard is steady again. Return to Heungbu for the valley's decision.`

---

## Client Design
### HUD
Quest tracker must support the new stage:
- title: `Steady the Valley`
- objective: `Repair the damaged yard marker near Heungbu's house.`

### Presentation
Keep the added beat modest:
- one warning-style banner for retaliation reveal
- one restoration-style banner for support-point repair completion
- avoid another large ceremony; this is a bridge beat, not a second climax

### Dialogue
- Heungbu should frame the repair as proof that kindness holds through damage.
- Nolbu should frame the sabotage as a test of whether generosity survives pressure.
- The support-point prompt itself should carry 1-2 lines of readable flavor.

---

## Data Model
### Player attributes
No new visible attribute required beyond updated quest title/objective.

### Runtime/session state
- `valleyStabilized`
- optional `retaliationSupportPoint`

### Village/global counters
Optional:
- `stabilizations`

This counter is non-essential for MVP.

### Runtime folders
Any new support-point props should live under existing runtime asset folders.

---

## Failure / Edge Cases
- **Player leaves after clearing brambles:** resume at `STABILIZE_VALLEY`, with brambles already cleared and support point still disrupted.
- **Player repairs support point before clearing brambles:** prompt should be disabled or give a blocked line.
- **Support-point prop fails to spawn:** fallback to Heungbu prompt completing `STABILIZE_VALLEY` with equivalent dialogue.
- **Player triggers Nolbu but never returns:** quest text must clearly direct the player back to Heungbu's side.
- **World text conflicts with ending ambient state:** retaliation-pressure copy overrides only until `FINAL_AUDIENCE` begins.
- **Duplicate repair input:** once stabilized, further interactions give ambient text only.

---

## Validation Plan
1. Progress to the blessed harvest ceremony and complete the magic payoff.
2. Trigger Nolbu retaliation.
3. Confirm the patch is bramble-blocked and one nearby support point is visibly disrupted.
4. Clear brambles and verify the quest advances to `STABILIZE_VALLEY`, not directly to `FINAL_AUDIENCE`.
5. Repair the support point and confirm a short restoration beat plays.
6. Verify the quest advances to `FINAL_AUDIENCE` only after repair.
7. Rejoin/reset mid-sequence and confirm stage guards recover correctly.
8. Confirm the final audience and ending choice still work without duplicated rewards or broken ambience.

---

## MVP Cut Line
- one new `STABILIZE_VALLEY` quest stage
- one disrupted support-point landmark near Heungbu
- one repair prompt and one restored state
- updated quest copy / sign copy for retaliation pressure
- clean handoff into existing final audience flow

## Future Extensions
- rotate among 2-3 support points for replay variation
- branch-aware repair flavor based on future moral counters
- minor patrol bark reactions during retaliation pressure
- tie repaired support points into post-ending ambience

## Recommended PM / Dev Hand-off
### PM should break this into
1. retaliation stage split
2. support-point disrupted/restored world state
3. repair prompt + fallback route
4. copy/effect verification

### Dev should implement in this order
1. new quest stage + profile flag
2. disrupted support-point prop state
3. repair interaction
4. quest/sign/effect polish

This keeps the next build focused on an obvious narrative weakness instead of expanding sideways into a larger system.