---
name: mcp-usage-guard
description: Use before using MCP tools or after receiving MCP results to decide whether external tool access is necessary, safe, scoped, read-only or write-capable, and how to report it in handoff.
---

# MCP Usage Guard

## Purpose

Prevent unnecessary or unsafe external tool usage.

## Inputs

Read:

1. Current task or issue.
2. `docs/mcp-registry.md`.
3. `AGENTS.md`.
4. MCP server/tool being considered.
5. Intended read or write action.

## Decision checklist

Before using MCP, answer:

1. What external system is needed?
2. Why is repository-local context insufficient?
3. Is the action read-only or write-capable?
4. What credentials are required?
5. Could the action expose secrets or customer data?
6. Does the action touch production, billing, auth, security, CI, or infrastructure?
7. Is human approval required?
8. How will the MCP use be reported in PR handoff?

## Output format

```md
## MCP usage decision

MCP needed: yes | no

Server:

Tool/action category:

Read-only: yes | no

Write-capable: yes | no

Credentials needed:

Human approval required: yes | no

Reason:

Scope limit:

Data safety notes:

Handoff note:
```

## Default decisions

- GitHub issue/PR/Actions reads: allowed when needed.
- GitHub issue/PR writes: require explicit instruction.
- Context7 documentation lookup: allowed when current external docs are needed.
- Production data access: not allowed by default.
- Secrets access: not allowed.
- Infrastructure/apply/deploy actions: not allowed without explicit human approval.

## Do not

- Do not use MCP just because it is available.
- Do not use MCP to bypass local Git, CI, branch protection, or human review.
- Do not modify external systems without surfacing the plan first.
