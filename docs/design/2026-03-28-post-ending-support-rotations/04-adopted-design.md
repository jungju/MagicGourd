# Adopted Design

## Chosen Candidate
Candidate A — Rotating Support-Point Tasks

## Why Chosen
This is the best next implementation opportunity because the current post-ending system now has three solid layers already in place:
- branch-aware ending aftermath
- branch-specific repeatable errands
- milestone escalation on repeated hand-ins

What still feels thin is **where** that replay happens. The player is being asked to repeat a meaningful action, but always at the same node. The next smart move is to spread that meaning across a tiny set of nearby support points, not to add a bigger reward tree or another story chapter.

It also fits the current code surface unusually well:
- runtime prompt parts already exist
- the retaliation repair marker proves support-point interactions are stable
- sign refresh and ambient hint text already centralize branch copy
- per-player errand counts already exist and can drive threshold-based rotation

## Why Others Were Rejected
- **Candidate B — Branch Helper NPC Barks:** useful garnish, but not enough gameplay gain for the next pass.
- **Candidate C — Tiny Branch Route Obstacles:** visually attractive, but risks overbuilding props before movement patterns matter.
- **Candidate D — Ending Echo Event Pings:** too much hidden cadence logic for the current need.

## Design Summary
Add a **support-point rotation layer** to `COMPLETE` branch errands.

Each branch keeps one active errand interaction at a time, but the active location can move after a small completion threshold:
- **Restoration points:** shared basket, village well pantry/drop point, yard marker relief mat
- **Tribute points:** road-due stand, Nolbu gate tally point, tribute basket route marker

The player still turns in one normal gourd for modest branch-specific rewards. The difference is that the village now asks for that help in slightly different places, making each ending feel more spatially inhabited.

---

## Player Experience Goal
### Restoration should feel
- communal
- distributed across the village core
- like people quietly keep sharing what the patch protected

### Tribute should feel
- organized
- route-oriented
- like the road keeps asking to be fed from multiple official points

### Shared goal
One extra harvest cycle should involve a short walk, a changed landmark, and a slightly different line of feedback — not just the same prompt again.

---

## Scope Boundary
This design is **not**:
- a quest board
- a timed daily system
- a map-wide request network
- a persistent NPC schedule feature
- a new resource type or reputation economy

This design **is**:
- 2-3 support points per branch
- one active point per branch at a time
- threshold-based rotation after successful hand-ins
- tiny location-specific copy changes on top of the existing branch errand loop

---

## Player Flow
1. Player reaches `COMPLETE` with a resolved ending.
2. The current active support point for that ending is visible/readable.
3. Player brings 1 normal gourd and completes the errand as usual.
4. After a threshold is met (recommended: every 2 completed branch errands), the active point rotates to the next nearby location for that branch.
5. Signage and hint text update to point toward the new location.
6. Player can keep farming and follow the village's shifting need through a short local route.

---

## World Objects

### Restoration support points
1. **Shared Basket** — existing restoration receiver near Heungbu/well side.
2. **Well Pantry Drop** — a small mat/crate near the village well; uses the well area that already reads communal.
3. **Yard Marker Relief Mat** — a tiny produce mat beside the repaired Heungbu yard marker; reuses the retaliation recovery landmark.

### Tribute support points
1. **Road-Due Stand** — existing tribute receiver near Nolbu route.
2. **Gate Tally Point** — a second prompt marker near Nolbu's front gate edge; feels official and controlled.
3. **Tribute Basket Route Marker** — a stricter roadside collection node by the tribute basket lane.

### Presentation rule
All points should be primitive/runtime-authored, prompt-first, and safe if one location is cut. No bespoke asset requirement.

---

## Interaction Design

### Shared rules
- active only in `COMPLETE`
- gated by `endingChoice`
- requires `1` normal gourd
- reuses current modest reward tuning
- only the currently active point accepts hand-ins
- inactive points remain visible only as flavor, or hide entirely if that is clearer

### Restoration location flavor
#### Shared Basket
- baseline communal drop
- copy emphasizes feeding neighbors together

#### Well Pantry Drop
- copy emphasizes the village center staying supplied
- strongest place to mention seeds returning after milestones

#### Yard Marker Relief Mat
- copy emphasizes that the yard Heungbu defended now supports others, not just his own house

### Tribute location flavor
#### Road-Due Stand
- baseline compliance point
- copy emphasizes keeping the road quiet

#### Gate Tally Point
- copy emphasizes inspection, counting, and official order

#### Tribute Basket Route Marker
- copy emphasizes routine surrender and the road's continuing claim on harvests

---

## Rotation Rules

### Recommended MVP rule
Rotate after every **2 successful hand-ins** within that branch's post-ending errand loop.

