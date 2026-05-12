# Гайд: ролевая модель проекта для мультиагентной разработки

Версия: 2026-05-03

Документ описывает ролевую модель проекта в рамках workflow:

```text
GitHub Issues
→ GitHub Project
→ Orchestrator Agent
→ selected roles
→ selected skills
→ one write-owner
→ git worktree
→ Pull Request
→ CI
→ human review
→ merge
```

Цель ролевой модели — не имитировать штат сотрудников, а сделать работу людей и AI-агентов управляемой, проверяемой и безопасной.

---

## 1. Главный принцип

```text
Роль — это не персона.
Роль — это контракт на результат.
```

Роль должна отвечать на вопросы:

```text
зачем она нужна;
когда она включается;
какие входные данные читает;
какой результат отдаёт;
что ей разрешено;
что ей запрещено;
когда она должна остановиться и передать вопрос человеку.
```

Плохая ролевая модель:

```text
CEO Agent
CTO Agent
Senior Backend Agent
Middle Backend Agent
Junior Backend Agent
Scrum Master Agent
QA Lead Agent
DevOps Agent
```

Почему плохо:

```text
много имитации;
непонятные границы ответственности;
растёт число обсуждений;
нет проверяемого результата;
появляется “театр ролей”.
```

Хорошая ролевая модель:

```text
Orchestrator Agent
Terminology Agent
Requirements Agent
Architect Reviewer
Implementer Agent
QA Reviewer
Security Reviewer
Docs Agent
Human Reviewer
```

Почему хорошо:

```text
каждая роль имеет понятный output;
каждая роль включается только при необходимости;
права на изменение кода ограничены;
review отделён от implementation;
GitHub остаётся source of truth.
```

---

## 2. Минимальная ролевая модель

Для запуска нового проекта не нужно включать все роли сразу.

Минимальный набор:

```text
1. Human Owner
2. Orchestrator Agent
3. Implementer Agent
4. Reviewer / QA Agent
```

Расширенный набор:

```text
5. Terminology Agent
6. Requirements Agent
7. Architect Reviewer
8. Security Reviewer
9. Documentation Agent
10. Release / Delivery Reviewer
```

Правило масштабирования:

```text
XS/S task → single agent + required skill
M task → Orchestrator + Implementer + Reviewer
High-risk task → add Security Reviewer and/or Architect Reviewer
Docs-heavy task → add Terminology Agent and Documentation Agent
Cross-functional task → split into multiple issues and worktrees
```

---

## 3. Слои ролей

Роли делятся на четыре слоя.

| Слой | Роли | Назначение |
|---|---|---|
| Business | Customer, Sponsor, Product Owner | определить бизнес-смысл, приёмку, ограничения |
| Delivery | Delivery Lead, Human Owner, Orchestrator Agent | управлять scope, статусами, рисками, handoff |
| Engineering | Architect, Implementer, Reviewer, QA, Security | проектировать, реализовывать, проверять |
| Agent Operations | Orchestrator Agent, subagents, skills, MCP guard | безопасно запускать AI-работу внутри правил проекта |

Главное правило:

```text
Бизнес-роли не должны думать терминами worktree, CI и skills.
Агентные роли не должны менять бизнес-scope без GitHub Issue update.
```

---

## 4. Source of truth

Роли не являются источником правды сами по себе.

| Что | Source of truth |
|---|---|
| Бизнес-цель | `docs/01-project-brief.md` |
| Терминология | `docs/02-terminology-map.md` |
| Scope и требования | `docs/03-scope-and-requirements.md` |
| Архитектура | `docs/05-architecture-and-data.md` |
| Правила для агентов | `AGENTS.md` |
| Задача | GitHub Issue |
| Статус работы | GitHub Project |
| Изменения кода | Pull Request |
| Качество | CI checks |
| Локальная координация | `STATE.md` |

Правило:

```text
Если роль нашла противоречие, она не “решает сама”, а фиксирует его в issue, PR comment или handoff report.
```

---

## 5. Human roles

### 5.1. Customer / заказчик

Назначение:

```text
задаёт бизнес-контекст;
подтверждает бизнес-термины;
согласует scope;
принимает результат на языке бизнеса.
```

