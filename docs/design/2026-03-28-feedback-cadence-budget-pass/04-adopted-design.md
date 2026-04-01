# Adopted Design

## Chosen Candidate
Candidate C — Combined Feedback Cadence Budget

## Why Chosen
MagicGourd already has most of the right ingredients:
- strong canonical verbs
- better HUD guidance
- event-specific banner text
- anchored world popups
- a spatial readability budget

What is still under-authored is **rhythm**.

In the active arcade loop, the player can cause several legitimate feedback events within a few seconds. If every event speaks with equal persistence, the game feels cheaper and noisier than it should. The best refinement is not new content. It is a compact rule set for **which feedback beat gets the spotlight, which one yields, and which one should stay quiet**.

---

## Design Goal
Preserve a readable one-beat-at-a-time rhythm during fast loop play while keeping payout, purchase, and danger emotionally stronger than setup or recovery.

The loop should feel like this:
- **Heal** = warm start
- **Plant** = light setup
- **Crack** = crisp progress
- **Payout** = strongest farming reward beat
- **Buy** = strong progression beat
- **Slow applied** = strongest interruption beat
- **Slow faded** = quiet release

---

## Scope Boundary
This pass is **not**:
- a new VFX pass
- a combo system
- a tutorial rewrite
- a new notification channel
- a change to reward values or mechanics

This pass **is**:
- cadence priority rules
- short suppression/yield windows
- surface dominance rules between banner and world popup
- validation guidance for repeated fast loops

---

## Core Principle
At any normal moment, one feedback beat should dominate the player's attention.

Priority order:
1. **danger interruption**
2. **progression spend**
3. **harvest payout**
4. **resource gain / progress**
5. **setup confirmation**
6. **recovery / bookkeeping**

If two events are valid at nearly the same time, the lower-priority one should shorten, yield, or remain banner-only.

---

## Event Cadence Table

| Event | Cadence Role | Relative Strength | World Popup Rule | Banner Rule |
|---|---|---|---|---|
| Swallow heal | warm resource start | medium | yes, short | yes |
| Pumpkin planted | setup confirmation | low | yes, very short | yes |
| Pumpkin crack progress | action pacing | medium-low | yes, very short | yes |
| Pumpkin broken payout | harvest reward | high | yes, strongest positive farming beat | yes |
| Upgrade bought | progression reward | high | yes, strong and clean | yes |
| Cannot afford / maxed | bookkeeping | low | no | yes |
| Goblin slow applied | interruption | highest | yes, immediate | yes |
| Slow faded | recovery | very low | no | yes, short |

---

## Cadence Rules

### 1. Setup should never overpower payoff
`Plant` feedback may confirm success, but it should clear the stage for the next meaningful beat quickly.

#### Rule
If a plant confirmation is still visually present when a crack/progress or payout beat occurs nearby, the later beat should visually win.

Implication:
- planting popup should stay shorter than crack progress
- planting banner detail should stay brief

---

### 2. Crack progress must support payout, not compete with it
Progress hits are important because they pace the action, but they are not the reward climax.

#### Rule
The final payout beat must read as clearly stronger than any `2 Left` / `Final Hit` progress moment.

Practical intent:
- progress popup lifetime stays shorter than payout
- progress wording stays ultra-compact
- payout may keep slightly longer linger and/or stronger contrast tier

---

### 3. Purchase should survive recent farming noise
A plaza buy often happens seconds after a payout. The player should still feel the plaza spend as a meaningful beat, not as leftover farming chatter.

#### Rule
When a purchase happens, recent low-tier nearby reward clutter should not visually dilute the buy moment.

Authoring intent:
- purchase popup text stays short and benefit-first (`Footwork Up`)
- cannot-afford and maxed remain banner-only so plaza space stays clean
- purchase beat should feel at least as distinct as payout, even if not louder than danger

---

### 4. Danger always interrupts the rhythm
A goblin slow is not just another notification. It changes immediate decision-making.

#### Rule
If slow is applied near the same window as another positive event, danger owns the dominant read.

Implication:
- slow popup remains immediate and player-anchored
- danger banner can overwrite a low-tier positive beat
- reward events do not need extra escalation to fight danger

---

