# Adopted Design

## Chosen Candidate
Candidate A — Support-Point Witness Barks

## Why Chosen
This is the best next implementation opportunity because the post-ending loop is now structurally real, but still under-witnessed.

The project already has:
- branch-aware aftermath
- repeatable branch errands
- rotating support points
- landmark tier accrual
- prompt/dialogue/effect infrastructure

So the next smart move is not another counter, reward, or branch rule. It is a lightweight social layer that makes the village **react** to the player's ongoing post-ending labor.

## Why Others Were Rejected
- **Candidate B — Route Cue Prop Pass:** useful fallback polish, but weaker than giving the loop social meaning.
- **Candidate C — Tier-Triggered Micro Moments:** attractive, but risks banner/event spam before witness texture exists.
- **Candidate D — Brother Reaction Expansion:** safe and worth folding in later, but too narrow as the next primary feature.

## Design Summary
Add a small set of **village witness interactions** near the post-ending support loop.

These are not full NPC schedules. They are tiny prompt-first or ambient-dialogue witnesses that:
- sit near the restoration / tribute support routes
- change line sets by `endingChoice`
- optionally vary by active support point and landmark tier
- reinforce that repeated help is being noticed by more than signs

The result should be:
- restoration feels socially warm and quietly communal
- tribute feels socially orderly and a little supervised
- the player hears that the village is adapting, not just counting

---

## Player Experience Goal
### Restoration should feel
- like neighbors are noticing food and relief actually moving around
- like shared help is becoming normal, not heroic
- like the village is growing trust

### Tribute should feel
- like everyone knows where the next due is being counted
- like routines are settling in around the road
- like compliance is visible even when no one says it loudly

### Shared goal
When the player walks between support points, they should occasionally hear or trigger a line that makes the current branch and landmark tier feel socially real.

---

## Scope Boundary
This design is **not**:
- a broad ambient NPC schedule system
- a new questline
- roaming chatter spam every few seconds
- a crowd simulation
- a reward-bearing feature

This design **is**:
- 2-3 small witness points per branch maximum
- short rotating line sets
- branch-aware and tier-aware reactions
- optional use of invisible prompts, simple stand-ins, or billboard-backed witness props

---

## Witness Set

### Restoration witnesses
1. **Well Neighbor**
   - placed near the well / pantry route
   - comments on pantry stocking, shared drops, and ordinary village relief
2. **Yard Helper**
   - placed near Heungbu's repaired marker / relief mat
   - comments on the yard becoming useful beyond one family
3. **Basket Passer**
   - optional, near the shared basket side
   - comments on food being left where others can reach it

### Tribute witnesses
1. **Road Clerk**
   - placed near the road-due stand
   - comments on quiet roads, counted harvests, and routine compliance
2. **Gate Watcher**
   - placed near Nolbu's gate tally point
   - comments on inspection and due-count order
3. **Route Observer**
   - optional, near the route marker
   - comments on the road claiming harvests before they even reach the stand

### Presentation rule
Each witness can be one of the following, chosen by implementation convenience:
- simple runtime-authored villager stand-in with prompt
- sign-like witness post with dialogue on interact
- invisible/local interaction hotspot paired with ambient line playback

Use the cheapest readable option. The feature is about voiced village perspective, not character rig complexity.

---

## Interaction Design

### Trigger rules
- active only in `COMPLETE`
- only relevant if `endingResolved` is true
- line family selected by `endingChoice`
- optional line swap based on current active support point id
- optional tier-aware upgrade at Tier 1 / Tier 2

### Frequency rule
Witnesses should be **player-pulled or lightly gated**, not constant autoplay.

Preferred MVP:
- player interacts with a witness prompt to hear 1 short 2-line bark
- repeated interactions rotate through 2-4 lines
- witness lines can refresh after each completed support errand or after support-point rotation

Avoid free-running chatter that fires whenever the player passes by.

### Restoration tone examples
- `Someone left another gourd by the well. Feels like the village has started trusting tomorrow again.`
- `Heungbu's yard used to just endure. Now even this corner passes food onward.`
- `The basket looks fuller these days, but somehow the village feels lighter.`

### Tribute tone examples
- `The due moved to the gate today. Best not arrive empty-handed when the count is this close.`
- `Funny how fast a road starts feeling official once every marker learns to ask.`
- `No one argues when the tally is already waiting for them.`