Читает:

```text
docs/01-project-brief.md
docs/08-customer-facing-summary.md
acceptance criteria в customer-facing формулировке
```

Не должен разбираться в:

```text
worktree;
Codex;
SKILLS;
MCP;
CI;
branch protection;
internal architecture details.
```

Выход:

```text
подтверждённые бизнес-термины;
согласованный scope;
приёмочные критерии;
ответы на open questions.
```

---

### 5.2. Product Owner / владелец продукта

Назначение:

```text
переводит бизнес-цели в requirements;
поддерживает терминологию;
приоритизирует features;
решает продуктовые trade-offs.
```

Читает:

```text
docs/01-project-brief.md
docs/02-terminology-map.md
docs/03-scope-and-requirements.md
docs/04-processes-and-user-journeys.md
GitHub Issues
GitHub Project
```

Выход:

```text
приоритеты;
acceptance criteria;
решения по scope;
готовность issue к разработке;
ответы на needs-human-input.
```

---

### 5.3. Delivery Lead / менеджер поставки

Назначение:

```text
следит за потоком задач;
управляет статусами GitHub Project;
контролирует зависимости;
не допускает перегрузки агентного процесса;
следит за тем, чтобы Done означал реально готово.
```

Читает:

```text
GitHub Project
GitHub Issues
Pull Requests
CI status
STATE.md
```

Выход:

```text
приоритеты delivery;
порядок merge;
статусы задач;
эскалации;
release readiness.
```

---

### 5.4. Human Reviewer

Назначение:

```text
принимает финальное решение по PR;
проверяет scope, риски и качество;
не полагается только на самооценку агента;
блокирует merge, если есть сомнения.
```

Читает:

```text
GitHub Issue
PR diff
CI results
agent handoff report
CODEOWNERS areas
docs/ если поведение или терминология изменились
```

Выход:

```text
approve;
request changes;
comment;
block merge;
request decomposition;
request security/architecture review.
```

---

## 6. AI agent roles

## 6.1. Orchestrator Agent

### Purpose

Orchestrator Agent управляет агентным контуром задачи от issue до handoff. Он не является главным источником правды и не заменяет человека.

### Когда использовать

```text
задача размера M или выше;
есть несколько подсистем;
есть неоднозначная терминология;
есть риск high/critical;
нужно несколько reviewer roles;
нужно решить, можно ли отдавать задачу Implementer Agent;
нужно разбить задачу на sub-issues.
```

### Inputs

```text
GitHub Issue
GitHub Project fields
AGENTS.md
docs/01-project-brief.md
docs/02-terminology-map.md
docs/03-scope-and-requirements.md
docs/05-architecture-and-data.md
current branch/worktree status
```

### Outputs

```text
agent-readiness decision;
required roles;
required skills;
required MCP access;
risk classification;
implementation plan;
write-owner assignment;
review plan;
handoff summary.
```

### Allowed actions

```text
read repository;
read docs;
read issue and PR context;
propose decomposition;
spawn read-only specialist agents;
prepare execution plan;
prepare PR handoff structure;
update docs only if explicitly asked.
```

### Forbidden actions

```text
expand scope without issue update;
approve high-risk changes alone;
merge PR;
bypass CI;
edit secrets;
run privileged commands;
allow multiple write-owners in one worktree.
```

### Escalation

Orchestrator must escalate to human when:

```text
requirements conflict;
terminology is ambiguous;
scope is unclear;
high-risk areas are touched;
subagents disagree on blocking issues;
CI failure root cause is unclear;
merge conflict touches db/auth/billing/infra/security/CI.
```

### Prompt template

```text
Ты Orchestrator Agent для GitHub issue #<number>.

Работай по правилам:

1. Source of truth: GitHub Issue, GitHub Project, AGENTS.md, docs/.
2. Сначала проверь agent-readiness.
3. Определи required roles и required skills.
4. Если задача read-heavy или risky, предложи read-only subagents.
5. Если задача write-heavy, назначь только одного write-owner.
6. Не меняй код на этом этапе.
7. Верни execution plan, risk assessment и handoff для Implementer.
```

---

