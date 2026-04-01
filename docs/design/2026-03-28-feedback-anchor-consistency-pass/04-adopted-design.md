# Adopted Design

## Chosen Candidate
Candidate A — Whole-loop feedback anchor consistency

## Design Goal
Make every meaningful loop event answer two questions consistently:
1. **Where does the feedback appear?**
2. **How strong should it feel?**

The player should be able to read reward cause/effect instantly:
- swallow reward feels local and warm
- planting feels like setup
- cracking feels like progress
- payout feels strong and satisfying
- buying feels anchored to the plaza
- goblin slow feels interruptive
- slow recovery feels quiet and clear

This is a presentation refinement pass, not a mechanics pass.

---

## Current Completion Gap
The current implementation already has:
- a top banner with tone buckets
- world popups for several action results
- coherent wording across much of the loop

But the remaining inconsistencies are visible:
- upgrades only talk through the banner, even though they happen at a physical plaza pad
- some low-stakes events and high-stakes events feel too similar in strength
- popup origin rules are implicit per callsite, not authored per event category
- recovery events risk feeling disconnected because they lack a stable source rule

That weakens perceived polish more than it weakens comprehension.

---

## Core Principle
Every event gets an authored combination of:
- **Banner presence**
- **World popup presence**
- **Anchor source**
- **Intensity tier**
- **Detail line policy**

Do not decide these ad hoc at each callsite.

---

## Surface Model
### Surface A — Banner
Use for events that affect current decision-making or need one-glance sentence clarity.

Examples:
- swallow reward
- pumpkin planted
- pumpkin broken payout
- upgrade bought
- cannot afford
- maxed
- goblin slow applied
- slow faded

### Surface B — World popup
Use for events that should feel spatially tied to an object, zone, or action point.

Examples:
- swallow reward above swallow position
- planted confirmation above pumpkin position
- crack progress above pumpkin position
- payout above pumpkin position
- upgrade purchase above pad center
- goblin slow above player or goblin contact zone

### Rule
Routine warnings that lack a meaningful world anchor may use banner only.

---

## Intensity Tiers

| Tier | Meaning | Banner | World Popup | Typical Duration Feel | Examples |
|---|---|---|---|---|---|
| T1 | Quiet confirmation | optional | yes or no | brief | slow faded, planted |
| T2 | Useful progress | yes | yes | brief-medium | pumpkin cracked, swallow healed |
| T3 | Reward / spend moment | yes | yes | medium | pumpkin broken payout, upgrade bought |
| T4 | Danger interruption | yes | yes | medium | goblin slow applied |
| T0 | Silent/noise-prone state | no | no | none | redundant repeated no-op events |

### Intensity rule
Do not give all events the same apparent weight. The strongest feel should belong to:
- payout
- upgrade purchase
- danger application

Routine recovery should be quieter than danger application.

---

## Event-to-Surface Map

### 1. Swallow heal success
**Banner:** yes  
**World popup:** yes  
**Anchor:** healed swallow position  
**Tier:** T2

**Why**
This is the start of the reward chain and should feel warm and immediate.

**Copy profile**
- banner headline: gain-first
- detail: next-step reinforcement only when helpful
- world popup: short numeric reward phrase

**Recommended world text**
- `+1 Seed`
- `+2 Seeds`

---

### 2. Pumpkin planted
**Banner:** yes  
**World popup:** yes  
**Anchor:** newly spawned pumpkin root  
**Tier:** T1

**Why**
Planting is setup, not payout. It should feel acknowledged but not over-celebrated.

**Rule**
Keep banner detail brief. The popup should affirm ownership/setup, not reward.

**Recommended world text**
- `Planted`

---

### 3. Pumpkin cracked (not final hit)
**Banner:** yes  
**World popup:** yes  
**Anchor:** pumpkin root  
**Tier:** T2

**Why**
This is progress feedback. It should help pace the action without overpowering the eventual payout.

