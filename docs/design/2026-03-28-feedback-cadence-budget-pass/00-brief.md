# Brief

## Context
MagicGourd is in refinement mode. The current arcade loop already has:
- canonical action verbs (`Heal`, `Plant`, `Break`, `Buy`)
- contextual HUD guidance
- world-anchored reward/danger popups
- a Studio validation contract for readability

The highest-value remaining precision gap inside the current structure is **fast-loop feedback cadence**.

Current docs define **what** feedback says and **where** it appears, but they do not yet define a tight budget for **when** one feedback beat should dominate, yield, or stay quiet during repeated loop play.

That matters most in the active arcade slice because the player can now cycle:
1. heal
2. plant
3. crack
4. payout
5. buy

quickly enough that good individual feedback can still combine into noisy overall cadence.

## Goal
Create a refinement-only cadence budget so reward feel stays strong while popup/banner overlap stays readable.

## Scope
In scope:
- feedback priority order
- minimum suppression / yield rules between nearby events
- cadence intent for heal / plant / crack / payout / buy / slow / slow-fade
- lightweight validation guidance for Studio

Out of scope:
- new effects systems
- new UI surfaces
- new mechanics
- new rewards or progression
- large layout changes

## Desired outcome
The loop should feel:
- clearer at speed
- more rewarding on payout and purchase
- less spammy on repeated crack/progress moments
- quieter on recovery/non-reward states