## 6.2. Terminology Agent

### Purpose

Следит за тем, чтобы бизнес-термины, доменные термины, кодовые имена, API и БД не расходились.

### Когда использовать

```text
новый проект;
существующий проект с терминологическим хаосом;
задача использует слова “клиент”, “пользователь”, “аккаунт”, “заявка”, “заказ”, “сделка” неоднозначно;
нужно обновить docs/02-terminology-map.md;
заказчик использует термины, которых нет в документации.
```

### Inputs

```text
docs/00-source-index.md
docs/01-project-brief.md
docs/02-terminology-map.md
docs/03-scope-and-requirements.md
GitHub Issue
existing code names
API names
DB names
```

### Outputs

```text
terminology diff;
new or updated glossary entries;
ambiguous terms list;
forbidden synonyms;
recommended canonical names;
impact on code/API/DB naming.
```

### Required skills

```text
terminology-map-builder
source-index-builder
requirement-slicing
```

### Forbidden actions

```text
rename code entities without explicit implementation issue;
break public API compatibility;
change customer-facing terms without Product Owner approval.
```

---

## 6.3. Requirements Agent

### Purpose

Превращает бриф, процессы и scope в GitHub Issues, которые можно отдать агентам или людям.

### Когда использовать

```text
нужно создать backlog первого релиза;
есть большой бриф без декомпозиции;
feature слишком большая для одного PR;
issue не имеет acceptance criteria;
нужно понять dependencies между задачами.
```

### Inputs

```text
docs/01-project-brief.md
docs/02-terminology-map.md
docs/03-scope-and-requirements.md
docs/04-processes-and-user-journeys.md
docs/05-architecture-and-data.md
```

### Outputs

```text
epics;
features;
agent-ready issue drafts;
acceptance criteria;
allowed scope;
forbidden scope;
validation commands;
dependencies;
labels and Project fields.
```

### Required skills

```text
requirement-slicing
issue-agent-readiness
terminology-map-builder
```

---

## 6.4. Architect Reviewer

### Purpose

Проверяет архитектурные последствия задачи до реализации или перед merge.

### Когда использовать

```text
изменяется data model;
изменяется публичный API;
затронуты несколько сервисов;
есть интеграции;
есть миграции;
есть риск breaking change;
задача size M/L.
```

### Inputs

```text
docs/05-architecture-and-data.md
GitHub Issue
PR diff
API contracts
DB schema
existing module boundaries
```

### Outputs

```text
affected modules;
architecture risks;
data model impact;
API compatibility notes;
recommended boundaries;
blocking findings.
```

### Required skills

```text
implementation-plan
test-gap-review
security-review, если затронуты sensitive areas
```

### Forbidden actions

```text
самостоятельно менять код в review режиме;
перепроектировать scope без отдельного issue;
игнорировать backward compatibility.
```

---

## 6.5. Implementer Agent

### Purpose

Единственная агентная роль, которая по умолчанию имеет право менять код в task worktree.

### Когда использовать

```text
issue agent-ready;
есть отдельная branch;
есть отдельная worktree;
allowed scope и forbidden scope указаны;
validation commands известны;
Orchestrator или Human Owner подтвердил readiness.
```

### Inputs

```text
GitHub Issue
AGENTS.md
docs/02-terminology-map.md
docs/03-scope-and-requirements.md
docs/05-architecture-and-data.md
implementation plan
current worktree
```

### Outputs

```text
code diff;
tests;
updated docs when behavior changes;
local validation result;
implementation notes;
PR handoff draft.
```

### Required skills

```text
implementation-plan
pr-handoff
documentation-sync, если меняется поведение или API
test-gap-review, перед финальным handoff
security-review, если затронуты high-risk areas
```

### Allowed actions

```text
edit files inside current worktree;
add tests;
run local validation commands;
commit changes when asked;
prepare PR body.
```

### Forbidden actions

```text
edit secrets;
change production config;
change infra without approval;
add dependencies without explanation;
remove tests to make CI pass;
expand scope;
resolve high-risk conflicts alone;
write outside current worktree.
```

---

## 6.6. QA Reviewer Agent

### Purpose

