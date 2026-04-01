# Architecture

This document describes the current repo architecture as it exists today.

## Rojo Mapping

- `src/server` -> `ServerScriptService/Server`
- `src/client` -> `StarterPlayer/StarterPlayerScripts/Client`
- `src/shared` -> `ReplicatedStorage/Shared`
- `src/workspace` -> `Workspace/Map`

`default.project.json` is the authoritative mapping file for this structure.

## Current Module Boundaries

### Server

- `src/server/init.server.luau`
  - thin bootstrap
- `src/server/ArcadeRuntime.luau`
  - startup composition
  - remote ensuring
  - world/service wiring
- `src/server/ArcadeWorld.luau`
  - runtime arena build
  - zone signage, props, prompts, and lane landmarks
- `src/server/PlayerStateService.luau`
  - player economy state
  - upgrade levels
  - walk speed and slow state application
- `src/server/SwallowService.luau`
  - shared swallow lifecycle
  - heal validation
  - seed rewards
- `src/server/PumpkinService.luau`
  - planting
  - ownership
  - hit validation
  - rewards
  - timeout and leave cleanup
- `src/server/GoblinService.luau`
  - goblin spawn and chase behavior
  - slow-on-contact behavior
- `src/server/UpgradeService.luau`
  - plaza prompt purchases
  - upgrade feedback

### Client

- `src/client/init.client.luau`
  - HUD creation
  - next-step guidance
  - prompt ownership/readability logic
  - seed-use UI and keyboard input
  - local handling of replicated attributes and runtime objects
  - client feedback presentation

### Shared

- `src/shared/ArcadeConfig.luau`
  - remote names
  - replicated attribute names
  - zone/world tuning
  - pumpkin/swallow/goblin values
  - feedback timing/tuning values

## Runtime World Layers

### Rojo-Managed Base

- `src/workspace/JoseonBase`
  - base map geometry and backdrop content

### Runtime-Authored Layer

- `Workspace/Map/Runtime`
  - current gameplay arena
  - swallows
  - pumpkins
  - goblins
  - runtime prompts, signs, and props

## Remote Contracts

### Gameplay Intent

- `HealSwallow`
  - client requests a heal interaction
  - server validates distance/object existence and awards seeds

- `UseSeed`
  - client requests a plant action
  - server validates inventory and spawns an owned pumpkin

- `HitPumpkin`
  - client requests a break/hit action
  - server validates ownership, distance, cooldown, and health mutation

### Feedback

- `ArcadeFeedback`
  - server sends feedback payloads for HUD/banner/world-popup presentation

## Attribute Contracts

### Player

- `Seeds`
- `Money`
- `MoveSpeedLevel`
- `AttackSpeedLevel`
- `SeedMultiplierLevel`
- `IsSlowed`

### Pumpkin / Interactables

- `owner`
- `Health`
- `ExpiresAt`
- `InteractionKind`
- `EntityId`
- `UpgradeId`

## Authority Model

- Client:
  - gathers input
  - routes prompt interactions
  - renders guidance and feedback
- Server:
  - validates all gameplay intent
  - mutates economy and shared state
  - owns reward logic and multiplayer fairness

This repo is currently server-authoritative for gameplay outcomes.

## Persistence Boundary

### Confirmed

- No repo-local DataStore/ProfileService/MemoryStore save implementation was found in `src/`.

### Current Implication

- The live baseline is session-based progression.
- Any future save schema work should be introduced explicitly as its own slice and documented as a new boundary.

## UI / Gameplay Orchestration

- Gameplay state is primarily driven by server-side services and replicated attributes.
- The client reacts to that state and resolves player-facing readability in one main LocalScript.
- This is not yet a heavily componentized UI architecture; docs and ops should reflect that truth instead of describing a nonexistent UI framework.
