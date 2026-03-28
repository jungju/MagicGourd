# Verification

## Final Verification Summary
This design passes the "next high-value feature" test because it targets the clearest remaining gameplay gap after the current post-ending ambient work: **branch consequence still needs a small action loop**.

It stays aligned with current implementation reality instead of inventing a bigger system.

---

## Why This Feature Is Needed Now
The project now has:
- a complete story arc
- branching endings
- ending-aware ambience
- stable post-ending free play

What it still lacks is a branch-specific reason to do one more harvest cycle after the ending.

Without that, the endings read well once but flatten quickly into generic replay.

This design fixes that with minimal new machinery.

---

## Fun / Loop Check
### Does it improve the loop?
Yes.

It adds one simple decision after every harvest:
- in restoration, do I contribute to the shared basket?
- in tribute, do I surrender this gourd to keep the road quiet?

That is enough to make post-ending farming feel narratively charged without overcomplicating it.

### Does it remain lightweight?
Yes.

The loop is still:
- grow
- harvest
- choose a hand-in
- get small feedback

No new long quest chain or hidden meta-system is required.

---

## Theme Check
### Heungbujeon fit
Strong.

The story's moral contrast becomes a repeatable harvest behavior:
- sharing abundance
- feeding fearful order

That is a clean thematic continuation of the current ending structure.

### Tone safety
Pass.

- restoration is generous, not naïve paradise
- tribute is orderly, not cartoon villain taxation

Both endings remain meaningful.

---

## Roblox / Rojo Feasibility Check
### Feasibility
High.

Everything can map onto current implementation seams already visible in `init.server.luau`:
- prompt-based interactions
- inventory counters for gourds and coins
- ending-state gating
- runtime prop folders
- dialogue/effect feedback

### Asset risk
Low.

Primitive stands, mats, baskets, and billboard prompts are enough.

### Studio dependency
Low.

A quick visual placement check is useful, but the design is not blocked on bespoke Studio choreography.

---

## Economy / Balance Check
### Risk
Manageable.

The only significant risk is overtuning repeatable payouts so the ending errand becomes the dominant coin source.

### Mitigation
- keep reward per gourd modest
- compare against normal sale/delivery values
- add soft cooldown only if abuse shows up in playtest

If tuning is uncertain, err lower, not higher.

---

## Coupling / Complexity Check
### Coupling
Low-medium.

The feature touches existing farming and prompt logic, but it does not require a new quest tree or persistence layer.

### Complexity trap to avoid
Do **not** turn this into:
- a village reputation system
- a job board
- daily quests
- rotating timers in MVP

The value comes from branch identity, not system breadth.

---

## PM Readiness Check
Ready.

The work can be broken into a compact set of PM tasks with clear acceptance criteria:
1. restoration receiver exists and works only for restoration ending
2. tribute receiver exists and works only for tribute ending
3. each consumes one normal gourd and gives modest reward
4. feedback text matches branch tone
5. no main quest regression under `COMPLETE`

---

## Dev Readiness Check
Ready.

### Smallest credible dev slice
If time is tight, ship:
1. one prompt per branch
2. one-gourd hand-in
3. one reward value per branch
4. two lines of feedback each

That is already enough to verify the design premise.

---

## Final Verdict
**Adopted and ready for PM/Dev hand-off.**

This is the right next design because it:
- directly follows the already-finished ambient aftermath pass
- gives endings a small but real replay loop
- fits the current Roblox/Rojo architecture cleanly
- avoids reopening story scope or creating economy sprawl

## Immediate Next Recommendation
PM should treat this as the next `new` feature after Studio validation. If Dev time is limited, implement the two branch receivers first and leave location rotation/support-point variants for a later pass.