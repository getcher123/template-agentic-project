# Skills registry

This is a menu. Start from the task and select only procedures that affect the
next decision. Reuse the approved task card in the issue/handoff.

| Skill | Use when |
|---|---|
| capability-router | Non-trivial task needs level, C/R/U, model tier and authority selection |
| implementation-plan | Implementation decisions are missing before changes |
| issue-agent-readiness | Preparing delegation or verifying a changed task contract |
| orchestration-plan | One batch has dependencies or multiple roles |
| program-orchestrator | Two or more related batches share Leads, surfaces or merge order |
| codex-cli-orchestration | Dispatching concrete independent subagent work |
| source-index-builder | Source provenance needs discovery |
| terminology-map-builder | Business and technical terms conflict |
| requirement-slicing | Turning requirements into bounded tasks |
| refactoring-plan | A behavior-preserving refactor needs explicit invariants/scope |
| test-gap-review | Acceptance lacks reliable independent tests |
| security-review | A sensitive boundary changed or project policy requires its review |
| documentation-sync | Changed behavior or delivery rules affect exact documents |
| pr-handoff | Filling the canonical repository PR template with real evidence |
| mcp-usage-guard | An external operation needs a necessity/authority check |

One implementer is enough for a bounded sequential task. Roles may be combined.
Use a standard model for mechanical work and stronger reasoning for difficult
semantics/architecture. A capable model grants no authority.

No mandatory chain through every skill, repeated whole-project reading, full
local gate per checkpoint, or repeated review of unchanged code. The actual
project's required CI and human review remain in force.

Create a skill only when a concrete reusable procedure improves decisions;
avoid new files that merely duplicate AGENTS.md or the task card.
