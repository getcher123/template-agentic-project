---
name: implementation-plan
description: Use before editing code to produce a scoped implementation plan: files likely to change, steps, tests, validation commands, risks, rollback notes, and forbidden changes.
---

# Implementation Plan

## Purpose

Plan implementation before modifying files.

## Inputs

Read:

1. GitHub Issue.
2. `AGENTS.md`.
3. `docs/02-terminology-map.md`.
4. `docs/03-scope-and-requirements.md`.
5. `docs/05-architecture-and-data.md`.
6. Existing code paths relevant to the issue.

## Procedure

1. Restate objective.
2. Restate acceptance criteria.
3. List likely files or modules to change.
4. List files or modules explicitly not to change.
5. Design implementation steps.
6. Identify tests to add or update.
7. Identify validation commands.
8. Identify risk areas.
9. Identify rollback notes.
10. For medium-risk tasks, require an explicit plan, validation, and Orchestrator synthesis before implementation handoff.
11. Request human approval only for high-risk changes, unsafe external actions, production/secrets/infra access, public API/schema/auth/security changes, or unresolved ambiguity.

## Output format

```md
## Implementation plan

Objective:

## Scope

Allowed:

- 

Forbidden:

- 

## Files likely to change

- 

## Implementation steps

1. 
2. 
3. 

## Tests to add or update

- 

## Validation commands

- make lint
- make typecheck
- make test

## Risks

- 

## Rollback notes

- 
```

## Do not

- Do not edit files during discovery.
- Do not add dependencies without explaining why.
- Do not change unrelated formatting.
- Do not modify secrets or production config.
