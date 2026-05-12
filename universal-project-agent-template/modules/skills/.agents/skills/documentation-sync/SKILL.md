---
name: documentation-sync
description: Use when code, API behavior, terminology, requirements, process, customer-facing language, or architecture changes and documentation must be checked or updated.
---

# Documentation Sync

## Purpose

Keep project documentation synchronized with implemented changes.

## Inputs

Read:

1. Current diff.
2. GitHub Issue.
3. `docs/02-terminology-map.md`.
4. `docs/03-scope-and-requirements.md`.
5. `docs/04-processes-and-user-journeys.md`, if relevant.
6. `docs/05-architecture-and-data.md`, if relevant.
7. `docs/08-customer-facing-summary.md`, if relevant.
8. README and API docs.

## Procedure

1. Identify which docs are affected by the change.
2. Check terminology consistency.
3. Check if customer-facing wording needs updates.
4. Check if API or data model docs need updates.
5. Check if AGENTS.md or templates need updates.
6. Produce docs changes or a docs update plan.

## Output format

```md
## Documentation sync

Status: docs-current | docs-updated | docs-needed

## Affected docs

| Document | Update needed | Reason |
|---|---|---|
|  |  |  |

## Terminology consistency

- 

## Customer-facing changes

- 

## Internal docs changes

- 

## Recommended PR notes

- 
```

## Do not

- Do not leak internal agent terminology into customer-facing docs.
- Do not introduce new terms without updating the terminology map.
- Do not update docs with assumptions; mark open questions instead.
