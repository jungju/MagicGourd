# Adopted Design

## Chosen Candidate
Candidate D — Unified Studio Validation Contract

## Design Goal
Define exactly how to verify and lightly tune the current arcade loop in Studio so the remaining blocked issues become:
- observable
- actionable
- low-scope
- finishable

This is a **completion contract**, not a new feature design.

---

## Why This Pass Is Needed Now
The current loop already has its intended structure:
1. Heal in Heungbu Village
2. Plant near the lane back toward center
3. Break pumpkins for money
4. Buy at Central Plaza
5. Risk the Nolbu route while managing goblin slow

What remains uncertain is not rules comprehension on paper. It is the live read of the shared space:
- Do prompts appear at the right moment, or too early / too late?
- Do signs teach without becoming visual wallpaper?
- Does the danger route feel fair before the first slow lands?
- Do repeated reward popups stay readable under a fast loop?
- Does the world layout still support the canonical loop after all recent polish passes?

Until those questions have a concrete pass/fail definition, the project remains falsely "almost done."

---

## Core Principle
Use **small positional/timing/readability tuning** only.

Allowed tuning levers:
- prompt activation distance
- billboard size / text length / offset
- minor pad / sign / lantern / rock spacing adjustments
- popup text shortening
- feedback timing/intensity trimming
- goblin spawn/route spacing within the current zone

Not allowed in this pass:
- new mechanics
- new reward types
- new onboarding systems
- extra map branches
- extra enemy types
- new persistent state

---

## Validation Scenes

### Scene 1 — Fresh spawn first read
**Start state**
- player spawns at `SpawnPoint = (0, 2, 18)`
- no resources
- no slow

**What should read immediately**
- spawn sign teaches `Heal -> Plant -> Break -> Buy`
- plaza pads are visible as future goals, not current confusion
- the clearest current direction is leftward toward Heungbu Village

**Pass conditions**
- spawn billboard is readable without stopping directly under it
- upgrade pad billboards do not visually overpower the immediate loop instruction
- the left path toward village reads as the natural first movement lane

**Fail examples**
- player stalls because plaza pads look interactable before the loop purpose is understood
- spawn billboard wraps badly or becomes unreadable while moving
- route split feels symmetrical/confusing instead of gently favoring the village first

**Allowed fixes**
- shorten sign copy before enlarging signs
- nudge billboard offsets/heights
- slightly increase visual distinction of the village lane using existing prop spacing, not new objects

---

### Scene 2 — Swallow approach and heal readability
**Start state**
- player enters Heungbu Village with zero seeds

**What should read immediately**
- swallows are the local purpose object
- prompts appear only when the player is close enough to commit
- billboard text remains background support, not prompt competition

**Pass conditions**
- only the nearest useful swallow prompt dominates at approach distance
- the player can tell that healing is the source of seeds without reading multiple surfaces at once
- signs do not block or visually merge with prompts

**Fail examples**
- several swallow prompts light up at once and create prompt spam
- sign text and prompt text overlap visually in the same camera slice
- heal prompts appear from so far away that they feel detached from the swallow model

**Tuning rules**
- prefer reducing prompt competition over increasing prompt reach
- if several swallows trigger together, solve via spacing or prompt distance first, not new UI
- keep `Heal` as the dominant verb; do not compensate with extra tutorial copy

---

### Scene 3 — Seed-to-pumpkin action lane
**Start state**
- player gains seeds and turns back toward the center lane

**What should read immediately**
- planting feels safe and available in the shared lane space
- the player is not forced into cramped placement reads near signs or upgrade pads
- the first owned pumpkin is readable as their next personal objective

**Pass conditions**
- planting near the center route does not regularly create prompt overlap with plaza pads
- owned pumpkin prompts read as the nearest priority object once planted
- the lane leaves enough visual breathing room between plaza signage and a newly planted pumpkin

**Fail examples**
- player plants within normal use distance and instantly competes with a `Buy` prompt
- pumpkin prompt readability suffers because billboard blocks occupy the same visual band
- planting feels as if it belongs to the plaza pads rather than the shared route

**Allowed fixes**
- small changes to pad spacing or prompt distance
- small change to recommended pumpkin spawn radius if needed
- billboard offset tuning

**Hard rule**
Do not solve this by forbidding planting in broad areas unless there is a true exploit. Favor readability-preserving layout tuning instead.

---

## Validation Scenes (continued)

### Scene 4 — Pumpkin crack / payout cadence
**Start state**
- player performs a normal 3-hit pumpkin cycle

