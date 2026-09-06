---
name: security-review
description: Review changed trust boundaries such as permissions, CI execution, credentials, data exposure or persistence; not every mention of an integration.
---

# Security Review

Read the exact diff/task and relevant constraints. Review the changed boundary
or a review required by project policy, not the whole system by keyword.
Check secret/data handling, execution authority, dependency/CI trust and negative
cases relevant to this diff. Use synthetic fixtures; no production/network writes
or credential inspection by default.

Findings need exact SHA, reproduction/evidence, impact and violated requirement.
Preserve project severity/merge criteria; neither elevate every suggestion to a
blocker nor downgrade a proved defect to accelerate delivery.
Review deltas after changes; unchanged SHA requires no new review without evidence.
Record unrelated hardening as follow-up. Escalate a repeated unresolved boundary
decision rather than inventing an unlimited sequence of hypothetical attacks.

Return verdict, findings, tests run/not run and residual risk. Never grant new
authority, approve a human review on their behalf or rewrite code as reviewer.