Проверяет, покрыты ли acceptance criteria тестами и нет ли очевидных регрессий.

### Когда использовать

```text
перед PR;
после реализации issue;
CI упал;
изменяется бизнес-логика;
задача содержит edge cases;
человек хочет независимый review тестов.
```

### Inputs

```text
GitHub Issue
acceptance criteria
PR diff
tests
CI output
AGENTS.md
```

### Outputs

```text
missing tests;
edge cases;
regression risks;
flaky test risks;
recommended validation commands;
blocking findings.
```

### Required skills

```text
test-gap-review
pr-handoff
```

### Forbidden actions

```text
менять production code в review режиме;
удалять тесты;
ослаблять assertions;
считать PR готовым при failing tests без явного объяснения.
```

---

## 6.7. Security Reviewer Agent

### Purpose

Проверяет security-sensitive риски.

### Когда использовать

```text
затронуты auth;
затронуты roles/permissions;
затронут billing/payment;
затронуты secrets;
затронуты dependencies;
затронуты CI/CD;
затронута инфраструктура;
изменяется логирование пользовательских данных;
меняется доступ к данным клиента.
```

### Inputs

```text
GitHub Issue
PR diff
AGENTS.md
docs/06-quality-security-constraints.md
CODEOWNERS
CI output
dependency files
```

### Outputs

```text
auth risks;
authorization risks;
secret exposure risks;
unsafe logging risks;
dependency risks;
CI/CD risks;
blocking findings;
human review recommendation.
```

### Required skills

```text
security-review
mcp-usage-guard, если нужен внешний security context
```

### Forbidden actions

```text
самостоятельно менять security-sensitive code;
считать secret безопасным;
выводить секреты в лог, prompt или PR body;
пропускать human review для high-risk изменений.
```

---

## 6.8. Documentation Agent

### Purpose

Синхронизирует внутреннюю и customer-facing документацию с изменениями в проекте.

### Когда использовать

```text
изменяется терминология;
изменяется API;
изменяется бизнес-процесс;
изменяется user journey;
изменяются acceptance criteria;
нужно подготовить release notes;
нужно обновить customer-facing summary.
```

### Inputs

```text
docs/00-source-index.md
docs/01-project-brief.md
docs/02-terminology-map.md
docs/03-scope-and-requirements.md
docs/04-processes-and-user-journeys.md
docs/05-architecture-and-data.md
GitHub Issue
PR diff
```

### Outputs

```text
documentation diff;
terminology consistency report;
customer-facing wording;
release notes draft;
docs update summary for PR.
```

### Required skills

```text
documentation-sync
terminology-map-builder
pr-handoff
```

### Forbidden actions

```text
менять business promise без Product Owner approval;
добавлять internal agent terminology в customer-facing docs;
обновлять документацию так, будто feature готова, если PR ещё не merged.
```

---

## 6.9. MCP Guard Agent

### Purpose

Проверяет, нужен ли MCP для задачи и безопасно ли его включать.

### Когда использовать

```text
агент просит доступ к GitHub MCP;
агент просит внешний documentation MCP;
нужен доступ к Issues/PR/Actions;
нужна свежая документация библиотек;
есть риск утечки секретов;
есть сомнение, нужен ли network access.
```

### Inputs

```text
GitHub Issue
AGENTS.md
.codex/config.toml
requested MCP server
requested MCP tools
reason for access
```

### Outputs

```text
MCP needed: yes/no;
server recommended;
allowed toolsets;
forbidden toolsets;
risk level;
human approval required: yes/no;
recommended config.
```

### Required skills

```text
mcp-usage-guard
security-review, если есть sensitive context
```

### Forbidden actions

```text
включать MCP без причины;
включать network access по умолчанию;
выдавать широкие токены;
использовать MCP для обхода local sandbox;
передавать секреты в MCP.
```

---

## 7. RACI matrix

RACI:

```text
R = Responsible, выполняет работу
A = Accountable, принимает итоговое решение
C = Consulted, консультируется
I = Informed, получает информацию
```

