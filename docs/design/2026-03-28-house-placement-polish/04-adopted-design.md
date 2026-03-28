# Adopted Design

## Chosen Candidate
Candidate 1 - Explicit House Placement Contract

## Why Chosen
It is the highest-value next implementation target because it fixes a current P1 visual weakness without opening a new gameplay system. The repo already has working story progression; what now looks cheapest in the experience is the house read. This candidate also converts today's brittle `rotate X by 90 and hope` behavior into an intentional contract that PM and Dev can both reason about.

## Why Others Were Rejected
- **Candidate 2 - Fallback-First Final Houses:** good emergency option, but too conservative while imported houses are still potentially salvageable.
- **Candidate 3 - Placement Calibration Layer:** useful later, but too tooling-heavy for the next handoff.

## Design Summary
Replace raw house placement guesswork with a **small per-house placement spec** that explicitly states:
1. what the asset's upright correction is
2. how it should face relative to the yard/pad
3. how its bottom should be anchored to the ground pad
4. what the fallback house should preserve if the imported asset fails

The goal is not a generic map editor. The goal is reliable placement for the two story-critical homes.

---

## Player Flow
1. Player spawns into the village.
2. Heungbu's house reads upright, modest, and open toward the patch/yard.
3. Nolbu's house reads upright, larger, and more assertively facing the estate road.
4. Dialogue/patrol/quest interactions happen against houses that now support the fiction instead of distracting from it.
5. If imported assets fail, fallback houses still occupy the same composition and facing, preserving the story read.

---

## State / World Flow
This feature does not add new quest stages. It changes the world composition contract around these existing runtime objects:
- `HeungbuHouse`
- `NolbuHouse`
- `HeungbuYardPad`
- `NolbuFrontYard`
- related talk prompts and billboards

### Placement flow
- resolve house spec
- load imported asset if available
- determine primary part / bounding box
- apply orientation correction first
- apply yaw/facing intent second
- anchor bottom to target pad height
- apply optional fine offsets
- if asset load fails, build fallback house using the same facing and footprint intent

---

## World Objects
### Reused
- runtime house pads
- house asset ids
- fallback houses
- talk prompt parts and signage

### New or adjusted concepts
- `placementSpec` per house
- `orientationCorrection` (for upside-down or sideways authored assets)
- `facingYaw` or `faceToward` intent
- `baseAnchor = boundingBoxBottom`
- optional `visualOffset`
- optional `padCenter` reference for composition consistency

### Hard constraint
The final system must stay readable in source control. Avoid opaque one-off transforms whose meaning only exists in someone's memory.

---

## Server Design
### Asset definition split
Current mixed house definitions should be separated conceptually into:
- **asset source**: asset id, kind, scale
- **placement spec**: target pad, correction rotation, facing, ground anchor, offsets, desired footprint feel

### Recommended house spec fields
For each major house:
- `padName`
- `position` or `padPosition`
- `orientationCorrection = Vector3.new(x, y, z)`
- `facingYaw`
- `groundOffset`
- `visualOffset = Vector3.new(x, y, z)`
- `scale`
- `fallbackFootprint`
- `narrativeRole = humble | imposing`

### Placement responsibilities
`applyPlacement()` should support a clearer order of operations:
1. compute corrected orientation from `orientationCorrection`
2. apply world-facing yaw/intended final rotation
3. pivot model
4. compute bounding-box bottom
5. lift/drop so the model bottom meets the target ground plane
6. apply optional visual offset for composition tuning

### Preferred simplification
For now, only houses use the richer spec. Do not generalize all runtime props into the same system yet.

### Fallback parity rule
Fallback houses must inherit:
- final yaw/facing
- ground anchor behavior
- intended footprint class (Heungbu smaller, Nolbu larger)

This prevents the fallback view from telling a different environmental story than the imported view.

---

## Client / Presentation Design
No dedicated client code is required.

Indirect player-facing goals:
- Heungbu dialogue box appears against a house silhouette that feels sheltering rather than broken.
- Nolbu encounter reads as status/power because the building orientation supports the gate and patrol composition.
- Billboard and prompt placement should remain legible after house repositioning; any overlap discovered during Dev validation should be corrected in the same pass.

---

## Data Model
No player persistence changes.

### Runtime code data
- house placement spec table in server code
- optional small helper for pad-derived transform assembly

### Existing runtime folders preserved
- `Runtime/PlacedAssets`
- `Runtime/InteractionNodes`

---

## Failure / Edge Cases
- **Imported house is upside down:** `orientationCorrection` handles the authoring mismatch explicitly instead of encoding it inside unexplained final rotation values.
- **Model pivot is poor or missing:** fallback to primary-part discovery plus bounding-box-bottom anchoring.
- **Imported footprint is offset from visible center:** use `visualOffset` rather than corrupting the base pad coordinates.
- **Asset load fails:** fallback house spawns with same story-facing composition.
- **House overlaps prompts or billboards after correction:** adjust prompt/sign offsets in the same polish pass; do not silently accept clipping.
- **Studio-only fine tuning still needed:** PM should keep the item as effectively done only after one actual visual check.

---

## Validation Plan
1. Start the game with imported houses loading successfully.
2. Confirm both houses are upright and not visibly upside down.
3. Confirm house bottoms meet pads/ground cleanly without obvious float or burial.
4. Confirm Heungbu house faces its yard/patch in a welcoming way.
5. Confirm Nolbu house faces the estate road/gate in a more dominant way.
6. Confirm prompts, billboards, patrol paths, and patch interactions are still readable nearby.
7. Force fallback behavior and confirm the fallback houses preserve the same composition intent.

---

## MVP Cut Line
- explicit per-house placement metadata
- upright correction separated from world-facing yaw
- bottom anchoring to ground plane/pad
- fallback parity with final composition
- one PM/Studio visual validation pass

## Future Extensions
- debug-only footprint/facing gizmos
- reusing the same contract for gates or special props
- house-specific decorative anchors (porch side, front approach, sign offsets)
- swapping to higher-quality fallback houses only if imported assets remain unsalvageable