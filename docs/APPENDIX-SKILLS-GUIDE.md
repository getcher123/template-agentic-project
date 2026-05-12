# Приложение A. Полный гайд по Skills для Codex New Project Agent Kit

Версия: 2026-05-03

Этот документ является приложением к архиву `codex-new-project-agent-kit.zip` и описывает, как использовать, поддерживать и расширять набор skills для запуска нового проекта в рамках workflow:

```text
GitHub Issue
→ GitHub Project
→ Orchestrator
→ selected roles
→ selected skills
→ one write-owner
→ git worktree
→ Codex implementation
→ PR
→ CI
→ human review
```

Главная идея: **skill — это не роль и не отдельный агент, а переиспользуемая процедура**. Роль отвечает за ответственность, skill отвечает за способ выполнения повторяемой работы, MCP отвечает за доступ к внешним системам, а `AGENTS.md` задаёт постоянные правила проекта.

Основная схема использования шаблона:

```text
Human operator
→ Lead / Orchestrator в VS Code
→ CLI subagents
→ handoff reports
→ Orchestrator synthesis
→ brief decision request
→ human merge или high-risk approval
```

Orchestrator должен брать на себя максимум координации и выводить человеку только финальные решения, небезопасные операции и вопросы, которые нельзя решить из issue/docs/repo context.

---

## 1. Назначение гайда

Гайд нужен, чтобы команда или solo-разработчик могли:

- быстро понять, какие skills уже есть в starter kit;
- правильно вызывать skills в Codex CLI и Codex IDE;
- не смешивать skills, роли, MCP и `AGENTS.md`;
- использовать skills на этапах документации, планирования, реализации, review и PR handoff;
- безопасно подключать MCP только там, где он действительно нужен;
- создавать новые skills без разрастания хаоса;
- держать агентный workflow воспроизводимым и проверяемым.

Минимальный принцип:

```text
Если действие повторяется больше 2–3 раз и имеет стабильный вход/выход — вынеси его в skill.
Если действие уникальное, спорное или требует решения человека — не делай из него skill слишком рано.
```

---

## 2. Словарь

| Термин | Значение | Где живёт |
|---|---|---|
| Skill | Переиспользуемая инструкция или процедура для Codex | `.agents/skills/issue-agent-readiness/SKILL.md` |
| Role | Ответственность агента в задаче | `docs/agent-roles.md` |
| MCP | Подключение к внешним системам и инструментам | `.codex/config.toml`, `docs/mcp-registry.md` |
| AGENTS.md | Постоянные правила проекта для Codex | `AGENTS.md` |
| Orchestrator | Роль, которая выбирает roles, skills, MCP и execution plan | `docs/agent-roles.md` |
| Write-owner | Единственный агент или человек, который меняет код в текущей worktree | GitHub Issue / Project / PR |
| Reviewer agent | Read-only агент, который проверяет diff, тесты, безопасность или docs | Subagent / Codex session |

Ключевое разделение:

```text
AGENTS.md = постоянные правила
Role = кто отвечает
Skill = как выполнять процедуру
MCP = чем пользоваться
Issue = что сделать
Worktree = где менять код
PR = что получилось
```

---

## 3. Структура skills в архиве

В архиве skills лежат здесь:

```text
.agents/
└── skills/
    ├── capability-router/
    │   └── SKILL.md
    ├── codex-cli-orchestration/
    │   └── SKILL.md
    ├── source-index-builder/
    │   └── SKILL.md
    ├── terminology-map-builder/
    │   └── SKILL.md
    ├── requirement-slicing/
    │   └── SKILL.md
    ├── issue-agent-readiness/
    │   └── SKILL.md
    ├── orchestration-plan/
    │   └── SKILL.md
    ├── refactoring-plan/
    │   └── SKILL.md
    ├── implementation-plan/
    │   └── SKILL.md
    ├── test-gap-review/
    │   └── SKILL.md
    ├── security-review/
    │   └── SKILL.md
    ├── documentation-sync/
    │   └── SKILL.md
    ├── pr-handoff/
    │   └── SKILL.md
    └── mcp-usage-guard/
        └── SKILL.md
```

