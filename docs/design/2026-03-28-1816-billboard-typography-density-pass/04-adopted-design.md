# Adopted Design

## Chosen Candidate
Candidate C — Full billboard presentation contract

## Design Goal
Make current world billboards read like a controlled support layer instead of a collection of equally loud floating cards.

This pass defines how the existing signs should differ by role so that:
- prompts keep decision ownership
- world popups keep payoff ownership
- signs remain useful before/after the action beat
- plaza and center-lane overlap cases stop reading like a text wall

This is a presentation refinement pass only.

---

## Why This Pass Is Needed Now
Current refinement work already solved a lot of the obvious structure issues:
- verbs are coherent
- prompts have ownership rules
- world popups have anchor and cadence rules
- signs have placement/band guidance

The remaining gap is subtler: many billboards still share the same presentation grammar, so different classes of support text do not feel meaningfully different.

That weakens completion in three ways:
1. **Spawn and route signs** can feel as loud as action destinations.
2. **Plaza role boards** can merge into one equal-weight text row.
3. **Popup headroom** can still feel tight even when positions are technically valid, because billboard bodies visually occupy too much attention.

---

## Scope

### In scope
- billboard class definitions
- title/body emphasis rules
- body length budget by sign class
- `AlwaysOnTop` usage discipline
- when sign bodies should be present vs omitted
- validation rules for spawn, plaza, lane, and danger slices

### Out of scope
- new sign locations
- new mechanics
- new HUD widgets
- reward/economy changes
- replacing billboards with a different UI system

---

## Billboard Class Set

### Class 1 — Loop Sign
Examples:
- spawn `Arcade Loop`

**Purpose**
Teach the full loop once, at the start.

**Priority**
Highest support priority, but still below active prompts.

**Typography rule**
- title can be bold and clear
- body may include the full 4-step chain
- this is the only sign class allowed to use a compact symbolic chain like `Heal -> Plant -> Break -> Buy.`

**Density budget**
- title: 1-3 words
- body: up to ~28 characters preferred
- avoid a second sentence

---

### Class 2 — Zone / Lane Support Sign
Examples:
- village landmark
- work-lane sign
- danger-entry sign
- retreat/reset-lane sign
- zone pad billboards for area purpose

**Purpose**
Reinforce one area role or route intention.

**Priority**
Medium support priority.

**Typography rule**
- title is the main read
- body should be one short sentence or clause
- body should explain purpose, not restate the whole loop

**Density budget**
- title: 1-3 words
- body: target <= 44 characters
- wrapping should stay visually shallow; if a second wrap line feels dense, shorten copy first

**Hard rule**
Zone/lane signs should never try to teach both reward and warning and route logic in the same body.
Pick one dominant function.

---

### Class 3 — Plaza Role Sign
Examples:
- Footwork
n- Quick Hands
- Blessing

**Purpose**
Tell the player what this pad is for, not re-explain the economy.

**Priority**
Lowest support priority among active gameplay signs because the prompt and HUD row already carry the commit/accounting layer.

**Typography rule**
- title does most of the work
- body should be a short gain fantasy, not a cost ladder
- if the body becomes long enough to wrap into a dense block, reduce it to a terse promise

**Density budget**
- title: 1-2 words preferred
- body: target <= 30 characters
- one sentence fragment is enough

**Examples**
- `Run faster between loop steps.`
- `Break pumpkins faster.`
- `Gain more seeds per heal.`

**Hard rule**
Do not let plaza role boards compete with purchase popups by carrying accounting details that the HUD/banner already explains.

---

## Title / Body Hierarchy Rules

### Title behavior
- Titles should remain the first sign read.
- Titles should not wrap under ordinary camera distance.
- If a title is long, shorten the label before widening the board.

### Body behavior
- Body text exists to support the title, not to become the primary read.
- Body can wrap lightly, but should feel visually quieter than the title.
- If a body needs two dense lines to make sense, it is too long.

### Scaling rule
Avoid relying on `TextScaled` alone to create hierarchy.
If implementation changes are made, favor a stable title/body distinction over two equally auto-scaled blocks competing for size.

This means the visual goal is:
- title = confident, fast read
- body = quieter, shorter confirmation

---

## Always-On-Top Discipline
Current billboards often use `AlwaysOnTop = true`. Keep that behavior only if it remains visually quiet enough.

### Rule by class
- Loop Sign: allowed to stay always-on-top
- Zone / Lane Support Signs: allowed, but only with short body copy and support-band offset discipline
- Plaza Role Signs: should be treated as the first candidate for quieting if Studio shows billboard-wall behavior

### Quieting order
If a sign feels too loud in Studio, tune in this order:
1. shorten body copy
2. reduce body emphasis / density
3. consider quieting the billboard class presentation
4. only then move objects around

This keeps geometry stable and solves density at the authoring layer first.

---

## Zone-by-Zone Application

### Spawn
Desired read:
1. loop sign
2. leftward village route
3. plaza options in the background

Implication:
- the spawn sign may be the clearest support billboard in the opening frame
- plaza boards should feel secondary until the player actually returns with money

### Heungbu Village
Desired read:
1. nearest `Heal` prompt
2. local heal reward popup
3. village support board

Implication:
- village board body must stay shorter and quieter than the active swallow moment

### Center Work Lane
Desired read:
1. owned pumpkin or current movement lane
2. crack/payout popup
3. nearby plaza support signage

Implication:
- any sign visible from the lane must feel like background orientation, not concurrent instruction

### Central Plaza
Desired read:
1. approached `Buy` prompt
2. purchase popup at pad center
3. pad title/body as role reinforcement

Implication:
- plaza board bodies must be the shortest billboard bodies in the game
- the title should carry identity; the body should only hint at payoff

### Danger Edge
Desired read:
1. entering-risk lane tone / goblin sightline
2. slow popup on contact
3. danger support sign as context

Implication:
- danger sign copy must stay warning-fast, not paragraph-like

---

## Server / World Follow-through
This pass should remain implementable through the existing world-authoring path.

### World object impact
No new object types.
No new state.
No new runtime folders.

### Likely touchpoints if implemented
- `attachBillboard()` defaults
- selective billboard presets per sign class
- zone/pad/sign copy trimming inside `ArcadeConfig` / `ArcadeWorld` authored strings

---

## Failure / Edge Cases
- **Mobile / smaller screens:** shorter body copy matters more than larger boards.
- **Fast loop play:** if the player only catches the title, the sign should still make sense.
- **Plaza revisit after many upgrades:** role boards should remain useful even when costs/max state are mostly carried elsewhere.
- **Danger overlap moments:** warning signs should still read before contact, not during the exact collision beat.

---

## Validation Plan
1. Spawn fresh and confirm the loop sign reads first while plaza boards stay secondary.
2. Approach a swallow and confirm the village board does not compete with the `Heal` prompt.
3. Plant/break near the center lane and confirm popups remain more legible than nearby support copy.
4. Approach each plaza pad and confirm the board title identifies the role quickly while the body stays visually quiet.
5. Buy an upgrade and confirm the purchase popup has cleaner airspace than the surrounding board bodies.
6. Enter the danger route and confirm the warning board reads as a cue before contact, not as same-band clutter.

---

## Recommended Hand-off
### PM
Use this as a final presentation-layer refinement underneath the existing spatial-readability and visual-band-separation passes.

### Dev
If Studio shows sign noise, do **not** start with map surgery.
Start with:
1. shorten billboard body copy
2. separate title/body emphasis
3. quiet plaza role boards first
4. only then adjust offsets or spacing

That is the smallest, highest-confidence completion move left in the current structure.