# Skills Registry

This registry defines the minimum skills used in the project startup and multiagent delivery workflow.

## Primary workflow

The default operating model is Orchestrator Console Workflow:

```text
Human operator -> Lead / Orchestrator in VS Code -> CLI subagents -> handoff reports -> Orchestrator synthesis -> decision request
```

The Orchestrator should maximize autonomous coordination and ask the human only for final merge, high-risk approval, missing business decisions, or unsafe operations.

## Skill lifecycle

```text
Task or issue
→ capability-router
→ selected roles and skills
→ codex-cli-orchestration, when CLI subagents are needed
→ Raw sources, when needed
→ source-index-builder
→ terminology-map-builder
→ requirement-slicing, for backlog decomposition
→ issue-agent-readiness, for issue and Project readiness
→ orchestration-plan
→ implementation-plan
→ implementation
→ test-gap-review
→ security-review when needed
→ documentation-sync
→ pr-handoff
```

## Skills

| Skill | Use when | Output |
|---|---|---|
| capability-router | before non-trivial work, to select roles, skills, MCP, risk, and escalation | routing summary, required roles, required skills, optional MCP, missing info |
| codex-cli-orchestration | when Lead / Orchestrator needs to launch and manage Codex CLI subagents | CLI subagent run plan, prompt, expected handoff, stop conditions, re-review criteria |
| source-index-builder | starting a new project or transforming an existing one | `docs/00-source-index.md` entries, reliability, open questions |
| terminology-map-builder | terms are unclear or business/code language diverges | canonical terminology table |
| requirement-slicing | turning brief/processes into GitHub Issues and backlog slices | epics, features, issue drafts, dependencies |
| issue-agent-readiness | before assigning work to Codex or marking Project items ready | readiness decision, missing info, recommended labels/status |
| orchestration-plan | task needs multiple roles, skills, or risk review | role plan, skill plan, write-owner, execution sequence |
| implementation-plan | before code changes | files likely to change, steps, tests, validation |
| test-gap-review | before PR readiness | missing tests, edge cases, validation gaps |
| security-review | auth, billing, DB, infra, CI, dependency, secret, data exposure risks | security findings and escalation decision |
| documentation-sync | behavior, terminology, API, or customer-facing docs changed | docs update plan and docs diff guidance |
| pr-handoff | before opening/updating PR | PR-ready handoff report |
| mcp-usage-guard | before using MCP tools | MCP usage plan, permission/risk decision |

## Explicit invocation examples

```text
Use $capability-router for issue #12. Choose required roles, required skills, optional MCP, and escalation.
```

```text
Use $codex-cli-orchestration to prepare a read-only Reviewer subagent prompt for the current diff.
```

```text
Use $issue-agent-readiness for issue #12 and tell me whether it is agent-ready.
```

```text
Use $orchestration-plan and $mcp-usage-guard. Decide if GitHub MCP is needed for this task.
```

```text
Use $test-gap-review on the current diff. Do not modify files.
```

```text
Use $pr-handoff and prepare the PR body for the current branch.
```

## Design rule

Do not create a new skill until the workflow has repeated at least three times and the procedure is stable enough to document.

## Starter skill groups

| Group | Skills |
|---|---|
| Routing and orchestration | capability-router, codex-cli-orchestration |
| Core delivery | issue-agent-readiness, implementation-plan, pr-handoff |
| Project setup | source-index-builder, terminology-map-builder, requirement-slicing, documentation-sync |
| Backlog and GitHub planning | requirement-slicing, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Review and risk | orchestration-plan, test-gap-review, security-review, mcp-usage-guard |
