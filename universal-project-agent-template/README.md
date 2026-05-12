# Universal Project Agent Template

Canonical language: English. Russian companion documents live in `ru/`.

This template adds a practical agent-ready delivery layer to a new or existing repository. It is intentionally stack-independent: it defines the operating contract, documentation baseline, GitHub workflow, skills, MCP policy, and worktree helpers without choosing Node, Python, Go, Docker, or any other application stack.

Primary operating model: the human operator talks to one Lead / Orchestrator agent in VS Code. The Orchestrator runs CLI subagents, collects their reports, requests fixes, performs re-review loops, and asks the human only for final merge, high-risk approval, missing business decisions, or unsafe operations.

## What This Template Provides

```text
GitHub Issue
-> GitHub Project Ready
-> Lead / Orchestrator in VS Code
-> CLI subagents as needed
-> one branch
-> one git worktree
-> Codex discovery
-> scoped implementation
-> local validation
-> Pull Request
-> CI
-> CODEOWNERS / human review
-> merge
-> cleanup
```

The main rule is simple:

```text
Repository state is the source of truth.
Agent memory is only a working aid.
```

## Layout

```text
core/
  AGENTS.md
  README.md
  Makefile
  docs/
  .github/

modules/
  github/
  mcp/
  skills/
  worktree/

ru/
  README.ru.md
  core/
  guides/

install.sh
```

## Install Profiles

| Profile | Installs |
|---|---|
| `core` | `AGENTS.md`, project README template, documentation baseline, issue templates, PR template, stack-independent Makefile contract |
| `recommended` | `core` plus capability router, skills, agent roles, MCP config disabled by default, and worktree scripts |
| `full` | `recommended` plus CODEOWNERS, GitHub workflows, labels helper, and GitHub Project setup guide |

Default mode is safe:

```bash
./install.sh --target /path/to/repo
```

This runs as:

```text
--mode existing --profile core --dry-run
```

## New Project

```bash
mkdir <REPO_NAME>
cd <REPO_NAME>
git init

/path/to/universal-project-agent-template/install.sh \
  --target . \
  --mode new \
  --profile recommended \
  --apply
```

After installation:

1. Replace placeholders such as `<PROJECT_NAME>`, `<ORG_OR_USER>`, `<DEFAULT_BRANCH>`, and `<PRIMARY_OWNER>`.
2. Configure exact validation commands in `Makefile`.
3. Use `capability-router` to choose roles, skills, risk, and optional MCP for non-trivial work.
4. Create the first scoped GitHub Issue before asking an agent to implement code.
5. Use the Orchestrator Console Workflow for autonomous subagent coordination.

## Existing Project

Start with a dry run:

```bash
/path/to/universal-project-agent-template/install.sh \
  --target /path/to/existing/repo \
  --mode existing \
  --profile core \
  --dry-run
```

Then apply without overwriting existing files:

```bash
/path/to/universal-project-agent-template/install.sh \
  --target /path/to/existing/repo \
  --mode existing \
  --profile core \
  --apply
```

If a file already exists, it is reported as a conflict and left untouched unless `--overwrite` is explicitly passed.

## MCP Safety

MCP servers are disabled by default. Enable them only after the repository is trusted and credentials are configured. The MCP module contains a policy document and a project-scoped `.codex/config.toml`.

The starter MCP set is deliberately small: GitHub MCP and Context7 MCP only. Browser automation can be added later as a separate UI extension when UI smoke testing becomes a regular workflow.

## Quality Contract

The installed `Makefile` intentionally fails until project-specific commands are configured:

```bash
make setup-ci
make lint
make typecheck
make test
make test-fast
```

This avoids false green checks in a generic template.

## Human Decision Requests

The Orchestrator should end merge/high-risk approval loops with a concise decision request:

```text
Context
What changed
Validation
Agent review result
Risks
Recommended action: Approve merge | Approve high-risk action | Request changes | Block
Why
```

The Orchestrator may recommend an action, but the human remains accountable for final merge and high-risk approval.
