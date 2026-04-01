# Adopted Design

## Chosen Candidate
Candidate A — Contact fairness budget

## Why chosen
MagicGourd's remaining completion risk is not whether goblins exist or whether the danger zone is labeled. It is whether the **moment-to-moment danger contract** feels fair during real movement:
- entry should telegraph risk before contact
- contact should read as a consequence of pushing too far, not random clutter
- retreat should produce a clean reset
- re-entry should feel intentional

This pass tightens that contract without adding any new mechanic.

---

## Design goal
Make goblin pressure feel like a readable interruption layer on top of the farming loop, not a messy collision tax.

The player should understand three things in motion:
1. `I am entering the risky lane now.`
2. `That tag happened because I stayed in threat space, not because the map or AI cheated.`
3. `If I pull back, I get a short, legible reset before choosing whether to go again.`

---

## Scope boundary
This pass is **not**:
- a new combat loop
- a dodge button or parry mechanic
- damage, death, or health tuning
- extra danger UI overlays
- more enemy types
- a pathfinding rewrite

This pass **is**:
- danger-entry readability rules
- first-contact fairness expectations
- chase/reset discipline
- validation scenes and tuning order for current goblin logic, spawns, rocks, and signs

---

## Core principle
A goblin tag is allowed to feel punishing.
It is **not** allowed to feel ambiguous.

The danger beat succeeds when the player can retrospectively explain the hit in one short sentence:
- `I crossed deeper into the slow zone.`
- `I drifted into the goblin's lane.`
- `I stayed greedy instead of resetting.`

The beat fails when the player instead thinks:
- `That came from nowhere.`
- `I couldn't tell where the safe route was.`
- `The goblin body-blocked me before the area even read as danger.`

---

## Contact fairness contract

### 1. Entry must telegraph before first tag
Before first contact, the player should get a readable danger prelude from the existing world:
- the `Slow Zone` sign
- lane color/material shift
- danger lantern warmth
- visible goblin silhouettes / motion
- reduced clutter around likely first-contact lines

#### Pass condition
A normal player approaching from Central Plaza should get **at least one short recognition beat** that they are entering danger before the first slow lands.

#### Fail examples
- first contact happens while the player still reads the lane as ordinary route continuation
- rocks or off-angle spawn positions hide the goblin until contact distance is already committed
- the player is tagged at the same moment they discover where the danger actually begins

#### Allowed fixes
- minor goblin spawn spacing changes
- minor rock adjustments
- small sign offset/copy trim
- slight danger-lane visual cleanup using existing props

#### Hard rule
Do not add a new warning banner just for entering the zone. The zone itself must do the teaching.

---

### 2. First contact should happen inside authored threat space
A goblin tag should occur only after the player has meaningfully entered the danger slice, not while skimming the safe-side edge or passing through the reset corridor.

#### Desired read
The player feels: `I pushed in and got checked.`

#### Pass conditions
- first tags happen predominantly inside the readable danger lane, not at plaza-edge ambiguity space
- a goblin should not regularly reach so far forward that plaza-adjacent movement reads unsafe by surprise
- the retreat-side lane remains a credible reset path after contact

#### Tuning levers
- chase zone padding
- chase range
- spawn-point spread
- rock spacing that defines but does not choke the lane

#### Constraint
Favor reducing unfair forward reach before increasing slow severity or goblin count.

---

### 3. Contact must preserve a retreat story
Once slowed, the player should still be able to parse the escape idea immediately:
`back out toward plaza / reset lane, then recover.`

#### Pass conditions
- the slowed player can still visually identify the safe-side path
- the goblin does not feel glued to the player through the entire recovery in an unreadable way
- recent sign / landmark work remains compatible with retreat at ordinary camera angles

#### Fail examples
- slowdown plus geometry makes the return lane visually mushy
- repeated immediate re-tags happen before the player can tell they successfully pulled back
- the goblin remains so spatially tangled with the player that retreat direction is unclear

#### Allowed fixes
- minor retreat-lane cleanup
- small leash / home-return discipline adjustments
- minor retarget pacing trims

---

### 4. Re-entry must feel like a new choice, not lingering punishment
After the player successfully pulls back and recovery clears, the next push into Nolbu Area should read as a fresh decision.

#### Pass conditions
- goblins visibly drift or re-center enough that re-entry is legible
- recovery guidance and lane landmarks hand the player back to a readable safe-side state first
- returning into danger feels like stepping back into a lane, not into leftover contact chaos

#### Fail examples
- goblin remains parked in a way that makes the zone entrance permanently sticky
- reset lane never feels reset because chase pressure stays smeared too close to plaza
- recovery clears, but the player still cannot tell whether the next step is safe-side loop work or a deliberate danger push

