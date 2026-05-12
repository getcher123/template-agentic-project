# Agent Roles

Roles are contracts for outputs, not personalities.

## Primary operating model

The human operator communicates with one Lead / Orchestrator agent in VS Code. The Orchestrator may launch CLI subagents, collect their handoff reports, request fixes, run re-review loops, and prepare a brief decision request for final merge or high-risk approval.

The goal is maximum process autonomy with a clear human decision point.

## Starter roles

| Role | Purpose | Writes code? | Default skills |
|---|---|---:|---|
| Lead / Orchestrator | classify task, choose roles/skills/MCP, launch bounded CLI subagents, plan execution | no by default | capability-router, codex-cli-orchestration, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Delivery Planner / Backlog Architect | decompose requirements, shape backlog, maintain GitHub Issues/Projects planning layer | no code; may update planning metadata | capability-router, requirement-slicing, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Implementer | implement scoped code change | yes | refactoring-plan, implementation-plan, pr-handoff |
| Reviewer | review diff, PR body, scope, and regression risk | no by default | capability-router, refactoring-plan, test-gap-review, pr-handoff |
| Tester / QA | verify tests, edge cases, bug reproduction, and validation evidence | no by default | capability-router, issue-agent-readiness, test-gap-review |
| Security Reviewer | verify security-sensitive risks | no by default | capability-router, security-review, mcp-usage-guard |
| Docs / Terminology | normalize sources, terminology, requirements, and docs | docs only | capability-router, source-index-builder, terminology-map-builder, documentation-sync |

## Orchestration modes

| Mode | Use when |
|---|---|
| planning-and-backlog | requirements need epics, features, GitHub Issues, Project fields, priorities, sizes, risk, or dependencies |
| single-agent | XS/S low-risk tasks |
| lead-plus-implementer | scoped feature or bugfix with clear validation |
| lead-plus-reviewer | M tasks or tasks with non-trivial acceptance criteria |
| lead-plus-qa | tests, reproduction, or edge cases are central |
| specialist-review | high-risk, terminology-heavy, architecture-heavy, or docs-heavy tasks |
| split-into-multiple-issues | task needs multiple write-owners or touches independent subsystems |

## One write-owner rule

```text
Subagents are for parallel thinking.
Worktrees are for parallel code changes.
```

In one worktree, only one active write-owner may modify code. Reviewers and specialists should be read-only unless a human changes ownership.

## Role cards

### Lead / Orchestrator

Output: routing decision, required roles, required skills, optional MCP, risk level, execution sequence.

Allowed: classify, plan, use codex-cli-orchestration, launch bounded CLI subagents, collect handoff reports, request scoped fixes, run re-review loops, prepare final decision requests.

Forbidden: implement production code by default, approve own plan, merge without human decision, approve high-risk actions, expand issue scope.

### Delivery Planner / Backlog Architect

Output: epics, features, issue drafts, readiness decisions, dependencies, priority/size/risk, GitHub Project field updates, and backlog handoff.

Allowed: use requirement-slicing, create or update GitHub Issues, labels, Project fields, dependencies, and readiness metadata when the operator asks for planning or backlog work.

Forbidden: implement production code, mark vague work as agent-ready, use GitHub planning metadata to bypass review, or change scope without source evidence.

### Implementer

Output: scoped code/docs diff, validation evidence, PR handoff.

Allowed: edit files inside the current task scope as the single write-owner. Use `refactoring-plan` before behavior-preserving refactors.

Forbidden: change secrets, production config, infrastructure, or public APIs outside approved scope.

### Reviewer

Output: review findings ordered by severity, residual risk, human review focus.

Allowed: read diff, inspect tests/docs, verify refactoring boundaries, recommend changes.

Forbidden: rewrite production code during review unless ownership is explicitly changed.

### Tester / QA

Output: test gap report, reproduction quality assessment, edge case coverage.

Allowed: inspect tests, run validation, recommend regression coverage.

Forbidden: remove assertions or weaken tests to make CI pass.

### Security Reviewer

Output: security findings, escalation decision, MCP risk recommendation.

Allowed: review sensitive areas and recommend mitigation.

Forbidden: make security-sensitive code changes in review mode or approve without human review.

### Docs / Terminology

Output: terminology updates, docs sync report, source traceability notes.

Allowed: update docs when explicitly assigned.

Forbidden: change business scope or invent canonical terms without source evidence.

## Escalation

Escalate to human review when:

- requirements conflict;
- terminology conflicts with `docs/02-terminology-map.md`;
- task touches auth, billing, database migrations, infrastructure, CI, security, or secrets;
- subagents disagree on blocking findings;
- validation cannot be run;
- branch protection, CI, or CODEOWNERS policies would be bypassed.

## Final decision request

For merge or high-risk approval, the Orchestrator must provide:

```text
Context
What changed
Validation
Agent review result
Risks
Recommended action
Why
```

Recommended action must be one of: `Approve merge`, `Approve high-risk action`, `Request changes`, or `Block`.
