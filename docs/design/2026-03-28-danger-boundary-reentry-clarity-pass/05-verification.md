# Verification

## Checklist

### Why this is needed now
- [x] targets a real completion gap inside the active arcade loop
- [x] improves flow clarity / readability / placement coherence without adding scope
- [x] stays aligned with refinement mode

### Player action clarity
- [x] explains what the player is doing when entering danger
- [x] explains how retreat should read
- [x] explains what the next safe-side step should become

### State transition coverage
- [x] danger entry -> slow/interruption -> retreat -> recovery -> loop re-entry is explicitly covered
- [x] normal loop priority after recovery is explicitly restated
- [x] ambiguous safe-side cases are handled with examples

### World / object coverage
- [x] boundary landmarks are covered
- [x] retreat corridor / clutter / prompt competition are covered
- [x] no new world system is required

### Server / client / data coverage
- [x] client feedback ownership is addressed
- [x] world/service follow-through points are identified
- [x] no new persistent data model is required
- [x] no new remote is required

### Failure / exception coverage
- [x] edge cases for partial retreat, immediate re-engage, plaza-adjacent retreat, multiplayer noise, and high movement speed are covered

### Validation coverage
- [x] contains a Studio/playtest checklist with observable pass/fail questions

## Final judgment
This pass is valid as a low-scope refinement artifact.

It does not expand MagicGourd beyond the current arcade structure.
It sharpens a remaining precision gap where danger pressure hands the player back into the main loop.

## Recommended next action
Do not implement speculatively.
Use this artifact if Studio/live validation shows that the goblin danger lane is readable on entry but still slightly loose on retreat or recovery.