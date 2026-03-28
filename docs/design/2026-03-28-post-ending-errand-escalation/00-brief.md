# Brief

## Feature
Post-ending errand escalation

## Problem
The current `COMPLETE` branch errands already work, but after 1-2 hand-ins they flatten into a static loop. The player understands the branch flavor once, then stops getting fresh feedback.

## Goal
Keep the existing shared-basket / road-due errands lightweight while making repeated post-ending harvests feel like they are accumulating meaning.

## MVP for this pass
- restoration errand occasionally returns a seed to imply the village is replanting shared abundance
- tribute errand occasionally returns a small inspection bonus to imply the road now recognizes reliable compliance
- HUD hint and signage escalate once enough errands have been completed
- no new quest stage, no new UI panel, no heavy economy system