Каждый skill — это отдельная папка. Минимально в ней должен быть файл `SKILL.md`. При необходимости можно добавить:

```text
references/   длинные справочные материалы
templates/    шаблоны документов или issue
scripts/      повторяемые команды и проверки
assets/       вспомогательные файлы
examples/     примеры хорошего и плохого результата
```

Рекомендуемая расширенная структура:

```text
.agents/skills/test-gap-review/
├── SKILL.md
├── references/
│   └── testing-policy.md
├── templates/
│   └── test-gap-report.md
└── examples/
    ├── good-review.md
    └── bad-review.md
```

---

## 4. Анатомия `SKILL.md`

Минимальный `SKILL.md` состоит из metadata block и инструкции.

```md
---
name: skill-name
description: Use when this exact repeatable workflow is needed. Include trigger words and clear boundaries.
---

# Skill Title

## Purpose

What this skill does and why it exists.

## Inputs

What files, issue fields, docs, diffs, logs, or context Codex must read.

## Procedure

Step-by-step workflow.

## Output format

The exact Markdown, table, checklist, command list, or report format expected.

## Do not

Safety boundaries and anti-patterns.
```

### 4.1. Правила для `name`

Хороший `name`:

```text
issue-agent-readiness
terminology-map-builder
security-review
pr-handoff
```

Плохой `name`:

```text
super-agent
senior-dev-helper
project-magic
fix-everything
```

Правила:

```text
- lowercase;
- kebab-case;
- отражает действие;
- не описывает должность;
- не обещает слишком широкий результат.
```

### 4.2. Правила для `description`

`description` — главный триггер выбора skill. Она должна говорить Codex, **когда** использовать skill.

Хорошо:

```text
description: Use before assigning a GitHub Issue to Codex. Determines whether an issue is agent-ready, needs human input, needs decomposition, or is not suitable for agent implementation.
```

Плохо:

```text
description: Helps with projects.
```

Хорошая description отвечает на вопросы:

```text
- когда использовать;
- какой вход ожидается;
- какой результат вернуть;
- когда не использовать.
```

---

## 5. Как Codex должен выбирать skills

Есть два режима использования.

### 5.1. Явный вызов

Используй явный вызов, когда важно управлять процессом:

```text
Используй skills:
- issue-agent-readiness
- orchestration-plan
- implementation-plan

Сначала проверь готовность issue. Не меняй файлы до implementation plan.
```

Такой подход лучше для:

```text
нового проекта;
первого запуска;
high-risk задач;
задач с неопределённым scope;
задач с MCP;
задач с несколькими ролями.
```

### 5.2. Неявный выбор

Codex может выбрать skill сам по описанию, если workflow очевиден. Это удобно для зрелого проекта, где skills уже стабильны.

Но для нашего стартового подхода правило такое:

```text
На старте проекта вызывай skills явно.
После стабилизации workflow можно разрешать неявный выбор.
```

---

## 6. Жизненный цикл skills в новом проекте

Основная цепочка:

```text
capability-router
→ selected roles and skills
→ codex-cli-orchestration, если нужны CLI subagents
→ source-index-builder
→ terminology-map-builder
→ requirement-slicing
→ issue-agent-readiness
→ orchestration-plan
→ refactoring-plan, если нужен behavior-preserving refactor
→ implementation-plan
→ test-gap-review
→ security-review, если есть риск
→ documentation-sync
→ pr-handoff
```

### 6.1. Этап 0: routing capabilities

Используется:

```text
capability-router
```

Цель:

```text
Выбрать минимально достаточную связку task type → roles → skills → optional MCP → escalation.
```

Выход:

```text
task type;
risk level;
required roles;
required skills;
optional MCP;
missing information;
escalation decision;
recommended next step.
```

Важно:

```text
capability-router не выполняет задачу, не меняет файлы и не включает MCP. Он только маршрутизирует работу.
```

### 6.1.1. Этап 0.5: CLI subagent orchestration

Используется:

```text
codex-cli-orchestration
```

Цель:

```text
Безопасно подготовить запуск Codex CLI subagent: роль, режим write-owner/read-only, scope, prompt, expected handoff, stop conditions и re-review criteria.
```