### 5. Recovery should yield to almost everything
`Slow faded` is useful, but it should not steal focus from a fresh reward or danger event.

#### Rule
Slow recovery remains banner-only and should be treated as the first message allowed to yield when a stronger beat lands nearby.

This keeps recovery clear without adding churn.

---

## Suppression / Yield Budget
These are behavioral budgets, not exact engine mandates.

### Local popup yield window
If two events share the same local play slice within a very short interval, prefer one strong popup over stacked equal-weight popups.

Use this preference order:
- danger > buy > payout > crack > heal > plant

Lower-priority event handling:
- shorten lifetime, or
- allow the later stronger event to visually own the space, or
- omit world popup if the banner already carries enough meaning

### Banner yield rule
Banner can stay last-event-wins, but low-tier states should not force long linger.

Preferred yield order:
- slow faded
- cannot afford / maxed
- plant
- heal
- crack progress
- payout / buy / slow applied

### Same-bucket discipline
When several world popups originate from nearly the same place in quick succession, keep the text shorter rather than adding more explanatory copy.

Hard rule:
- never solve overlap by making popup sentences longer

---

## Surface Dominance Rules

### Banner
Use banner for semantic clarity and next-step consequence.

### World popup
Use world popup for spatial/emotional punctuation.

### Dominance rule
If one event needs both surfaces to be understood, that is acceptable.
If two events both want both surfaces at once, the higher-priority event should own the emotional read and the lower-priority event should become shorter, quieter, or banner-only.

---

## Player-Experience Targets

### Normal farming loop
The player should feel:
- heal = useful
- plant = acknowledged
- crack = paced
- payout = satisfying

### Plaza return
The player should feel:
- the buy moment resets momentum cleanly
- plaza feedback feels local and intentional
- plaza text does not collapse into clutter

### Danger contact
The player should feel:
- interruption is immediate
- the state change is readable before optimization thoughts resume

### Recovery
The player should feel:
- state cleared, no ceremony needed

---

## Server / Client Follow-through

### Client
Keep current banner + world-popup architecture.
This pass mainly needs small tuning support, not new systems.

Helpful implementation levers if needed:
- per-intensity duration tuning
- optional local suppression by nearby popup bucket
- preserving short popup strings

### Services
- `SwallowService`: keep warm, short resource-gain cadence
- `PumpkinService`: ensure crack progress yields to payout
- `UpgradeService`: keep purchase payoff benefit-first and uncluttered
- goblin/slow flow: preserve interruption priority; keep slow-faded quiet

### Data model
No new persistent state required.
No new replicated gameplay state required.

---

## Failure / Edge Cases
- **Plant then immediately crack:** plant confirmation may exist, but crack progress should become the more meaningful active beat.
- **Final hit followed immediately by buy:** plaza buy should still read cleanly as a new progression beat rather than getting buried under payout residue.
- **Slow fades during farming:** recovery should quietly yield if payout or crack feedback is fresher and more important.
- **Repeated failed purchases:** banner-only handling remains correct; do not add plaza popup spam.
- **Busy multiplayer frame:** the local player's strongest nearby beat should remain readable even if other ambient popups exist.

---

## Validation Plan
1. Heal once and confirm the gain feels warm but not oversized.
2. Plant and immediately start breaking; confirm plant does not visually compete with crack progress.
3. Run several full pumpkin cycles; confirm payout remains the strongest farming beat.
4. Buy an upgrade within seconds of a payout; confirm the purchase still feels distinct and local.
5. Trigger cannot-afford and maxed cases; confirm they stay banner-only and do not pollute plaza space.
6. Get slowed near other recent loop events; confirm danger owns the read.
7. Let slow fade during ordinary play; confirm recovery is clear but easy to yield.
8. Repeat the loop quickly in Studio and confirm the overall rhythm feels authored rather than chatty.

---

## Recommended Hand-off
### PM
Use this as a precision follow-through under MG-PM-408's live readability validation, especially the popup-overlap and reward-feel parts.

### Dev
If Studio shows noise, tune in this order:
1. shorten low-tier popup linger
2. keep low-tier world text ultra-short
3. let stronger nearby events visually win
4. only then add small bucket-level suppression if clutter remains

This keeps the game inside refinement mode: same loop, cleaner rhythm, stronger payoff.
