# Adopted Design

## Chosen Slice
Candidate: Rare errand echo events

## Why chosen
This is the highest-value safe follow-up after support rotations, landmarks, route cues, and witness barks. The village already reacts structurally. What it lacks is occasional surprise texture inside the repeatable loop itself.

## Design Summary
When the player completes post-ending errands in `COMPLETE`, the game occasionally fires a small rare event variant. These are not new quests. They are short flavor beats that make the loop feel less flat.

### Restoration rare events should feel
- communal
- grateful
- lightly abundant
- like small kindness is multiplying

### Tribute rare events should feel
- procedural
- colder
- administratively efficient
- like the road is becoming more formal with each due

## Trigger rule
- only in post-ending errand completions
- only on light milestone cadence (safe deterministic cadence, not spam)
- branch-aware
- optionally aware of active support point and landmark tier

## Implementation plan
1. Add a table-driven rare-event definition layer in `init.server.luau`.
2. On successful ending errand completion, evaluate whether the current count should surface a rare event.
3. If yes, play one extra effect/dialogue beat after the normal errand feedback.
4. Keep rewards modest and infrequent.

## Reward rule
- restoration rare events may occasionally return a seed or +1 coin when framed as village reciprocity
- tribute rare events may occasionally return +1 inspection coin when framed as formal recognition
- never outscale the main errand loop

## Validation
- Restoration path: confirm at least one rare event appears after repeated shared drops and reads warmer than baseline.
- Tribute path: confirm at least one rare event appears after repeated dues and reads more official/colder than baseline.
- Confirm no new quest state opens and ordinary farming remains the dominant repeatable action.