Выход:

```text
CLI subagent run plan;
subagent role;
mode;
scope;
prompt;
expected handoff;
stop conditions;
re-review criteria.
```

Важно:

```text
Этот skill не мержит PR, не даёт high-risk approval и не запускает dangerous commands. Он только задаёт протокол запуска CLI-субагентов.
```

### 6.2. Этап 1: источники

Используется:

```text
source-index-builder
```

Цель:

```text
Создать docs/00-source-index.md и не потерять, откуда взялись требования.
```

Выход:

```text
таблица источников;
уровень надёжности;
ключевые факты;
открытые вопросы;
какие docs затронуты.
```

### 6.3. Этап 2: терминология

Используется:

```text
terminology-map-builder
```

Цель:

```text
Связать бизнес-термины заказчика, менеджерские термины, доменные термины, кодовые имена и DB naming.
```

Выход:

```text
docs/02-terminology-map.md
```

### 6.4. Этап 3: нарезка требований

Используется:

```text
requirement-slicing
```

Цель:

```text
Превратить project brief, scope и процессы в epics, features и GitHub Issue drafts.
```

Выход:

```text
Epics
Features
Suggested GitHub Issues
Acceptance criteria
Allowed scope
Forbidden scope
Validation commands
```

### 6.5. Этап 4: готовность issue

Используется:

```text
issue-agent-readiness
```

Цель:

```text
Понять, можно ли отдавать конкретный issue Codex.
```

Возможные статусы:

```text
agent-ready
needs-human-input
needs-decomposition
not-agent-suitable
```

### 6.6. Этап 5: orchestration

Используется:

```text
orchestration-plan
```

Цель:

```text
Выбрать роли, skills, MCP, write-owner, reviewers и execution sequence.
```

### 6.7. Этап 6: план реализации

Используется:

```text
implementation-plan
```

Цель:

```text
Составить план до изменения файлов.
```

Важно:

```text
Для medium/high-risk задач implementation-plan должен быть принят человеком или Orchestrator перед редактированием кода.
```

### 6.8. Этап 7: review качества

Используется:

```text
test-gap-review
```

Цель:

```text
Проверить, покрыты ли acceptance criteria тестами и validation commands.
```

### 6.9. Этап 8: security review

Используется:

```text
security-review
```

Запускать обязательно, если diff касается:

```text
auth
authorization
billing
payments
database migrations
infrastructure
CI/CD
secrets
logging
customer data
new dependencies
external integrations
```

### 6.10. Этап 9: документация

Используется:

```text
documentation-sync
```

Цель:

```text
Проверить, нужно ли обновить terminology map, requirements, architecture, README или customer-facing summary.
```

### 6.11. Этап 10: PR handoff

Используется:

```text
pr-handoff
```

Цель:

```text
Собрать PR description, validation report, risk notes и human review focus.
```

---

## 7. Каталог skills

## 7.0. `capability-router`

### Когда использовать

```text
- в начале нетривиальной задачи;
- перед выбором ролей, skills или MCP;
- когда задача может быть feature, bugfix, review, QA, security или docs;
- когда нужно понять, требуется ли escalation.
```

### Входы

```text
task or issue text;
acceptance criteria;
allowed scope;
forbidden scope;
known risks;
current diff or PR context, if relevant;
AGENTS.md and project docs.
```

### Выход

```text
task type
risk level
required roles
required skills
optional MCP
missing information
escalation decision
recommended next step
```

### Не использовать

```text
для реализации задачи;
для изменения файлов;
для включения MCP;
для approval без human review.
```

---

## 7.0.1. `codex-cli-orchestration`

### Когда использовать

```text
- Orchestrator запускает Codex CLI subagent;
- нужно задать роль, режим, scope и prompt;
- нужен read-only review/QA/security/docs subagent;
- нужен write-owner Implementer внутри task worktree;
- нужен re-review после исправлений.
```

### Входы

```text
capability routing result;
issue/task context;
subagent role;
allowed scope;
forbidden scope;
write-owner decision;
validation commands;
risk level.
```

### Выход

