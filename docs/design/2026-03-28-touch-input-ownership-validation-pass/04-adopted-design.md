# Adopted Design

## Chosen Candidate
Candidate A — Touch-first input ownership contract

## Why chosen
MagicGourd already teaches the loop well on paper:
- HUD guidance is prioritized
- local prompts own nearby commitments
- the global seed CTA is demoted in stronger local contexts
- danger/recovery reads are cleaner

The remaining completion risk is that **touch play can still feel slightly negotiative instead of authored** if the player sees both a tappable CTA and a nearby world prompt during motion.

This pass closes that gap without changing mechanics.

## Why others were rejected
- **B** was too local; plaza spend is important, but not the whole touch problem.
- **C** was valuable but too state-specific.
- **D** was too weak; validation needs a design contract, not just scenes.

## Design goal
On touch/mobile, the player should always have one clearly implied commitment owner:
1. local prompt when a world interaction is the active commitment
2. bottom CTA when planting is the best available no-prompt action
3. HUD text as support, not as a competing action surface

The player should feel:
- `I know what tap matters right now.`
- `The plant button is available when useful, but not rude.`
- `Walking into a prompt space makes the intended action more obvious, not more crowded.`

## Scope boundary
This pass is **not**:
- a new touch control scheme
- a new contextual radial menu
- a new tutorial layer
- a platform-specific rebalance
- a redesign of prompt placement

This pass **is**:
- touch ownership rules
- CTA demotion/presence rules for mobile validation
- small timing/priority expectations
- exact validation scenes and fallback tuning order

## Core principle
Touch should preserve the same authored hierarchy already established elsewhere:

1. immediate danger / recovery state
2. active local world commitment
3. unresolved owned-object commitment
4. ready plant CTA
5. fallback loop guidance

The difference is surface behavior:
- touch players need clearer ownership between **screen-fixed CTA** and **world-space prompt**
- the same state priority must not produce two equally loud tap targets

## Input ownership contract

### 1. When a local prompt is active, the prompt owns the commit
If the player is inside an authored interaction space:
- swallow heal
- owned pumpkin break
- plaza buy

then the local prompt becomes the primary commitment owner.

#### Touch rule
The bottom CTA may remain visible only if it reads as clearly secondary.
It must not feel like an equally urgent parallel action.

#### Acceptable behavior
- CTA dims
- CTA label becomes less imperative
- CTA remains tappable only if it does not steal the expected read

#### Preferred behavior by context
- **Swallow nearby:** `Heal` should clearly outrank `Plant`
- **Owned pumpkin nearby:** `Break` should clearly outrank `Plant`
- **Plaza pad nearby:** `Buy` should clearly outrank `Plant`

### 2. Plant CTA owns only the no-prompt setup window
The bottom CTA should feel strongest when:
- the player has seeds
- no stronger local prompt is active
- no unresolved owned pumpkin is the more immediate loop beat
- the player is not in a slowed/recovery handoff that implies retreat or cash-out first

This is the clean touch fantasy:
`I have seeds and open space, so the bottom button is my next move.`

### 3. Prompt-entry grace should favor stability over flicker
Touch readability gets worse if ownership swaps too eagerly while the player brushes the edge of prompt radius.

#### Rule
Use a short prompt-entry/exit grace window so touch ownership feels sticky enough to read.

Desired result:
- walking near a swallow or plaza pad does not cause rapid CTA/prompt tug-of-war
- stepping fully into the interaction space makes the local prompt clearly own the moment
- stepping back out restores CTA ownership cleanly after a short settle window

### 4. Recovery state must not leave stale CTA dominance
When slow pressure clears, touch players should quickly regain one obvious action owner.

Priority after recovery:
1. owned pumpkin to break
2. plant CTA if seeds are ready and no stronger prompt exists
3. plaza buy if no seeds/pumpkin and a purchase is the clean reset
4. village return as fallback

#### Hard rule
Recovery should not leave the screen in a state where both `Plant` and a nearby local prompt feel equally primary.

### 5. Ambiguous multi-valid touch cases

#### Case A — seeds ready + plaza nearby
- Default owner: plaza prompt only if the player is meaningfully inside the pad's commitment space
- Otherwise: plant CTA owns the screen

