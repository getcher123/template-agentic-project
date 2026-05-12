---
name: test-gap-review
description: Use before PR readiness or after implementation to review the current diff for missing tests, uncovered acceptance criteria, edge cases, regression risk, and validation gaps. Prefer read-only mode.
---

# Test Gap Review

## Purpose

Determine whether the current implementation is adequately tested against the issue acceptance criteria.

## Inputs

Read:

1. GitHub Issue acceptance criteria.
2. Current diff.
3. Existing test files.
4. Validation commands.
5. PR body, if already created.

## Procedure

1. Map each acceptance criterion to a test or validation method.
2. Identify missing positive tests.
3. Identify missing negative/error tests.
4. Identify edge cases.
5. Check whether existing tests were weakened or removed.
6. Check whether validation commands were run.
7. Decide if PR is ready, needs tests, or needs human review.

## Output format

```md
## Test gap review

Status: ready | needs-more-tests | blocked

## Acceptance criteria coverage

| Acceptance criterion | Covered by | Gap |
|---|---|---|
|  |  |  |

## Missing tests

- 

## Edge cases

- 

## Regression risks

- 

## Validation commands to run

```bash
make lint
make typecheck
make test
```

## Recommendation

- 
```

## Do not

- Do not remove assertions to make tests pass.
- Do not mark PR ready if validation did not run and no reason is given.
- Do not approve high-risk behavior with only snapshot or superficial tests.
