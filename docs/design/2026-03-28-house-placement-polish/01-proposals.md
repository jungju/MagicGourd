# Proposals

## Proposal A
- Summary: Add a small explicit placement contract for each major house: facing intent, ground anchor mode, orientation correction, and fallback parity.
- Why it helps: turns fragile guesswork into predictable runtime behavior.
- Cost: medium.
- Risk: still needs one Studio confirmation pass.

## Proposal B
- Summary: Abandon imported house assets and ship polished fallback houses as the final art for now.
- Why it helps: removes InsertService/orientation fragility entirely.
- Cost: low-medium.
- Risk: loses authored asset flavor and makes both homes feel more placeholder.

## Proposal C
- Summary: Keep current placement logic and only tweak raw rotation/position values until the houses look acceptable.
- Why it helps: fastest possible short-term fix.
- Cost: low.
- Risk: creates more hidden magic numbers and likely breaks again if assets change.

## Proposal D
- Summary: Introduce pad-aligned house staging with optional visual calibration markers and a debug-only metadata table for footprint/facing verification.
- Why it helps: makes future placement tuning easier for other runtime props too.
- Cost: medium-high.
- Risk: may overshoot the immediate need if debug scaffolding becomes the work instead of the fix.