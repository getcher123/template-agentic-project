# Template Agentic Project

A reusable, stack-independent kit for scoped agent development: task contracts,
skills, worktree helpers, PR handoff and small validation workflows.

Start with [AGENTS.md](AGENTS.md) and [START_HERE](docs/START_HERE.md).
The current task and delivery status live in GitHub Issues/Projects.

## Maintaining the template

Canonical distributable sources are under
[universal-project-agent-template](universal-project-agent-template/README.md).
Edit those sources, then run:

```bash
python3 scripts/sync-template-mirrors.py
make lint
make typecheck
make test
```

The root is an example installation. The mirror command preserves its project
identity and excludes user `.codex/config.toml`, secrets, CODEOWNERS and the
repository-specific Makefile. New package files must be staged before
`make package`; `make package-check` verifies the distributable archive.

Python 3.10+, Bash and Git are required for kit checks. There are no third-party
Python dependencies. Application validation in an installed project must be
configured explicitly; kit checks are not application acceptance.

## Working on tasks

Use one scoped issue and an isolated worktree. On WSL prefer a path under the
Linux home filesystem. The start helper preserves dirty main and supports
`AGENT_WORKTREE_ROOT`. Record the full checkpoint and next action in the issue.

Select configured docs checks or named local tests; GitHub CI remains the final
required check. A single approved batch may use one rollup PR.
Use the canonical PR template and retain human review before merge.

## Distribution and historical material

Use `universal-project-agent-template/` or its rebuilt ZIP for new installations.
The old `codex-new-project-agent-kit-with-skills-guide.zip`, top-level Skills
appendix, onboarding notes and older Russian companion guides are historical
background. Current English
AGENTS.md, skills and delivery docs take precedence.
