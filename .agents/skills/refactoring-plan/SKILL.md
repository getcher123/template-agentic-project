---
name: refactoring-plan
description: Use before behavior-preserving refactoring to decide whether the refactor is allowed in the current issue, needs a separate issue, must be blocked, or should be folded into the current task. Defines triggers, anti-triggers, invariants, allowed/forbidden changes, tests, validation, and rollback notes.
---

# Refactoring Plan

## Purpose

Decide whether a proposed refactor is safe, scoped, and behavior-preserving before any files are changed.

This skill does not perform the refactor. It is a gate before `implementation-plan`.

## Inputs

Read:

1. GitHub Issue or task context.
2. Current diff or code area, if any.
3. Refactor trigger.
4. Allowed and forbidden scope.
5. Public API, schema, migration, auth, infra, security, or data impact.
6. Existing tests and validation commands.
7. `docs/02-terminology-map.md`, if naming or legacy terms are involved.

## Valid Triggers

Use this skill when at least one trigger is present:

- duplicate logic in 3+ places;
- function or module blocks safe change or testing;
- behavior cannot be tested without extraction or isolation;
- unclear responsibility boundary;
- repeated bug pattern;
- high-churn fragile file;
- terminology or legacy naming conflicts with the terminology map.

## Anti-Triggers

Do not approve a refactor when the reason is only:

- cosmetic cleanup;
- broad refactor inside a feature or bug issue;
- public API, schema, migration, auth, infra, security, or data change without explicit approval;
- no test coverage and no characterization path;
- unrelated formatting churn.

## Procedure

1. State the refactor trigger.
2. Decide the refactor status:
   - `approved-in-scope`;
   - `needs-separate-issue`;
   - `blocked`;
   - `fold-into-current-task`.
3. List behavior invariants that must not change.
4. List allowed changes.
5. List forbidden changes.
6. Identify tests or characterization checks that protect behavior.
7. Identify validation commands.
8. Identify rollback notes.
9. Escalate to human review if the refactor touches high-risk areas or changes behavior.

## Output Format

```md
## Refactoring plan

Status: approved-in-scope | needs-separate-issue | blocked | fold-into-current-task

## Refactor trigger

-

## Behavior invariants

-

## Allowed changes

-

## Forbidden changes

-

## Tests or characterization

-

## Validation commands

- make lint
- make typecheck
- make test

## Rollback notes

-

## Recommendation

-
```

## Do Not

- Do not edit files while using this skill.
- Do not approve behavior changes as refactoring.
- Do not hide feature work or bug fixes inside a refactor.
- Do not refactor public APIs, migrations, auth, infra, security, or data flows without explicit approval.
- Do not proceed without tests or a characterization path unless the result is `blocked`.