#### Tuning levers
- leash radius
- roam target spread
- retarget interval
- spawn/home placement relative to the entrance and rocks

---

## World object expectations

### Signs
- `Slow Zone` should remain the earliest danger label.
- `Reset Lane` should stay readable while retreating, not only while standing still.
- Neither sign should try to carry the whole mechanic explanation.
- If copy competes with movement readability, shorten the body before moving geometry.

### Rocks and lanterns
- Rocks should shape the danger slice, not create ambush blind spots at the first approach angle.
- Lanterns should help the danger lane feel distinct, but not hide goblin silhouettes.
- Small spacing changes are acceptable if first-contact fairness improves.

### Goblin homes / spawn points
- Homes should support a readable front half of danger and a readable deeper half.
- The two active goblins should not collapse into one visually muddy first-contact cluster during ordinary entry.

---

## Server logic follow-through
No new systems required.

The existing `GoblinService` already has the right control surfaces:
- `ChaseZonePadding`
- `ChaseRange`
- `LeashRadius`
- `RetargetInterval`
- `TouchCooldown`
- spawn/home positions from `ArcadeConfig`

This pass defines how to tune them.

### Behavior expectations
- chase should feel intentional, not jittery
- goblins should threaten inside authored space, not drag danger too far into safe-side routing
- touch cooldown should prevent immediate spammy body-check reads
- home/re-roam behavior should let the lane breathe again after retreat

---

## Client / feedback expectations
The current danger feedback stack stays intact:
- player-anchored `Slowed` world popup
- strong warning banner on hit
- quiet `Slow faded.` recovery banner
- retreat / safe-side guidance from the existing HUD hierarchy

This pass does **not** add more danger copy.
It verifies that current copy lands on top of fair world behavior.

---

## Validation scenes

### Scene 1 — First approach from plaza
1. Spawn or stand in Central Plaza.
2. Move toward Nolbu Area at a normal pace.
3. Observe whether the route reads as risky before any hit.

**Pass if** danger is recognizable before contact.
**Needs tune if** first tag arrives before a clear prelude.

### Scene 2 — Edge skim
1. Approach the safe-side edge of danger without fully committing deep.
2. Test whether plaza-adjacent or reset-lane movement still feels plausibly safe.

**Pass if** the player can skim and decide, not get surprise-tagged at the threshold too often.
**Needs tune if** forward goblin reach makes the entrance feel sticky or arbitrary.

### Scene 3 — Deep push and retreat
1. Commit deeper into the danger zone until slowed.
2. Immediately retreat toward the reset lane.
3. Confirm the return route remains obvious while slowed.

**Pass if** retreat reads immediately and re-tags are not visually confusing.
**Needs tune if** geometry, goblin overlap, or leash behavior muddies escape.

### Scene 4 — Recovery and re-entry
1. Let slow clear on the safe side.
2. Pause one beat.
3. Re-enter danger.

**Pass if** the second push feels like a fresh deliberate choice.
**Needs tune if** goblin pressure remains smeared over the entrance and denies a readable reset.

### Scene 5 — Repeated farming loop with danger dips
1. Run several ordinary loop cycles.
2. Dip into danger briefly between plaza or farming beats.
3. Confirm the danger layer feels like meaningful pressure, not random route tax.

**Pass if** the player can explain each hit as a readable risk decision.
**Needs tune if** goblin contacts still feel detached from lane ownership.

---

## Tuning order
When Studio exposes a problem, tune in this order:
1. first-contact readability via spawn/rock spacing
2. sign copy trim / offset if the warning read is too slow
3. chase-zone reach (`ChaseZonePadding`, `ChaseRange`)
4. leash / roam / retarget discipline
5. only then consider touch cooldown adjustments

Reason:
The cheapest correct fix should win, and most unfair-feeling hits should be solved before touching the fundamental slow cadence.

---

## Failure / edge cases
- **Two goblins converge near the same approach line:** acceptable only if the lane still reads and the first contact remains attributable.
- **Player intentionally sprints deep into danger:** punishing tags are fine; unreadable tags are not.
- **Camera angle hides one goblin briefly:** acceptable if the zone read still telegraphed danger beforehand.
- **Recovery finishes near the entrance:** acceptable if re-entry still reads as a fresh choice rather than immediate sticky overlap.

---

## Verification method
This pass succeeds when a live tester can describe goblin pressure in plain language as:
- readable on entry
- fair on first contact
- clear on retreat
- deliberate on re-entry

If not, only low-scope tuning inside the current world/config/service boundaries is allowed.

---

## PM handoff
Use this as a focused completion sub-contract under MG-PM-408's blocked Studio validation work.
It narrows the single biggest remaining `danger feel` uncertainty without reopening design scope.