Why 2:
- enough time for the player to notice a location before it moves
- still frequent enough to reduce static repetition quickly
- simpler than cooldown/timer logic

### Rotation order
Keep it deterministic, not random.

#### Restoration order
1. Shared Basket
2. Well Pantry Drop
3. Yard Marker Relief Mat
4. back to Shared Basket

#### Tribute order
1. Road-Due Stand
2. Gate Tally Point
3. Tribute Basket Route Marker
4. back to Road-Due Stand

### Per-player vs village-wide authority
**Per-player rotation** is recommended for MVP.

Reason:
- current errand progression and rewards are already per-player
- avoids shared-world conflicts where one player's hand-in moves another player's active point unexpectedly
- keeps implementation surface smaller and clearer

Village-wide signage can still reflect aggregate counts, but active prompt eligibility should be per-player.

---

## Server Design

### New helper concept
Add a small support-point selection layer, for example:
- `getActiveEndingSupportPoint(player)`
- `advanceEndingSupportPoint(player, errandKind)`
- `isEndingSupportPointActive(player, pointId)`
- `refreshEndingSupportPointPresentation(player)` or equivalent shared world-state hook

### Data model
Reuse existing errand counts where possible.

Recommended lightweight additions:
- `profile.restorationSupportPointIndex = 1`
- `profile.tributeSupportPointIndex = 1`
- `profile.restorationRotationStep = 0`
- `profile.tributeRotationStep = 0`

Alternative compressed model is acceptable, but keep it readable.

### Completion behavior
On successful errand completion:
1. consume 1 normal gourd
2. apply current reward logic unchanged
3. increment branch rotation step
4. if threshold reached, advance support point index and reset the branch step counter
5. update player-facing hint text and active prompt presentation

### Prompt authority rules
- only the active support point should complete the errand
- inactive same-branch points can say `The next shared drop is being gathered elsewhere.` / `Today's road due is being counted at another stand.`
- opposite-branch points still use the current branch mismatch safety text

### Sign / hint hooks
At minimum, update `QuestHint` or equivalent passive hint text in `COMPLETE` to indicate the current active point.

Example restoration hints:
- `Shared harvests are being gathered near the well.`
- `Heungbu's yard marker now serves as the next relief drop.`

Example tribute hints:
- `The next road due is being counted by Nolbu's gate.`
- `The road's basket marker is collecting today's due.`

---

## Client / HUD / Presentation
- No new panel.
- Existing HUD hint area is enough.
- Optional small effect pulse only when the support point rotates for the first time to a new location.
- Avoid full-screen banners on every move.

### Visibility recommendation
Keep non-active points visually present but passive if that is readable in playtests. If it becomes confusing, hide or heavily mute inactive prompts while leaving their props in world.

---

## Failure / Edge Cases
- **Player goes to an inactive same-branch point:** return a short redirect line, not a failure effect.
- **Player has no gourd:** use current missing-gourd text, optionally with location-specific flavor.
- **Player disconnects after a rotation threshold:** resume on the newly selected support point.
- **One support point prop fails to spawn:** skip that point in the order or fall back to the branch baseline point.
- **Too much walking:** keep all support points inside a short village loop; do not place them in distant farm extremities.
- **Mixed village aggregate ending signs:** okay; active prompt routing remains per-player.

---

## Validation Plan
1. Finish the story on restoration.
2. Complete two shared-harvest hand-ins.
3. Confirm the active restoration point rotates from the shared basket to the well pantry drop.
4. Confirm the old point stops accepting completions and redirects cleanly.
5. Repeat until the yard marker relief mat becomes active.
6. Verify reward tuning remains unchanged aside from the already-existing milestone escalation.
7. Repeat the full loop on tribute and confirm route-specific copy reads colder and more official.
8. Rejoin mid-rotation and confirm the active point is preserved for that player.

---

## MVP Cut Line
- 2 support points per branch minimum, 3 preferred
- deterministic per-player rotation
- rotate every 2 successful hand-ins
- updated hint/sign copy naming the active point
- no new reward layer beyond current errand logic

## Post-MVP Extensions
- add branch helper barks at active support points
- let cumulative counts cosmetically decorate each point
- add one tiny route prop cue between active points
- vary line sets per support point as content polish

## Recommended PM / Dev Hand-off
### PM should break this into
1. restoration point set + copy
2. tribute point set + copy
3. per-player rotation rule
4. hint/sign redirection behavior
5. fallback behavior if a point is unavailable

### Dev should implement in this order
1. support-point data definition and per-player active index
2. second prompt location for each branch
3. active/inactive prompt gating + redirect text
4. third point only if the first two feel stable
5. hint/sign polish

This keeps the next build focused on actual replay feel, using systems the project already proved out, instead of inventing a broader live-village simulation too early.
