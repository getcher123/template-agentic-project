# GitHub Project Setup

## Labels

After installing the `full` profile, run:

```bash
./scripts/setup-github-labels.sh
```

The script expects GitHub CLI authentication:

```bash
gh auth status
```

## Project Fields

Create one GitHub Project for `<PROJECT_NAME>` with these fields:

| Field | Type | Values |
|---|---|---|
| Status | Single select | Inbox, Ready, In Progress, Review, Blocked, Done |
| Priority | Single select | P0, P1, P2, P3 |
| Size | Single select | XS, S, M, L, XL |
| Risk | Single select | Low, Medium, High, Critical |
| Area | Single select | Backend, Frontend, Data, AI, Infra, Tests, Docs |
| Agent mode | Single select | None, Discovery, Implementation, Review |
| Owner | Text | human or agent owner |
| Branch | Text | branch name |
| Worktree | Text | local worktree folder |
| Validation | Text | required commands |
| Depends on | Text | issue or PR dependency |
| Target date | Date | planned date |

## Views

| View | Purpose | Filter |
|---|---|---|
| Board | Normal kanban | all open items |
| Agent Ready | Tasks ready for Codex | label:agent-ready status:Ready |
| High Risk | Security, infra, DB, billing | risk High or Critical |
| Review Queue | PR review | status:Review |
| Blocked | Blockers | status:Blocked |
| Done This Week | Shipped work | status:Done updated recently |

## Automations

Minimum recommended rules:

- New issue -> Status: Inbox.
- Issue gets `agent-ready` -> Status: Ready.
- PR opened and linked -> Status: Review.
- PR merged -> Status: Done.
- Issue gets `blocked` -> Status: Blocked.

## Branch Protection

Protect `<DEFAULT_BRANCH>` with:

- Pull request required before merge.
- Required status checks for CI.
- CODEOWNERS review required for protected areas.
- No force pushes.
- No direct pushes unless explicitly allowed for maintainers.

