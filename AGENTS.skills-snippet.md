# Skills and MCP operating rules

## Skills policy

Use skills as repeatable procedures, not as personas.

Before starting non-trivial work, decide which skills apply:

- `capability-router` for selecting task type, required roles, required skills, optional MCP, risk, and escalation.
- `codex-cli-orchestration` for safely launching bounded Codex CLI subagents from the Lead / Orchestrator workflow.
- `source-index-builder` for raw source extraction and source reliability.
- `terminology-map-builder` for business/domain/code naming alignment.
- `requirement-slicing` for turning brief/processes into epics, features, and agent-ready issues.
- `issue-agent-readiness` before delegating an issue to Codex implementation.
- `orchestration-plan` for multi-role or medium/high-risk tasks.
- `implementation-plan` before editing code.
- `test-gap-review` before marking a PR ready.
- `security-review` for auth, billing, DB, infra, CI, dependency, or secret-related changes.
- `documentation-sync` when behavior, terminology, scope, API, or customer-facing meaning changes.
- `pr-handoff` before opening or updating a PR.
- `mcp-usage-guard` before using MCP tools that read or write external systems.

## MCP policy

MCP is tool access, not authority.

Rules:

- GitHub Issues, Projects, PRs, and CI remain source of truth.
- Use GitHub MCP for issue/PR/Actions context only when local repository context is insufficient.
- Use Context7 MCP only when current library or framework documentation is needed.
- Do not use MCP to access secrets, production data, customer private data, or external systems unrelated to the issue.
- Any write action through MCP must be explicitly planned and surfaced in the handoff.
- For high-risk tasks, prefer read-only analysis and human approval before write actions.

## Role-to-skill mapping

| Role | Default skills |
|---|---|
| Lead / Orchestrator | capability-router, codex-cli-orchestration, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Delivery Planner / Backlog Architect | capability-router, requirement-slicing, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Implementer | implementation-plan, pr-handoff |
| Reviewer | capability-router, test-gap-review, pr-handoff |
| Tester / QA | capability-router, issue-agent-readiness, test-gap-review |
| Security Reviewer | capability-router, security-review, mcp-usage-guard |
| Docs / Terminology | capability-router, source-index-builder, terminology-map-builder, documentation-sync |

## One write-owner rule

In a single worktree, only one active agent may modify code. Other agents should be read-only reviewers unless a human explicitly changes the write-owner.
