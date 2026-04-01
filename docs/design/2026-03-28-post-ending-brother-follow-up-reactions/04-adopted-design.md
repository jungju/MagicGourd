# Adopted Design

## Chosen Candidate
Candidate A — Brother Follow-Up Reactions

## Why Chosen
This is the best next implementation opportunity because the current post-ending loop now has enough world response to support a more personal response.

The project already has:
- branch-aware ending aftermath
- repeatable post-ending errands
- rotating support points
- landmark accrual tiers
- witness barks
- route cue props
- rare errand variants
- Story Stone reflections

So the next smart move is not another village object. It is a small pass that lets **Heungbu and Nolbu react like the ending is still unfolding through the player's repeat actions**.

## Why Others Were Rejected
- **Candidate B — Shared Summary Board Refresh:** useful later, but too redundant with Story Stone + distributed signs.
- **Candidate C — Tier-Triggered Micro Moments:** attractive later, but the build already has enough short celebratory beats for now.
- **Candidate D — End-Branch Ambient Duet Lines:** worth layering in later, but it depends on stronger brother revisit logic first.

## Design Summary
Add branch-aware post-ending follow-up dialogue pools for Heungbu and Nolbu that unlock inside ordinary revisit interactions during `COMPLETE`.

These reactions should:
- acknowledge the chosen ending branch
- evolve across landmark tiers
- occasionally reference the currently active support point
- optionally echo the latest rare event once
- stay concise and non-mandatory

The result should be:
- restoration feels personally affirmed by Heungbu and quietly resisted or ruefully noted by Nolbu
- tribute feels normalized or defended by Nolbu and mourned or carefully tolerated by Heungbu
- repeated errands feel like they keep changing relationships, not just counters

---

## Player Experience Goal
### If the player chose restoration
- Heungbu should sound grateful, steadier, and less fragile over time.
- Nolbu should sound irritated, dismissive, or forced into grudging observation as the village keeps choosing warmth.
- The player should feel that shared labor is becoming visible in family terms, not just village terms.

### If the player chose tribute
- Nolbu should sound more vindicated, formal, and settled as tribute routines harden.
- Heungbu should sound saddened, careful, but still humane rather than melodramatic.
- The player should feel that tribute is not just a system loop; it is a moral atmosphere that the brothers keep living inside.

### Shared goal
Talking to either brother after several replay-loop errands should feel like checking back on the emotional consequence of the ending.

---

## Scope Boundary
This design is **not**:
- a new branch choice
- a hidden affinity system
- a new cutscene pipeline
- a mandatory return-after-every-errand quest
- a replacement for ambient village witnesses

This design **is**:
- extra `COMPLETE` dialogue pools for Heungbu and Nolbu
- branch-aware and tier-aware line selection
- optional point-aware mentions for active support focus
- optional one-time rare-event echo lines
- ordinary prompt-based interaction using existing dialogue UI

---

## Dialogue Structure

### Heungbu follow-up buckets
#### Restoration bucket
Tone progression:
- Tier 0: relieved that kindness held
- Tier 1: noticing routine shared help becoming dependable
- Tier 2: speaking with grounded confidence about the valley learning trust again

Example beats:
- `I thought the first shared baskets might be remembered only as a kind gesture. Now people are planning around them.`
- `The yard used to ask for help. Lately it has started sending help back out.`
- `When the well stays stocked between visits, it feels like hope has finally learned the road home.`

#### Tribute bucket
Tone progression:
- Tier 0: trying to stay gentle under a colder order
- Tier 1: noticing how tribute is becoming routine
- Tier 2: accepting the road's stability without calling it goodness

Example beats:
- `The road is quieter, but I do not mistake quiet for comfort.`
- `People have learned where to carry the due before anyone asks. That may be the saddest kind of efficiency.`
- `Even a steady road can leave a house feeling smaller.`

### Nolbu follow-up buckets
#### Restoration bucket
Tone progression:
- Tier 0: annoyed that the valley did not stay fearful
- Tier 1: noticing restoration habits are surviving beyond sentiment
- Tier 2: grudgingly admitting the village has organized itself without him

Example beats:
- `I expected generosity to tire itself out. Annoyingly, it appears to be learning discipline.`
- `A village that keeps leaving food where others can reach it becomes harder to pressure cleanly.`
- `Do not mistake me for impressed. I only notice when a habit refuses to die.`

#### Tribute bucket
Tone progression:
- Tier 0: satisfied that order is holding
- Tier 1: treating tribute as a sensible norm
- Tier 2: sounding almost administrative about the road's permanence

Example beats:
- `People complain less once the due learns where it belongs.`
- `The gate tally saves everyone time. Structure often looks cruel only until it becomes familiar.`
- `The road runs more smoothly when no one pretends a harvest is purely private.`

---

## Line Selection Rules

### Inputs
- `profile.questStage`
- `profile.endingResolved`
- `profile.endingChoice`
- branch landmark tier via existing helper
- active support point via existing helper
- `profile.lastEndingRareEventTitle` / `profile.lastEndingRareEventBranch` if available
- optional per-brother post-ending cursor

