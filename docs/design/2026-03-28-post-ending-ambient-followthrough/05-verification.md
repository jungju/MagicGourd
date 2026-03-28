# Verification

## Final Verification Summary
The adopted design passes the current implementation-value test because it targets the biggest remaining experiential gap in the project:

- the ending structure is implemented
- the payoff presentation exists
- post-ending free play exists
- but the village still does not fully *live inside* the chosen ending

This design stays small enough for a focused PM/Dev pass while still producing visible player-facing change.

---

## Why This Feature Is Needed Now
### Current gap
The project already supports:
- a main quest arc
- a blessed seed payoff
- retaliation and recovery
- a final branch choice

What it still lacks is **post-ending environmental consequence density**.

Right now, after a meaningful branch choice, the player mostly gets:
- updated quest/HUD hints
- some sign text changes
- one-off branch dialogue

That is structurally correct, but emotionally underpowered.

### Why this is the right next step
This design improves the ending where the current code is already strongest:
- centralized sign refresh
- branch-aware dialogue entry points
- patch mood control
- runtime-spawned props

So it is high-value without needing a new architecture layer.

---

## Fun / Loop Check
### Does it create a better play loop?
Yes, in a modest but important way.

It does not add a new main loop. Instead, it improves the **meaning** of the existing free-play loop:
- farming after restoration feels generous and alive
- farming after tribute feels productive but constrained
- revisiting NPCs continues the ending instead of forgetting it

That makes the ending feel less like a menu choice and more like a world condition.

### Does it support screenshots / vibe / replay?
Yes.
A player should be able to stand in the village and immediately read the branch tone through props, patch state, and signage. That is useful for both emotional payoff and future iteration.

---

## Theme Check
### Heungbujeon fit
Strong.

The core moral contrast of the slice is not just who wins an argument. It is what kind of harvest culture the valley adopts:
- shared kindness and recovery
- fearful order and tribute

A branch-aware ambient layer expresses that theme directly in the world.

### Tone safety
Passes, with one caution:
- tribute aftermath should feel colder, not cartoonishly evil
- restoration aftermath should feel hopeful, not unrealistically perfect

The chosen design leaves room for both endings to feel meaningful.

---

## Roblox / Rojo Feasibility Check
### Feasibility
High.

Everything in MVP can be built through systems already present in `init.server.luau`:
- billboard updates
- prompt-triggered dialogue
- patch material/color/light changes
- runtime primitive props

### Rojo safety
High.

The design does not depend on Studio-only placement choreography. Accent props can be spawned under runtime folders just like existing interaction markers and fallback world pieces.

### Asset risk
Low.

The design can succeed entirely with primitive parts, text, and existing effects. No external mesh or animation dependency is required.

---

## Code Coupling Check
### Existing hooks that support the feature
- `profile.endingChoice`
- `profile.endingResolved`
- `refreshVillageSigns()`
- `setPatchMood()` and `setPatchText()`
- complete-state Heungbu / Nolbu dialogue branches
- runtime folders under `Workspace/Map/Runtime`

### Coupling risk
Low to medium.

The only real risk is overloading shared sign refresh and patch logic with too many special cases. PM/Dev should keep the implementation explicit and small rather than trying to create an over-generalized narrative framework.

---

## Economy / Reward Conflict Check
### Core question
Does this design distort the existing farming/reward balance?

### Answer
Not in MVP.

The base version mostly changes presentation and ambient interaction text. That keeps the economy stable.

### Caution for optional extension
If PM/Dev includes repeatable tribute hand-ins in the same pass:
- payout must stay modest
- it should not dominate normal Heungbu delivery value
- cap, cooldown, or intentionally low reward may be needed

If there is any doubt, cut repeatable rewards from MVP.

---

## Failure Recovery Check
### If branch props fail
Signs + dialogue + patch mood still carry the feature.

### If patch mood conflicts with another state
Story-critical active states like brambles or blessed harvest should temporarily override ambient ending mood, then return to the ending idle mood afterward.

### If mixed village counters make the shared world ambiguous
Use player-facing prompt/dialogue logic from the interacting player's profile. Shared signage can continue using aggregate counts as a rough public-world summary.

This is acceptable for the current session-based architecture.

---

## PM Readiness Check
This design is ready for PM breakdown because it has:
- clear chosen scope
- explicit MVP cut line
- defined implementation order
- optional work clearly separated from required work

### Suggested PM acceptance conditions
PM can mark the feature ready for Dev when tasks explicitly cover:
1. patch aftermath mode
2. sign aftermath copy
3. Heungbu/Nolbu ambient line expansion
4. tribute basket aftermath behavior
5. accent prop spawn/reveal

---

## Dev Readiness Check
This design is ready for Dev because each piece maps cleanly onto an existing code seam.

### Smallest credible Dev slice
If time is tight, Dev can still ship a valuable subset:
1. stronger branch-specific sign updates
2. patch idle aftermath mode by ending
3. expanded post-ending Heungbu/Nolbu dialogue

That alone would already make the ending feel more persistent.

---

## Final Verdict
**Adopted and implementation-ready.**

This is the right next design because it:
- reinforces the already-built ending structure
- deepens player payoff without quest sprawl
- is highly compatible with the current Roblox/Rojo architecture
- creates a stronger foundation for later branch-specific free-play systems

## Immediate Next Recommendation
Hand this to PM as the next `new` feature after any remaining Studio-only validation items. For Dev, prefer a compact first pass that ships:
- patch aftermath
- branch signage
- ambient dialogue expansion

Only add repeatable tribute mechanics if those land cleanly first.
