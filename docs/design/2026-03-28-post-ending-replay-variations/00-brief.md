# Brief

## Context
`docs/pm/TASKS.md` currently marks **MG-PM-106 Post-ending ambient follow-through** as done and explicitly recommends the next new work as **richer post-ending replay variations beyond the current ambient aftermath**.

The current code/design baseline already provides:
- resolved ending state (`endingChoice`, `endingResolved`)
- branch-aware patch mood, signs, and ambient dialogue
- branch accent props
- free-play farming after `COMPLETE`

So the next design should not reopen the main questline. It should add a **small repeatable post-ending activity layer** that makes each ending feel playable for a few extra minutes.

## Problem
After the player finishes the story, the world now *looks* more branch-aware, but there is still only limited branch-specific action. The ending consequence reads well on first revisit, yet free play still converges quickly back to generic farming.

## Goal
Design the next high-value post-ending system that:
- builds directly on existing `COMPLETE` free play
- differentiates restoration vs tribute through action, not only text
- stays lightweight enough for the next PM/Dev pass
- avoids save rewrites, schedule systems, or large new economy loops

## Non-Goals
- no new main-story chapter
- no persistent cross-session progression redesign
- no heavy NPC AI scheduling
- no large asset/Studio-dependent content pack

## Expected Output
A design for compact branch-specific repeatable interactions that can be layered onto the current aftermath implementation with low risk.