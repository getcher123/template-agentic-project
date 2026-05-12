---
name: orchestration-plan
description: Use for medium, high-risk, multi-role, documentation-heavy, or architecture-heavy tasks to decide roles, skills, MCP usage, write-owner, execution sequence, and escalation rules before implementation.
---

# Orchestration Plan

## Purpose

Create a controlled execution plan for a task before any code changes.

## Inputs

Read:

1. GitHub Issue.
2. GitHub Project status, if available.
3. `AGENTS.md`.
4. `docs/skills-registry.md`.
5. `docs/agent-roles.md`.
6. `docs/mcp-registry.md`.
7. Relevant project documentation.

## Procedure

1. Confirm agent readiness using `issue-agent-readiness`.
2. Choose orchestration mode:
   - `planning-and-backlog`
   - `single-agent`
   - `lead-plus-implementer`
   - `lead-plus-reviewer`
   - `lead-plus-qa`
   - `specialist-review`
   - `split-into-multiple-issues`
3. Select roles.
4. Select skills.
5. Decide whether MCP is needed using `mcp-usage-guard`.
6. Assign exactly one write-owner for a single worktree.
7. Define read-only reviewers.
8. Define validation commands.
9. Define escalation triggers.
10. Produce an execution sequence.

## Output format

```md
## Orchestration plan

Mode: planning-and-backlog | single-agent | lead-plus-implementer | lead-plus-reviewer | lead-plus-qa | specialist-review | split-into-multiple-issues

## Selected roles

| Role | Purpose | Write access | Skills |
|---|---|---|---|
| Orchestrator |  | no |  |
| Implementer |  | yes |  |

## MCP decision

MCP needed: yes | no
MCP servers:

- github: reason
- context7: reason

## Write-owner

- 

## Read-only reviewers

- 

## Execution sequence

1. 
2. 
3. 

## Validation commands

- make lint
- make typecheck
- make test

## Escalation triggers

- 

## Handoff requirements

- 
```

## Do not

- Do not assign multiple code-writing agents to one worktree.
- Do not use MCP write actions without surfacing the plan.
- Do not expand scope beyond the issue.
