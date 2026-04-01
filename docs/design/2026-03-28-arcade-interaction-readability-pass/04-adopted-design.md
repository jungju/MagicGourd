# Adopted Design

## Chosen Candidate
Candidate A — Contextual Next-Action HUD Guidance

## Why Chosen
This is the best next refinement because the current arcade structure is already small, mechanical, and shippable. The remaining weakness is not missing content. It is **priority readability**.

Right now the player can eventually understand the loop, but the HUD still behaves more like a static info card than a play partner. A refinement pass should make the game answer these questions instantly:
- What should I do right now?
- Why can't I do the next thing yet?
- Is danger my main problem or is economy my main problem?
- Which upgrade is worth returning to plaza for?

## Why Others Were Rejected
- **Candidate B — Upgrade Readability Cards:** valuable, but it should sit inside a broader guidance hierarchy instead of becoming the whole pass.
- **Candidate C — Precision Feedback Taxonomy:** useful support, but reactive feedback is weaker than improving the live next-action read.
- **Candidate D — Prompt / Copy Consistency Pass:** should still happen, but as a supporting authoring rule rather than the primary refinement target.

## Design Summary
Keep the current HUD shell and input model, but reorganize its authority:
1. **Primary guidance line** says the best next action.
2. **Status line** says the most important current condition.
3. **Resource block** stays compact and readable.
4. **Upgrade rows** expose affordability and next benefit more clearly.
5. **Feedback banner** uses clearer event-specific copy, but stays secondary.

This is not a new tutorial system. It is a **live readability layer** that turns existing state into better-ranked UI.

---

## Player Experience Goal
### In the first minute
A player should understand:
- swallows are the seed source
- seeds become pumpkins
- pumpkins become money
- money buys upgrades in the plaza
- goblins interrupt the loop by slowing you

### In repeated play
A player should be able to glance once and know whether they should:
- go left to heal
- plant now
- finish pumpkins for cash
- return to plaza to spend
- back out of Nolbu danger until slow wears off

### Shared goal
The HUD should feel like a quiet, competent coach — not a wall of text and not a tutorial pop-up machine.

---

## Scope Boundary
This design is **not**:
- a quest log
- a modal tutorial sequence
- new minimap or waypoint UI
- new progression content
- a rewrite of prompt networking
- a story-mode comeback

This design **is**:
- one derived next-action string
- one derived status string with stronger priority rules
- clearer upgrade-read rows inside the current panel
- feedback copy cleanup
- prompt wording consistency rules

---

## Information Hierarchy

### 1. Primary guidance
Add a dedicated high-read line in the HUD for **Next Step**.

Examples:
- `Next: Heal a swallow in Heungbu Village for seeds.`
- `Next: Plant a pumpkin nearby with Q.`
- `Next: Break your pumpkin for coins.`
- `Next: Return to Central Plaza — you can afford an upgrade.`
- `Next: Shake off the goblin slow before pushing deeper.`

#### Rule
Only one message owns this slot at a time. No rotating tips while a clear actionable priority exists.

### 2. Status line
Keep the status line shorter and more stateful than the current generic clear/slow text.

Examples:
- `Status: Safe to farm`
- `Status: Seed-ready`
- `Status: Upgrade available`
- `Status: Goblin slow active`

#### Rule
Status should summarize current condition. Primary guidance should tell the player what to do.

### 3. Tip line
The existing tip line becomes low-priority support text.

Examples:
- `Loop: heal -> plant -> break -> upgrade.`
- `Goblins do not steal progress; they waste time.`
- `Use the plaza when one upgrade changes your pace.`

#### Rule
Tips should be stable and sparse. They should not compete with the primary guidance line.

---

## Guidance Priority Rules
Use deterministic ranking instead of frequent copy churn.

### Highest priority states
1. **Slowed by goblin**
   - guidance: avoid danger / recover positioning
   - reason: immediate threat beats economy optimization
2. **No seeds**
   - guidance: heal a swallow
3. **Has seeds**
   - guidance: plant with Q if no better urgent condition exists
4. **Can afford at least one upgrade**
   - guidance: return to plaza after current safe action window
5. **Has no seeds but has money below first cost**
   - guidance: keep running loop from swallow side

### Tie-break rule
If the player is slowed, danger owns the top slot.
Otherwise, actionable economy steps should prefer the earliest missing link in the loop:
- no seeds -> heal
- seeds -> plant
- money and affordable upgrade -> spend

### Anti-thrash rule
Do not rewrite the guidance line every frame due to tiny state changes. Only refresh when one of these changes:
- seed count crossing 0
- money crossing an upgrade threshold
- slowed toggles on/off
- optional owned-pumpkin presence if that data becomes easy to read

---

## Upgrade Readability Rules
Keep the three existing upgrade rows, but make each row answer four questions quickly:
- what is this
- what level am I on
- what do I get next
- can I buy it now

### Row structure recommendation
`Footwork Lv.1 -> Lv.2 | 40 coins | Affordable`
`Quick Hands Lv.0 -> faster hits | 20 coins | Buy now`
`Blessing Lv.3 | MAX`

### Copy rules
- If affordable, use confident wording: `Buy now` or `Affordable`
- If not affordable, show missing amount only if it helps, for example: `Need 12 more`
- If maxed, replace cost text with `MAX`
- Keep flavor short; the line should read as decision UI first, flavor second

### Visual emphasis rule
Affordable rows should be brighter than non-affordable ones.
Maxed rows should read complete, not disabled/confusing.

---

## Feedback Precision Rules
The existing banner remains temporary, but the copy should become more semantically distinct.

