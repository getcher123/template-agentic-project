---
name: pr-handoff
description: Use before opening or updating a Pull Request to produce a complete PR handoff: linked issue, summary, validation, commands not run, risks, human review focus, rollback notes, roles, skills, and MCP usage.
---

# PR Handoff

## Purpose

Prepare a PR-ready handoff that allows a human reviewer to understand scope, validation, risks, and follow-up work.

## Inputs

Read:

1. GitHub Issue.
2. Current branch name.
3. Current diff.
4. Commit history for the branch.
5. Validation command results.
6. Findings from QA, security, docs, or other reviewers.

## Procedure

1. Link the issue.
2. Summarize changes in bullets.
3. List touched areas.
4. State validation commands and results.
5. List commands not run and why.
6. Summarize agent roles and skills used.
7. Summarize MCP usage, if any.
8. List risk areas.
9. Give human reviewer focus points.
10. Provide rollback notes.

## Output format

```md
## Linked issue

Closes #

## Summary

- 

## Scope

Touched areas:

- 

Intentionally not touched:

- 

## Validation

Commands run:

```bash
make lint
make typecheck
make test
```

Results:

- lint:
- typecheck:
- tests:
- CI:

Commands not run and reason:

- 

## Agent roles used

- Orchestrator:
- Implementer:
- QA Reviewer:
- Security Reviewer:
- Docs Agent:

## Skills used

- 

## MCP usage

- github:
- context7:
- none:

## Risk areas

- 

## Human review focus

- 

## Rollback notes

- 

## Checklist

- [ ] PR is linked to the issue.
- [ ] Diff is scoped to the issue.
- [ ] Tests were added or updated when behavior changed.
- [ ] Documentation was updated when behavior changed.
- [ ] No secrets or credentials are included.
- [ ] No unrelated formatting-only diff is included.
- [ ] CODEOWNERS review is requested when protected areas changed.
```

## Do not

- Do not hide failing tests.
- Do not claim validation ran if it did not.
- Do not mark high-risk findings as minor.
