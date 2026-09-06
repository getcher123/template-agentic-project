---
name: orchestration-plan
description: Plan dependency-safe waves for one multi-role batch; avoid duplicating an approved handoff or allocating agents without useful parallel work.
---

# Orchestration Plan

Consume the approved issue/handoff (and Program Directive if present).
Reference its task card; add only owners, independent work surfaces, dependencies,
validation barriers and the next checkpoint.

For one sequential change use one implementer. For two independent changes and
four available slots use a coordinator, two isolated implementers and one reserve.
Roles are responsibilities; a Lead may also be the named implementer.
Each worktree has one write-owner. Review/QA default read-only.
Delegate concrete independent outputs, not whole-policy rereading or duplicate
diagnosis. Do useful non-dependent work while a reviewer runs.

A wave ends with affected validation, full SHA, dirty-state disclosure and next
action. One bounded rollup PR may contain multiple related fixes.
Final exact-SHA reviews and required CI remain; no full gate per wave by default.

Multiple related batches use program-orchestrator for shared locks/merge order.
Record an unavailable tool or external decision against only its dependants.
Do not create another registry or expand authority.
