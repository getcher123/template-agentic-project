# <PROJECT_NAME>

Short description:

```text
<Describe what this project does in one or two sentences.>
```

## Current Status

```text
<New project | Existing project migration | Active delivery | Maintenance>
```

## Source of Truth

- Requirements: GitHub Issues
- Delivery status: GitHub Project
- Architecture and terminology: `docs/`
- Agent rules: `AGENTS.md`
- Code changes: Pull Requests

## Local Setup

Replace this section with project-specific setup commands.

```bash
make setup-ci
```

## Validation

These commands define the minimum quality contract for pull requests:

```bash
make lint
make typecheck
make test
```

The generic application targets fail until configured for this project. Select
local checks for the actual diff: `make validate-docs` for kit documents, or
`make local-validate TARGETED_TESTS="..."` after configuring the project's
named-test runner. Required CI remains authoritative. Kit checks require
Python 3.10+ and do not prove application correctness.

## Working With Agents

Before assigning work to Codex or another coding agent:

1. Create a GitHub Issue.
2. Fill objective, context, allowed scope, forbidden scope, acceptance criteria, and validation commands.
3. Mark the issue `agent-ready` only after the task is sufficiently scoped.
4. Use one branch and one worktree per issue.
5. Require PR validation and human review before merge.

## Documentation

Use [START_HERE](docs/START_HERE.md) to find only the documents relevant to the task.
The following documents are available; they are not a mandatory reading order:

1. `docs/00-source-index.md`
2. `docs/01-project-brief.md`
3. `docs/02-terminology-map.md`
4. `docs/03-scope-and-requirements.md`
5. `docs/04-processes-and-user-journeys.md`
6. `docs/05-architecture-and-data.md`
7. `docs/06-quality-security-constraints.md`
8. `docs/07-delivery-model.md`
9. `docs/08-customer-facing-summary.md`
