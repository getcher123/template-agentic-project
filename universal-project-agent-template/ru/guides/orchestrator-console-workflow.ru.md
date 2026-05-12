# Orchestrator Console Workflow

Это основная схема работы шаблона.

Человек общается с одним Lead / Orchestrator агентом в VS Code. Orchestrator сам запускает CLI-субагентов, принимает их handoff reports, просит исправления, запускает re-review и готовит финальный запрос решения.

## Модель работы

```text
Human operator
-> Lead / Orchestrator в VS Code
-> capability-router
-> codex-cli-orchestration
-> CLI subagents
-> subagent handoff reports
-> Orchestrator synthesis
-> fixes / re-review
-> PR handoff
-> brief decision request
-> human merge или high-risk approval
```

## Принцип автономности

Orchestrator должен брать на себя максимум координации:

- выбрать roles, skills, risk level и optional MCP;
- использовать `codex-cli-orchestration` перед запуском CLI-субагентов;
- запустить bounded subagents;
- следить за правилом one write-owner;
- собрать findings;
- запросить исправления;
- повторить agent review;
- подготовить PR handoff;
- вывести человеку только финальный краткий запрос решения.

## Протокол запуска CLI-субагента

Перед запуском CLI-субагента Orchestrator фиксирует:

- доступность sandbox и fallback-решение;
- роль субагента;
- режим: `write-owner` или `read-only`;
- allowed и forbidden scope;
- prompt для Codex CLI;
- ожидаемый handoff;
- stop conditions;
- критерии re-review.

Reviewer, Tester / QA, Security Reviewer и Docs / Terminology по умолчанию read-only. Implementer может быть write-owner только внутри текущей task worktree и утверждённого scope.

Если Codex CLI sandbox не работает в реальном репозитории, Orchestrator не должен переходить на sandbox bypass. Нужно остановиться с `blocked`, предложить установить Bubblewrap при отсутствии `bwrap`, либо запускать проверку только в disposable copy, если достаточно одноразовой валидации.

## Финальный запрос решения

Для merge или high-risk approval Orchestrator должен дать:

```md
## Decision Request

### Context

<issue/PR, task type, risk level>

### What changed

-

### Validation

-

### Agent review result

-

### Risks

-

### Recommended action

Approve merge | Approve high-risk action | Request changes | Block

### Why

<одно-два предложения>
```

Orchestrator может рекомендовать действие, но финальная ответственность остаётся за человеком.
