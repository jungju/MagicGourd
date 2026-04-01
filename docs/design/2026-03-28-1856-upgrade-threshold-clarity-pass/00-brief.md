# Brief

## Context
MagicGourd is in refinement mode. The arcade loop already teaches `heal -> plant -> break -> buy`, and recent passes have improved prompt ownership, popup cadence, billboard density, and shared-slice readability.

What still feels slightly under-authored is the moment **between payout and plaza spend**:
- the player earns money in clean 10-coin chunks
- upgrade rows show raw affordability state
- purchase feedback is good once a buy happens
- but the loop is weaker at telling the player **how close** they are to a meaningful spend before they return to plaza

That creates a subtle completion gap: payouts feel valid, but not always sharply connected to the next upgrade threshold.

## Refine targets
1. tighten the read from pumpkin payout to nearest upgrade threshold
2. make money accumulation feel like progress toward a known spend, not just a number
3. improve plaza-return timing clarity without forcing immediate detours
4. keep upgrade comparison readable when several rows are close in value
5. preserve current loop simplicity and avoid adding a new economy layer

## Candidate focus
This pass will evaluate small refinement options that improve **threshold clarity** and **reward-to-spend coherence** inside the current structure.

## Non-goals
- no new upgrades
- no new currencies
- no new inventory UI
- no progression rebalance
- no combo/multiplier system
- no full quest expansion around plaza spending
