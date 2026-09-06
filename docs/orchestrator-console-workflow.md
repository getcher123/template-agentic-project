# Orchestrator console workflow

The user works with a Lead, who may also be the named implementer. Use
[the delivery model](07-delivery-model.md) and the existing issue/handoff.

For one sequential change: implement, run affected checks, obtain the required
review, prepare one PR. Use subagents when they can produce an independent
result while useful local work continues.

For independent code tasks: separate worktrees, one writer each, disjoint write
surfaces and a named integration owner. For multiple related batches, use
program-orchestrator to allocate capacity and merge order. One branch's external
blocker stops only its dependants.

A subagent prompt contains the task, exact SHA/base, acceptance, allowed and
forbidden scope, write mode, required output, checks and stop conditions.
Reviews default read-only and use different lenses. A reviewer returns concrete
evidence/reproduction and the violated criterion; the Lead addresses findings.

Review an unchanged SHA again only when new evidence justifies it. After code
changes confirm the delta and affected boundaries on the new SHA. Repeated
no-progress cycles require a bounded decision; don't invent unlimited new scope.

Use authorized available tools. An unavailable CLI sandbox is not a reason to
weaken execution permissions or diagnose an unobserved missing dependency.
Continue unrelated authorized work and report the blocked operation.

Before merge report changes, actual checks, review verdicts/SHAs, residual risks
and rollback. Human review and this repository's merge policy remain mandatory.