**Rule**
Use concise countdown-style popup text.

**Recommended world text**
- `2 Left`
- `Final Hit`

---

### 4. Pumpkin broken payout
**Banner:** yes  
**World popup:** yes  
**Anchor:** destroyed pumpkin root position captured before cleanup  
**Tier:** T3

**Why**
This is the core harvest reward. It should be one of the clearest positive moments in the loop.

**Rule**
This event gets the strongest positive world text in the farming slice.

**Recommended world text**
- `+10 Money`

---

### 5. Upgrade purchased
**Banner:** yes  
**World popup:** yes  
**Anchor:** purchased plaza pad center / prompt parent position  
**Tier:** T3

**Why**
This is the biggest current omission. Spending successfully should feel physically tied to the plaza, not only described in a banner.

**Rule**
The popup should name the gain, not restate the full transaction string.

**Recommended world text**
- `Footwork Up`
- `Quick Hands Up`
- `Blessing Up`

**Banner rule**
The banner can keep the exact level/cost detail because it carries the accounting layer.

---

### 6. Upgrade cannot afford
**Banner:** yes  
**World popup:** no  
**Anchor:** none  
**Tier:** T1

**Why**
This is decision feedback, not a celebratory world moment. A popup at the plaza would add clutter without improving reward feel.

**Rule**
Banner only.

---

### 7. Upgrade maxed
**Banner:** yes  
**World popup:** no  
**Anchor:** none  
**Tier:** T1

**Why**
Completion is useful to know, but not something that needs a repeated floating label every time the player tests the prompt.

---

### 8. Goblin slow applied
**Banner:** yes  
**World popup:** yes  
**Anchor:** affected player root position preferred; fallback goblin contact position  
**Tier:** T4

**Why**
The player needs immediate interruption feedback that is spatially legible.

**Rule**
The popup belongs near the player because the state change is on the player, not on the goblin.

**Recommended world text**
- `Slowed`

---

### 9. Slow faded
**Banner:** yes  
**World popup:** no  
**Anchor:** none  
**Tier:** T1

**Why**
Recovery should be clear but calm. A popup would often appear while the player is already moving again and would create unnecessary screen noise.

---

## Anchor Rules

### Object-owned event rule
If the event is caused by a specific world object that the player just acted on, anchor the popup to that object.

Applies to:
- swallow heal
- pumpkin plant
- pumpkin crack
- pumpkin payout
- upgrade purchase (anchor to upgrade pad)

### Player-state event rule
If the event changes the player state rather than the world object state, anchor to player position only if the change is urgent.

Applies to:
- slow applied -> yes, player anchor
- slow faded -> no popup

### Negative economy rule
Do not anchor failure/no-money popups into the world unless the failure itself is meant to feel dramatic. In this loop, it is not.

---

## Detail Line Policy

| Event | Detail Line Policy |
|---|---|
| swallow heal | optional; mention next-step if reward multiplier changed meaningfully |
| planted | yes, but one short anticipation line only |
| crack progress | yes, short and action-forward |
| payout | yes, reinforce plaza spend or immediate replant option |
| upgrade bought | yes, imply pace gain or loop acceleration |
| cannot afford | yes, specific recovery advice |
| maxed | yes, redirect to another upgrade or loop continuation |
| slowed | yes, recovery advice |
| slow faded | yes, one short relief line |

### Hard rule
Detail lines should never be required to understand the event. The headline must stand on its own.

---

## Overlap / Suppression Rules

### Banner rule
The existing last-event-wins banner behavior is acceptable for this pass.

### Popup rule
World popups may overlap lightly, but apply these discipline rules:
1. Keep popup text to 1–2 words or numeric phrase.
2. Do not emit separate world popups for both failure and guidance on the same input.
3. Prefer a single stronger popup over stacked weak popups.
4. Recovery (`Slow faded`) should remain banner-only to reduce churn.