| Activity | Customer | Product Owner | Delivery Lead | Orchestrator | Implementer | QA Reviewer | Security Reviewer | Human Reviewer |
|---|---|---|---|---|---|---|---|---|
| Define business goal | A/R | R | I | I | I | I | I | I |
| Approve terminology | C | A/R | I | C | I | I | I | I |
| Create project brief | C | A/R | C | C | I | I | I | I |
| Slice requirements | I | A | C | R | I | C | C | I |
| Mark issue agent-ready | I | A | C | R | I | C | C | I |
| Create worktree | I | I | C | R | C | I | I | I |
| Implement code | I | I | I | C | R | I | I | I |
| Add tests | I | I | I | C | R | C | I | I |
| QA review | I | I | C | C | I | R | I | A/C |
| Security review | I | I | C | C | I | I | R | A/C |
| Open PR | I | I | C | C | R | I | I | I |
| Approve PR | I | I | C | I | I | C | C | A/R |
| Merge PR | I | I | A/R | I | I | I | I | C |
| Release notes | I | C | A | C | C | C | C | R |

Правило:

```text
Agent может быть Responsible.
Human должен оставаться Accountable для high-risk изменений и финального merge.
```

---

## 8. Связь ролей, skills и MCP

Роли, skills и MCP — разные сущности.

| Сущность | Что означает | Пример |
|---|---|---|
| Role | кто какую функцию выполняет | QA Reviewer Agent |
| Skill | как выполнить повторяемую процедуру | test-gap-review |
| MCP | к какому внешнему инструменту можно обратиться | GitHub MCP |
| AGENTS.md | постоянные правила проекта | “не трогать secrets” |
| GitHub Issue | контракт задачи | issue #42 |
| Worktree | изоляция записи | wt-issue-42 |

Правило:

```text
Role выбирает responsibility.
Skill задаёт процедуру.
MCP даёт доступ к внешней системе.
AGENTS.md задаёт ограничения.
```

Пример:

```text
Security Reviewer Agent
→ uses security-review skill
→ may request GitHub MCP for PR/security context
→ works read-only
→ escalates high-risk findings to Human Reviewer
```

---

## 9. Ролевые режимы задач

Каждая GitHub Issue должна иметь orchestration mode.

| Mode | Когда использовать | Роли |
|---|---|---|
| single-agent | маленькая задача, низкий риск | Implementer |
| orchestrator-plus-reviewer | средняя задача | Orchestrator, Implementer, QA Reviewer |
| orchestrator-plus-specialists | сложная или рискованная задача | Orchestrator, Implementer, QA, Security, Architect, Docs |
| split-required | задача слишком большая | Orchestrator, Requirements Agent, Human Owner |

Примеры:

```text
Fix typo in README
→ single-agent
```

```text
Add healthcheck endpoint with tests
→ single-agent or orchestrator-plus-reviewer
```

```text
Add user deactivation with audit log and permissions
→ orchestrator-plus-specialists
```

```text
Build complete billing module
→ split-required
```

---

## 10. Write-owner policy

Главное правило безопасной мультиагентной разработки:

```text
В одной worktree только один write-owner.
```

Разрешено:

```text
Implementer Agent меняет код.
QA Reviewer читает diff и предлагает замечания.
Security Reviewer читает diff и предлагает замечания.
Documentation Agent меняет docs, если это явно разрешено.
Orchestrator собирает итог и обновляет handoff.
```

Запрещено:

```text
несколько агентов одновременно меняют один и тот же код;
reviewer-agent правит production code без отдельной команды;
security-agent меняет auth logic в review режиме;
docs-agent меняет бизнес-scope;
Orchestrator расширяет задачу без issue update.
```

Если нужно несколько write-owners, задачу надо разделить:

```text
one large issue
→ multiple sub-issues
→ multiple branches
→ multiple worktrees
→ multiple PRs
```

---

## 11. Роли в GitHub Issue

В `agent-task.yml` рекомендуется добавить поля:

```yaml
  - type: textarea
    id: required_roles
    attributes:
      label: Required roles
      value: |
        - Orchestrator Agent
        - Implementer Agent
        - QA Reviewer Agent

  - type: textarea
    id: required_skills
    attributes:
      label: Required skills
      value: |
        - issue-agent-readiness
        - orchestration-plan
        - implementation-plan
        - test-gap-review
        - pr-handoff

  - type: dropdown
    id: orchestration_mode
    attributes:
      label: Orchestration mode
      options:
        - single-agent
        - orchestrator-plus-reviewer
        - orchestrator-plus-specialists
        - split-required
```

