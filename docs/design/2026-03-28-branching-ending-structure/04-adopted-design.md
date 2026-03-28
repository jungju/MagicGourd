# Adopted Design

## Chosen Candidate
Candidate 1 - Final Audience Choice

## Why Chosen
It is the highest-value next story/system feature because it turns the current soft ending into a clear moral resolution without demanding a large new content set. It also gives PM and Dev a crisp next implementation target that fits the existing prompt/dialogue/effect architecture.

## Why Others Were Rejected
- **Candidate 2 - Hidden Moral Score Ending:** elegant, but the current slice does not yet have enough visible moral variation to make an automatic result feel fair.
- **Candidate 3 - Ceremony Plus Timed Recovery:** emotionally strong, but better as a presentation layer on top of a solid ending structure, not instead of one.
- **Candidate 4 - Epilogue Reputation Loop:** useful long-term foundation, but too large for the next implementation window.

## Design Summary
After the player clears the brambles, the story should enter a **short final audience sequence** where Heungbu and Nolbu represent two paths for the valley:
1. **Restoration Ending** - protect Heungbu's patch and share future harvest hope.
2. **Tribute Ending** - prioritize fear, tribute, and Nolbu's demands for stability.

This is not a branching campaign yet. It is a **branching finale shell** that gives the current slice a decisive ending and establishes save/runtime hooks for future story divergence.

---

## Player Flow
1. Player clears the brambles from Heungbu's patch.
2. A restoration beat fires, but the quest does not jump straight to generic free play.
3. Heungbu asks the player to come to the yard for a final decision about what kind of harvest the valley should protect.
4. Nolbu appears as a competing voice near his gate or through a linked audience prompt.
5. Player enters a final choice interaction.
6. Player chooses one of two responses:
   - stand with Heungbu and restore the patch for shared prosperity
   - appease Nolbu and dedicate future harvests as tribute for order
7. The game plays the matching ending banner/dialogue sequence.
8. Player receives a named ending result and unlocks post-ending free play with that village tone reflected in signage/HUD text.

---

## Quest / State Flow
### Existing states reused
- `NOLBU_RETALIATION`
- `CLEAR_BRAMBLES`
- `COMPLETE`

### New quest states
- `FINAL_AUDIENCE` - player is told to return to Heungbu for the valley's decision
- `CHOOSE_ENDING` - the ending choice interaction is active
- `ENDING_RESTORATION` - resolved Heungbu-aligned ending
- `ENDING_TRIBUTE` - resolved Nolbu-aligned ending

### Transition rules
- `CLEAR_BRAMBLES -> FINAL_AUDIENCE`: after bramble clearing presentation completes
- `FINAL_AUDIENCE -> CHOOSE_ENDING`: player speaks with Heungbu and is directed into the decision beat
- `CHOOSE_ENDING -> ENDING_RESTORATION`: player selects Heungbu/restoration response
- `CHOOSE_ENDING -> ENDING_TRIBUTE`: player selects Nolbu/tribute response
- `ENDING_* -> COMPLETE`: complete becomes a post-ending free-play umbrella, not the first ending itself

### Authority rule
Quest stage remains authoritative. Ending flavor/result should be stored separately from the numeric quest stage so `COMPLETE` can still represent unlocked free play while preserving which ending was earned.

---

## World Objects
### Reused
- Heungbu talk prompt
- Nolbu talk prompt
- Heungbu patch and yard
- village billboards
- StoryEffectEvent banner/flash channel

### New or adjusted objects
- one lightweight `FinalAudiencePrompt` near Heungbu's yard, or reuse Heungbu prompt with choice mode
- optional visual lane marker between Heungbu yard and Nolbu gate for staging clarity
- ending-tinted billboard text updates after resolution

### Hard constraint
No ending should require bespoke animated NPC rigs, camera rails, or Studio-only scene choreography. The sequence must still read through prompts, dialogue, banners, and billboard state.

---

## Server Design
### New player-state fields
Runtime/session profile fields:
- `endingChoice = none | restoration | tribute`
- `endingResolved = false | true`
- optional `kindnessScore` and `greedPressure` counters for future expansion, but not required for MVP gating

### Ending sequence responsibilities
- On bramble clear completion:
  - show restoration beat
  - move player to `FINAL_AUDIENCE`
  - update quest text to return to Heungbu
