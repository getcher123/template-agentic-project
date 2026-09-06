---
name: capability-router
description: Route non-trivial tasks to the smallest sufficient workflow, model tier, skills and scoped authority. Do not execute or replan an already approved task.
---

# Capability Router

Start from the task and already-loaded AGENTS.md. Use docs/START_HERE.md only
to locate missing sources. Do not require a documentation tour.

Classify independently:
- Level: task (one change), batch (one resumable package), program (multiple
  related Leads/batches sharing dependencies/merge order).
- Complexity: C1 mechanical, C2 bounded, C3 cross-layer/semantic, C4 architectural.
- Risk: R1 low, R2 medium, R3 protected, R4 destructive/production.
- Uncertainty: U0 decision-complete, U1 discoverable locally, U2 owner/source needed.
- Mode: read-only, local-write, external-write. Mode does not itself set risk.

Use a standard tier for C1/C2 U0; stronger reasoning for C3/C4 or material U1.
Risk requires the appropriate review/authority, not automatically a costly
implementer. Never pin a vendor model name as permanent policy.

One bounded task: one implementer (possibly the Lead). Add subagents only for
independent useful outputs. Use program-orchestrator only for related batches.
U2 blocks only dependent implementation; capture the missing decision.

Output: level, C/R/U/mode, tier rationale, owner, selected skills, authority,
missing fields and next action. Reuse an approved contract; report only deltas.
Routing never authorizes external actions or broadens scope.
