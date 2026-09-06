---
name: pr-handoff
description: Fill the repository's canonical PR template with actual validation and exact-SHA review evidence; do not maintain a second template.
---

# Pr Handoff

Read `.github/pull_request_template.md`, the task, diff, exact SHA and validation.
That file is the only PR-body template. Preserve its headings including
Human Review Focus and Rollback Notes. Never paste an incompatible skill copy.

State objective/scope, tests run and actual results, unrun checks with reasons,
review verdicts and SHAs, changed boundaries, external actions and rollback.
Do not precheck claims about tests, secrets, scope or CI that were not verified.
A read-only agent review is not a human or CODEOWNERS approval.

Validate the filled body with `python3 scripts/validate-pr-body.py --body FILE`.
Metadata-only edits do not require re-reviewing unchanged code.
Required CI/human review stay mandatory. Report a missing approval, do not
bypass it or use another project's reviewer credentials.
