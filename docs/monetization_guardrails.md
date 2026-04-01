# Monetization Guardrails

`MagicGourd` does not currently ship a monetization layer in source. This document defines the guardrails for any future monetization work.

## Core Guardrails

### No Pay-to-Win

- Do not sell direct power that breaks multiplayer fairness.
- Do not sell exclusive access to core loop progression.
- Do not let paid advantages bypass the server-authoritative ownership and reward rules.

### Economy Integrity

- Preserve the session-based arcade loop as understandable and fair without payment.
- Paid systems must not invalidate the meaning of seeds, money, upgrade pacing, or goblin pressure.
- If a monetized convenience is introduced later, document its interaction with the current economy explicitly.

### Reward Cadence

- Paid rewards must not compress the current loop so aggressively that the game stops reading as a loop.
- Reward pacing should remain legible to non-paying players in a shared world.

### UX Guardrails

- Do not interrupt healing, planting, breaking, or danger recovery with aggressive prompts.
- Do not put purchase pressure inside high-attention danger moments.
- Keep store/promotional surfaces separate from urgent gameplay guidance.

## Current Recommendation

If monetization is explored later, start with:
- cosmetic world or HUD variations
- non-competitive presentation customizations
- optional support-pack style content

Do not begin with:
- direct stat purchases
- paid exclusive upgrade tracks
- time skips for a system that does not currently use timers

## Assumptions

- Any future monetization work should be treated as its own slice with separate review against multiplayer fairness, economy integrity, and player trust.
