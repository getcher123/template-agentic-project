# Capability Selection Guide

Use this guide before non-trivial work. The goal is the smallest sufficient set of roles, skills, and MCP access.

## Starter Capability Rule

```text
First route the work.
Then plan the work.
Then implement or review the work.
```

Default starter MCP:

- GitHub MCP: only when issue, PR, Actions, or repository context is not available locally.
- Context7 MCP: only when current library/framework documentation is required.

No other MCP belongs in the starter set. Browser/Playwright can be considered later as an optional UI extension, but it is not configured by default.

## Task Matrix

| Task type | Required roles | Required skills | Optional MCP |
|---|---|---|---|
| New project setup | Lead / Orchestrator, Delivery Planner / Backlog Architect, Docs / Terminology | capability-router, source-index-builder, terminology-map-builder, requirement-slicing | none |
| Existing project adaptation | Lead / Orchestrator, Delivery Planner / Backlog Architect, Docs / Terminology, Reviewer | capability-router, source-index-builder, terminology-map-builder, documentation-sync, requirement-slicing | GitHub MCP if repo issue/PR context is needed |
| Backlog decomposition | Delivery Planner / Backlog Architect, Docs / Terminology, Lead / Orchestrator | capability-router, requirement-slicing, issue-agent-readiness, orchestration-plan | GitHub MCP if creating/updating Issues or Projects |
| GitHub planning layer | Delivery Planner / Backlog Architect, Lead / Orchestrator | capability-router, issue-agent-readiness, mcp-usage-guard, orchestration-plan | GitHub MCP for Issues, Projects, labels, Actions context |
| Feature implementation | Lead / Orchestrator, Implementer, Tester / QA | capability-router, issue-agent-readiness, implementation-plan, test-gap-review, pr-handoff | Context7 MCP if current framework docs are needed |
| Bugfix | Lead / Orchestrator, Implementer, Tester / QA | capability-router, issue-agent-readiness, implementation-plan, test-gap-review, pr-handoff | GitHub MCP if linked issue/PR context is needed |
| Refactor | Lead / Orchestrator, Implementer, Reviewer | capability-router, orchestration-plan, implementation-plan, test-gap-review, pr-handoff | none by default |
| PR review | Reviewer, Tester / QA | capability-router, test-gap-review, pr-handoff | GitHub MCP if PR metadata or CI status is needed |
| Security-sensitive task | Lead / Orchestrator, Security Reviewer, Reviewer | capability-router, security-review, mcp-usage-guard, test-gap-review | GitHub MCP read-only if security context is in PR/Actions |
| Documentation change | Docs / Terminology, Reviewer | capability-router, documentation-sync, terminology-map-builder | none by default |
| CI failure | Lead / Orchestrator, Reviewer, Implementer if fix is scoped | capability-router, mcp-usage-guard, test-gap-review, implementation-plan | GitHub MCP for Actions logs/status |

## Escalate To Human Review

Escalate when:

- requirements conflict;
- scope is missing or too broad;
- multiple write-owners would be needed;
- task touches auth, secrets, billing, migrations, infrastructure, CI, or sensitive customer data;
- validation cannot be run;
- MCP write access would be required.
