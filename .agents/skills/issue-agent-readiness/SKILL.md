---
name: issue-agent-readiness
description: Use before assigning a GitHub Issue to Codex. Determines whether an issue is agent-ready, needs human input, needs decomposition, or is not suitable for agent implementation.
---

# Issue Agent Readiness

## Purpose

Decide whether a task can be safely delegated to Codex within the current multiagent workflow.

## Inputs

Read:

1. The GitHub Issue.
2. `AGENTS.md`.
3. `docs/02-terminology-map.md`.
4. `docs/03-scope-and-requirements.md`.
5. `docs/05-architecture-and-data.md`, if relevant.
6. Current branch/worktree state, if already created.

## Checklist

An issue is `agent-ready` only if all are true:

- Objective is clear.
- Acceptance criteria are concrete and testable.
- Allowed scope is listed.
- Forbidden scope is listed.
- Validation commands are listed.
- Risk level is known.
- No secret access is required.
- No production access is required.
- Task fits in one PR.
- Terminology matches `docs/02-terminology-map.md`.
- Human approval requirements are clear.

## Output format

```md
## Agent readiness

Status: agent-ready | needs-human-input | needs-decomposition | not-agent-suitable

## Reasoning summary

- 

## Missing information

- 

## Risk classification

Risk: low | medium | high | critical
Reason:

## Required roles

- Lead / Orchestrator:
- Delivery Planner / Backlog Architect:
- Implementer:
- Reviewer:
- Tester / QA:
- Security Reviewer:
- Docs / Terminology:

## Required skills

- 

## Recommended labels

- 

## Recommended project status

- 

## Suggested issue improvements

- 
```

## Escalation

Mark as requiring human review if the issue touches:

- auth;
- billing;
- database migrations;
- infrastructure;
- CI/CD;
- security-sensitive behavior;
- secrets;
- production config;
- legal/compliance constraints.

## Do not

- Do not mark a vague issue as agent-ready.
- Do not assume missing acceptance criteria.
- Do not allow implementation without validation commands.
