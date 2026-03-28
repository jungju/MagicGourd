# Adopted Design

## Chosen Candidate
Candidate A — Active Route Cue Prop Pass

## Why Chosen
This is the best next implementation opportunity because the post-ending loop is now functionally mature enough to benefit from **small environmental guidance instead of more structure**.

The project already has:
- branch-aware ending aftermath
- repeatable post-ending errands
- rotating support points
- landmark accrual tiers
- village witness interactions

So the next smart move is not another counter, panel, or story branch. It is a tiny pass that makes the active route feel legible and authored while the player walks.

## Why Others Were Rejected
- **Candidate B — Brother Follow-Up Reactions:** worth doing later, but it does less for moment-to-moment routing.
- **Candidate C — Tier-Triggered Micro Moments:** attractive later, but ceremony matters less if the active point still relies on text-first guidance.
- **Candidate D — Shared Summary Board Refresh:** useful backup readability, but weaker than improving the immediate path itself.

## Design Summary
Add a small **route-cue prop layer** to the post-ending support loop.

Each branch gets a few low-cost primitive cues that subtly frame the current active support point and its approach path:
- **Restoration** uses baskets, cloth, seed sacks, and warm communal staging
- **Tribute** uses rope, ledgers, marker cloth, stones, and more official alignment

These cues should update with the currently active support point and remain tightly local. The player should feel nudged by the environment, not railroaded by giant arrows.

---

## Player Experience Goal
### Restoration should feel
- like shared help is being routed by neighbors
- like the village quietly leaves things ready where they are needed next
- warm, practical, and ordinary rather than magical

### Tribute should feel
- like the road's demand is already prepared before the player arrives
- official, counted, and slightly tense
- tidy in a way that reads colder than restoration

### Shared goal
When the active support point changes, the player should be able to notice that shift from nearby world dressing before they need to parse sign copy.

---

## Scope Boundary
This design is **not**:
- minimap guidance
- an objective arrow system
- a heavy VFX trail
- a permanent clutter pass across the whole village
- a new progression mechanic

This design **is**:
- 1-2 tiny cue clusters near each active point
- optional short approach cues for the two clearest transitions per branch
- branch-aware visual language
- active-point-driven presentation, not static permanent decoration everywhere

---

## Cue Language

### Restoration cue vocabulary
Use a mix of:
- folded or draped cloth
- small crate/basket staging
- seed sack or gourd grouping
- warmer lamp/lantern emphasis where already tonally appropriate

### Restoration read rule
Cues should imply:
- people prepared a shared drop here
- food/seed is circulating outward
- the village center is helping each other on purpose

### Tribute cue vocabulary
Use a mix of:
- rope segments or lane edging
- ledger/tally props
- marker cloth
- stones/posts arranged with stricter spacing

### Tribute read rule
Cues should imply:
- the due has been formally redirected here
- the route is being watched or normalized
- compliance is expected before the player even arrives

---

## Support Point Mapping

### Restoration support points
1. **Shared Basket**
   - baseline communal node
   - active cue: slightly fuller staging around the basket lip or beside the mat
2. **Well Pantry Drop**
   - center-village node
   - active cue: extra crate/cloth/sack cluster oriented toward the well path
3. **Yard Relief Mat**
   - Heungbu-side node
   - active cue: relief bundle and small staged produce near the yard marker path

### Tribute support points
1. **Road-Due Stand**
   - baseline tribute node
   - active cue: ledger/rope emphasis around the stand approach
2. **Gate Tally Point**
   - controlled tally node
   - active cue: rope/post alignment and stricter tally staging near the gate edge
3. **Route Marker**
   - lane-facing collection node
   - active cue: marker cloth, rope, and stone alignment making the route look claimed

---

## State / Activation Rules

### Activation rule
- route cues are only active in `COMPLETE`
- cue family is selected by `endingChoice`
- cue placement should respond to the player's currently active support point where feasible
- if the world presentation must stay village-global, only the branch-matching cue family should be shown and the active-point emphasis should be kept to the currently village-visible point signage area

