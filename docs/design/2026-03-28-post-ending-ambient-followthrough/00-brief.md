# Brief

## Feature
Post-ending ambient follow-through

## Why now
The current branching finale resolves correctly in quest/state terms, but the village only reflects that choice through HUD hints and a few billboard text changes. The next high-value step is to make the ending feel like it actually changed the place without introducing a new chapter-sized system.

## Problem
After the player chooses an ending, the world state becomes mechanically complete but emotionally thin. The decision lands in UI and dialogue, yet the village loop does not sustain enough visible consequence to make replay, free play, or screenshots feel distinct.

## Goal
Add a small, reliable layer of ambient world response so that:
- restoration ending feels warmer, more communal, and alive
- tribute ending feels orderly, tense, and extractive
- post-ending free play keeps carrying story tone instead of reverting to a generic farming sandbox

## Constraints
- must fit current prompt/dialogue/billboard/runtime-prop architecture
- no heavy cutscene, save migration, or large NPC content set
- should be implementable in a focused PM/Dev pass after current ending work
- should not thrash map docs or require Studio-only choreography for MVP

## Expected outcome
A compact system where ending choice drives ambient signage, patch tone, small world-state variations, and repeatable post-ending interactions that make the village feel materially different.