# Adopted Design

## Chosen Candidate
Candidate 1 — Lane Landmark Grammar

## Why Chosen
This is the highest-value refinement now because the current loop already explains itself through HUD, prompts, and feedback text. What it still lacks is a compact rule set for how the *space itself* stays coherent when minor tuning happens.

The goal is not to make the map bigger or prettier. The goal is to make each lane keep a stable readable identity:
- village lane = kindness / first task
- center lane = harvest transition / player ownership
- plaza = brief decision island
- danger lane = visible risk

That improves flow clarity, placement consistency, and polish inside the existing structure.

## Why Others Were Rejected
- **Center Lane Ownership Contract:** useful, but too local. It should be absorbed into a broader lane grammar.
- **Danger Telegraph Contract:** important, but prior docs already cover much of its validation logic. The bigger need is a whole-map consistency rule set.

## Player Flow
1. Spawn and immediately read the leftward village route as the first meaningful movement.
2. Heal in the village and naturally turn back through a center corridor that feels like the player's work lane.
3. Plant and break in that corridor without the plaza stealing ownership of the action.
4. Step into the plaza only when choosing to spend.
5. Cross into the danger route only when intentionally taking risk, with visible warning before contact.

## Quest / State Flow
- Spawn / zero resources -> village-first lane read
- Seed gained -> center-lane plant/break ownership
- Money threshold reached -> plaza commitment read
- Plaza exit -> either back to village loop or deliberate danger push
- Danger contact -> retreat lane remains legible

## World Objects
- NPCs:
  - Swallows own the village action band.
  - Goblins own the danger motion band.
- prompts:
  - Prompt dominance should reinforce lane purpose, not override it.
- map props:
  - lanterns, rocks, signs, paths, plaza pads stay as the full vocabulary for this pass.
- interaction points:
  - village: heal
  - center: plant / break
  - plaza: buy
  - danger edge: warning / slow threat

## Server Design
- No gameplay logic changes required.
- Existing services remain the same.
- Any follow-through should come through small positional, prompt-distance, or billboard-copy adjustments in `ArcadeWorld` and existing config values.

## Client Design
- HUD remains the semantic coach.
- World composition should do more of the quiet guidance work before the HUD has to rescue clarity.
- No new HUD panels, warnings, arrows, or minimap.

## Data Model
- No new persistent data.
- No new replicated state.
- Existing config values remain sufficient; this pass mainly adds placement rules and authoring constraints.

## Landmark Grammar

### 1. Village Lane Grammar
**Purpose**
Teach the first step of the loop before the player needs to decode systems.

**Primary read**
- healing / kindness / safety / purpose

**Allowed dominant cues**
- greener ground tone
- warm lantern guidance
- visible swallow spacing
- short zone sign that reinforces healing

**Must stay secondary**
- plaza spend copy
- danger silhouettes
- long billboard reading time

**Rule**
When standing near spawn or entering the left path, the village should read as the easiest first commitment without needing a tutorial overlay.

### 2. Center Lane Grammar
**Purpose**
Act as the player's working corridor between seed gain and money conversion.

**Primary read**
- ownership / planting / breaking / temporary work space

**Allowed dominant cues**
- clear walk strip back toward center
- enough breathing room for one owned pumpkin to feel local and intentional
- restrained support from nearby plaza visuals

**Must stay secondary**
- multi-pad `Buy` prompt noise
- billboard walls from plaza pads
- decorative objects that make the lane feel claimed by the plaza

**Rule**
A normal planted pumpkin should read as *my current job in the lane*, not *part of the shop area*.

### 3. Plaza Grammar
**Purpose**
Be a calm decision island for spending, not a constant ambient demand.

**Primary read**
- choice / reset / commit-to-buy

**Allowed dominant cues**
- three distinct pads
- one approached pad at a time
- short role-specific upgrade copy

**Must stay secondary**
- plant/break ownership
- repeated cannot-afford clutter
- signs large enough to merge into one text wall

**Rule**
The plaza should feel quiet until entered, then clear once committed.

### 4. Danger Lane Grammar
**Purpose**
Signal "you are crossing into risk" before the slow lands.

**Primary read**
- threat / interruption / caution

**Allowed dominant cues**
- darker material and prop tone
- visible goblin motion or silhouette before first hit
- path shape that still leaves retreat readable

**Must stay secondary**
- over-occluding rocks
- text-heavy warning dependency
- random-feeling first contact from blind angles

**Rule**
The player should feel warned by the lane itself, not only informed afterward by feedback.

## Placement Consistency Rules

### Lane ownership rule
Each route slice should have one clear owner:
- village owns heal intention
- center owns plant/break intention
- plaza owns buy intention
- danger route owns risk intention

If one lane starts teaching another lane's purpose more loudly than its own, the space has drifted.

### Prop role rule
Use existing props as support, not clutter.
- lanterns = lane flavor / path reassurance
- signs = short orientation reinforcement
- rocks = danger silhouette framing, not full visibility blockers
- pads = interaction commitment points

### Sign discipline rule
Signs should explain lane purpose in one short beat.
If the player must slow down to read a paragraph, the sign is doing too much.

### Transition rule
The route should hand off intention cleanly:
- spawn hands off to village
- village hands off to center work lane
- center hands off to plaza or back-loop choice
- plaza hands off to danger or return

Transitions should feel like role changes, not like entering visual ambiguity.

## Failure / Edge Cases
- if a planted pumpkin sits visually inside plaza ownership, tune pad spacing / prompt reach before adding plant restrictions
- if the village-first read weakens, shorten plaza sign authority before enlarging village cues
- if danger feels unfair, first reduce occlusion or improve first-contact sightline before adding more warning text
- if future prop additions make two lanes read the same, remove or subordinate the weaker prop instead of compensating with more UI

## Validation Method
Use this pass alongside the Studio validation contract.

### Scene checks
1. From spawn, confirm the village lane wins the first-read race.
2. Returning from the village, confirm the center lane feels like a work corridor, not shop spillover.
3. Plant in ordinary positions and confirm the pumpkin owns the local task read.
4. Step into the plaza and confirm one pad becomes the current commitment without billboard wall clutter.
5. Push toward danger and confirm warning is readable before first goblin contact.
6. Retreat after slow and confirm the path back to center/plaza remains obvious.

### Pass criteria
- lane identity is readable before full text decoding
- each interaction type feels spatially "at home" in its route slice
- small fixes can be described as restoring lane grammar, not inventing new micro-rules

## MVP Cut Line
- document the lane grammar
- use it as the tie-breaker for any future map-spacing/readability tweaks
- keep any implementation follow-through limited to copy trims, offsets, prompt distances, and small prop/pad/rock nudges

## Future Extensions
- If the project later adds richer art dressing, all new props should inherit this grammar rather than increasing density.
- If the loop expands, new route slices should be authored with a single lane owner from the start.
- No further expansion is needed for this pass right now.