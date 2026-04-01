# Game Overview

## Confirmed Facts

- `MagicGourd` is a Roblox + Rojo project.
- The current live gameplay baseline in `src/` is a shared arcade loop, not the older branching-story structure.
- The world is split between a Rojo-managed backdrop in `src/workspace/JoseonBase` and runtime-authored gameplay objects under `Workspace/Map/Runtime`.
- Current session economy is attribute-driven and server-authored.
- Current shared gameplay contract is centered on:
  - healing swallows
  - planting owned pumpkins
  - breaking pumpkins for money
  - buying three plaza upgrades
  - dealing with goblin slow pressure

## Core Fantasy

Play as Heungbu inside a small shared folkloric space where kindness and quick action feed each other:
- help an injured swallow
- turn that help into immediate growth
- cash the result out quickly
- loop the reward back into stronger movement, harvesting, and setup

## Core Loop

1. Spawn in the Central Plaza.
2. Travel to Heungbu Village.
3. Heal an injured swallow.
4. Receive seeds immediately.
5. Use a seed to spawn an owned pumpkin near the player.
6. Break the pumpkin for money.
7. Spend money on Footwork, Quick Hands, or Blessing.
8. Re-enter the loop while managing goblin pressure from the Nolbu side.

## Progression

### Confirmed

- Progression is session-based.
- Upgrades currently improve:
  - movement speed
  - pumpkin break cadence
  - seed gain per swallow heal

### Current Boundary

- No repo-local persistence/save layer currently exists in source.
- No building, land ownership, house management, or crop growth timers are part of the live loop, even though the map now includes static Heungbu/Nolbu house dressing.

## Player Goals

### Short-Term

- understand the loop quickly
- keep planting and cashing out without stalling
- avoid losing tempo to goblin slow pressure

### Mid-Term

- unlock all three upgrade tracks
- optimize route choice between village, work lane, plaza, and danger boundary

## Session Length

### Confirmed

- The loop is authored for immediate feedback and short traversal.

### Assumptions

- Intended session length is likely short-to-medium arcade play, roughly 5-15 minutes per session, based on the current loop speed and lack of persistent progression.
- If future design wants longer-term retention, that should be added explicitly rather than implied by the current repo.

## UI Flow

### Confirmed

- The current client owns a compact HUD, next-step guidance, status messaging, upgrade readability, a seed-use button, and local prompt/readability handling.
- The server drives authoritative game state and pushes feedback through remotes and replicated attributes.

## Assumptions

- The repo wants to keep the current arcade baseline and iterate through validation/refinement slices rather than reopening the archived story prototype by default.
