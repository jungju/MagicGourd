# Adopted Design

## Chosen Candidate
Candidate D — Combined Spatial Readability Budget

## Design Goal
Author a compact set of spatial rules so the existing arcade loop keeps one clear read at a time:
- where to go
- what to interact with
- what just paid off
- when danger is coming

This is a **tuning contract**, not a new feature pass.

---

## Why this pass is needed now
The current loop already has:
- canonical action language (`Heal`, `Plant`, `Break`, `Buy`)
- anchored world feedback for rewards and danger
- a three-zone map with a clear intended route
- a validation contract describing what should feel readable

What is still missing is the smaller rule set that says **how much separation is enough**.

Without that, Studio fixes can drift into guesswork:
- prompts get shortened but still activate too broadly
- signs get bigger when copy trimming would have solved the problem
- center-lane friction gets solved with broad placement denial instead of breathing room
- danger fairness gets judged emotionally instead of from first readable contact distance

---

## Core Principle
At any normal moment, the player should read one dominant thing per layer:
- **movement layer:** the next lane
- **interaction layer:** the intended prompt
- **orientation layer:** the supporting sign
- **feedback layer:** the active reward/danger response

When two items compete, preserve this priority:
1. active prompt
2. immediate reward/danger feedback
3. route lane shape
4. support signage

If signage is winning against interaction, the space is over-authored.

---

## Budget Set

### 1. Prompt Competition Budget
Use prompt tuning to enforce a single intended interaction at ordinary stopping distance.

#### Shared rule
From a natural approach position, one prompt may be visible, but only one should feel central and actionable.

#### Distance targets
- swallow prompt target range: **10-12 studs**
- pumpkin prompt target range: **10-12 studs**
- plaza pad prompt target range: **8-10 studs**

#### Why plaza is shorter
Plaza pads sit close together and compete with planting-route traffic. Their prompts should read as deliberate commitment, not ambient noise.

#### Fail conditions
- two plaza `Buy` prompts activate with equal salience from one ordinary standing point
- a freshly planted pumpkin commonly shares camera-center with a plaza `Buy` prompt at normal route distance
- several swallow prompts light up in one camera slice before the player has chosen a swallow

#### Fix order
1. reduce prompt distance
2. adjust object spacing slightly
3. adjust approach angle with small placement nudges
4. do **not** add extra teaching UI

---

### 2. Billboard Visual-Band Budget
Signs should stay in a support band above interaction, not inside the same visual decision band.

#### Copy budget
- title: **1-3 words**
- body: **max ~52 characters**, ideally one sentence
- no stacked accounting text on world signs if HUD already carries it

#### Offset budget
- default sign offset: roughly **4.5-5.5 studs** above the anchor
- avoid raising signs so high that they become skyline clutter
- avoid lowering signs into prompt/popup headspace

#### Width/height rule
Current sign scale is acceptable if copy remains short.
If text wraps to feel dense, shorten the copy first before enlarging the billboard.

#### Fail conditions
- a sign shares the same focal band as the active prompt during approach
- a popup repeatedly rises through billboard text, making either hard to read
- the three plaza pad signs read as a single text wall rather than three approachable choices

---

### 3. Center-Lane Breathing-Room Budget
The center lane must remain a readable shared strip for:
- returning from village
- planting
- breaking nearby pumpkins
- deciding whether to commit to plaza spending

#### Spatial rule
Preserve a **clear read corridor** between the planting lane and the plaza pads.
The player should be able to plant near the center route without instantly feeling magnetized into `Buy` prompts.

#### Tuning target
- keep ordinary planting positions outside reliable multi-pad prompt range
- preserve a visible walk gap between adjacent pad footprints rather than letting the plaza become one merged platform read
- allow pumpkins to feel lane-adjacent, not plaza-owned

#### Hard rule
Do not solve this with broad no-plant exclusion unless a genuine exploit exists.
Readability should be protected by spacing and prompt budgets first.

#### Fail conditions
- a normal plant placement regularly causes immediate `Buy` prompt competition
- the first owned pumpkin reads like part of the plaza instead of part of the route
- the player has to step backward just to separate plant/break meaning from buy meaning

---

### 4. Danger First-Contact Sightline Budget
The Nolbu route must announce risk before the first slow lands.

#### Readability target
A player entering from the plaza should get **at least one readable beat of warning** before first goblin contact.
In practice, that means the player should be able to read one of these before contact:
- danger sign and lane tone
- goblin silhouette/motion
- clear hostile route shape

