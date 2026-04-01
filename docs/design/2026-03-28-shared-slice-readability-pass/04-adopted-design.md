# Adopted Design

## Chosen Candidate
Candidate C — Combined shared-slice readability contract

## Why Chosen
The current arcade loop is explicitly shared:
- all players are Heungbu
- swallows and goblins are shared
- seeds, money, upgrades, and pumpkins are player-owned

That means the highest-value remaining completion risk is not a missing feature. It is the moment when **shared objects and player-owned beats occupy the same camera slice** and the authored loop stops feeling clean.

Existing docs already cover solo readability, cadence, landmarks, prompt reach, and danger fairness. This pass adds the missing multiplayer interpretation layer without expanding scope.

## Why Others Were Rejected
- **A** was too narrow; prompt clarity alone does not preserve reward feel or retreat clarity in shared play.
- **B** was valuable but incomplete; feedback dominance without route/prompt rules leaves overlap unresolved.
- **D** was too weak; the repo already has validation contracts, so the missing value is the rule set, not just the checklist.

---

## Design Goal
Keep the current arcade loop readable when another player is nearby by preserving one obvious local read across shared slices:
1. what **I** can act on now
2. what **just happened to me or my object**
3. what lane still owns my next movement

Remote activity may stay visible, but it should not displace the local authored beat unless it is physically the local player's new commitment.

---

## Core Principles

### 1. Local commitment beats remote context
When several readable things coexist, this priority should hold:
1. local active prompt or local immediate danger
2. local-owned result feedback
3. route lane shape / retreat lane
4. remote player feedback
5. support signage

Remote context is allowed to exist. It just should not become the dominant read over the local player's current loop step.

### 2. Shared does not mean equal-salience
Because the world is shared, nearby activity will appear. But shared visibility does **not** mean every nearby event should feel equally important.

The finishing goal is:
- other players make the world feel alive
- your own step still feels authored and legible

### 3. Solve overlap with the smallest lever first
Allowed resolution levers:
- shorter copy
- stronger local priority rules on existing feedback surfaces
- small offset/duration tuning
- small spacing or approach-distance tuning
- validation-driven scene checks

Not allowed:
- new widgets
- new private lanes
- player filtering systems
- new tutorial overlays

---

## User Flow Interpretation in Shared Play

### Spawn -> Village
If another player is already near plaza signs or crossing center, the fresh player's first read should still favor:
- the village route
- the swallow-heal purpose
- the fact that plaza pads are future choices, not the first commitment

**Rule:** remote plaza activity cannot make the plaza look like the intended first action for a zero-resource spawn.

### Village -> Seed reward
If two players enter the village at once, the local player should still read one nearby swallow as the actionable target.

**Rule:** shared swallow presence is good, but multi-prompt activation should not create a flat wall of equal `Heal` options from one stopping point.

### Plant -> Break in center lane
If another player's pumpkin or feedback is nearby, the local player's newly planted pumpkin should still become the strongest personal objective.

**Rule:** your owned pumpkin prompt and its crack/payout beats should read as your current work lane, while another player's beats remain peripheral.

### Plaza spend
If another player is buying, standing on a pad, or triggering purchase feedback, the local player approaching a different pad should still be able to read one chosen pad as their commitment.

**Rule:** remote purchase celebration is allowed, but it should not turn the whole plaza into one undifferentiated text wall.

### Danger entry / retreat
If another player pulls goblin attention or is already retreating, the local player should still read:
- where the danger begins
- when they themselves are slowed
- where the safe retreat line is

**Rule:** remote motion may add energy, but should not hide the safe-side next step after your own slow lands.

---

## State / Readability Contract

### State A — Shared prompt slice
**Definition**
Two or more interactables of the same class, or nearby players around them, are visible in one approach slice.

**Desired read**
One local prompt should still feel like the intended commitment.

**Pass conditions**
- nearest useful prompt is visually centered or contextually dominant
- remote player presence does not make adjacent prompts feel equally urgent
- support signs remain in the background support role

**Fail examples**
- two swallow prompts read as identical choices from the same stopping point
- local plaza approach becomes ambiguous because a neighbor's purchase feedback feels as strong as the approached `Buy` prompt

### State B — Shared reward slice
**Definition**
Another player's heal / break / payout / upgrade beat appears near the local player's active loop step.

**Desired read**
Local reward/result beats own the emotional read; remote beats remain atmospheric.

