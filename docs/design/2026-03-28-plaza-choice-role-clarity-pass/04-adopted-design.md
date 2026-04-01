# Adopted Design

## Chosen Candidate
Candidate A — Plaza Choice Role Clarity

## Why Chosen
The current arcade loop already teaches three of its four verbs cleanly:
- heal
- plant
- break

The fourth verb, **buy**, is mechanically present and readable enough, but it is still the least expressive part of the loop. The player can often tell **whether** they can buy before they can tell **why this specific pad is the right buy**.

That makes the plaza step feel more like bookkeeping than choice.

This pass keeps the same three upgrades, same costs, same prompts, and same plaza footprint. It only clarifies each upgrade's **job**, **ideal timing**, and **emotional promise**.

---

## Design Goal
Make each plaza upgrade answer a different loop need at a glance.

The player should be able to read the three pads like this:
- **Footwork** = `I want faster travel and safer repositioning.`
- **Quick Hands** = `I want shorter pumpkin break windows.`
- **Blessing** = `I want bigger seed gain from each swallow heal.`

The plaza should feel like a crisp strategic fork, not a wall of similar improvements.

---

## Scope Boundary
This pass is **not**:
- a new upgrade system
- a rebalance pass
- a plaza rebuild
- a tutorial overlay
- a new progression layer

This pass **is**:
- role-differentiation wording
- timing guidance for when each upgrade is attractive
- tighter alignment between pad billboard, HUD row, popup, and banner
- a small visual-language contract for plaza coherence

---

## Core Principle
Every upgrade should communicate four things in one glance:
1. **Role** — what part of the loop it changes
2. **Payoff direction** — speed, break tempo, or seed economy
3. **Ideal timing** — when it is especially worth buying
4. **Next-run promise** — what the very next loop should feel like after purchase

If a surface cannot carry all four, prioritize in this order:
- role
- payoff direction
- next-run promise
- ideal timing

Do not let cost/accounting bury the role.

---

## Upgrade Role Map

### Footwork
**Role:** traversal / recovery / return speed  
**Loop slice improved:** village-to-plaza travel and danger disengage  
**Player fantasy:** `I feel lighter and less delayed.`

**Canonical promise:**
- get between loop steps faster
- lose less time to travel and recovery repositioning

**Best timing cue:**
- attractive when the player feels the map distance between steps
- especially useful after a recent slow or when repeated returns feel long

---

### Quick Hands
**Role:** pumpkin finish speed  
**Loop slice improved:** time spent breaking owned pumpkins  
**Player fantasy:** `My money step gets snappier.`

**Canonical promise:**
- shorten the vulnerable / stationary break window
- convert planted pumpkins into money faster

**Best timing cue:**
- attractive when the player is regularly planting and cashing out
- especially useful when pumpkin breaking feels like the slowest slice of the loop

---

### Blessing
**Role:** swallow efficiency / seed economy  
**Loop slice improved:** reward gained from each heal  
**Player fantasy:** `Each act of kindness pays forward harder.`

**Canonical promise:**
- each swallow heal is worth more seed output
- stronger setup for future pumpkins and loop chaining

**Best timing cue:**
- attractive when the player wants stronger setup from the village side
- especially useful when one heal producing more future actions feels valuable

---

## Surface-by-Surface Contract

### 1. Pad billboard
Pad billboards should answer **role first**, not full accounting.

Recommended structure:
- title = upgrade name
- body = one short role sentence
- optional subtext only if needed later, but not required now

Recommended body copy:
- **Footwork:** `Move between loop steps faster.`
- **Quick Hands:** `Break pumpkins in less time.`
- **Blessing:** `Gain more seeds from each heal.`

#### Rule
Billboards should describe the **loop slice** each pad improves.
They should not try to show level ladders, precise value deltas, or multi-line justification that the HUD already covers.

---

### 2. HUD upgrade row
HUD rows should answer:
- what improves
- what the next level gives
- whether I can buy now

Recommended style:
- `Footwork Lv.1 -> Lv.2 | 18 -> 20 speed | Buy now`
- `Quick Hands Lv.0 -> Lv.1 | 0.75s -> 0.60s hit gap | Need 8 more`
- `Blessing Lv.2 -> Lv.3 | 3 -> 4 seeds/heal | Buy now`

#### Additional role cue rule
Keep the upgrade names stable, but treat the benefit text as the real decision-making surface.
If a future wording trim is needed, shorten around the numbers before removing the role-defining unit (`speed`, `hit gap`, `seeds/heal`).

---

### 3. Prompt object text
Prompt action already correctly uses `Buy`.
The object name should keep the clean display name only:
- `Footwork`
- `Quick Hands`
- `Blessing`

#### Rule
Do not overload prompt object text with level or price. Prompt is commitment confirmation, not comparison UI.

