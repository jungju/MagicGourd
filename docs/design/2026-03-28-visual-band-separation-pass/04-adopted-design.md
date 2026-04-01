# Adopted Design

## Chosen Candidate
Candidate A — Whole-map visual band separation contract

## Why Chosen
MagicGourd already has most of the right refinement pieces:
- canonical verbs
- lane grammar
- tighter plaza prompt reach
- anchored world feedback
- cadence/intensity rules
- a Studio validation contract

What it still lacks is one compact answer to this question:

**When signs, prompts, and world popups all exist in the same place, which one owns which visual band?**

Without that rule, future tuning drifts into guesswork:
- signs get raised until they become skyline clutter
- prompt confusion gets solved with more copy instead of cleaner separation
- world popups read inconsistently because they inherit whatever headroom happens to be left

This pass finishes the existing structure rather than expanding it.

---

## Design Goal
Create a stable camera-layer contract so each active play slice keeps three readable bands:
1. **Decision band** — the prompt the player can act on now
2. **Feedback band** — the short world popup for what just happened
3. **Support band** — the billboard/sign that reinforces orientation or role

The player should not have to decode a text stack where all three bands fight for the same attention.

---

## Scope Boundary
This pass is **not**:
- a new HUD pass
- a new VFX pass
- a map expansion
- a tutorial rewrite
- a reward rebalance

This pass **is**:
- vertical/readability separation rules
- copy/offset discipline
- zone-by-zone layering expectations
- a validation contract for overlap cases

---

## Core Principle
At any normal gameplay moment, the player should be able to read these in order:
1. **what can I do right now?**
2. **what just happened?**
3. **where am I / what is this area for?**

That means the read priority is:
- **prompt** over world sign
- **fresh meaningful popup** over support sign
- **support sign** only when it does not occupy the active decision band

If signage is beating prompts or reward popups inside an action moment, the space is over-authored.

---

## The Three-Band Contract

### Band 1 — Decision Band
**Owner:** active `ProximityPrompt`

**Purpose**
Tell the player the next committed action.

**Examples**
- `Heal`
- `Break`
- `Buy`

**Rule**
No billboard should sit so low or feel so visually dense that it competes with the active prompt at ordinary approach distance.

**Authoring implication**
If prompt clarity fails, fix in this order:
1. shorten nearby sign copy
2. raise or nudge the sign slightly
3. reduce prompt competition through spacing/distance
4. do not add more explanatory text

---

### Band 2 — Feedback Band
**Owner:** short world popup tied to a local result

**Purpose**
Deliver emotional punctuation for the action that just resolved.

**Examples**
- `+1 Seed`
- `Planted`
- `2 Left`
- `+10 Money`
- `Footwork Up`
- `Slowed`

**Rule**
The feedback band must stay visually clear enough for 1-2 words or short numeric text to read instantly.
It should feel closer to the acted-on object/player than to the zone signage.

**Authoring implication**
If feedback readability fails, first suspect:
1. sign copy length
2. sign offset height
3. multi-prompt clutter
4. only then popup timing/height

Do not solve feedback collision by making the popup sentence longer.

---

### Band 3 — Support Band
**Owner:** billboard/sign

**Purpose**
Reinforce lane role, zone purpose, or upgrade identity without stealing the active moment.

**Examples**
- spawn loop instruction
- village/danger lane landmarks
- upgrade pad role boards
- zone billboards

**Rule**
Support signage belongs above and behind the action read. It should help before/after the action, not during the exact commit beat.

**Copy discipline**
- title: 1-3 words
- body: one short sentence
- do not repeat prompt verbs and accounting text if HUD/banner already carries them

**Offset discipline**
- keep signboards roughly in the existing ~4.5-5.5 stud support band
- avoid drifting downward into prompt/popup headspace
- avoid drifting upward into noisy skyline clutter

---

## Zone-by-Zone Layering Rules

### 1. Spawn Read
**Desired order**
- support band teaches `Heal -> Plant -> Break -> Buy`
- village lane wins the movement read
- plaza signs remain visible but secondary

**Fail state**
The player spawns and the plaza pads feel as loud as the loop instruction.

**Fix direction**
Trim plaza sign body or reduce perceived sign wall density before enlarging onboarding text.

---

