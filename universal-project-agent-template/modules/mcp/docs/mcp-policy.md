# MCP Policy

MCP is tool access, not authority.

## Default

- MCP servers are disabled by default.
- Enable only the server needed for the current task.
- Prefer read-only access.
- Report MCP usage in the PR handoff.

## Allowed Uses

- Read GitHub issue or PR context when the prompt does not contain enough detail.
- Inspect GitHub Actions status for the current PR.
- Fetch current framework or library documentation when local docs are insufficient.

## Forbidden Uses

- Do not access secrets, production data, customer private data, or unrelated repositories.
- Do not bypass branch protection, CI, PR review, or human approval.
- Do not perform write actions through MCP unless explicitly requested and reported.
- Do not use MCP to expand the task scope beyond the linked issue.

## Decision Checklist

Before using MCP:

1. What external system is needed?
2. Is the task impossible or meaningfully riskier without it?
3. Is the action read-only or write-capable?
4. Does it require credentials?
5. Could it expose secrets or customer data?
6. Does it need human approval?
7. How will it be reported in the handoff?

