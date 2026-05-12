# AGENTS.md: русская справка

`AGENTS.md` — главный контракт для Codex и других агентов.

Он должен отвечать на вопросы:

- где лежит source of truth;
- как агент начинает работу;
- когда можно менять файлы;
- какие команды проверки обязательны;
- какие действия запрещены без явного разрешения;
- когда нужно остановиться и запросить human review.

Базовые правила:

- один GitHub Issue = одна задача;
- человек общается с одним Lead / Orchestrator агентом в VS Code;
- Delivery Planner / Backlog Architect отвечает за decomposition, backlog, GitHub Issues/Projects metadata, priority, size, risk и dependencies;
- Orchestrator автономно запускает CLI-субагентов и собирает их handoff reports;
- одна задача = одна branch;
- одна branch = одна worktree;
- одна worktree = один write-owner;
- нет merge без validation и human review.

Для финального merge или high-risk approval Orchestrator должен дать краткую сводку:

- context;
- что изменилось;
- validation;
- результат agent review;
- риски;
- recommended action;
- why.