---

### 4. Purchase world popup
Purchase popup should communicate the **role upgrade identity** in 1-2 words.

Current shape like `Footwork Up` is directionally correct.
Preferred style remains:
- `Footwork Up`
- `Quick Hands Up`
- `Blessing Up`

#### Rule
Do not replace these with generic `Upgrade Bought` or price-led popups.
The popup's job is identity + emotional punctuation.

---

### 5. Purchase banner detail
Banner headline can remain transaction-accurate, but the detail line should imply the next-run benefit.

Recommended detail style by upgrade:
- **Footwork:** `Your next route should feel lighter immediately.`
- **Quick Hands:** `Your next pumpkin should cash out faster.`
- **Blessing:** `Your next swallow heal should feed a bigger loop.`

#### Rule
The detail line should answer `what should feel different on the very next run?`
That is the missing emotional bridge after a plaza spend.

---

## Decision Timing Guidance
This pass does not force recommendations with new UI. It simply aligns wording so the player can self-diagnose the best buy.

### Footwork should read best when
- travel time is the main annoyance
- the player has just reset from danger
- the player wants smoother returns between village, center lane, and plaza

### Quick Hands should read best when
- the player is already farming pumpkins steadily
- break windows feel long or exposed
- the player wants money conversion to feel snappier

### Blessing should read best when
- the player wants better setup from each village visit
- seed scarcity feels like the limiting factor
- the player wants more future plant opportunities from one heal

#### Hard rule
Do not spell all of this out on-screen at once.
Distribute it across row benefit text, billboard body, and purchase detail lines.

---

## Placement / Coherence Rules

### Plaza visual-language rule
Each pad already has a distinct color. Keep that color identity synchronized with all associated surfaces where practical:
- pad color
- HUD row tint
- purchase popup tone if differentiated later

This is not a new color system. It is a consistency reminder so each upgrade retains a recognizable silhouette.

### Comparison rule
The plaza should present three **different reasons to spend**, not three copies of the same sentence pattern.

Bad pattern:
- `Run faster.`
- `Break faster.`
- `Gain faster.`

Better pattern:
- `Move between loop steps faster.`
- `Break pumpkins in less time.`
- `Gain more seeds from each heal.`

The second set ties each upgrade to a specific loop slice.

### Accounting discipline rule
Cost matters, but it is secondary once affordability is already visible.
If a surface must choose between cost detail and role clarity, role clarity wins except on the transaction banner headline.

---

## Server / Client Follow-through

### Server
No new gameplay state.
No new remote required.

Helpful small follow-through if implementation is desired later:
- make purchase detail lines upgrade-specific instead of generic
- keep purchase popup identity-specific
- preserve current plaza pad anchor behavior

### Client
No new UI surface required.

Helpful small follow-through if implementation is desired later:
- ensure benefit text keeps role-defining units visible
- preserve per-row tint consistency
- keep `Buy now` / `Need X more` / `MAX` as short decision suffixes rather than the row's main message

---

## Failure / Edge Cases
- **All three upgrades are affordable:** role clarity matters even more here; the player should still be able to choose by loop need, not only cost.
- **Player ignores role and buys favorite color/name:** acceptable; the design should guide, not force.
- **Small screens compress row text:** preserve units and role-defining nouns before preserving filler words.
- **Repeated purchases in quick succession:** popup identity + upgrade-specific banner detail should keep purchases from blending together.
- **Future balance changes:** if values change, the role contract still holds because it is framed around loop slice, not exact numbers.

---

## Validation Plan
1. Stand in the plaza and identify the likely purpose of each pad without opening code.
2. Confirm each billboard points to a different loop slice rather than repeating generic upgrade language.
3. Read the HUD rows and confirm the role-defining units (`speed`, `hit gap`, `seeds/heal`) remain visible.
4. Buy Footwork and confirm the detail line promises a faster route/reposition feel.
5. Buy Quick Hands and confirm the detail line promises faster pumpkin cash-out.
6. Buy Blessing and confirm the detail line promises larger future seed gain.
7. Trigger repeated purchases across different upgrade types and confirm the popups still identify which upgrade advanced.
8. Confirm the plaza still feels like the same compact arcade spend step, not a new system.

---

## Recommended Hand-off
### PM
Use this as a completion pass underneath the already-done readability/copy work. It is not a new feature. It is a coherence contract for the plaza decision step.

### Dev
If implementation follow-through is needed, do it in this order:
1. make purchase detail lines upgrade-specific
2. trim pad billboard body copy so each pad names its loop slice cleanly
3. preserve role-defining units in HUD rows
4. only then consider any extra tint/visual polish if readability still feels flat

This keeps the project in refinement mode: same loop, clearer choices, better reward framing.
