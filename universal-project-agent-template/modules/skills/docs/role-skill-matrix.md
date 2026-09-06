# Roles and skills

Roles describe responsibilities, not separate mandatory agents.

| Role | Responsibility | Write mode |
|---|---|---|
| Lead / Implementer | Scoped implementation, checks and handoff for one task | One named writer per worktree |
| Batch Lead | Dependencies, checkpoints and integration within an approved batch | May implement when named owner |
| Program Orchestrator | Shared status, locks and merge order across related batches | Shared coordination only |
| Delivery Planner | Sources, decomposition, readiness and task metadata | Only authorized planning surfaces |
| Reviewer / QA | Independent behavior, negative cases and validation evidence | Read-only by default |
| Security Reviewer | Changed sensitive boundary and applicable policy | Read-only by default |
| Docs / Terminology | Authoritative source and derived-view consistency | Write only when assigned ownership |

Choose procedures from [the skill registry](skills-registry.md), not a fixed
role-to-skill checklist. One agent may hold multiple compatible roles; the
implementer cannot provide its own independent review.

For two independent code tasks and four available slots: coordinator, two
implementers in isolated worktrees and one reserve. Don't fill every slot with
duplicate diagnosis. For one shared sequential surface use one writer.

The task card names ownership transfers, base SHA, validation and next action.
Review evidence does not replace human approval, required CI or scoped authority.
