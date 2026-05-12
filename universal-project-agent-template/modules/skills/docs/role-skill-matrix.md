# Role Skill Matrix

Roles are accountability contracts. Skills are procedures. Do not create role-specific skills unless a repeated procedure has a stable input and output.

## Primary Operating Model

The human operator communicates with one Lead / Orchestrator agent in VS Code. The Orchestrator coordinates CLI subagents, accepts their handoff reports, asks for fixes, runs re-review loops, and prepares the final human decision request.

Human attention should be reserved for final merge, high-risk approval, missing business decisions, and unsafe operations.

## Starter Roles

| Role | Purpose | Writes code? | Default skills | Forbidden actions |
|---|---|---:|---|---|
| Lead / Orchestrator | Route task, launch bounded CLI subagents, synthesize findings, prepare decision request | no by default | capability-router, codex-cli-orchestration, issue-agent-readiness, orchestration-plan, mcp-usage-guard | implementing code by default, merging, approving high-risk actions, expanding scope |
| Delivery Planner / Backlog Architect | Decompose requirements, build backlog, and maintain GitHub Issues/Projects planning metadata | no code; planning metadata only | capability-router, requirement-slicing, issue-agent-readiness, orchestration-plan, mcp-usage-guard | implementing code, marking vague work agent-ready, changing scope without source evidence, bypassing review through Project metadata |
| Implementer | Make scoped code changes as the single write-owner | yes | refactoring-plan, implementation-plan, pr-handoff | editing outside scope, changing secrets/config without approval, bypassing validation |
| Reviewer | Review diff, PR body, scope, refactoring boundaries, and regression risk | no by default | capability-router, refactoring-plan, test-gap-review, pr-handoff | rewriting production code during review, approving high-risk changes alone |
| Tester / QA | Check tests, edge cases, bug reproduction, and validation evidence | no by default | capability-router, issue-agent-readiness, test-gap-review | removing assertions to make tests pass, accepting unverified behavior |
| Security Reviewer | Review auth, secrets, infra, CI, dependency, and sensitive data risks | no by default | capability-router, security-review, mcp-usage-guard | making security-sensitive code changes in review mode, approving without human review |
| Docs / Terminology | Normalize terminology and synchronize docs with behavior | docs only | capability-router, source-index-builder, terminology-map-builder, documentation-sync | changing business scope, inventing canonical terms without source |

## Orchestration Modes

| Mode | Use when | Required roles |
|---|---|---|
| planning-and-backlog | source material needs epics, features, issues, dependencies, priority/size/risk, or Project field setup | Lead / Orchestrator, Delivery Planner / Backlog Architect, Docs / Terminology when source docs are unclear |
| single-agent | XS/S low-risk implementation | Implementer |
| lead-plus-implementer | scoped feature or bugfix with clear validation | Lead / Orchestrator, Implementer |
| lead-plus-reviewer | non-trivial acceptance criteria or PR review needed | Lead / Orchestrator, Implementer, Reviewer |
| lead-plus-qa | tests, reproduction, or edge cases are central | Lead / Orchestrator, Implementer, Tester / QA |
| specialist-review | security-sensitive or docs/terminology-heavy work | Lead / Orchestrator, relevant specialist, Reviewer |
| split-required | multiple write-owners or independent subsystems needed | Lead / Orchestrator, Human Owner |

## One Write-Owner Rule

In one worktree, only one active write-owner may modify code. Reviewers and specialists are read-only unless a human explicitly changes ownership.

## Decision Request Actions

| Action | Use when |
|---|---|
| Approve merge | Validation passed, agent review has no blocking findings, residual risk is acceptable |
| Approve high-risk action | High-risk action is explicitly scoped, reviewed, and still requires human authorization |
| Request changes | Findings are actionable and fixable inside current scope |
| Block | Scope, safety, requirements, validation, or ownership is not acceptable |