Reason:
Touch should not let nearby plaza presence constantly suppress planting from ordinary center-lane movement.

#### Case B — seeds ready + owned pumpkin nearby
- Default owner: owned pumpkin prompt
- Plant CTA demotes

Reason:
The player already has unresolved personal value on the ground.

#### Case C — slowed near a prompt while exiting danger
- Default owner: retreat/recovery guidance first, then local prompt only after the player is safely back inside its intended space

Reason:
Touch should not invite a side interaction while the player still reads as under pressure.

## Surface contract

### Bottom CTA
The bottom CTA should answer one question only:
`Is planting the clean no-prompt action right now?`

If yes:
- it may be strong, bright, and direct

If no:
- it should either demote, soften, or temporarily back off

#### Copy rule
Do not solve touch ambiguity with longer CTA text.
Ownership should come from hierarchy first, wording second.

### World prompt
World prompts own local commitment certainty.
On touch, they should feel like the intentional answer to being physically in that space.

#### Rule
If a world prompt is the intended owner, do not let the CTA remain equally vivid.

### HUD guidance
The HUD still tells the player what the loop wants next.
But on touch it must not compete as a third action surface.

Rule:
- `Next:` explains
- prompt/CTA commits

## Validation scenes

### Scene 1 — Village heal approach on touch
1. Enter village while holding a seed.
2. Walk into swallow range.
3. Confirm `Heal` becomes the clear commitment owner.
4. Confirm the plant CTA does not feel equally primary.

Fail if:
- the CTA remains just as visually assertive as the heal prompt
- ownership flickers repeatedly while approaching at normal speed

### Scene 2 — Center-lane plant freedom on touch
1. Leave village with seeds.
2. Stand in the normal center planting lane, not deeply inside plaza pads.
3. Confirm plant CTA is the dominant owner.

Fail if:
- plaza presence suppresses plant too early
- the player must guess whether the lane is still a planting space

### Scene 3 — Owned pumpkin follow-through on touch
1. Plant a pumpkin.
2. Stay near the pumpkin while still having seeds.
3. Confirm `Break` owns the local moment and the CTA demotes.

Fail if:
- plant CTA continues to compete as if the unresolved pumpkin does not matter

### Scene 4 — Plaza spend approach on touch
1. Approach each upgrade pad from the center lane.
2. Confirm the pad prompt becomes primary only when the player meaningfully commits into that pad's space.
3. Confirm the CTA is secondary or softened during that commitment.

Fail if:
- pad approach feels ambiguous between buy and plant
- CTA suppression starts so early that center-lane planting feels stolen

### Scene 5 — Danger recovery on touch
1. Get slowed by a goblin.
2. Retreat into the safe side.
3. Let recovery clear.
4. Confirm the screen restores one obvious owner based on actual state.

Fail if:
- stale slow/recovery messaging delays action ownership too long
- nearby CTA and local prompt feel equally primary immediately after recovery

## Tuning order if validation fails
Use the smallest lever first:
1. prompt-entry/exit grace timing
2. CTA visual demotion strength
3. prompt distance / spatial commitment boundary
4. CTA temporary suppression windows in edge cases
5. copy trim only if hierarchy is correct but still reads muddy

Do **not** solve touch ambiguity by:
- adding a new button set
- adding large tutorial overlays
- globally hiding the CTA too often
- widening prompts until they steal ordinary movement space

## Server / client follow-through
No new server state required.
No new remote required.

Likely client touchpoints only:
- prompt activity tracking
- CTA emphasis/demotion state
- brief grace timing around prompt entry/exit
- recovery handoff timing

## Failure / edge cases
- **Player intentionally taps CTA instead of nearby prompt:** acceptable if the hierarchy was still readable; this pass is about clarity, not force-locking.
- **Very small screens:** preserve ownership contrast before adding more words.
- **Fast movement through plaza edge:** a short grace window should prevent oscillation.
- **Multiplayer overlap:** local ownership still wins; nearby remote actions must not become equally actionable on the local touch screen.

## Verification method
This pass succeeds if a tester can play one short mobile-oriented loop and consistently answer, without hesitation, what the primary tap target is in each state.

That is the real completion bar.
