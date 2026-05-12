---
name: capability-router
description: Use at the start of a non-trivial task to choose the required roles, skills, optional MCP access, risk level, missing information, and escalation path. This skill routes work; it does not execute the task.
---

# Capability Router

## Purpose

Select the smallest sufficient capability set for a task:

```text
task type -> required roles -> required skills -> optional MCP -> escalation decision
```

This skill keeps the starter workflow lean. Roles define responsibility. Skills define repeatable procedures. MCP provides external tool access only when local context is insufficient.

## Inputs

- Task or GitHub Issue text.
- Acceptance criteria, if available.
- Allowed and forbidden scope, if available.
- Known risk areas.
- Current repository documentation and `AGENTS.md`.
- Current diff or PR context, if routing a review task.

## Procedure

1. Classify the task type:
   - documentation/setup;
   - feature;
   - bugfix;
   - refactor;
   - review;
   - test/QA;
   - security-sensitive;
   - CI/MCP/external context.
2. Choose required roles from the starter set:
   - Lead / Orchestrator;
   - Implementer;
   - Reviewer;
   - Tester / QA;
   - Security Reviewer;
   - Docs / Terminology.
3. Choose required skills from the registry.
4. Decide whether MCP is needed:
   - GitHub MCP for issue, PR, Actions, or repository context unavailable locally.
   - Context7 MCP for current library/framework docs unavailable locally.
   - No MCP when local repo/docs are sufficient.
5. Identify missing information and blockers.
6. Decide whether human escalation is required.

## Output Format

```md
## Capability Routing

### Task type

<one of: documentation/setup | feature | bugfix | refactor | review | test/QA | security-sensitive | CI/MCP/external context>

### Risk level

low | medium | high | critical

### Required roles

-

### Required skills

-

### Optional MCP

- MCP needed: yes | no
- MCP server: GitHub MCP | Context7 MCP | none
- Reason:
- Mode: read-only | write-capable

### Missing information

-

### Escalation

- Human escalation required: yes | no
- Reason:

### Recommended next step

<the next safe action>
```

## Do Not

- Do not implement the task.
- Do not edit files.
- Do not enable MCP.
- Do not perform MCP write actions.
- Do not approve the task or PR.
- Do not add new roles, skills, or MCP servers.
- Do not expand scope beyond the linked issue or task.

