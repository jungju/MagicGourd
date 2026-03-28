# Adopted Design

## Chosen Candidate
Candidate 1 — Branch-Specific Village Errands

## Why Chosen
This is the best next implementation opportunity because it directly addresses the exact remaining gap after the current ambient aftermath pass: the player can now **see** the ending, but cannot yet **play** the ending for very long.

It also fits the present code and PM trajectory unusually well:
- `COMPLETE` free play already exists
- `endingChoice` and branch-aware prompts already exist
- delivery/turn-in style interactions are already core to the game
- rewards can stay tiny, so economy risk remains low

This means the next smart step is not a broader dynamic world simulation. It is a **small branch-specific replay loop** that keeps each ending mechanically distinct.

## Why Others Were Rejected
- **Candidate 2 — Rotating Support-Point Tasks:** attractive, but a bit more staging-heavy and easier to misread as "more chores" unless the branch loop already exists.
- **Candidate 3 — Tribute Route Pressure Loop:** worth folding into the tribute-side errand, but too one-sided as the main feature.
- **Candidate 4 — Ending Echo Events:** fun later, but too much hidden state/cadence logic for the next pass.

## Design Summary
Add a tiny **Ending Errand Layer** that unlocks once the player reaches `COMPLETE`.

Each ending gets one primary repeatable interaction family:
- **Restoration:** deliver small harvest help to a communal receiver near Heungbu's side of the village.
- **Tribute:** fulfill a controlled toll/inspection hand-in near Nolbu's route.

Both loops should:
- use the player's resolved `endingChoice`
- accept already-familiar resources (mainly normal gourds; optional herbs/seeds later)
- provide modest rewards and branch-specific flavor lines
- never replace ordinary farming, only add meaning to it

The player should feel:
- in **Restoration**, that harvests continue to support people
- in **Tribute**, that harvests continue to satisfy imposed order

---

## Player Experience Goal
### Restoration ending should feel
- communal
- warm but still active
- like the player is helping the valley stay shared

### Tribute ending should feel
- efficient
- slightly tense
- like the player is keeping the peace by feeding an obligation

### Shared goal
After finishing the story, the player should have a short, legible reason to run **one more harvest cycle** and feel a different meaning depending on the ending.

---

## Scope Boundary
This design is **not**:
- a new chapter
- a reputation metagame
- a broad village request board
- a persistent, multi-session economy layer

This design **is**:
- one lightweight repeatable errand loop per ending
- small branch-specific dialogue/sign/prompt support
- low-risk reward framing for post-ending free play

---

## Player Flow
1. Player finishes the story and resolves an ending.
2. In `COMPLETE`, the existing ambient ending aftermath appears.
3. The player revisits the village and finds a branch-appropriate repeatable prompt:
   - **Restoration:** a community basket / shared pantry / relief mat near Heungbu yard or the well
   - **Tribute:** a tally stand / toll basket near Nolbu gate or the tribute road
4. The prompt explains what is needed.
5. The player brings a normal gourd (MVP), interacts, and receives:
   - a small reward
   - branch-aware feedback text
   - a refreshed prompt body for the next hand-in
6. The player can continue farming normally and optionally repeat the errand later.

---

## World Objects
### Restoration receiver
Recommended MVP object:
- `CommunityBasket` or `SharedPantryMat`
- position near Heungbu yard edge or village well so it reads as communal, not private inventory

### Tribute receiver
Recommended MVP object:
- `TollLedgerStand` or `TributeTallyBasket`
- position near Nolbu gate / current tribute-side route so it reads as controlled collection

### Presentation rule
These should be simple runtime-authored props, ideally primitive-based, with billboard/prompt text. No bespoke asset dependency required.

---

## Interaction Design

### Restoration errand: Shared Harvest Drop
#### Fiction
The village now leaves part of each healthy harvest where neighbors can draw on it.

#### MVP input
- requires `endingChoice == restoration`
- requires `questStage >= COMPLETE`
- requires at least `1` normal gourd

#### MVP output
- consumes `1` normal gourd
- grants a modest reward, recommended:
  - `+2` coins **or**
  - `+1` coin plus a small flavor-side village counter
- rotates through 2-4 gratitude/support lines
- optionally increments a lightweight runtime `sharedHarvestDrops` counter

#### Tone
This should feel generous, not transactional. Even if coins are granted, copy should frame it as village reciprocity or communal thanks, not a market sale.

