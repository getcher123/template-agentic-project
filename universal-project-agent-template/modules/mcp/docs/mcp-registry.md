# MCP Registry

This project starts with a deliberately small MCP surface.

## Default MCP servers

| MCP server | Status | Purpose | Default mode |
|---|---|---|---|
| GitHub MCP | disabled until configured | Issues, PRs, repository context, Actions, code security context | limited toolsets, approval required for writes |
| Context7 MCP | disabled until needed | current library/framework documentation | read-only documentation lookup |

## GitHub MCP

Configured in:

```text
.codex/config.toml
```

Before enabling, explicitly select target-project values:

```bash
export AGENT_GITHUB_TOKEN='<retrieve from the target project secret store>'
export AGENT_GITHUB_ACTOR='<expected login>'
export AGENT_GITHUB_REPOSITORY='<owner/repository>'
scripts/check-github-context.sh
```

Configured toolsets:

```text
context,repos,issues,pull_requests,actions,code_security
```

Use GitHub MCP for:

- reading issue details when not already in prompt;
- reading linked PR details;
- checking workflow/Actions status;
- checking repository context;
- triage support;
- PR and issue automation after explicit instruction.

The wrapper checks that the token resolves to the expected actor and that the
current `origin` matches the expected repository. It never prints the token.
Do not derive this token automatically from the currently active `gh` account.

Do not use GitHub MCP for:

- bypassing branch protection;
- silently changing issues or PRs;
- pushing secrets;
- accessing unrelated repositories;
- making production-impacting decisions without human review.

## Context7 MCP

Configured in:

```text
.codex/config.toml
```

Use Context7 MCP when:

- the task depends on current framework/library API behavior;
- package docs may have changed recently;
- implementation requires current examples;
- local docs are insufficient.

Do not use Context7 MCP when:

- the answer is already in repository docs;
- the task is purely internal business/domain work;
- library version is pinned and local docs/tests are sufficient.

## MCP use decision

Before using MCP, run this mental checklist or invoke `mcp-usage-guard`:

```text
1. What external system is needed?
2. Is the task impossible or risky without it?
3. Is the action read-only or write-capable?
4. Does it require credentials?
5. Does it expose secrets or customer data?
6. Does it need human approval?
7. How will the MCP action be reported in the handoff?
```

## Optional MCP servers to add later

The starter template does not configure additional MCP servers. For UI-heavy projects, a browser automation MCP can be considered later as a separate UI extension after the basic workflow is stable.

Any future MCP must be added with least privilege, disabled by default, and documented in this file.
