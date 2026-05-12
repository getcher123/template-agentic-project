# Подбор capabilities

Перед нетривиальной задачей сначала выбери минимальный набор возможностей:

```text
тип задачи -> роли -> skills -> optional MCP -> escalation
```

## Минимальный starter MCP

- GitHub MCP: только если локального контекста issue, PR, Actions или repo недостаточно.
- Context7 MCP: только если нужны актуальные docs библиотеки или фреймворка.

Другие MCP не входят в стартовый набор. Browser/Playwright можно рассмотреть позже как отдельное UI-расширение, но он не настраивается по умолчанию.

## Быстрая матрица

| Тип задачи | Роли | Skills | MCP |
|---|---|---|---|
| Новый проект | Lead / Orchestrator, Docs / Terminology | capability-router, source-index-builder, terminology-map-builder, requirement-slicing | none |
| Адаптация проекта | Lead / Orchestrator, Docs / Terminology, Reviewer | capability-router, source-index-builder, terminology-map-builder, documentation-sync | GitHub MCP при нехватке issue/PR контекста |
| Feature | Lead / Orchestrator, Implementer, Tester / QA | capability-router, issue-agent-readiness, implementation-plan, test-gap-review, pr-handoff | Context7 при необходимости |
| Bugfix | Lead / Orchestrator, Implementer, Tester / QA | capability-router, issue-agent-readiness, implementation-plan, test-gap-review, pr-handoff | GitHub MCP при необходимости |
| Review | Reviewer, Tester / QA | capability-router, test-gap-review, pr-handoff | GitHub MCP для PR/CI |
| Security-sensitive | Lead / Orchestrator, Security Reviewer, Reviewer | capability-router, security-review, mcp-usage-guard, test-gap-review | GitHub MCP read-only при необходимости |