### Recommended helper concepts
- `getBrotherCompleteLineSet(player, brotherId)`
- `getBrotherCompleteContext(player)` returning branch + tier + activePoint + latestRareEvent
- `getNextBranchDialogue(profile, key, pools)` if the project wants to reuse the existing rotating-line style

### Priority order
1. wrong quest stage -> existing quest dialogue remains authoritative
2. `COMPLETE` branch bucket by chosen ending
3. optional active support point mention if especially relevant
4. tier-specific tone upgrade
5. optional rare-event echo once, then fall back to ordinary pool rotation

### Anti-spam rule
Rare-event echo lines should be treated as garnish, not a dominant state. One remembered reference per brother per relevant branch is enough before returning to the normal rotating pool.

---

## Support Point Mention Rules

### Restoration examples
- `sharedBasket`: emphasize the village center learning to leave food where others can reach it
- `wellPantry`: emphasize dependable stocking and ordinary relief
- `yardRelief`: emphasize Heungbu's home becoming a point of outward care

### Tribute examples
- `roadStand`: emphasize roadside compliance and public counting
- `gateTally`: emphasize pressure becoming personal at Nolbu's gate
- `routeMarker`: emphasize the road claiming harvests before they even arrive

### Rule
Support-point-specific lines should be sparse. They are there to make revisit dialogue feel current, not to become navigation hints.

---

## Server / Runtime Design

### Data model
Prefer derived presentation over new persistent progression.

Acceptable small additions:
- `profile.completeDialogueCursor = profile.completeDialogueCursor or {}`
- optional consumed-memory flags for rare-event echo lines if needed

Primary inputs should stay derived from existing state:
- ending branch
- branch errand counts
- current landmark tier
- active support point
- latest rare-event memory

### Runtime behavior
On Heungbu or Nolbu interaction in `COMPLETE`:
1. derive branch context for that player
2. choose the brother's branch-specific line family
3. optionally inject one support-point or rare-event-aware line family
4. rotate to the next line in the merged pool
5. show ordinary dialogue UI
6. preserve existing bonus coin behavior only if already intentional in that interaction; this feature adds no new reward rule

### Authoring rule
Keep the line tables centralized and table-driven so PM can extend tone without touching interaction flow.

---

## Client / HUD / Presentation
- No new HUD
- No cutscene camera
- No mandatory revisit callout
- Reuse current brother prompts and dialogue box

### Readability rule
The brothers should still sound like optional revisit conversations, not like they are offering another quest.

---

## Failure / Edge Cases
- **Player talks to brother before `COMPLETE`:** current quest dialogue remains unchanged.
- **Player repeats interactions rapidly:** use rotating lines; avoid repeating the same high-signal line back-to-back.
- **Rare-event memory is nil:** skip the echo branch cleanly.
- **Support-point mention does not fit current brother mood:** fall back to tier-only branch lines.
- **One brother ends up sounding too recap-heavy:** trim point-aware mentions before trimming core emotional lines.

---

## Validation Plan
1. Finish on restoration and talk to Heungbu and Nolbu immediately after entering `COMPLETE`.
2. Confirm both speak from restoration-specific post-ending pools.
3. Complete enough shared-harvest errands to reach Tier 1.
4. Revisit both brothers and confirm their tone upgrades appropriately without pretending a new quest opened.
5. Rotate the active support point and confirm at least one line can reflect the current village focus.
6. Trigger a rare restoration event and confirm at most one tasteful echo line appears later.
7. Repeat the full flow on tribute and confirm the emotional contrast is clear.
8. Confirm witness barks, Story Stone, and brother lines feel complementary rather than repetitive.

---

## MVP Cut Line
- one `COMPLETE` dialogue bucket per brother per ending branch
- tier-aware variation at Tier 1 / Tier 2
- rotating line selection
- no new rewards
- optional point-aware and rare-event-aware mentions only where they clearly improve freshness

## Post-MVP Extensions
- add duet-style mirrored lines where Heungbu and Nolbu indirectly answer the same village state
- let one Tier 2 line reference landmark visuals more explicitly
- allow a very rare immediate post-errand reactive line if playtests still want stronger brother presence

## Recommended PM / Dev Hand-off
### PM should break this into
1. Heungbu restoration tone ladder
2. Heungbu tribute tone ladder
3. Nolbu restoration tone ladder
4. Nolbu tribute tone ladder
5. sparse support-point and rare-event reference rules

### Dev should implement in this order
1. extract/extend `COMPLETE` brother dialogue selection into table-driven branch pools
2. add tier-aware overrides
3. add sparse active-point mentions
4. add optional rare-event echo memory only if it stays low-spam
5. trim any lines that duplicate witness bark territory

This keeps the next design focused on a real upcoming implementation opportunity: the replay loop already changes the village, so now it should also keep changing the brothers.