#### Spatial rule
The first meaningful goblin read should happen at **roughly 10+ studs before contact** in a normal approach, not at the instant of a blind-side touch.

#### Allowed fixes
- slight goblin spawn spread within the existing zone
- slight rock position changes if they over-occlude silhouettes
- slight sign/body trimming if warning text reads too slowly

#### Not allowed
- new danger UI overlays
- extra tutorial callouts
- expanding the whole danger zone

---

### 5. Popup Headroom Budget
World popups need protected airspace above action anchors.

#### Rule
The space above swallows, pumpkins, plaza pads, and the slowed player should stay visually clean enough for 1-2 word popup reads.

#### Design implication
If a popup is unreadable, first suspect:
1. nearby sign offset/copy length
2. repeated prompt overlap
3. too many equally loud world objects in one slice

Only after that should popup size/duration be retuned.

#### Fail conditions
- payout popup rises through dense sign text often enough to weaken the reward read
- plaza purchase popup appears but gets visually swallowed by billboard clutter
- slow popup appears in a crowded frame where the player cannot instantly parse the state change

---

## Zone-by-Zone Application

### Spawn / first read
- spawn sign teaches the loop
- plaza pads remain visible but secondary
- left route toward Heungbu Village should win the first-lane read

**Budget emphasis:** billboard hierarchy over plaza noise

### Heungbu Village
- one swallow prompt should dominate at a time
- local sign supports purpose but does not compete with the chosen swallow

**Budget emphasis:** prompt competition

### Center lane
- plant/break actions should feel like route continuation, not plaza bleed

**Budget emphasis:** breathing-room budget

### Central Plaza
- one approached pad should read clearly
- the plaza should not collapse into a three-prompt, three-billboard wall

**Budget emphasis:** shorter prompt reach + billboard separation

### Nolbu Area
- route should read as knowingly risky before contact
- retreat path should stay obvious after slow

**Budget emphasis:** first-contact sightline budget

---

## Tuning Order
When Studio exposes a readability problem, fix in this order:
1. shorten copy
2. reduce prompt distance
3. adjust billboard offset/height
4. apply small object spacing changes
5. adjust goblin spawn spread / rock occlusion
6. only then trim popup timing/size if clutter remains

Reason: cheap authoring fixes should beat geometry churn.

---

## Service / World Follow-through

### ArcadeWorld
- may shorten plaza prompt activation relative to village/pumpkin prompts
- may slightly separate pad approach spaces if Studio proves ambiguity
- may trim billboard copy before any size increase

### SwallowService / PumpkinService
- no new mechanics
- retain current anchor logic; this pass mainly protects the space those anchors occupy

### UpgradeService
- preserve pad-anchored reward popup
- ensure plaza approach distance supports one clear purchase choice at a time

### GoblinService
- maintain current pressure model
- tune spawn spread only if first-contact readability fails in Studio

---

## Failure / Edge Cases
- **Fast player with upgrades:** shorter plaza prompt reach still holds because purchase should remain a deliberate approach.
- **Mobile/smaller screens:** shorter copy and stronger layer hierarchy matter more than larger signs.
- **Busy multiplayer slice:** the budget aims for dominant local reads, not total silence. Minor background prompts are acceptable if one choice stays clearly primary.
- **Repeated loop speed-up:** popup cadence is acceptable as long as headroom remains protected.

---

## Validation Plan
1. Spawn fresh and confirm the left route still wins over plaza noise.
2. Approach swallows from several angles and confirm one prompt dominates.
3. Plant in ordinary center-lane positions and confirm `Buy` prompts do not immediately compete.
4. Approach each plaza pad and confirm one pad reads as the current commitment.
5. Break pumpkins near the center lane and confirm payout popups stay visually clean.
6. Push into Nolbu Area and confirm the first goblin read happens before contact, not on collision.
7. Retreat while slowed and confirm the safe return lane remains obvious.

---

## Recommended Hand-off
### PM
Use this as the precision layer underneath MG-PM-408. If Studio validation finds confusion, tune against these budgets instead of inventing ad hoc fixes.

### Dev
Prefer the smallest possible fixes:
- shorten copy
- trim prompt reach
- keep signs in a support band
- preserve center-lane breathing room
- only touch danger spacing when first-contact fairness visibly fails

This keeps the loop coherent without expanding the game.