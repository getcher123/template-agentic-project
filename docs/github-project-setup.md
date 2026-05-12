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

The helper uses `gh api`, so it works even when older GitHub CLI versions do not provide `gh label`.

## Project Fields

Create one GitHub Project for `Template Agentic Project` with these fields:

Project setup requires GitHub Projects permissions. If you automate this with `gh api graphql`, the token needs Projects access (`read:project` to inspect projects and project write access to create or update them). If the local `gh` version does not include `gh project`, create the Project and fields in the GitHub web UI or use GraphQL after refreshing token scopes.

| Field | Type | Values |
|---|---|---|
| Status | Single select | Inbox, Ready, In Progress, Review, Blocked, Done |
| Priority | Single select | P0, P1, P2, P3 |
| Size | Single select | XS, S, M, L, XL |
| Risk | Single select | Low, Medium, High, Critical |
| Area | Single select | Backend, Frontend, Data, AI, Infra, Tests, Docs |
| Agent mode | Single select | None, Planning, Discovery, Implementation, Review |
| Owner | Text | human or agent owner |
| Branch | Text | branch name |
| Worktree | Text | local worktree folder |
| Validation | Text | required commands |
| Depends on | Text | issue or PR dependency |
| Target date | Date | planned date |

## Views

Views may need to be created in the GitHub web UI. Some GitHub CLI and GraphQL versions can read Project views but do not expose stable create/update mutations for them.

| View | Purpose | Filter |
|---|---|---|
| Board | Normal kanban | all open items |
| Agent Ready | Tasks ready for Codex | label:agent-ready status:Ready |
| High Risk | Security, infra, DB, billing | risk High or Critical |
| Review Queue | PR review | status:Review |
| Blocked | Blockers | status:Blocked |
| Done This Week | Shipped work | status:Done updated recently |

## Automations

Automations may need to be configured in the GitHub web UI. Some API surfaces expose existing workflows but not create/update operations for the recommended rules.

Minimum recommended rules:

- New issue -> Status: Inbox.
- Issue gets `agent-ready` -> Status: Ready.
- PR opened and linked -> Status: Review.
- PR merged -> Status: Done.
- Issue gets `blocked` -> Status: Blocked.

## Branch Protection

Protect `main` with:

- Pull request required before merge.
- Required status checks for CI.
- CODEOWNERS review required for protected areas.
- No force pushes.
- No direct pushes unless explicitly allowed for maintainers.