### Tribute errand: Road Due Hand-In
#### Fiction
The road remains orderly only because harvests are still being counted and surrendered.

#### MVP input
- requires `endingChoice == tribute`
- requires `questStage >= COMPLETE`
- requires at least `1` normal gourd

#### MVP output
- consumes `1` normal gourd
- grants a modest reward, recommended:
  - `+3` coins, or
  - `+2` coins with sharper flavor text
- rotates through 2-4 toll/inspection lines
- optionally increments a lightweight runtime `tributeDuePaid` counter

#### Tone
This should feel materially efficient but emotionally colder than restoration. The hand-in should read as compliance, not generosity.

---

## Signage / Ambient Support
To help the loop read clearly, add tiny branch-aware support copy.

### Restoration support text examples
- `Shared Basket: Leave a fresh gourd so the valley keeps eating together.`
- `Heungbu says the patch should feed more than one yard.`

### Tribute support text examples
- `Tally Stand: One more gourd keeps Nolbu's road quiet for another day.`
- `The basket is never full for long. The count always returns.`

These can be billboard bodies or prompt action/object text only. Do not create a large new UI.

---

## Server Design
### New helper concept
Add a narrow post-ending errand helper layer, for example:
- `canUseEndingErrand(player, errandKind)`
- `completeEndingErrand(player, errandKind)`
- `getEndingErrandPromptText(player, errandKind)`

### Data model
Reuse existing profile fields wherever possible.

Optional lightweight additions:
- `profile.sharedHarvestDrops = 0`
- `profile.tributeDuePaid = 0`
- `profile.endingErrandCooldownAt = 0` only if anti-spam is needed

Hard rule: do not introduce a complicated quest-state subtree under `COMPLETE`.

### Reward rules
- rewards must remain smaller than major quest beats
- normal farming/sales should remain viable; the errand is meaning, not dominant income
- if anti-spam is required, prefer a tiny cooldown or soft cap over a big lockout system

### Recommended MVP sequence
1. Add two runtime props/prompts.
2. Gate each by the player's `endingChoice`.
3. On interaction, require `1` normal gourd.
4. Consume item, grant modest reward, show branch-aware dialogue/effect.
5. Refresh support sign/prompt text.

---

## Client / HUD / Presentation
- No new major panel required.
- Existing dialogue and prompt flows are sufficient.
- Optional tiny HUD hint under `COMPLETE` can mention:
  - restoration: `You can leave shared harvests for the village.`
  - tribute: `You can keep the road settled with tribute hand-ins.`

If any screen-space UI is added, keep it to a one-line hint only.

---

## Failure / Edge Cases
- **Wrong ending branch:** the opposite errand should either hide or return safe branch-mismatch text.
- **Player has no gourd:** prompt should clearly say a fresh gourd is needed.
- **Player spams hand-ins:** add a tiny cooldown or modest reward tuning, not a complex punishment system.
- **Prompt prop fails:** the rest of the ambient aftermath must still work.
- **Future persistent saves:** counters should remain optional flavor data, not hard progression requirements.

---

## Validation Plan
1. Finish the game on restoration.
2. Confirm ambient aftermath still appears.
3. Bring a normal gourd to the restoration receiver.
4. Verify the gourd is consumed, the reward is modest, and the feedback line matches restoration tone.
5. Confirm the tribute receiver is hidden or safely inactive for this player.
6. Repeat on tribute ending.
7. Verify tribute feedback reads colder/more regulatory and rewards stay modest.
8. Confirm neither branch reopens the questline or duplicates ending rewards.
9. Confirm ordinary farming still works normally after repeated hand-ins.

---

## MVP Cut Line
- one restoration receiver
- one tribute receiver
- 1-gourd hand-in rule
- modest rewards
- 2-4 feedback lines per branch
- minimal prompt/sign support text

## Post-MVP Extensions
- restoration variant: occasional seed return instead of coins
- tribute variant: inspection line variants tied to village counters
- rotate 2-3 support-point locations as a follow-up feature
- tie ambient props/signs to cumulative errand counts

## Recommended PM / Dev Hand-off
### PM should break this into
1. restoration errand interaction
2. tribute errand interaction
3. reward tuning / anti-spam guardrail
4. tiny support copy updates

### Dev should implement in this order
1. branch-gated prompt props
2. gourd consumption + reward logic
3. branch dialogue text
4. optional cooldown/counter tuning only if needed

This keeps the next pass focused on actual replay value instead of speculative world simulation.