---

## State / Line Selection

### Inputs
- `profile.endingChoice`
- `profile.sharedHarvestDrops`
- `profile.tributeDuesPaid`
- active support point id for the relevant branch
- optional per-witness cursor for line rotation

### Derived behavior
#### Restoration
- Tier 0: cautious optimism, early communal language
- Tier 1: pantry / relief routines becoming normal
- Tier 2: visible trust, stocked corners, stronger shared confidence

#### Tribute
- Tier 0: compliance and quiet pressure
- Tier 1: tally routine settling in
- Tier 2: order now feeling normalized and institutional

### Recommended helper concepts
- `getWitnessLineSet(player, witnessId)`
- `getWitnessContext(player)` returning branch + active support point + tier
- `playWitnessBark(player, witnessId)`

If the codebase prefers a table-driven approach, store witness definitions with branch-specific line pools and optional overrides by point/tier.

---

## World Objects

### MVP placement guidance
Keep witness points inside the same short village loop already used by support rotation.

#### Restoration
- one witness near well pantry
- one witness near yard relief marker
- optional third near shared basket

#### Tribute
- one witness near road-due stand
- one witness near gate tally point
- optional third near route marker

### Hard rule
Do not add enough witness points that the village becomes noisy. Two per branch is enough for first implementation.

---

## Server Design

### Data model
Prefer tiny additions only if needed:
- `profile.witnessDialogueCursor = {}` reusing the existing ambient cursor shape is ideal
- witness definition table in server code

No new save-heavy progression is required.

### Runtime behavior
On witness interaction:
1. derive branch + active support point + tier for the player
2. choose the matching line set
3. rotate to the next line in that witness pool
4. fire ordinary dialogue UI

### Optional refresh hook
After successful post-ending errand completion:
- no mandatory extra dialogue
- but the next witness interaction may surface a newer line family that acknowledges the updated point/tier

This preserves the low-spam goal.

---

## Client / HUD / Presentation
- No new HUD panel
- Reuse current dialogue presentation
- Prompts can be named things like `Ask`, `Listen`, or `Check In`
- Witness props should read as villagers or village touchpoints, not new quest givers

### Clarity rule
The player should understand these are flavor witnesses, not mandatory progression actors.

---

## Failure / Edge Cases
- **Player before `COMPLETE`:** witnesses stay silent or return generic village flavor.
- **Mixed village-global signage vs player-specific state:** witness dialogue should prefer the interacting player's branch and active support point.
- **One witness point is cut:** the system still works with two witnesses per branch.
- **Repeated spam-clicking:** use the existing rotating line behavior; optional tiny cooldown only if needed.
- **Support rotation not currently active for that witness's point:** witness can still speak in passive terms instead of direct routing language.

---

## Validation Plan
1. Finish on restoration.
2. Complete 0-2 restoration errands and talk to the restoration witnesses.
3. Confirm they speak with Tier 0 restoration tone.
4. Reach Tier 1 and rotate the active support point.
5. Confirm at least one witness line changes to acknowledge the new point or the better-stocked valley.
6. Repeat at Tier 2 and confirm the village sounds more settled and confident.
7. Repeat the full flow on tribute and confirm the tone feels more official and supervised.
8. Confirm none of the witness interactions are mistaken for new mandatory quests.

---

## MVP Cut Line
- 2 witness points per branch
- 2-4 short lines per witness family
- branch-aware line pools
- optional point/tier variation only where it adds clear value
- no rewards, no new UI, no autoplay chatter

## Post-MVP Extensions
- fold in expanded Heungbu / Nolbu post-ending reactions
- add tiny route cue props as support for witness locations
- let Tier 2 unlock one rarer witness line set
- add a very small chance for one witness to react immediately after a hand-in

## Recommended PM / Dev Hand-off
### PM should break this into
1. restoration witness set
2. tribute witness set
3. line variation rules by tier / active point
4. prompt naming and placement clarity

### Dev should implement in this order
1. witness definition table + interaction points
2. branch-aware line selection
3. tier-aware overrides where useful
4. optional active-point-specific lines only if the base pass reads clearly

This keeps the next pass tightly aligned to the feature gap the current build actually has: the village has systems now, but it still needs social texture around them.