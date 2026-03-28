# Adopted Design

## Chosen Candidate
Candidate A — Blessed Harvest Ceremony

## Why Chosen
It is the highest-value next implementation target because it improves the existing climax without requiring new progression systems. It directly answers the outstanding PM gap (`MG-PM-204`) and is immediately implementable with the present server/client scaffolding.

## Why Others Were Rejected
- **Candidate B — Retaliation Escalation:** worth doing, but only after the player first gets a satisfying magical reward moment.
- **Candidate C — Patch Restoration Contrast:** useful as a sub-beat, but too narrow to carry the next design cycle alone.

## Design Summary
Turn the blessed-seed climax into a **three-beat ceremonial sequence**:
1. **Blessed Harvest Recognition** — harvesting the true magic gourd feels rare and sacred.
2. **Heungbu Reward Ceremony** — delivery to Heungbu triggers a richer staged banner/dialogue/effect chain.
3. **Nolbu Shock -> Bramble Consequence** — jealousy interrupts the celebration and cleanly hands off to recovery gameplay.

This is not a full cutscene system. It is a **scripted presentation sequence** layered on top of existing quest interactions.

---

## Player Flow
1. Player harvests the true magic gourd.
2. A special harvest presentation appears immediately: sacred title, brighter flash, and "bring this to Heungbu" framing.
3. Player reaches Heungbu and interacts.
4. Reward ceremony plays in 2-3 short authored beats:
   - Heungbu recognizes the true gourd.
   - village blessing / prosperity banner appears.
   - coins + seed bonus are awarded and confirmed.
5. Player is redirected toward Nolbu.
6. Nolbu interaction lands as an interruption beat, not just another line delivery.
7. Brambles appear and the patch reads as recently sabotaged.
8. Player clears brambles.
9. Restoration confirmation closes the sequence and returns to free play.

---

## State / Sequence Design

### Existing gameplay states reused
- `HARVEST_BLESSED`
- `MAGIC_PAYOFF`
- `NOLBU_RETALIATION`
- `CLEAR_BRAMBLES`
- `COMPLETE`

### New presentation sub-states (ephemeral, non-persistent)
These do **not** become save/profile progression states; they are transient sequence labels inside server/client presentation helpers.
- `BlessedHarvestReveal`
- `HeungbuCeremonyIntro`
- `HeungbuCeremonyReward`
- `NolbuInterruption`
- `PatchRestored`

### Sequence rules
- Presentation sub-states only gate local sequencing/timing, not quest advancement authority.
- Quest stage still remains the source of truth.
- If a player leaves mid-sequence, current session behavior is acceptable: they resume from the authoritative quest stage.

---

## World Objects

### Reused
- Heungbu talk prompt
- Nolbu talk prompt
- existing patch / bramble setup
- existing HUD, dialogue box, and story banner

### Optional additions for MVP+
- temporary "golden glow" part or light at the patch after blessed harvest
- short-lived reward sparkle emitter near Heungbu
- patch color/material swap during bramble sabotage and restoration

### Hard constraint
All visual objects must degrade gracefully if missing. The sequence must remain readable through dialogue + HUD banners alone.

---

## Server Logic

### New helper concept
Add a small server-authored presentation sequencer that can fire 1-3 timed `StoryEffectEvent` payloads around existing quest transitions.

### Responsibilities
- On blessed-gourd harvest:
  - fire `BlessedHarvestReveal`
  - send one special banner payload and one follow-up dialogue payload
- On Heungbu payoff hand-in:
  - fire `HeungbuCeremonyIntro`
  - after a short delay, grant rewards
  - fire `HeungbuCeremonyReward`
  - then advance to `NOLBU_RETALIATION`
- On Nolbu interaction:
  - fire `NolbuInterruption`
  - emphasize that celebration is being spoiled, then spawn/enable brambles
- On bramble clear completion:
  - fire `PatchRestored`
  - return player to `COMPLETE`

