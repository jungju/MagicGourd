# Adopted Design

## Chosen Candidate
Candidate A — Ambient Ending Mood Layer

## Why Chosen
It is the best next implementation target because the branching ending structure already exists in code, but the village still only carries that result through a narrow band of dialogue and sign text. This feature strengthens the ending without reopening the core questline, changing save shape, or demanding a large new economy loop.

It also fits the current implementation surface very well:
- `endingChoice` already exists per player
- village signs already refresh from centralized server logic
- patch mood and prompt text are already server-driven
- post-ending Heungbu/Nolbu dialogue already branches by ending

So the next smart move is not a brand-new chapter. It is a compact ambient layer that makes the existing finale feel materially true.

## Why Others Were Rejected
- **Candidate B — Ending-Specific Free-Play Tasks:** valuable, but should come after the village can clearly communicate which ending the player is living in.
- **Candidate C — Conflict Echo Layer:** strong sub-layer, but too negative and too narrow to serve as the whole post-ending system.
- **Candidate D — Branch-Aware Ambient Dialogue Pack:** worth including, but too text-heavy on its own.
- **Candidate E — Ending Landmark Prop:** visually attractive, but risks becoming one prop instead of a village-wide consequence.

## Design Summary
Add a lightweight **post-ending ambience controller** that changes a few high-visibility world elements after `COMPLETE` based on `endingChoice`:

- patch appearance and patch guidance text
- Heungbu yard / Nolbu gate / tribute basket signage tone
- a small set of branch-aware ambient prompt responses
- one or two simple world props or light-touch markers per ending
- a repeatable post-ending interaction framing, without introducing a full new quest arc

The goal is simple: after the player finishes the story, they should be able to walk the village for ten seconds and immediately feel whether they created a **Restored Valley** or a **Tribute Road**.

---

## Player Experience Goal
### Restoration ending should feel
- warmer
n- more communal
- visibly safer around the patch
- hopeful without feeling "finished and dead"

### Tribute ending should feel
- orderly
- slightly tense
- materially stable but emotionally colder
- like the village is still productive under pressure

### Shared post-ending rule
The world should remain playable and readable in free play. Nothing should require a new cutscene or long quest chain to understand the consequence.

---

## Scope Boundary
This design is **not**:
- a persistent save-system rewrite
- a full branch-specific economy loop
- a heavy NPC schedule system
- a large map art pass needing Studio choreography

This design **is**:
- a focused server-authored ambient layer
- a small amount of branch-aware content
- immediate payoff for the already-implemented ending choice
- a foundation for later repeatable ending-specific tasks

---

## Player Flow
1. Player completes the ending and enters `COMPLETE` with `endingChoice` resolved.
2. On the first post-ending ambient refresh, the village adopts the matching branch mood.
3. As the player revisits the core landmarks, they notice:
   - patch copy and visuals changed
   - key billboards read differently
   - Heungbu and Nolbu now speak in branch-aware ambient lines
   - one small world marker reinforces the branch tone
4. The player can continue farming and talking to NPCs.
5. Post-ending interactions keep reinforcing the chosen ending instead of drifting back to generic village text.

---

## World-State Design

### 1) Patch Mood Layer
Extend the current patch presentation so `idle` after `COMPLETE` is no longer neutral.

#### Restoration branch
- patch color shifts to healthier warm-earth / soft green accent
- patch light uses a gentle glow at low brightness
- patch billboard text emphasizes shared harvest and open access
- planting/harvesting copy suggests the patch is protected and communal

Suggested patch text examples:
- `The patch stays open. Plant here for a harvest the whole valley can share.`
- `The soil feels calmer now. Kindness still grows here.`

#### Tribute branch
- patch keeps a workable but more controlled tone
- light is dimmer or absent
- patch billboard text emphasizes counted harvest and obligation
- planting/harvesting copy suggests survival under pressure rather than celebration

Suggested patch text examples:
- `The patch still grows, but every harvest now feels counted.`
- `Plant carefully. Nolbu's road still expects its due.`

### 2) Signage Layer
Expand the existing `refreshVillageSigns()` behavior into branch-specific ambient messaging instead of only aggregate counters.

#### Heungbu yard sign
- **Restoration:** warmth, openness, recovery, communal protection
- **Tribute:** endurance, caution, surviving under imposed order

#### Nolbu gate sign
- **Restoration:** lingering resentment, reduced moral authority, watchful tension
- **Tribute:** official order, tribute pressure, disciplined tone

#### Tribute basket sign
- **Restoration:** basket remains present as a reminder of what was resisted
- **Tribute:** basket becomes normalized, framed as routine obligation

#### Optional extra target
- Story Stone or Village Well gets one line of branch-aware aftermath flavor

### 3) Ambient Landmark Accent
Add one tiny, robust landmark accent per branch using primitives or simple runtime props only.

#### Restoration accent
One of:
- small lantern glow near Heungbu yard
- seed baskets or stacked produce near the patch
- soft green banner/cloth marker

#### Tribute accent
One of:
- stricter road marker near Nolbu gate
- tally board / ledger stand near tribute basket
- darker banner/rope marker indicating regulated passage

Hard rule: this must be small enough to author in code and safe if omitted.

---

## Interaction Design

### Heungbu post-ending ambient interaction
Current complete-state Heungbu dialogue already branches once. Expand it into a small rotating line set.

#### Restoration tone
- gratitude
- shared stewardship
- invitation to keep the patch alive