```text
CLI Subagent Run Plan
Subagent role
Mode: write-owner | read-only
Scope
Prompt to run in Codex CLI
Expected handoff
Stop conditions
Re-review criteria
```

### Не использовать

```text
для merge;
для high-risk approval;
для dangerous commands;
для расширения scope;
для sandbox bypass в реальном repo, если Codex CLI sandbox не работает;
для замены human decision.
```

---

## 7.1. `source-index-builder`

### Когда использовать

```text
- старт нового проекта;
- трансформация существующего проекта;
- есть интервью, брифы, таблицы, старые docs, регламенты;
- требования пришли из разных источников;
- нужно отделить факты от предположений.
```

### Входы

```text
customer brief;
interview notes;
contract excerpts;
legacy README;
existing code/API names;
spreadsheets;
screenshots;
process notes;
security/compliance constraints.
```

### Выход

```text
docs/00-source-index.md
source reliability
key facts
open questions
source risks
recommended next skills
```

### Не использовать

```text
для реализации кода;
для превращения гипотез в requirements;
для назначения approval без подтверждения.
```

---

## 7.2. `terminology-map-builder`

### Когда использовать

```text
- есть термины клиент/user/account/request/ticket/status;
- бизнес говорит по-русски, код должен быть на английском;
- старый проект использует конфликтующие названия;
- нужно создать domain model;
- перед созданием первых GitHub Issues.
```

### Входы

```text
docs/00-source-index.md
docs/01-project-brief.md
docs/03-scope-and-requirements.md
кодовые имена
API routes
DB tables
UI labels
legacy docs
```

### Выход

```text
docs/02-terminology-map.md
canonical domain terms
code/API terms
database terms
allowed synonyms
forbidden synonyms
legacy compatibility notes
```

### Не использовать

```text
для массового переименования кода без отдельного issue;
для скрытия конфликтов терминов;
для смешивания customer-facing и engineering naming.
```

---

## 7.3. `requirement-slicing`

### Когда использовать

```text
- нужно создать backlog;
- есть project brief, scope, процессы;
- нужно превратить требования в agent-ready issues;
- feature слишком большая;
- нужно определить epics/features/tasks.
```

### Выход

```text
Epics
Features
Suggested GitHub Issues
Acceptance criteria
Allowed scope
Forbidden scope
Validation commands
Risk
Size
Dependencies
```

### Не использовать

```text
если нет project brief;
если нет terminology map для доменных терминов;
если заказчик ещё не согласовал scope первого релиза.
```

---

## 7.4. `issue-agent-readiness`

### Когда использовать

```text
- перед созданием worktree;
- перед запуском Codex на issue;
- перед добавлением label agent-ready;
- если scope кажется размытым;
- если задача может быть слишком большой.
```

### Выход

```text
Status: agent-ready | needs-human-input | needs-decomposition | not-agent-suitable
Risk classification
Missing information
Required roles
Required skills
Recommended labels
Suggested issue improvements
```

### Главный критерий

Issue можно отдавать Codex только если:

```text
objective clear
acceptance criteria testable
allowed scope listed
forbidden scope listed
validation commands listed
risk known
no secret access
no production access
fits one PR
terminology matches terminology map
```

---

## 7.5. `orchestration-plan`

### Когда использовать

```text
- задача medium или larger;
- несколько подсистем;
- нужны subagents;
- есть high-risk зоны;
- есть документационный или терминологический риск;
- нужно решить, нужен ли MCP.
```

### Выход

```text
orchestration mode
selected roles
selected skills
MCP decision
write-owner
read-only reviewers
execution sequence
validation commands
escalation triggers
```

### Важное правило

```text
В одной worktree только один write-owner.
Subagents подходят для параллельного анализа, но не для одновременного редактирования одного и того же кода.
```

---

## 7.5.1. `refactoring-plan`

### Когда использовать

```text
- перед behavior-preserving refactor;
- duplicate logic встречается в 3+ местах;
- функция или модуль блокирует безопасное изменение или тестирование;
- поведение нельзя протестировать без extraction или isolation;
- ответственность модуля размыта;
- повторяется один и тот же bug pattern;
- файл high-churn и fragile;
- legacy naming конфликтует с terminology map.
```

