---
name: implementation-plan
description: Prepare the missing implementation decisions before code or documentation changes; reuse an approved issue or handoff.
---

# Implementation Plan

Read the task contract, AGENTS.md and only affected source/code.
If objective, acceptance, scope, checkpoint, owner, validation, authority and
next action already exist, reference them; do not recreate the plan.

Fill only missing decisions: changed surfaces, preserved invariants, steps,
positive/negative tests, chosen validation, rollback and concrete stop conditions.
Distinguish source edits from generated mirrors and do not edit private config.

Prefer configured docs checks or named affected tests:
`make local-validate TARGETED_TESTS="..."`. Full local tests are a diagnostic
choice, not automatically repeated before authoritative CI.
Do not claim unconfigured/skipped checks passed. Do not modify code during a
review-only request. A plan is not authorization for production, secrets,
new integrations or unapproved business rules.