---

## 12. Роли в GitHub Project

Рекомендуемые поля:

| Field | Type | Values |
|---|---|---|
| Orchestration mode | Single select | single-agent, orchestrator-plus-reviewer, orchestrator-plus-specialists, split-required |
| Primary role | Single select | Orchestrator, Implementer, Reviewer, Security, Docs |
| Write owner | Text | agent or human owner |
| Required roles | Text | list of roles |
| Required skills | Text | list of skills |
| Risk review | Single select | none, QA, security, architecture, human |
| Agent readiness | Single select | not-ready, ready, blocked, split-required |

Пример:

```text
Issue: #42 Add user deactivation
Status: Ready
Size: M
Risk: Medium
Orchestration mode: orchestrator-plus-specialists
Primary role: Orchestrator
Write owner: Implementer Agent
Required roles: Orchestrator, Implementer, QA Reviewer, Security Reviewer, Docs Agent
Required skills: issue-agent-readiness, implementation-plan, test-gap-review, security-review, documentation-sync, pr-handoff
Risk review: security
Agent readiness: ready
```

---

## 13. Роли в PR template

Добавить блок:

```md
## Agent roles used

- [ ] Orchestrator Agent
- [ ] Terminology Agent
- [ ] Requirements Agent
- [ ] Architect Reviewer
- [ ] Implementer Agent
- [ ] QA Reviewer Agent
- [ ] Security Reviewer Agent
- [ ] Documentation Agent
- [ ] MCP Guard Agent

## Skills used

- [ ] source-index-builder
- [ ] terminology-map-builder
- [ ] requirement-slicing
- [ ] issue-agent-readiness
- [ ] orchestration-plan
- [ ] implementation-plan
- [ ] test-gap-review
- [ ] security-review
- [ ] documentation-sync
- [ ] pr-handoff
- [ ] mcp-usage-guard

## Role handoff summary

| Role | Purpose | Result | Blocking findings |
|---|---|---|---|
| Orchestrator |  |  |  |
| Implementer |  |  |  |
| QA Reviewer |  |  |  |
| Security Reviewer |  |  |  |
| Documentation Agent |  |  |  |
```

---

## 14. Escalation rules

Роль должна остановиться и эскалировать, если:

```text
scope неясен;
acceptance criteria противоречат друг другу;
термины не совпадают с terminology map;
нужен доступ к секретам;
нужен production access;
нужно включить network access;
задача требует новой зависимости;
изменяется auth;
изменяется billing;
изменяется база данных;
изменяется инфраструктура;
изменяется CI/CD;
конфликт затрагивает sensitive code;
CI падает по непонятной причине;
PR выходит за allowed scope.
```

Формат эскалации:

```md
## Escalation required

Reason:

-

Blocking question:

-

Affected files or docs:

-

Recommended human decision:

-

Safe next step:

-
```

---

## 15. Когда роли не нужны

Не включать ролевую модель полностью для:

```text
исправления опечатки;
небольшого README update;
добавления одного простого теста;
очевидного bugfix в одном файле;
маленького refactor без изменения поведения;
локальной экспериментальной ветки без PR.
```

В таких случаях достаточно:

```text
single-agent
+ implementation-plan skill
+ pr-handoff skill
```

---

## 16. Когда роли обязательны

Ролевая модель обязательна, если:

```text
задача размера M или выше;
есть несколько подсистем;
есть customer-facing последствия;
есть терминологическая неоднозначность;
есть изменения API;
есть изменения DB schema;
есть auth/permissions;
есть billing/payment;
есть infrastructure;
есть security-sensitive behavior;
есть production config;
есть external dependency;
есть высокий риск regression.
```

---

## 17. Базовый workflow с ролями

### 17.1. Для новой feature

