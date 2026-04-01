---
name: luau-quality-gate
description: Run or document the real MagicGourd Luau quality gates using confirmed repo-local tooling first and missing-tool honesty second. Use when validating a slice before handoff or reporting what static checks are actually available.
---

# Luau Quality Gate

## Trigger

Use this skill when:
- a slice is ready for validation
- a report needs to say which static/build checks were actually run
- the repo needs an honest summary of available versus missing quality tools

## Do Not Trigger

Do not use this skill when:
- the task is only backlog planning
- no code or contract changes happened and no validation summary is needed

## Input

- changed files
- repo root
- current environment tool availability

## Procedure

1. Treat `rojo build default.project.json --output <temp>` as the primary confirmed repo-local build gate.
2. Check whether optional tools are actually available before claiming them:
   - `stylua`
   - `selene`
   - `luau-analyze`
3. If a tool is missing, report it as missing. Do not pretend it ran.
4. Add grep/static inspections when remote/attribute/persistence facts matter.
5. Summarize exactly:
   - what ran
   - what passed
   - what was unavailable
   - what remains unverified

## Output

- honest quality-gate summary
- pass/missing/blocker notes tied to real repo tooling