### Выход

```text
status: approved-in-scope | needs-separate-issue | blocked | fold-into-current-task
refactor trigger
behavior invariants
allowed changes
forbidden changes
tests or characterization
validation commands
rollback notes
recommendation
```

### Не использовать

```text
для cosmetic cleanup only;
для broad refactor внутри feature/bug issue;
для behavior changes без отдельного issue или explicit approval;
если нет tests или characterization path;
для unrelated formatting churn.
```

---

## 7.6. `implementation-plan`

### Когда использовать

```text
- перед изменением кода;
- после readiness и orchestration;
- когда нужно понять, какие файлы менять;
- перед medium/high-risk реализацией;
- перед передачей задачи Implementer Agent.
```

### Выход

```text
objective
scope
files likely to change
implementation steps
tests to add/update
validation commands
risks
rollback notes
```

### Не использовать

```text
как замену implementation;
как разрешение на high-risk правки без human approval;
как способ расширить scope issue.
```

---

## 7.7. `test-gap-review`

### Когда использовать

```text
- после implementation;
- перед PR;
- после CI failure;
- когда acceptance criteria много;
- когда тесты могли быть ослаблены;
- когда задача затрагивает бизнес-логику.
```

### Выход

```text
coverage table
missing tests
edge cases
regression risks
validation commands
recommendation: ready | needs-more-tests | blocked
```

### Не использовать

```text
как formal approval без human review;
для удаления assertions;
для признания PR готовым без validation.
```

---

## 7.8. `security-review`

### Когда использовать

```text
- auth;
- authorization;
- billing;
- payments;
- secrets;
- logging;
- customer data;
- dependencies;
- CI/CD;
- infra;
- migrations;
- external integrations.
```

### Выход

```text
Status: pass | needs-fix | requires-human-review
Findings table
Secret exposure check
Auth/authorization check
Dependency/supply-chain check
Required human review
Recommendation
```

### Не использовать

```text
для автоматического approval high-risk changes;
для production-impacting commands;
для просмотра или публикации секретов.
```

---

## 7.9. `documentation-sync`

### Когда использовать

```text
- изменился API;
- изменилась бизнес-логика;
- изменилась терминология;
- добавлена новая сущность;
- изменены роли пользователей;
- изменились requirements;
- changed behavior should be customer-visible.
```

### Выход

```text
Status: docs-current | docs-updated | docs-needed
Affected docs table
Terminology consistency
Customer-facing changes
Internal docs changes
Recommended PR notes
```

### Не использовать

```text
для внесения предположений как фактов;
для добавления внутренней agent terminology в customer-facing docs;
для создания новых terms без terminology map.
```

---

## 7.10. `pr-handoff`

### Когда использовать

```text
- перед открытием PR;
- перед обновлением PR description;
- после review subagents;
- после локальной validation;
- после CI failure fix;
- перед human review.
```

### Выход

```text
linked issue
summary
scope
validation
commands not run
agent roles used
skills used
MCP usage
risks
human review focus
rollback notes
checklist
```

### Не использовать

```text
для скрытия failing tests;
для создания видимости готовности без validation;
для замены human review.
```

---

## 7.11. `mcp-usage-guard`

### Когда использовать

```text
- перед использованием GitHub MCP;
- перед использованием Context7 MCP;
- перед любым внешним tool access;
- если MCP действие write-capable;
- если есть credentials;
- если действие касается production, security, CI или infra.
```

### Выход

```text
MCP needed: yes | no
Server
Tool/action category
Read-only
Write-capable
Credentials needed
Human approval required
Reason
Scope limit
Data safety notes
Handoff note
```

### Правило

```text
MCP используется только если локального repo context недостаточно.
MCP не должен обходить GitHub Issue, PR, CI, branch protection или human review.
```

---

## 8. Матрица выбора skills по этапам проекта

