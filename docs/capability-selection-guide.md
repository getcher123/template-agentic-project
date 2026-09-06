# Capability selection

Start from the task, apply AGENTS.md, then select only necessary skills.

| Work | Smallest useful shape |
|---|---|
| Small bounded fix or docs edit | One implementer; affected checks |
| Resuming an approved batch | Verify changed SHA/scope/authority; reuse the plan |
| Independent implementation tasks | Separate writers/worktrees and integration owner |
| Multiple related batches | Program Orchestrator and shared dependency/merge order |
| Product/source uncertainty | Discover evidence; unresolved owner decisions block their dependants |
| Sensitive boundary change | Focused independent review plus required human approval |

Classify level (task/batch/program), complexity C1–C4, risk R1–R4,
uncertainty U0–U2 and read/local/external write separately.
Standard models suit bounded mechanical changes; stronger reasoning suits
semantic conflicts and architecture. Risk does not automatically require a
costlier implementer.

External tools are optional: repository-local context first, read-only when
sufficient, explicit scope and current authority before writes. Starter MCP
configuration is disabled and separate from a consuming project's user config.

Do not turn this guide into another mandatory planning document.