- On Heungbu interaction during `FINAL_AUDIENCE`:
  - explain that the valley now follows the example the player chooses
  - move to `CHOOSE_ENDING`
  - surface the two ending options
- On ending selection:
  - lock out repeat selection
  - set `endingChoice`
  - play corresponding presentation sequence
  - update billboards / HUD flavor
  - move stage to `COMPLETE`

### Choice delivery options
Preferred MVP option: one compact client choice panel triggered from the server with two labeled responses.

Fallback MVP option: reuse prompts with a two-step flow:
- interact with Heungbu to choose restoration
- interact with Nolbu to choose tribute
- stage copy must make the choice explicit before commitment

### Reward handling
- Restoration ending reward: bonus seeds + village warmth framing
- Tribute ending reward: immediate coins + darker village flavor text
- Both outcomes should keep free-play harvesting available after resolution

### Guard rails
- no duplicate ending reward claims
- ending cannot trigger before brambles are cleared
- if player disconnects mid-ending, they resume from `FINAL_AUDIENCE` or `CHOOSE_ENDING` unless the resolution already completed

---

## Client Design
### HUD
- quest tracker must support the final-audience and choose-ending objectives
- optional small ending badge after resolution: `Ending: Restored Valley` or `Ending: Tribute Road`

### Choice UI
For MVP, keep it minimal:
- title
- 1-2 sentence framing
- two large buttons
- clear consequence language

Suggested button copy:
- `Stand with Heungbu` -> protect the patch and share future harvests
- `Appease Nolbu` -> offer future harvest tribute to keep the peace

### Presentation
Use existing effect kinds with small extension:
- `restoration` for Heungbu-aligned ending
- `warning` or a darker `banner` tone for Nolbu-aligned ending
- optional new kind later: `ending`

### Dialogue tone
- Heungbu branch should feel hopeful, communal, and quietly resolute
- Nolbu branch should feel materially safer in the short term, but emotionally colder
- neither branch should feel like a joke ending; both should read as meaningful consequences

---

## Data Model
### Player attributes
- `QuestStage`
- `QuestTitle`
- `QuestObjective`
- `Seeds`
- `Gourds`
- `BlessedSeeds`
- `BlessedGourds`
- `Coins`
- new optional attribute: `EndingName`

### Runtime/session state
- `endingChoice`
- `endingResolved`
- optional future counters: `kindnessScore`, `greedPressure`

### Village/global counters
- `restorationEndings`
- `tributeEndings`

### Runtime folders
No required folder expansion for MVP beyond an optional final audience interaction part.

---

## Failure / Edge Cases
- **Player leaves before choosing:** resume at `FINAL_AUDIENCE` or `CHOOSE_ENDING`, no reward granted yet.
- **Player disconnects after choice but before presentation finishes:** server should persist resolved ending state in session profile before firing long presentation beats.
- **Choice UI fails to appear:** fallback interaction route through Heungbu/Nolbu prompts remains possible.
- **NPC prompt missing:** final audience prompt should be enough to complete the ending.
- **Rapid double input:** once a choice is committed, all other ending inputs are ignored.
- **Future save persistence added later:** ending result should be stored in a dedicated field, not inferred from current quest stage alone.

---

## Validation Plan
1. Progress through the main story until brambles are cleared.
2. Confirm the quest moves to `FINAL_AUDIENCE` instead of dropping directly into generic completion.
3. Speak with Heungbu and verify the ending decision is clearly framed.
4. Choose restoration and confirm:
   - restoration ending presentation plays
   - ending reward lands once
   - `EndingName` / signage / objective text reflect the hopeful result
5. Replay and choose tribute and confirm the alternate ending presentation and reward framing.
6. Attempt repeat interactions after resolution and confirm no duplicate rewards or branch swapping.
7. Confirm post-ending free play still works under `COMPLETE`.

---

## MVP Cut Line
- new final-audience quest stages
- one explicit two-choice ending interaction
- two ending result sequences
- ending result stored separately from quest stage
- post-ending signage/HUD flavor update

## Future Extensions
- blend explicit choice with hidden kindness/greed modifiers
- add a third reconciliation ending once more systems exist
- persist ending across sessions
- unlock branch-specific repeatable tasks or ambient NPC barks
- use the ending result as the opening condition for the next chapter