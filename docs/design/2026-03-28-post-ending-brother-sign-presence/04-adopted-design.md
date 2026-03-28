# Adopted Design

## Chosen Candidate
Post-ending brother sign presence

## Why Chosen
The post-ending loop already had:
- brother revisit dialogue
- witness barks
- Story Stone reflections
- support-point rotations

But the brothers' own world billboards were still mostly generic. That meant the valley aftermath was readable **after interaction**, not **while moving through the village**.

This pass makes the ending consequence visible at a glance.

## Scope
Add branch-aware, tier-aware, and lightly support-point-aware billboard body text for:
- Heungbu's talk node
- Nolbu's talk node

Rules:
- no new quest
- no reward changes
- no new UI widgets
- no cutscenes
- reuse existing ambient ending state and village landmark/support-point helpers

## Player Value
- Players can feel the chosen ending sooner, before clicking prompts.
- Heungbu/Nolbu feel like they continue living inside the aftermath.
- The village reads more coherently as a playable post-ending space rather than a set of isolated dialogue triggers.

## Implementation Notes
- Add a small server helper that derives global sign copy from:
  - ambient ending branch
  - village landmark tier
  - active village support point
- Keep copy short enough for billboard readability.
- Fall back to pre-ending summary text when no ending ambient mode is active.
- Refresh through the existing `refreshVillageSigns()` path.

## Validation
1. Finish restoration and confirm both brother billboards change tone.
2. Rotate restoration support points and confirm at least one sign reacts.
3. Raise restoration to higher tier and confirm wording upgrades.
4. Repeat for tribute.
5. Confirm pre-ending flow still shows generic summary text.
