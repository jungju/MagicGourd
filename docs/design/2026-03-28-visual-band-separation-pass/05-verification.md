# Verification

## Design Completeness Check
- [x] Refinement target stays inside the current arcade loop
- [x] No new mechanics, currencies, enemies, or routes added
- [x] Player-facing value is clear: easier action reading, cleaner reward feel, less text clutter
- [x] World-object implications are concrete: signs, prompts, popups, lane slices
- [x] Server/client follow-through is bounded and low-risk
- [x] Validation steps are explicit and Studio-friendly

## Why this is needed now
The project already solved many wording and anchoring issues. The remaining polish risk is layered readability drift: good individual surfaces that become messy when seen together. This artifact gives a small rule set for finishing that gap without reopening scope.

## Collision / Scope Check
- Does not conflict with the active arcade loop in `README.md`
- Reinforces the lane grammar, spatial budget, cadence budget, and anchor consistency docs
- Avoids duplicating their systems; instead it defines how those authored surfaces share the same frame

## Fun / Feel Check
Expected play-feel improvement:
- action moments feel cleaner
- reward beats feel less visually muffled
- plaza choices feel more intentional
- danger reads feel fairer because support signage stops competing with contact feedback

## Roblox / Rojo Check
- Works with current BillboardGui + ProximityPrompt + world-popup architecture
- Needs only small placement/copy/timing follow-through in existing files
- Safe to author incrementally without structural Rojo changes

## Ready-for-implementation Checklist
- [x] Prompt band rule defined
- [x] Feedback band rule defined
- [x] Support band rule defined
- [x] Zone-by-zone expectations documented
- [x] Overlap resolution order documented
- [x] Tuning order documented
- [x] Validation scenes documented

## Suggested follow-through
If Studio validation shows a real problem, apply the smallest fix that restores band separation:
1. shorten sign copy
2. adjust sign offset
3. reduce prompt competition
4. only then retune popup height/duration

If Studio does not show a real problem, leave the implementation alone and keep this artifact as a guardrail for later tuning.