### Farming cadence rule
Repeated crack/progress popups are acceptable because they map to discrete hits and reinforce pacing.

---

## State / Payload Design
No new persistent gameplay state is required.

### Recommended payload shape extension
Current payload already supports:
- `text`
- `detail`
- `worldText`
- `worldPosition`
- `tone`

That is enough for this pass.

### Optional helper addition
To reduce callsite duplication, add a small helper convention per service so each event explicitly selects:
- headline
- detail
- tone
- worldText
- worldPosition
- whether popup is omitted

This is an implementation convenience, not a new system requirement.

---

## Service-by-Service Follow-through

### SwallowService
Keep current anchored reward popup behavior.

Small refinement:
- maintain gain-first wording
- keep world popup short

### PumpkinService
Keep current plant / crack / payout anchors.

Small refinements:
- ensure planting remains weaker than payout in tone/intensity
- keep final-hit progress weaker than actual money payout

### UpgradeService
Refine purchase path so a successful upgrade includes a plaza-anchored world popup.

Implementation guidance:
- fetch prompt parent or pad part position from `world.upgradePrompts[upgradeId]`
- include `worldText`
- include `worldPosition`

No popup needed for cannot-afford or maxed states.

### PlayerState / Goblin flow
On slow apply, route a feedback event with player-root anchor if practical.
If current architecture makes server-side player-root capture awkward, client may synthesize the local popup only for the slow-applied event while preserving banner consistency.

Slow-cleared remains banner only.

---

## UI / UX Notes
- Top banner remains the semantic authority.
- World popup is the spatial/emotional accent.
- The two surfaces should complement each other, not duplicate full sentences.
- If a headline is long, the world popup must become shorter, not equally verbose.

### Good pairing example
Banner: `Bought Footwork Lv.1 (-20 money)`  
Popup: `Footwork Up`

### Bad pairing example
Banner: `Bought Footwork Lv.1 (-20 money)`  
Popup: `Bought Footwork Lv.1 (-20 money)`

---

## Failure / Edge Cases
- **Player moves away immediately after upgrade purchase:** popup still appears at plaza pad; this is correct because the spend happened there.
- **Pumpkin destroyed while multiple actions happen nearby:** payout popup still anchors to pumpkin location and should win emotionally over crack-progress events.
- **Goblin slow re-applied rapidly:** cooldown logic already limits spam; retain banner + popup only on actual slow application.
- **Slow fades while other reward events happen:** banner overwrite is acceptable; no world popup needed.
- **Mobile/small-screen readability:** because world popup text stays very short, it remains legible without growing size.

---

## Validation Plan
1. Heal a swallow and confirm the reward feels local to the swallow.
2. Plant a pumpkin and confirm the popup reads as setup, not payout.
3. Crack a pumpkin and confirm progress feedback is concise and spatially tied to the pumpkin.
4. Break the pumpkin and confirm payout is the strongest positive farming moment.
5. Buy an upgrade and confirm the plaza now produces a visible local payoff at the purchased pad.
6. Attempt to buy without enough money and confirm banner-only feedback avoids plaza clutter.
7. Trigger goblin slow and confirm the interruption reads near the affected player, not as a detached system message.
8. Wait for slow recovery and confirm only the banner clears the state without extra popup spam.
9. Run a quick loop repeatedly and confirm popups remain readable rather than turning into stacked sentence clutter.
10. Confirm no event category that should feel major is left as banner-only by accident, except intentional banner-only states (cannot afford, maxed, slow faded).

---

## Recommended Hand-off
### PM
Track this as a refinement-only presentation pass focused on:
- reward feel
- placement consistency
- surface discipline

### Dev
Implement in this order:
1. add plaza purchase world popup support
2. confirm goblin slow anchor behavior
3. verify event-to-surface map against current services
4. shorten any popup text that duplicates banner sentences
5. run one farming loop to tune overlap noise only if needed

This keeps the pass small, precise, and fully inside the current arcade structure.