### Payload style guide
Prefer a compact payload contract rather than many bespoke remotes.

Recommended payload fields:
- `kind` = `celebration | warning | blessing | restoration`
- `title`
- `body`
- `color`
- `duration` (optional)
- `pulseCount` (optional, client may ignore)
- `soundCue` (optional future-facing string only; no hard dependency)

### Reward timing
Do not award coins/seeds before the ceremony begins. Rewards should land during the second beat so the player associates the numbers with the spectacle.

---

## Client UI / HUD / Effects

### Core principle
Make the sequence feel ceremonial using existing UI primitives, not camera-heavy cutscenes.

### Required client changes
1. **Support per-payload duration**
   - banner lifetime should be overrideable
2. **Different visual treatment by `kind`**
   - `celebration`: warm gold, larger flash
   - `blessing`: softer cream/gold, slower fade
   - `warning`: sharper red/orange interruption
   - `restoration`: green-gold recovery tone
3. **Allow short chained beats**
   - a second banner arriving shortly after the first should replace/continue smoothly rather than feel like a glitch
4. **Stats readability during reward beat**
   - ensure the stat line update is visible while the banner is still on screen

### Recommended authored beats

#### Beat 1: Blessed harvest
- Title: `A True Magic Gourd`
- Body: `The vine answers Heungbu's kindness. Bring the sacred harvest home.`
- Kind: `blessing`

#### Beat 2: Heungbu ceremony intro
- Title: `Heungbu's Blessing`
- Body: `The village gathers around the miracle harvest.`
- Kind: `celebration`

#### Beat 3: Reward confirmation
- Title: `Prosperity Spreads`
- Body: `You receive coins and blessed seed stock for future hope.`
- Kind: `celebration`

#### Beat 4: Nolbu interruption
- Title: `Jealous Eyes Turn Here`
- Body: `Nolbu sees the miracle and vows to ruin the patch.`
- Kind: `warning`

#### Beat 5: Restoration
- Title: `Hope Returns`
- Body: `The patch breathes again. Kindness still grows here.`
- Kind: `restoration`

---

## Data Model
No persistent schema expansion required for MVP.

### Existing data reused
- `BlessedSeeds`
- `BlessedGourds`
- `Coins`
- `QuestStage`
- existing retaliation / bramble flags

### Optional runtime-only values
- active ceremony token/id for sequence cancellation safety
- last effect timestamp to avoid overlapping spam

These can remain transient server/client locals and do not need to be stored on the player profile.

---

## Failure / Edge Cases
- **Player double-triggers interaction:** server must ignore re-entry while the same ceremony hand-in is resolving.
- **Banner overlap:** newest beat replaces current beat cleanly; no stacking multiple frames.
- **Missing VFX parts/assets:** fallback to banner + flash only.
- **Player walks away during ceremony:** quest reward still resolves server-side once interaction is accepted.
- **Low-end readability:** each beat must still function without particles or custom sounds.
- **Repeat play after completion:** special ceremony sequence should only run for the first true magic payoff, not every generic farming loop.

---

## Validation Plan
1. Progress normally to blessed harvest.
2. Confirm harvest produces a distinct sacred reveal beat.
3. Deliver to Heungbu and verify the ceremony plays in short ordered beats.
4. Confirm reward counts update during/just after the reward confirmation beat.
5. Talk to Nolbu and verify interruption tone clearly breaks the celebration.
6. Clear brambles and confirm restoration message lands before free play resumes.
7. Retry interactions rapidly to confirm no duplicate reward ceremony triggers.

---

## MVP Cut Line
- timed multi-beat banner/effect sequencing
- distinct effect kinds for blessing / celebration / warning / restoration
- improved reward timing around the Heungbu payoff
- clean handoff into retaliation and restoration beats

## Future Extensions
- camera push or letterbox for rare story beats
- localized sound cues per effect kind
- burst reward prop / coin shower visuals
- village NPC reaction barks during ceremony
