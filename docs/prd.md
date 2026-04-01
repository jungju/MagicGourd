# Product Requirements Document

## Product Statement

`MagicGourd` should ship as a clear, replayable, Heungbu-themed multiplayer arcade loop built on the current Roblox + Rojo codebase.

This PRD is intentionally grounded in the current repo baseline, not an idealized rewrite.

## Current Product Shape

- Shared world
- Session-based economy
- Server-authored gameplay state
- Attribute-driven client HUD
- Runtime-generated arena over a Rojo-managed map backdrop

## Pillars

See [docs/pillars.md](pillars.md).

## Primary Player Promise

Players should understand what to do within one short run:
- heal
- plant
- break
- buy
- repeat

## Feature Buckets

### 1. Core Loop Integrity

- swallow interaction
- seed gain
- pumpkin ownership and payoff
- upgrade economy
- goblin risk

### 2. Multiplayer Fairness

- remote authority
- ownership validation
- shared-world readability
- cleanup on player leave

### 3. Readability and Guidance

- HUD next-step clarity
- zone readability
- prompt hierarchy
- event feedback clarity

### 4. Operational Stability

- Rojo-safe structure
- truthful docs
- slice discipline
- validation workflows

## MVP Boundaries

### In

- current shared arcade loop
- three upgrade tracks
- goblin slow pressure
- server-authoritative multiplayer fairness
- runtime world rebuild
- Studio/MCP-assisted smoke validation

### Out

- persistent save progression
- building / housing systems
- land ownership
- branching endings as active gameplay
- speculative large-scale source-tree reorganization

## Acceptance Direction

The current product direction is acceptable when:
- the loop is understandable quickly
- multiplayer ownership is fair
- the repo can be evolved one slice at a time without structural chaos
- docs and ops artifacts stay aligned with live behavior

## Confirmed Facts

- Rojo build is the primary confirmed repo-local build surface.
- The current live remote contract is `HealSwallow`, `UseSeed`, `HitPumpkin`, and `ArcadeFeedback`.
- No repo-local persistence system exists yet.

## Assumptions

- The next major value is safer iteration and validation discipline, not a large gameplay pivot.
- Future monetization, persistence, and broader progression should be designed as explicit slices instead of being implied by current scaffolding.