| Этап | Основной skill | Дополнительные skills |
|---|---|---|
| Capability routing | capability-router | codex-cli-orchestration, issue-agent-readiness, mcp-usage-guard |
| Сбор источников | source-index-builder | terminology-map-builder |
| Терминология | terminology-map-builder | source-index-builder, documentation-sync |
| Backlog | requirement-slicing | issue-agent-readiness, orchestration-plan |
| GitHub planning layer | issue-agent-readiness | requirement-slicing, mcp-usage-guard |
| Triage issue | issue-agent-readiness | terminology-map-builder |
| Планирование задачи | orchestration-plan | refactoring-plan, implementation-plan, mcp-usage-guard |
| Refactoring | refactoring-plan | implementation-plan, test-gap-review |
| Реализация | implementation-plan | refactoring-plan, pr-handoff |
| Review тестов | test-gap-review | issue-agent-readiness |
| Security review | security-review | mcp-usage-guard |
| Docs update | documentation-sync | terminology-map-builder |
| PR | pr-handoff | test-gap-review, security-review, documentation-sync |
| MCP decision | mcp-usage-guard | orchestration-plan |

---

## 9. Матрица roles → skills

| Role | Основные skills | Дополнительные skills |
|---|---|---|
| Orchestrator | issue-agent-readiness, orchestration-plan | mcp-usage-guard, pr-handoff |
| Delivery Planner / Backlog Architect | requirement-slicing, issue-agent-readiness | capability-router, orchestration-plan, mcp-usage-guard |
| Terminology / Analyst Agent | source-index-builder, terminology-map-builder | requirement-slicing, documentation-sync |
| PM / Scope Agent | requirement-slicing, issue-agent-readiness | orchestration-plan |
| Architect Agent | refactoring-plan, implementation-plan, documentation-sync | security-review |
| Implementer Agent | refactoring-plan, implementation-plan | pr-handoff |
| QA Reviewer Agent | test-gap-review | refactoring-plan, pr-handoff |
| Security Reviewer Agent | security-review, mcp-usage-guard | test-gap-review |
| Docs Agent | documentation-sync, terminology-map-builder | pr-handoff |

Правило:

```text
Роль может использовать несколько skills.
Skill может использоваться разными ролями.
Но skill не должен сам превращаться в “виртуального сотрудника”.
```

---

## 10. Skills и MCP

MCP подключает Codex к внешним системам. В starter kit есть два MCP-кандидата:

```text
github
context7
```

Они выключены по умолчанию в `.codex/config.toml`.

```toml
sandbox_mode = "workspace-write"
approval_policy = "on-request"

[sandbox_workspace_write]
network_access = false
```

### 10.1. Когда нужен GitHub MCP

Использовать только если нужно читать или управлять:

```text
GitHub Issues
Pull Requests
Actions/CI
repository context
code security context
issue/PR triage
```

Правила:

```text
Read-only GitHub context — можно, если это нужно для задачи.
Write actions в GitHub — только после явной команды.
Project/Issue/PR updates — должны отражаться в handoff.
MCP не заменяет branch protection и human review.
```

### 10.2. Когда нужен Context7 MCP

Использовать только если нужна актуальная документация внешних библиотек:

```text
новый framework API;
новая версия SDK;
неясный пример использования;
изменившаяся документация пакета.
```

Не использовать:

```text
если информация есть в репозитории;
если задача не зависит от внешних docs;
если доступ к сети не нужен;
если можно решить через README/AGENTS.md/project docs.
```

### 10.3. MCP decision flow

Перед MCP вызвать:

```text
mcp-usage-guard
```

Вопросы:

```text
1. Почему локального repo context недостаточно?
2. Какой MCP нужен?
3. Действие read-only или write-capable?
4. Какие credentials нужны?
5. Есть ли риск утечки данных?
6. Требуется ли human approval?
7. Как это будет описано в PR handoff?
```

---

## 11. Prompt-паттерны

### 11.1. Первый запуск нового проекта

```text
Работай как Orchestrator Agent для нового проекта.

Используй skills:
- source-index-builder
- terminology-map-builder
- requirement-slicing
- issue-agent-readiness
- orchestration-plan

Сначала не меняй код.
Подготовь минимальный documentation baseline, список GitHub Issues для первого релиза и критерии agent-ready.
```

### 11.2. Проверка issue перед Codex