**Pass conditions**
- local object-anchored feedback remains easiest to parse
- remote popups can be noticed but not mistaken as the local outcome
- the local next step remains obvious after the beat resolves

**Fail examples**
- another player's payout is visually louder than the local crack-progress or payout moment in the same slice
- plaza purchase feedback from a neighbor makes the local player misread which pad they just committed to

### State C — Shared lane crossing
**Definition**
Two players cross the center lane or one plants/breaks while another returns to plaza or exits village.

**Desired read**
The center lane still reads as a work corridor, not as a confused ownership zone.

**Pass conditions**
- a local planted pumpkin still reads as the local next objective
- remote traffic does not make the local pumpkin feel like ambient shared clutter
- plaza signs and prompts do not absorb the planted-pumpkin read during ordinary overlap

### State D — Shared danger retreat
**Definition**
Multiple players occupy the Nolbu edge or retreat corridor while one or more goblin contacts occur.

**Desired read**
A slowed player still gets one obvious safe-side next step.

**Pass conditions**
- the local slow beat is readable even if another player is also moving through the corridor
- the route back toward the safer side remains visually obvious
- remote combat/movement does not replace the retreat read with noise

---

## World Objects / Authoring Rules

### Swallows
- keep current shared-swallow architecture
- preserve single-swallow commitment at ordinary approach distance
- if multiplayer overlap causes several valid `Heal` reads, prefer spacing or prompt-distance tuning before any new signage

### Pumpkins
- keep player-owned pumpkins in shared space
- local-owned pumpkins should remain the dominant `Break` read once planted
- remote pumpkins may be visible, but should not make the local planted pumpkin feel anonymous

### Plaza pads
- keep three shared upgrade pads
- local pad commitment must survive nearby remote purchases
- purchase popups should reinforce pad-local ownership of the beat, not a general plaza-wide event feeling

### Danger props / goblins
- keep the existing shared danger model
- remote player movement may enrich the space, but the local player's first readable danger beat and safe retreat lane must remain clear

---

## Server Logic Expectations
No new systems are required, but existing logic should continue to support these reads.

### Prompt-producing interactions
- keep current prompt-distance discipline
- preserve object-local prompts rather than broad area interaction metaphors

### Event feedback emitters
- continue treating heal, plant, break, payout, buy, and slow as object/player-anchored events
- local ownership of pumpkins and local application of slow remain the semantic anchor for readability

### Ownership semantics
- do not weaken owner-only pumpkin hit rules
- do not convert shared-world ambiguity into shared ownership ambiguity

---

## Client UI / HUD / Presentation

### HUD
Current HUD remains sufficient.
This pass does not add a multiplayer roster or extra ownership widgets.

### Presentation rule
The client should preserve the sense that local action beats matter most:
- local prompt commitment first
- local result beat second
- remote events as background texture

### Copy rule
If shared slices feel noisy, shorten remote-facing or support copy before inventing more explanatory surfaces.

---

## Data Model
No new persistent or replicated data required.
This is a readability / presentation / tuning contract layered onto the current model:
- shared swallows
- shared goblins
- player-owned pumpkins
- player-owned economy/upgrades
- local slowed state

---

## Failure / Edge Cases
- **Two players target the same swallow:** only one reward is granted; the loser should still be able to identify the next nearest swallow without prompt chaos.
- **Two pumpkins break near each other:** both payouts may appear, but the local player's payout should remain the clearest result read.
- **One player buys while another plants near center:** the planter's next objective should remain the pumpkin, not the neighbor's plaza feedback.
- **Two slowed players retreat together:** the local player's retreat lane should still read cleanly; danger should not devolve into unreadable crowd motion.
- **Mobile / smaller screen:** local-first hierarchy matters more than adding more text.

---

## Validation Plan
Run paired Studio checks for these scenes:
1. two players spawn while one is already near plaza space
2. two players approach adjacent village swallows
3. one player plants/breaks while another returns toward plaza
4. two players use neighboring pumpkins in the center lane
5. one player buys while another approaches a different pad
6. one player enters danger while another retreats through the reset lane
7. two players share a retreat corridor after separate slow events

For each scene, record:
- pass / needs tune
- whether the local next-step read stayed obvious
- whether remote feedback stole the moment
- smallest fix needed, if any

---

## Final Verification Target
This pass succeeds if multiplayer presence makes the world feel more alive **without** making the player's next action less clear.

That is the completion bar for the current shared arcade structure.