#### Tribute tone
- resilience
- quiet disappointment without despair
- planting as an act of endurance

### Nolbu post-ending ambient interaction
Current complete-state Nolbu dialogue also branches once. Expand into a small rotating line set.

#### Restoration tone
- annoyance that the valley chose warmth over order
- warnings that kindness still has to defend itself

#### Tribute tone
- satisfaction that tribute became normalized
- implication that productivity matters more than joy

### Tribute basket interaction after ending
This is the best candidate for a tiny systemic follow-through without opening a new design track.

#### Restoration branch
- no mandatory delivery loop
- basket mostly serves as a story prop / reminder
- if interacted with, it explains that the village refused to let tribute rule the harvest

#### Tribute branch
- allow a **soft repeatable tribute hand-in** only if it can be implemented safely in one pass
- reward should be modest and non-disruptive
- no new quest states required; this is ambient free-play framing, not a new storyline

If this repeatable hand-in is too large for the next Dev pass, cut it from MVP and keep branch-aware text only.

---

## Server Design

### New concept: ambient ending mode
Introduce a small helper that derives a branch mood from either:
- a specific player's `endingChoice` for player-facing prompts/HUD, and/or
- village aggregate counts for shared billboard defaults

Recommended helpers:
- `getAmbientEndingModeForPlayer(player)`
- `applyPostEndingPatchMood(profile)`
- `refreshVillageSignsForEndingState()`
- `getAmbientDialogueLineSet(npcName, endingChoice)`

### MVP implementation responsibilities
1. Detect when a player with resolved ending is in post-ending free play.
2. Apply branch-specific patch text/mood instead of the generic idle text.
3. Expand billboard refresh rules to include stronger branch copy.
4. Route Heungbu/Nolbu/tribute basket interactions through branch-aware ambient line sets.
5. Spawn or reveal one minimal branch accent prop set at runtime.

### State model
No major schema change required.

Reuse:
- `profile.endingChoice`
- `profile.endingResolved`
- `villageState.restorationEndings`
- `villageState.tributeEndings`

Optional lightweight additions:
- `profile.postEndingAmbientSeed` for line rotation stability
- `runtimeFolder/EndingAccentProps`

### Authority rules
- Quest stage remains authoritative for progression.
- Ambient ending layer only affects post-ending presentation and optional free-play interactions.
- No ambient branch feature should block farming, harvesting, or speaking with main prompts.

---

## Client / HUD / Presentation

### HUD
Keep the existing ending hint, but sharpen post-ending persistence.

Recommended additions:
- small passive badge or label already supported by `EndingName`
- no modal UI needed
- no extra cutscene required

### Presentation rule
Post-ending ambience should be mostly environmental, not banner-spam. Avoid firing large effect banners on every revisit. Reserve banners for rare first-time transitions only.

---

## Content Pack Recommendations
A good MVP content pack is:
- 2-3 restoration Heungbu lines
- 2-3 tribute Heungbu lines
- 2-3 restoration Nolbu lines
- 2-3 tribute Nolbu lines
- 2 tribute basket aftermath variants
- 4-6 branch-aware billboard bodies
- 1 small runtime accent per branch

That is enough to make the aftermath feel authored without creating doc or content thrash.

---

## Failure / Edge Cases
- **No player has finished an ending yet:** village stays in pre-ending/default sign mode.
- **Mixed aggregate village counts:** shared billboard defaults may prefer the dominant branch count; player-facing dialogue still uses the interacting player's `endingChoice`.
- **Player with no resolved ending enters late:** they should not see branch-specific quest assumptions; fallback copy remains safe.
- **Accent prop fails to spawn:** signs + patch + dialogue must still carry the feature.
- **Patch is in another active mood (growing, blessed, brambles):** story-critical patch states override ambient idle mood until they finish.
- **Repeatable tribute hand-in is abused:** either keep the reward tiny and capped, or cut the mechanic from MVP.

---

## Validation Plan
1. Finish the story on the restoration branch.
2. Confirm `COMPLETE` free play still works.
3. Revisit Heungbu yard, patch, Nolbu gate, and tribute basket.
4. Verify all four read as restoration-flavored, not generic.
5. Confirm Heungbu and Nolbu use restoration-aware ambient lines.
6. Repeat on the tribute branch.
7. Verify tribute aftermath feels colder and more regulated in signs and prompt responses.
8. Confirm no branch ambient feature reopens the main questline or duplicates ending rewards.
9. If optional tribute hand-in is implemented, confirm it is modest, repeatable, and does not break the core economy.

---

## MVP Cut Line
- branch-specific patch idle mood/text after `COMPLETE`
- stronger branch-specific billboard copy
- expanded Heungbu/Nolbu post-ending dialogue sets
- branch-aware tribute basket aftermath interaction
- one minimal runtime accent prop set per ending

## Post-MVP Extensions
- repeatable restoration community-delivery interaction
- repeatable tribute toll interaction with caps/cooldown
- branch-aware ambient NPC walkers or patrol bark text
- per-ending weather/light tint moments
- persistent saved ending state across sessions

## Recommended PM / Dev Hand-off
### PM should break this into
1. patch mood aftermath
2. signage aftermath
3. ambient dialogue pack
4. optional tribute-basket free-play interaction
5. branch accent props

### Dev should implement in this order
1. patch + sign hooks
2. dialogue pack
3. accent props
4. optional repeatable interaction only if the first three are stable

This keeps the next build focused on the existing implementation opportunity instead of inventing a larger system too early.