### Event buckets
- **Swallow heal success:** kindness / gain framing
- **Seed use success:** ownership / placement framing
- **Seed use fail:** blocked / no-space / no-seed framing
- **Pumpkin break success:** payout / harvest framing
- **Upgrade bought:** progression / empowerment framing
- **Cannot afford upgrade:** cost framing
- **Maxed upgrade:** completion framing
- **Goblin slow applied:** danger / recovery framing
- **Slow ended:** relief / back-to-loop framing

### Examples
- `Swallow healed. Seeds gained.`
- `Pumpkin planted. Break it before it fades.`
- `20 coins spent. Footwork feels lighter already.`
- `Goblin hit — movement slowed.`
- `Slow faded. Back to full pace.`

### Rule
Feedback should explain consequence, not restate button input.

---

## Prompt / Copy Consistency Rules
Action words should stay stable across prompts, buttons, and feedback.

### Verb map
- swallow -> `Heal`
- seed action -> `Plant`
- pumpkin action -> `Break`
- plaza pad -> `Buy`
- danger warning -> `Avoid` / `Recover`

### Naming rule
Avoid mixing synonyms like `use`, `spawn`, `drop`, `cash in`, and `hit` in player-facing text unless there is a clear thematic reason.
The code can still use old remote names; this is a presentation cleanup.

Preferred player-facing phrasing:
- button: `Plant Pumpkin [Q]`
- no-seed button: `Need Seeds`
- pumpkin prompt: `Break Pumpkin`
- swallow prompt: `Heal Swallow`
- upgrade prompt: `Buy Footwork`

---

## Data / Runtime Design

### Inputs already available
- `Seeds`
- `Money`
- `MoveSpeedLevel`
- `AttackSpeedLevel`
- `SeedMultiplierLevel`
- `IsSlowed`
- upgrade costs / value tables from `ArcadeConfig`

### Recommended client helpers
- `getAffordableUpgradeIds(money)`
- `getPrimaryGuidance(playerState)`
- `getStatusSummary(playerState)`
- `formatUpgradeRow(upgradeId, money, level)`
- `getSupportTip(playerState)`

### Guidance derivation order
1. pull current player attributes
2. derive slowed state
3. derive seed state
4. derive affordable upgrades
5. choose one primary guidance string
6. choose one status summary string
7. format upgrade rows
8. refresh button text and support tip

### State model rule
Keep this fully derived on the client. No new replication or save data should be introduced for this pass.

---

## HUD Layout Recommendation
Reuse the current top-left panel with small hierarchy changes.

### Recommended order
1. Title
2. Resources
3. **Next Step** line
4. Status line
5. Upgrade section
6. Tip/support line

### Why
The current panel places upgrades before the most important live instruction. That is backwards for first-read clarity.

### Size rule
Only grow the panel if needed for legibility. Prefer tighter copy and better ordering before adding height.

---

## Client / Presentation Design
- Keep the existing bottom-center action button.
- Rename it toward planting clarity.
- If seeds > 0: `Plant Pumpkin [Q]`
- If seeds == 0: `Need Seeds — Heal a swallow first`

### Button rule
The button should communicate the immediate purpose first, not the implementation detail.
`Use Seed` is functional but weaker than `Plant Pumpkin`.

### Danger read
When slowed:
- status line turns urgent
- next-step line prioritizes recovery
- button can remain usable if mechanics allow, but copy should not imply safety

### Low-clutter rule
Do not add a second banner, flashing arrows, or big modal warnings for the slowed state. Color + priority text is enough.

---

## Failure / Edge Cases
- **Player has money for upgrades but chooses to keep farming:** allowed; guidance suggests, not forces.
- **Player rapidly crosses affordability thresholds:** anti-thrash rule keeps copy readable.
- **All upgrades maxed:** guidance falls back to the core loop instead of pointing at plaza.
- **Player is slowed while holding seeds:** danger wins the top guidance slot.
- **Prompt wording in world cannot all be updated immediately:** UI copy can ship first; prompt naming cleanup can trail slightly.
- **Owned-pumpkin state is not cheaply available on client:** keep guidance based on seeds/money/slowed only for MVP.

---

## Validation Plan
1. Join fresh with zero resources.
2. Confirm HUD clearly says to heal a swallow first.
3. Heal one swallow and confirm the guidance flips to planting.
4. Plant and break pumpkins until reaching 20 coins.
5. Confirm the HUD explicitly surfaces upgrade affordability.
6. Buy one upgrade and confirm the row updates to the next level/cost cleanly.
7. Enter Nolbu Area, get slowed, and confirm danger takes priority over farming guidance.
8. Wait for slow recovery and confirm guidance returns to the loop without stale warning text.
9. Max one upgrade and confirm it reads `MAX` without confusion.
10. Confirm feedback banner copy feels distinct by event type, not samey.

---

## MVP Cut Line
- one `Next:` guidance line
- one better `Status:` line
- clearer upgrade row formatting
- planting-focused action button copy
- event-specific feedback text buckets
- prompt verb consistency rules for follow-through

## Post-MVP Extensions
- detect local owned pumpkin presence for even better next-step ranking
- subtle highlight on the cheapest affordable upgrade row
- optional zone-aware support tip copy
- one compact beginner-mode variant if onboarding still underperforms

## Recommended PM / Dev Hand-off
### PM should break this into
1. guidance priority copy table
2. status summary copy table
3. upgrade row formatting rules
4. button/prompt naming cleanup
5. feedback copy buckets

### Dev should implement in this order
1. add derived guidance + status helpers
2. reorder HUD hierarchy
3. reformat upgrade rows with affordability/max states
4. rename planting button and related player-facing strings
5. refine feedback messages to event-specific wording

This keeps the work tightly inside refinement mode: no new mechanics, much better readability.