**What should read immediately**
- each hit gives concise progress
- final payout feels stronger than progress hits
- popup and banner surfaces complement rather than flood

**Pass conditions**
- `2 Left` / `Final Hit` remain legible at normal camera distance
- payout remains the strongest positive moment in the cycle
- repeated loops do not produce unreadable popup stacks or full-sentence clutter

**Fail examples**
- progress popups linger long enough to visually stack over payout
- payout feels only marginally stronger than ordinary crack progress
- banner/detail text becomes more important than the world anchor during active breaking

**Allowed fixes**
- shorten popup lifetime slightly
- reduce progress intensity before increasing payout intensity
- trim duplicate wording before changing event order

---

### Scene 5 — Plaza spend readability
**Start state**
- player returns with enough money for at least one upgrade

**What should read immediately**
- each pad advertises a distinct benefit
- `Buy` prompts appear intentionally at approach range
- successful purchases feel anchored to the pad, not detached system text

**Pass conditions**
- one pad can be approached and read without the other two prompts becoming equally noisy
- purchase popup appears clearly at the purchased pad center
- cannot-afford cases remain banner-only and do not clutter the plaza space

**Fail examples**
- standing between pads causes multi-prompt ambiguity too often
- purchase popup appears but is visually lost inside billboard clutter
- plaza looks like three equal text blocks with no readable interaction lane between them

**Allowed fixes**
- small pad separation adjustment
- prompt distance trim
- billboard body shortening
- popup height/offset trim

---

### Scene 6 — Danger-edge anticipation and recovery
**Start state**
- player crosses from plaza toward Nolbu Area

**What should read immediately**
- the player is entering risk before the goblin touch happens
- the route back out remains legible after slow is applied
- danger props support the read without replacing it with noise

**Pass conditions**
- the danger sign and environment telegraph slowdown risk before contact
- first goblin contact feels like entering readable danger, not random collision from off-angle clutter
- after slow, the safe return path back toward plaza remains visually obvious

**Fail examples**
- goblin touch happens before the player has any readable sense of entering a danger lane
- rocks/props obscure goblin silhouettes too heavily at first contact
- slowed players lose route clarity and camera readability on retreat

**Allowed fixes**
- small goblin spawn spacing adjustments within existing zone bounds
- minor rock/prop position tweaks
- small sign/body copy trims if the warning reads too slowly

**Hard rule**
Do not solve danger readability by adding a new warning UI. The zone itself should read better.

---

## Global Readability Rules

### Prompt competition rule
At any normal interaction position, only one prompt should feel like the intended current choice.

Acceptable:
- two prompts exist in the world, but one is clearly nearer / centered / contextually dominant

Not acceptable:
- several prompts activate at equal salience in the same camera slice during ordinary routing

### Billboard rule
Signs are for orientation and reinforcement, not for frame-by-frame competition.

Use this order of correction:
1. shorten body copy
2. adjust billboard offset/size
3. move sign slightly
4. only then consider larger spatial changes

### Popup rule
World popups must remain 1-2 words or numeric phrases during active play.
If a popup starts needing a sentence to be understood, the headline/banner pairing is wrong.

### Lane rule
Each transition should preserve one obvious next movement lane:
- spawn -> village
- village -> center planting lane
- pumpkin -> plaza
- plaza -> danger route or back into the loop

If a player regularly stops to decode geometry instead of acting, the lane is under-authored.

---

## Tuning Order
When a live readability issue appears, tune in this order:
1. copy length
2. billboard offset/size
3. prompt distance
4. popup duration/intensity
5. small world spacing/position changes
6. goblin spawn spacing

Reason:
The cheapest authoring change that improves readability should win. Avoid using map surgery to fix a wording problem.

---

## Verification Deliverable
One Studio pass should produce a short result log per scene:
- pass / needs tune
- issue observed
- fix applied (if any)
- whether the fix changed docs/PM state

If no issue is observed, leave the system as-is. This pass is about precise finishing, not polishing for its own sake.

---

## Recommended PM / Dev Hand-off
### PM
Use this as the acceptance contract for MG-PM-408 and for any minor follow-up tuning on MG-PM-409 through MG-PM-411.

### Dev
Validate in this order:
1. fresh spawn first read
2. swallow prompt competition
3. planting lane vs plaza prompt overlap
4. pumpkin popup cadence
5. plaza pad interaction clarity
6. danger-edge anticipation + retreat readability

Only document or change what fails visibly in Studio.
