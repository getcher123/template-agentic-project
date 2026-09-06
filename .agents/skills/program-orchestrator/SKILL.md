---
name: program-orchestrator
description: Coordinate two or more related batches or Leads with shared dependencies, write surfaces or merge order; not for a single bounded issue.
---

# Program Orchestrator

Read the approved program handoff and existing batch task cards. Keep status in
those issues/handoff; don't build a second tracking service.

For each batch record Lead, scope lock, worktree, base/checkpoint, dependencies,
validation, authority and next action. The coordinator owns shared status and
merge order, not the same files as implementers.
Schedule only dependency-ready work. Shared surfaces need ordered ownership
transfer. Independent Leads develop in parallel in separate worktrees; reserve
capacity for integration/review and don't promise every Lead a full team.

A blocked external wave stops its dependants only. Don't repeatedly poll an
unchanged decision or restart plans. Integrate one reviewed batch at a time when
shared surfaces require it; update the next base and validate the affected delta.
Checkpoints are immutable SHAs plus evidence, not dirty trees.

Reuse scoped active approvals without asking per step, but never infer new
systems, broader limits, production or another project's authority.
Human review and CI remain governed by this project's policy.
Stop at actual completion or a concrete authority/dependency blocker; report
status, residual risk and next action per Lead in plain language.
