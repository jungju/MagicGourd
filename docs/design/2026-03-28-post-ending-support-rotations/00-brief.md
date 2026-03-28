# Brief

## Feature
Post-ending support-point rotations

## Problem
The current post-ending branch errands now work and escalate, but they still happen at a single fixed point per branch. After a few hand-ins, the loop reads more like repeating one prop than tending a living village.

## Goal
Add a lightweight location-rotation layer so post-ending errands occasionally move between 2-3 nearby support points without becoming a chore board or a scheduling system.

## Why now
This is the next honest implementation target because:
- branch ambience already exists
- branch errands already exist in code
- milestone escalation already exists
- the current weakest point is spatial repetition, not reward depth

## MVP for this pass
- restoration errands can rotate between the shared basket, village well, and repaired yard marker area
- tribute errands can rotate between the road-due stand, Nolbu gate edge, and tribute basket route marker
- only one active support point per branch at a time
- rotation happens after a small completion threshold, not on a timer
- no quest-stage rewrite, no minimap, no request board, no NPC scheduler