### 2. Heungbu Village
**Desired order**
- nearest `Heal` prompt owns the decision band
- short heal reward popup owns the feedback band after action
- village support sign stays above the interaction slice

**Fail state**
Several swallows, prompts, and sign text share one camera band and healing feels noisy instead of kind/clear.

**Fix direction**
Prefer prompt-distance/spacing cleanup and sign-copy trimming before any new guidance.

---

### 3. Center Work Lane
**Desired order**
- planted pumpkin prompt owns the next action read
- crack/payout popups own the immediate payoff band
- nearby plaza signage stays visibly adjacent, not visually merged

**Fail state**
A center-lane pumpkin feels textually swallowed by plaza signs or nearby `Buy` prompts.

**Fix direction**
Protect the work lane by keeping plaza support in the support band and preserving popup headroom over the pumpkin.

---

### 4. Central Plaza
**Desired order**
- one approached `Buy` prompt owns the decision band
- purchase popup reads locally at the pad center
- pad billboards define roles without merging into one wall

**Fail state**
The plaza reads as three equal blocks of text where the purchase popup appears but has no clean airspace.

**Fix direction**
First shorten billboard body copy, then adjust offsets/spacing. Do not compensate by making purchase popups louder and longer unless the space is already clean.

---

### 5. Danger Edge
**Desired order**
- entering-risk read comes from lane tone + goblin sightline + warning sign support
- `Slowed` popup owns the feedback beat only when contact occurs
- warning signage should not occupy the same band as the slow event

**Fail state**
The first danger read happens as a cluttered collision between props, sign, goblin body, and popup.

**Fix direction**
Preserve support signage as a pre-contact cue, not a same-band contact overlay.

---

## Overlap Rules

### Prompt vs sign
If a prompt and sign compete in the same slice, the prompt is correct and the sign must yield.

### Popup vs sign
If a meaningful popup becomes harder to read because of sign density, the sign must yield.

### Prompt vs popup
During an action resolution window, the popup may briefly dominate emotionally, but the prompt should regain clarity once the action beat passes.

### Sign vs sign
If several signboards merge into a readable wall instead of distinct support cues, shorten body copy before changing map scale.

---

## Tuning Order
When a visual overlap problem appears in Studio, fix in this order:
1. shorten sign copy
2. adjust sign offset/height slightly
3. reduce prompt competition or prompt reach
4. preserve popup headroom with small local spacing changes
5. only then retune popup height/duration

Reason: most current issues are authoring-density problems before they are systems problems.

---

## Server / Client Follow-through

### Server / world authoring
Primary follow-through lives in `ArcadeWorld.luau` and config-driven placement/copy values.
No new systems are required.

### Client
Current banner + world popup architecture is sufficient.
This pass should mostly prevent scenes where client feedback has to fight world signage.

### Data model
No new replicated or persistent state.

---

## Failure / Edge Cases
- **Fast movement through plaza:** short purchase popup is still correct, but only if pad signs stay in the support band instead of the action band.
- **Repeated pumpkin cycles:** payout remains readable if sign density stays quiet above the loop, not inside it.
- **Slow applied near signage:** danger popup may dominate briefly; signage should still feel like context, not collision clutter.
- **Mobile/smaller screens:** band separation matters more than bigger signs. Shorter copy beats larger boards.

---

## Validation Plan
1. Spawn fresh and confirm the onboarding sign helps without letting plaza signs steal the frame.
2. Approach a swallow and confirm the `Heal` prompt is the strongest text read.
3. Plant near the center lane and confirm the pumpkin/popup band stays distinct from plaza billboards.
4. Break a pumpkin and confirm `2 Left` / `Final Hit` / payout all read in protected headroom.
5. Approach one upgrade pad and confirm its `Buy` prompt dominates over neighboring signs.
6. Buy an upgrade and confirm the purchase popup is not visually buried in billboard text.
7. Enter the danger lane and confirm warning support reads before contact, while `Slowed` owns the contact beat itself.

---

## Recommended Hand-off
### PM
Use this as a tie-breaker refinement doc under MG-PM-408 whenever a Studio issue is really about layered readability rather than mechanics.

### Dev
Before changing world geometry or popup timing, ask:
- is the decision band clear?
- is the feedback band clear?
- is the support band staying supportive?

If not, fix the band conflict first. That is the smallest, highest-confidence completion move inside the current arcade structure.
