---
name: codex-cli-orchestration
description: Dispatch and supervise concrete subagent tasks with isolated ownership, resumable handoffs and exact-SHA review reuse; not a mandatory step for single-agent work.
---

# Codex Cli Orchestration

Use available authorized delegation tools. For CLI use supported options from
local help; do not assume a sandbox failure is caused by a particular dependency,
and never weaken sandbox/approvals to launch a reviewer.

Prompt contract: task/acceptance, exact SHA or baseline, allowed files, forbidden
actions, read-only or write-owner, expected bounded output, checks, dependencies
and authority. Do not send secrets or unnecessary raw data.

One active writer per worktree. Multiple developers need isolated worktrees and
non-overlapping locks; share an integration owner and merge order. Reviewers
remain read-only. Don't wait for research unrelated to the next implementation.

Require handoff: exact SHA, outcome, findings with reproduction and violated
criterion, tests run/not run, residual risk, next action.
For reviews use different lenses (correctness/QA and changed sensitive boundary).
Do not repeat review of an unchanged SHA without new evidence. Changed SHA
requires delta/affected-boundary confirmation, not automatically a fresh audit.
Record nonblocking improvements for follow-up; keep project blocking criteria.
If repeated cycles add no progress, escalate the bounded unresolved decision.

Do not merge, impersonate a human, change authority, or bypass required CI.
Unavailable delegation can leave the affected review pending; it does not stop
unrelated authorized local implementation.