### Visibility recommendation
For MVP, prefer a **single active cue cluster per branch-visible route point** rather than many simultaneous accents.

If per-player prop visibility is awkward in Roblox world-state terms, use this fallback:
- keep all branch baseline support props visible
- only toggle a tiny highlight cluster at the current active point for the interacting player if local presentation is easy
- otherwise, let signs/hints carry per-player specificity while route cues reinforce branch flavor at the most recent or village-global active point

### Landmark compatibility rule
Route cues must not fight landmark accrual props.

Recommended layering:
- landmark accrual = persistent branch-state growth
- route cues = current active-point emphasis

If a support point gets visually crowded, landmark props take priority and route cues should collapse to one small readable accent.

---

## Server / Runtime Design

### Recommended helper concepts
- `updateEndingRouteCueProps(mode)`
- `setRouteCueClusterVisible(cluster, visible)`
- optional `getActiveVillageSupportPointId(errandKind)` reuse for village-global presentation

### Data model
Prefer **derived presentation** rather than new save state.

Primary inputs:
- active support point id
- `endingChoice`
- current village ambient mode
- existing landmark tier helpers where overlap must be resolved

No new persistent counters are required.

### Runtime behavior
When the active support point changes or village ending presentation refreshes:
1. determine branch presentation mode
2. determine the support point that should receive active route emphasis
3. hide the inactive cue clusters for that branch
4. show the active cue cluster at the relevant point
5. refresh sign copy as usual

### Authoring rule
All cue props should be runtime-authored primitives and grouped cleanly so they can be toggled without bespoke scene editing.

---

## Client / HUD / Presentation
- No new HUD panel
- No full-screen callout for routine rotations
- Existing hint text remains as backup clarity
- Route cues should be readable from a short walking distance, not from across the entire map

### Transition behavior
When a support point rotates:
- no banner is needed
- optional tiny sound/effect pulse is acceptable only if the route change is consistently missed in playtests
- default implementation should rely on changed props + sign copy only

---

## Failure / Edge Cases
- **Player misses the cue change:** sign and prompt copy still provide the final authority.
- **Cue props overlap landmark props:** reduce to one accent cluster; do not stack clutter.
- **One support point is visually awkward:** skip the approach cue and keep only the active-point cue.
- **Per-player visibility is too expensive/confusing:** keep route cues branch-global and use them mainly as flavor support around already highlighted nodes.
- **Restoration and tribute props visually collide in shared spaces:** only the currently dominant village ending presentation should surface its cue family in that shared read.

---

## Validation Plan
1. Finish on restoration.
2. Complete enough errands to rotate between all restoration support points.
3. At each point, confirm the active route cue cluster is readable before reading the sign body.
4. Confirm the point still feels uncluttered when landmark tier props are also present.
5. Repeat on tribute and confirm the route cue tone feels stricter and more official, not merely color-swapped.
6. Confirm inactive points do not look more important than the active point.
7. Confirm the loop still reads clearly with no additional UI.

---

## MVP Cut Line
- one active cue cluster per support point
- branch-aware prop language
- support-point-specific toggling
- no new save state
- no VFX trail and no path arrows

## Post-MVP Extensions
- add one short approach cue for the two most confusing point transitions per branch
- let witness signs echo the active route cue tone more directly
- fold in brother follow-up reactions once the loop's physical read is stable
- add a rare Tier 2-only accent variant if the village needs a richer final-state read

## Recommended PM / Dev Hand-off
### PM should break this into
1. restoration cue vocabulary and per-point mapping
2. tribute cue vocabulary and per-point mapping
3. active-point visibility rule
4. overlap cut rules with landmark accrual props
5. readability pass criteria

### Dev should implement in this order
1. define cue clusters per support point
2. toggle clusters from existing active-point helpers
3. test for overlap against landmark props and witness signs
4. trim any over-busy point back to one accent cluster
5. consider short approach cues only if the base pass still feels text-led

This keeps the next build focused on real next-play readability, not doc churn or a larger systemic detour.