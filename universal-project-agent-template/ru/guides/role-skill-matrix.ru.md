# Матрица ролей и skills

Роль — это ответственность и ожидаемый результат. Skill — это повторяемая процедура. Не нужно создавать отдельный skill для каждой роли.

| Роль | Назначение | Может писать код? | Skills |
|---|---|---:|---|
| Lead / Orchestrator | выбрать роли, skills, MCP, risk level и последовательность | нет по умолчанию | capability-router, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Delivery Planner / Backlog Architect | декомпозиция требований, backlog, GitHub Issues/Projects planning metadata | код нет; planning metadata да | capability-router, requirement-slicing, issue-agent-readiness, orchestration-plan, mcp-usage-guard |
| Implementer | менять код как единственный write-owner | да | refactoring-plan, implementation-plan, pr-handoff |
| Reviewer | read-only review diff/PR и refactoring boundaries | нет | capability-router, refactoring-plan, test-gap-review, pr-handoff |
| Tester / QA | тесты, edge cases, bug reproduction | нет | capability-router, issue-agent-readiness, test-gap-review |
| Security Reviewer | auth, secrets, infra, CI, sensitive data | нет | capability-router, security-review, mcp-usage-guard |
| Docs / Terminology | документация, термины, требования | только docs | capability-router, source-index-builder, terminology-map-builder, documentation-sync |

`refactoring-plan` не меняет код. Он решает `approved-in-scope`, `needs-separate-issue`, `blocked` или `fold-into-current-task`, фиксирует invariants, allowed/forbidden changes и validation.

Главное правило:

```text
Одна worktree = один write-owner.
Параллельное мышление — через роли.
Параллельное изменение кода — через разные worktree.
```