```text
Используй skill issue-agent-readiness для GitHub issue #42.

Проверь:
- objective;
- acceptance criteria;
- allowed scope;
- forbidden scope;
- validation commands;
- risk level;
- terminology map consistency;
- human approval requirements.

Не меняй код.
Верни статус: agent-ready, needs-human-input, needs-decomposition или not-agent-suitable.
```

### 11.3. Orchestration перед работой

```text
Используй skills:
- issue-agent-readiness
- orchestration-plan
- mcp-usage-guard

Для issue #42 выбери:
- orchestration mode;
- roles;
- skills;
- whether MCP is needed;
- write-owner;
- read-only reviewers;
- validation commands;
- escalation triggers.

Не меняй файлы.
```

### 11.4. План реализации

```text
Используй skill implementation-plan.

Сначала составь план реализации для issue #42:
- files likely to change;
- files not to touch;
- implementation steps;
- tests to add/update;
- validation commands;
- risks;
- rollback notes.

Не редактируй файлы до завершения плана.
```

### 11.5. Review перед PR

```text
Используй skills:
- test-gap-review
- security-review, если diff затрагивает risk areas
- documentation-sync
- pr-handoff

Проверь текущий diff перед PR.
Не скрывай failing tests.
Не отмечай PR ready, если validation не запускалась.
Верни blocking, important и minor findings.
```

### 11.6. MCP decision

```text
Используй skill mcp-usage-guard.

Нужно решить, можно ли использовать GitHub MCP для issue #42.
Оцени:
- зачем нужен внешний доступ;
- read-only или write-capable действие;
- credentials;
- data safety;
- human approval;
- handoff note.

Не выполняй MCP write actions без явного разрешения.
```

---

## 12. Как создать новый skill

Новый skill нужен, если:

```text
workflow повторяется;
входы и выходы стабильны;
есть понятный owner;
есть критерий качества результата;
Codex часто ошибается без отдельной инструкции;
процедура не должна каждый раз копироваться в prompt.
```

Новый skill не нужен, если:

```text
это разовая задача;
это просто роль;
это желание “сделать агента умнее” без конкретного workflow;
это спорное решение без стабильного процесса;
это дублирует существующий skill.
```

### 12.1. Команды

```bash
mkdir -p .agents/skills/api-contract-review
touch .agents/skills/api-contract-review/SKILL.md
```

### 12.2. Шаблон нового `SKILL.md`

```md
---
name: api-contract-review
description: Use before PR readiness when an issue changes public API routes, request/response schemas, SDK contracts, or backward compatibility expectations. Do not use for purely internal refactors without API impact.
---

# New Skill Title

## Purpose

Describe the repeatable workflow this skill performs.

## When to use

- 
- 
- 

## Inputs

Read:

1. 
2. 
3. 

## Procedure

1. 
2. 
3. 

## Output format

```md
## Result

Status:

## Findings

- 

## Recommendation

- 
```

## Safety rules

- 
- 

## Do not

- 
- 
```

### 12.3. Обновить registry

После создания skill обновить:

```text
docs/skills-registry.md
```

Добавить строку:

```md
| new-skill-name | When to use | Inputs | Outputs | Main roles |
```

### 12.4. Проверить starter kit

```bash
./scripts/check-agent-kit.sh
```

---

## 13. Правила качества skills

Хороший skill:

```text
- имеет узкое назначение;
- имеет чёткий trigger;
- определяет входы;
- содержит пошаговую процедуру;
- возвращает структурированный output;
- содержит safety / do not;
- не дублирует другой skill;
- не требует лишнего MCP;
- не расширяет scope задачи;
- улучшает воспроизводимость.
```

Плохой skill:

```text
- называется слишком широко;
- говорит “помоги с проектом”;
- не имеет output format;
- смешивает analysis, implementation и review;
- требует внешние инструменты без причины;
- даёт агенту право на risky actions;
- противоречит AGENTS.md;
- создаёт виртуальную должность вместо процедуры.
```

---

## 14. Правила безопасности

Для skills действует общий security baseline:

```text
- Не читать и не публиковать секреты.
- Не редактировать production config без approval.
- Не запускать destructive commands.
- Не отключать тесты ради зелёного CI.
- Не использовать MCP без mcp-usage-guard, если есть credentials или write action.
- Не менять high-risk зоны без human review.
- Не создавать issue-ready статус без acceptance criteria и validation commands.
```