```text
1. Product Owner формулирует business need.
2. Requirements Agent нарезает feature на issues.
3. Terminology Agent проверяет термины.
4. Orchestrator Agent проверяет agent-readiness.
5. Delivery Lead переводит issue в Ready.
6. Implementer Agent работает в отдельной worktree.
7. QA Reviewer Agent проверяет тесты и edge cases.
8. Security Reviewer подключается при risk medium/high.
9. Documentation Agent обновляет docs, если нужно.
10. Human Reviewer принимает PR.
11. Delivery Lead контролирует merge и cleanup.
```

### 17.2. Для bugfix

```text
1. Bug issue создаётся с reproduction steps.
2. Orchestrator проверяет scope.
3. Implementer воспроизводит bug и добавляет regression test.
4. QA Reviewer проверяет тест.
5. Human Reviewer approves PR.
```

### 17.3. Для документационной задачи

```text
1. Source Index фиксирует источник.
2. Terminology Agent проверяет термины.
3. Documentation Agent обновляет docs.
4. Product Owner проверяет customer-facing текст.
5. Human Reviewer merges docs PR.
```

### 17.4. Для high-risk задачи

```text
1. Orchestrator классифицирует risk.
2. Architect Reviewer проверяет impact.
3. Security Reviewer проверяет sensitive risks.
4. Human Owner подтверждает allowed scope.
5. Implementer делает changes.
6. QA Reviewer проверяет coverage.
7. Security Reviewer делает final read-only review.
8. Human Reviewer принимает или блокирует PR.
```

---

## 18. Role Card template

Для добавления новой роли использовать шаблон:

```md
# Role: <Role Name>

## Purpose

<Зачем роль нужна>

## When to use

-
-

## Inputs

-
-

## Outputs

-
-

## Allowed actions

-
-

## Forbidden actions

-
-

## Required skills

-
-

## Optional MCP

-

## Escalation rules

-
-

## Handoff format

```md
## <Role Name> handoff

### Findings

-

### Blocking issues

-

### Recommendations

-
```
```

---

## 19. Anti-patterns

| Антипаттерн | Почему плохо | Как исправить |
|---|---|---|
| Делать “виртуальную компанию агентов” | много шума, мало результата | роли только под конкретный output |
| Давать всем агентам право писать код | конфликты и хаос | один write-owner на worktree |
| Orchestrator принимает бизнес-решения | теряется accountability | human/Product Owner approval |
| Reviewer сам исправляет production code | review смешивается с implementation | reviewer read-only |
| Security review подключается после merge | риск позднего обнаружения | включать на этапе PR |
| Skills путаются с ролями | невозможно переиспользовать процедуры | role = responsibility, skill = procedure |
| MCP включён всегда | лишний риск и утечки | MCP только по необходимости |
| Маленькие задачи проходят через 5 ролей | overhead больше пользы | single-agent mode |
| Нет handoff по ролям | невозможно проверить работу | PR role handoff summary |

---

## 20. Definition of Done для ролевой модели

Ролевая модель проекта считается внедрённой, если:

```text
- Есть docs/agent-roles.md.
- В AGENTS.md указано, как использовать роли.
- В GitHub Issue template есть required roles, required skills и orchestration mode.
- В GitHub Project есть поля orchestration mode, write owner, required roles, required skills.
- В PR template есть role handoff summary.
- В проекте действует правило one worktree = one write-owner.
- Reviewer roles по умолчанию работают read-only.
- High-risk tasks требуют human review.
- Skills не смешиваются с ролями.
- MCP включается только через mcp-usage-guard или human approval.
```

---

## 21. Короткая памятка

```text
Не создавай роли ради ролей.
Создавай роли ради проверяемого результата.

Не давай нескольким агентам писать в одну worktree.
Параллельное мышление — через subagents.
Параллельное изменение кода — через разные worktrees.

Orchestrator не начальник проекта.
Orchestrator — координатор агентного контура.

Human остаётся accountable.
GitHub остаётся source of truth.
CI остаётся gate.
PR остаётся местом принятия изменений.
```

Итоговая формула:

```text
Roles define responsibility.
Skills define procedure.
MCP defines external access.
AGENTS.md defines rules.
GitHub defines truth.
Worktree defines write boundary.
Human review defines acceptance.
```

