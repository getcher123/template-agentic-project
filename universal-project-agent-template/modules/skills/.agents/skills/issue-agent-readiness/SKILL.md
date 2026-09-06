---
name: issue-agent-readiness
description: Assess whether a task contract has sufficient scope, acceptance, ownership, validation and authority for implementation or delegation.
---

# Issue Agent Readiness

Read the linked issue/handoff first. Use only the relevant canon for unresolved
terms or behavior; do not reread architecture for a docs-only task.

Required contract: objective, source/context, observable acceptance, allowed and
forbidden scope, checkpoint/base, one write-owner, validation, authority/limits
and next action. A truthful U1 discovery step may proceed; U2 waits for its owner.
An external decision for one branch does not block unrelated local work.

Reuse existing approvals only within their recorded system, environment,
operations, limits and expiry. Readiness is not a new permission or merge approval.

Return ready / needs-input / needs-decomposition / unsuitable, with only missing
fields, affected dependencies and next action. Do not rerun readiness on every
tool call; revisit changed checkpoint/scope/authority or a new concrete blocker.