High-risk зоны:

```text
auth
authorization
billing
payments
database migrations
infrastructure
CI/CD
secrets
customer data
logging
dependencies
external integrations
```

---

## 15. Версионирование skills

Для starter kit достаточно простого changelog в `docs/skills-registry.md` или отдельного файла:

```text
docs/skills-changelog.md
```

Шаблон:

```md
# Skills Changelog

## 2026-05-03

### Added

- source-index-builder
- terminology-map-builder
- requirement-slicing
- issue-agent-readiness
- orchestration-plan
- implementation-plan
- test-gap-review
- security-review
- documentation-sync
- pr-handoff
- mcp-usage-guard

### Changed

- 

### Removed

- 
```

Когда менять skill:

```text
- Codex стабильно ошибается в одном месте;
- output format неудобен для PR/Issue;
- появились новые project rules;
- добавился новый MCP;
- role model изменилась;
- повторяемый workflow стал стабильным.
```

---

## 16. Антипаттерны

| Антипаттерн | Почему плохо | Как исправить |
|---|---|---|
| Один огромный skill на весь проект | загрязняет контекст и смешивает процессы | разделить на маленькие procedures |
| Skill как должность | непонятный output | role отдельно, skill отдельно |
| Skill без output format | результат нельзя проверить | добавить шаблон ответа |
| Skill вызывает MCP по умолчанию | риск credentials/network/data exposure | добавить mcp-usage-guard |
| Skill сам даёт approval | ломает human review | skill даёт recommendation, не approval |
| Skill меняет high-risk код | опасно | только Implementer с approval и review |
| Skill дублирует AGENTS.md | рассинхрон правил | AGENTS.md = постоянные правила, skill = процедура |
| Skill создаётся на каждую мелочь | бюрократия | создавать только для повторяемых процессов |

---

## 17. Минимальный рабочий набор для первого проекта

Если не хочется включать всё сразу, используй только 6 skills:

```text
capability-router
codex-cli-orchestration
source-index-builder
terminology-map-builder
requirement-slicing
issue-agent-readiness
pr-handoff
```

Для первого coding issue добавь:

```text
orchestration-plan
implementation-plan
test-gap-review
```

Для high-risk задач добавь:

```text
security-review
mcp-usage-guard
```

Для customer-facing или API изменений добавь:

```text
documentation-sync
```

---

## 18. Definition of Done для skills layer

Skills layer считается готовым, если:

```text
- .agents/skills существует;
- каждый skill имеет SKILL.md;
- каждый SKILL.md имеет name и description;
- docs/skills-registry.md описывает все skills;
- AGENTS.md ссылается на skills policy;
- есть capability-router;
- есть codex-cli-orchestration;
- есть mcp-usage-guard;
- есть pr-handoff;
- есть issue-agent-readiness;
- есть check-agent-kit.sh;
- первый issue прошёл через readiness → plan → PR handoff;
- команда понимает разницу между skills, roles, MCP и AGENTS.md.
```

---

## 19. Практическое правило выбора

```text
Не начинай с “какой агент нужен?”
Начинай с “какой task type и capability set нужны?”
Для этого используй capability-router.
```

Если процедура — проверка issue, нужен:

```text
issue-agent-readiness
```

Если процедура — нарезка требований:

```text
requirement-slicing
```

Если процедура — внешний доступ:

```text
mcp-usage-guard
```

Если процедура — финализация PR:

```text
pr-handoff
```

И только после этого выбирай роль:

```text
Orchestrator
Implementer
QA Reviewer
Security Reviewer
Docs Agent
```

---

## 20. Главный принцип

```text
Skills делают работу повторяемой.
Roles делают ответственность понятной.
MCP делает инструменты доступными.
AGENTS.md делает правила постоянными.
GitHub делает состояние каноническим.
Worktree делает изменения безопасно изолированными.
```

Если придерживаться этого разделения, система не превратится в избыточный “штат виртуальных сотрудников”, а останется практичной операционной моделью для Codex-native разработки.
