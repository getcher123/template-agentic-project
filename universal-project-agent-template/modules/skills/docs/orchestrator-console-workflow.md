# Orchestrator Console Workflow

This is the primary operating model for the template.

The human operator communicates with one Lead / Orchestrator agent in VS Code. The Orchestrator may launch CLI subagents, collect their handoff reports, request fixes, run re-review loops, and prepare the final decision request.

## Operating Model

```text
Human operator
-> Lead / Orchestrator in VS Code
-> capability-router
-> codex-cli-orchestration
-> CLI subagents for implementation/review/QA/security/docs
-> subagent handoff reports
-> Orchestrator synthesis
-> fixes and re-review when needed
-> PR handoff
-> brief decision request
-> human merge or high-risk approval
```

## Autonomy Principle

The Orchestrator should handle as much coordination as possible:

- classify the task;
- select roles, skills, and optional MCP;
- switch into Delivery Planner / Backlog Architect mode when the task is decomposition, backlog, GitHub Issues, or Project metadata;
- use `codex-cli-orchestration` before launching CLI subagents;
- launch bounded subagents;
- enforce the one write-owner rule;
- collect and reconcile findings;
- request scoped fixes;
- repeat agent review when needed;
- prepare PR handoff;
- ask the human only for final merge, high-risk approval, missing business decisions, or unsafe operations.

## Subagent Rules

- Implementer can write within the current task scope as the single write-owner.
- Reviewer, Tester / QA, Security Reviewer, and Docs / Terminology are read-only by default.
- If multiple write-owners are needed, split the work into multiple issues and worktrees.
- Subagents must return concise handoff reports with findings, blockers, validation, and recommended next action.
- Orchestrator may close internal subagent loops when findings are resolved.

## CLI Subagent Launch Protocol

Before launching a CLI subagent, the Orchestrator uses `codex-cli-orchestration` to define:

- sandbox availability and fallback decision;
- subagent role;
- mode: `write-owner` or `read-only`;
- allowed and forbidden scope;
- prompt to run in Codex CLI;
- expected handoff format;
- stop conditions;
- re-review criteria.

Reviewer, Tester / QA, Security Reviewer, and Docs / Terminology default to read-only mode. Implementer may be write-owner only inside the current task worktree and approved scope.

If Codex CLI sandbox is unavailable in a real repository, the Orchestrator must not switch to sandbox bypass. It should stop with `blocked`, recommend installing Bubblewrap when `bwrap` is missing, or run only in a disposable copy when a throwaway validation is sufficient.

## Human Decision Requests

For final merge or high-risk approval, the Orchestrator must provide a short decision request:

```md
## Decision Request

### Context

<issue/PR, task type, risk level>

### What changed

-

### Validation

-

### Agent review result

-

### Risks

-

### Recommended action

Approve merge | Approve high-risk action | Request changes | Block

### Why

<one or two sentences>
```

The Orchestrator may recommend an action, but the human remains accountable for final merge and high-risk approval.
