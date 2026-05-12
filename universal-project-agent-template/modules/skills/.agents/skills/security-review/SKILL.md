---
name: security-review
description: Use for tasks touching auth, authorization, billing, database migrations, infrastructure, CI/CD, dependencies, secrets, logging, data exposure, or high-risk integrations. Prefer read-only review unless explicitly approved.
---

# Security Review

## Purpose

Review security-sensitive risks before PR readiness.

## Inputs

Read:

1. GitHub Issue.
2. Current diff.
3. `AGENTS.md`.
4. `docs/06-quality-security-constraints.md`, if present.
5. Auth, permission, logging, dependency, infra, and CI-related files touched by the diff.

## Procedure

Check:

1. Secrets are not committed.
2. Tokens, cookies, private keys, or credentials are not logged.
3. Auth checks are not weakened.
4. Authorization is enforced at the correct layer.
5. Role checks are tested.
6. Customer or personal data is not exposed.
7. New dependencies are justified.
8. CI/CD changes do not increase supply-chain risk.
9. Database migrations preserve data and include rollback notes when relevant.
10. Infrastructure changes require human review.

## Output format

```md
## Security review

Status: pass | needs-fix | requires-human-review

## Findings

| Severity | Area | Finding | Recommendation |
|---|---|---|---|
|  |  |  |  |

## Secret exposure check

- Result:

## Auth/authorization check

- Result:

## Dependency/supply-chain check

- Result:

## Required human review

- yes | no
- reason:

## Recommendation

- 
```

## Do not

- Do not approve changes that expose secrets.
- Do not allow production config changes without explicit approval.
- Do not mark high-risk changes as safe without evidence.
- Do not run production-impacting commands.
