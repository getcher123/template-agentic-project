# Гайд: минимально достаточная проектная документация для создания или трансформации проекта

## 1. Цель гайда

Этот гайд нужен, чтобы перед созданием нового проекта или трансформацией существующего проекта собрать не “много документации”, а **минимально достаточный набор источников**, из которого можно:

- понять бизнес-смысл проекта;
- договориться с заказчиком на понятном ему языке;
- сформировать внутренний backlog;
- дать Codex и разработчикам устойчивый контекст;
- создать GitHub Issues без потери смысла;
- не смешивать бизнес-термины, менеджерские термины и технические сущности;
- избежать ситуации, когда агент пишет код по неполной или противоречивой терминологии.

Главный принцип:

```text
Сначала источники и терминология
→ потом каноническая документация
→ потом GitHub Issues
→ потом код
```

Не наоборот.

## 2. Что такое “минимально достаточная документация”

Минимально достаточная документация — это не полный enterprise-пакет из десятков файлов. Это такой набор документов, при котором:

```text
1. Заказчик понимает, что будет создано и зачем.
2. Менеджер понимает scope, приоритеты, риски и этапы.
3. Разработчик понимает доменную модель, ограничения и архитектуру.
4. Codex понимает правила проекта, допустимые изменения и validation commands.
5. GitHub Issues можно создавать без постоянных уточнений в чате.
```

Если после чтения документации новый разработчик или агент всё ещё спрашивает “а что такое клиент?”, “чем пользователь отличается от аккаунта?”, “что считается завершённой заявкой?”, “какие файлы можно менять?” — документация ещё не минимально достаточная.

## 3. Три типа знания: источник, канон, рабочий артефакт

Перед структурой файлов важно разделить три понятия.

| Тип | Что это | Пример | Статус |
|---|---|---|---|
| Источник | Первичное знание, из которого извлекается смысл | интервью, бриф заказчика, письмо, договор, старый README, код, таблица, регламент | сырой материал |
| Канонический документ | Нормализованное знание, которому доверяет команда | glossary, project brief, requirements, architecture | source of truth |
| Рабочий артефакт | То, через что выполняется работа | GitHub Issue, PR, Project status, STATE.md | операционный слой |

Важно: **GitHub Issue не должен быть первым местом, где формулируется смысл проекта**. Issue должен ссылаться на уже нормализованные понятия из brief, glossary и requirements.

## 4. Минимальная структура документации

Рекомендуемая структура:

```text
docs/
├── 00-source-index.md
├── 01-project-brief.md
├── 02-terminology-map.md
├── 03-scope-and-requirements.md
├── 04-processes-and-user-journeys.md
├── 05-architecture-and-data.md
├── 06-quality-security-constraints.md
├── 07-delivery-model.md
└── 08-customer-facing-summary.md

AGENTS.md
README.md
.github/
├── ISSUE_TEMPLATE/
│   └── agent-task.yml
└── pull_request_template.md
```

Для совсем маленького проекта минимальный набор можно сократить до пяти документов:

```text
docs/
├── 00-source-index.md
├── 01-project-brief.md
├── 02-terminology-map.md
├── 03-scope-and-requirements.md
└── 05-architecture-and-data.md

AGENTS.md
README.md
```

Но `02-terminology-map.md` лучше не пропускать. Именно он защищает проект от терминологического хаоса.

## 5. Слои терминологии

В проекте должны быть разделены минимум пять терминологических слоёв.

```text
L1. Бизнес-терминология заказчика
L2. Внутренняя менеджерская терминология
L3. Внутренняя продуктовая/доменная терминология
L4. Внутренняя инженерная терминология
L5. Агентная/операционная терминология
```

### 5.1. L1 — бизнес-терминология заказчика

Это язык, на котором заказчик описывает свою реальность.

Примеры:

```text
Клиент
Заявка
Сделка
Договор
Акт
Оплата
Менеджер
Склад
Отгрузка
Тариф
```

Назначение слоя:

- фиксировать, как заказчик сам называет объекты;
- не навязывать ему технические термины;
- использовать этот язык в customer-facing документах;
- предотвращать ситуацию, когда команда говорит “entity”, “record”, “tenant”, а заказчик слышит непонятный жаргон.

Где используется:

```text
docs/01-project-brief.md
docs/08-customer-facing-summary.md
презентации
коммерческие предложения
acceptance criteria для заказчика
```

Правило:

```text
В документах для заказчика не использовать внутренние инженерные термины, если они не нужны для принятия решения.
```

### 5.2. L2 — внутренняя менеджерская терминология

Это язык управления проектом.

Примеры:

```text
Epic
Feature
Milestone
Release
Priority
Risk
Dependency
Owner
Status
Acceptance criteria
Definition of Done
```

Назначение слоя:

- управлять scope;
- декомпозировать работу;
- фиксировать приоритеты;
- согласовывать этапы;
- переводить бизнес-цели в backlog.

Где используется:

```text
GitHub Projects
GitHub Issues
docs/03-scope-and-requirements.md
docs/07-delivery-model.md
roadmap
weekly status
```

Правило:

```text
Менеджерский термин должен объяснять состояние работы, а не устройство кода.
```

Например:

```text
Правильно: Feature “Деактивация клиента” находится в статусе Review.
Неправильно: Entity CustomerAccount находится в статусе Review.
```

### 5.3. L3 — внутренняя продуктовая и доменная терминология

Это мост между бизнесом и разработкой. Здесь бизнес-понятия превращаются в доменные сущности и правила.

Примеры:

```text
CustomerAccount
ServiceRequest
Deal
Invoice
Payment
UserRole
SubscriptionPlan
ActivationStatus
```

Назначение слоя:

- определить сущности предметной области;
- зафиксировать связи между ними;
- описать жизненный цикл объектов;
- определить инварианты;
- подготовить основу для архитектуры, API и базы данных.

Где используется:

```text
docs/02-terminology-map.md
docs/04-processes-and-user-journeys.md
docs/05-architecture-and-data.md
AGENTS.md
issue templates
```

Правило:

```text
Каждое важное бизнес-понятие должно иметь доменное имя.
Каждое доменное имя должно иметь одно основное значение.
```

Например, нельзя одновременно использовать:

```text
Client
Customer
Account
User
```

для одного и того же понятия без явного различия.

### 5.4. L4 — внутренняя инженерная терминология

Это язык реализации.

Примеры:

```text
customer_accounts table
CustomerAccount model
POST /customer-accounts/{id}/deactivate
customerAccountId
deactivation_requested event
CustomerAccountRepository
CustomerAccountService
```

Назначение слоя:

- связать доменную модель с кодом;
- определить названия таблиц, API, DTO, events, modules;
- уменьшить количество случайных названий;
- дать Codex устойчивые naming conventions.

Где используется:

```text
код
API contracts
database schema
tests
docs/05-architecture-and-data.md
AGENTS.md
```

Правило:

```text
Кодовые имена лучше вести на английском, но они должны быть связаны с русской бизнес-терминологией через terminology map.
```

Пример:

```text
Бизнес-термин: Клиент
Доменный термин: CustomerAccount
Код: CustomerAccount
API: customerAccount
DB: customer_accounts
```

### 5.5. L5 — агентная и операционная терминология

Это язык работы Codex, GitHub Issues, PR и CI.

Примеры:

```text
agent-ready
agent-running
allowed scope
forbidden scope
validation commands
handoff report
worktree
branch
PR
CI check
human review focus
```

Назначение слоя:

- дать агенту чёткие границы;
- описать, что можно менять;
- описать, что нельзя менять;
- определить, как проверить готовность;
- связать issue с worktree и PR.

Где используется:

```text
AGENTS.md
.github/ISSUE_TEMPLATE/agent-task.yml
.github/pull_request_template.md
GitHub Project
STATE.md
```

Правило:

```text
Агентная терминология не должна попадать в документы для заказчика.
Заказчику не нужно знать, что задача была agent-ready или выполнялась в worktree.
```

## 6. Главный документ: terminology map

Файл:

```text
docs/02-terminology-map.md
```

Это не просто глоссарий. Это карта соответствий между языком заказчика, менеджера, разработчика и кода.

### 6.1. Рекомендуемая структура

```md
# Terminology Map

## Purpose

This document maps customer-facing business terms to internal product, management, engineering, and code-level terms.

## Rules

- One business concept must have one canonical domain term.
- Code names must be derived from canonical domain terms.
- Synonyms are allowed only when documented.
- Forbidden synonyms must not be used in new code or issues.
- Customer-facing documents use business terms.
- Internal development documents use canonical domain terms.
- Code uses English engineering names.

## Terms

| Term ID | Customer-facing term | Manager term | Domain term | Code/API term | Database term | Definition | Allowed synonyms | Forbidden synonyms | Example |
|---|---|---|---|---|---|---|---|---|---|
| customer_account | Клиент | Клиентский аккаунт | CustomerAccount | customerAccount | customer_accounts | Организация или физическое лицо, с которым компания ведёт работу и по которому хранятся заявки, сделки и платежи. | клиент, аккаунт клиента | user, client_record, account_entity | Клиент становится неактивным, если нет сделок 90 дней. |
| service_request | Заявка | Рабочая заявка | ServiceRequest | serviceRequest | service_requests | Обращение клиента, которое требует обработки сотрудником или автоматическим процессом. | обращение | ticket, task, issue | Заявка может быть создана клиентом или менеджером. |
| payment | Оплата | Платёж | Payment | payment | payments | Факт поступления денег по счёту или договору. | платёж | transaction без уточнения | Оплата связывается со счётом и клиентом. |
| manager_user | Менеджер | Ответственный | ManagerUser | managerUser | users | Пользователь системы с правами обработки клиентов, заявок и сделок. | сотрудник | admin, operator без уточнения | Менеджер может закрыть заявку после выполнения. |
| activation_status | Статус клиента | Статус активности | ActivationStatus | activationStatus | activation_status | Признак, определяющий, активен ли клиент для новых операций. | активность | state, status без уточнения | Неактивный клиент не может создавать новые заявки. |
```

### 6.2. Почему это критично для Codex

Codex часто хорошо пишет код, но может ошибаться в названиях, если терминология не закреплена.

Без terminology map агент может создать:

```text
Client
Customer
Account
UserAccount
CustomerProfile
```

для одного и того же понятия.

После этого проект получает хаос:

```text
API использует clientId
DB использует customer_id
frontend использует accountId
тесты используют user_id
```

Terminology map предотвращает это заранее.

## 7. `00-source-index.md`: реестр источников

Файл:

```text
docs/00-source-index.md
```

Назначение: зафиксировать, откуда взялись требования, термины и ограничения.

### 7.1. Шаблон

```md
# Source Index

## Purpose

This document lists raw sources used to create canonical project documentation.

## Source reliability levels

| Level | Meaning |
|---|---|
| High | Confirmed by decision-maker, contract, regulation, production system, or signed document |
| Medium | Confirmed by project team, but not formally approved |
| Low | Hypothesis, assumption, informal conversation, or unverified legacy knowledge |

## Sources

| Source ID | Source type | Date | Owner | Reliability | Key facts extracted | Canonical docs affected | Open questions |
|---|---|---|---|---|---|---|---|
| SRC-001 | Customer interview | 2026-05-01 | Commercial Director | High | Клиент считается активным, если была сделка или оплата за последние 90 дней. | terminology-map, requirements | Нужно ли учитывать бесплатные тестовые сделки. |
| SRC-002 | Existing spreadsheet | 2026-04-27 | Operations Manager | Medium | Заявки делятся на новые, в работе, ожидают клиента, закрыты. | processes, requirements | Нужен ли отдельный статус “отменена”. |
| SRC-003 | Legacy API review | 2026-04-29 | Backend Lead | Medium | В старом API клиент называется client, но в новой модели нужно использовать CustomerAccount. | terminology-map, architecture | Нужно ли поддерживать старое имя в публичном API. |
| SRC-004 | Contract draft | 2026-04-25 | Customer Legal Team | High | Система должна хранить историю оплат не менее 5 лет. | quality-security-constraints, architecture | Нужны ли отдельные правила для персональных данных. |
```

### 7.2. Правило

```text
Любое важное требование должно иметь источник.
Любое спорное требование должно иметь open question.
Любое решение должно перейти из open question в decision log.
```

## 8. `01-project-brief.md`: краткий проектный бриф

Файл:

```text
docs/01-project-brief.md
```

Назначение: объяснить проект одним документом на языке, понятном бизнесу, менеджеру и разработке.

### 8.1. Шаблон с примером

```md
# Project Brief

## Project name

Atlas Service Desk

## Business problem

Компания обрабатывает клиентские заявки через почту, таблицы и ручные сообщения в мессенджерах. Из-за этого менеджеры теряют контекст, руководитель не видит статус работ, а клиент получает разные ответы от разных сотрудников.

## Business goal

Создать единую систему управления клиентскими заявками, в которой менеджеры видят историю клиента, статус заявок, ответственных и сроки обработки.

## Target users

| User group | Description | Main goals |
|---|---|---|
| Клиент | Внешний пользователь, который создаёт заявку | создать заявку, увидеть статус, получить ответ |
| Менеджер | Сотрудник, который обрабатывает заявки | назначить ответственного, изменить статус, ответить клиенту |
| Руководитель | Управляет процессом обработки | видеть нагрузку, сроки, просрочки, качество обработки |
| Администратор | Настраивает пользователей и права | управлять доступами, справочниками и настройками |

## In scope

- Создание клиентских заявок.
- Назначение ответственного менеджера.
- Изменение статуса заявки.
- История комментариев.
- Базовые уведомления.
- Дашборд по статусам и просрочкам.
- Роли клиента, менеджера, руководителя и администратора.

## Out of scope

- Полноценная CRM для сделок.
- Финансовый учёт.
- Интеграция с телефонией.
- Мобильное приложение.
- AI-автоответы клиенту в первой версии.
- Сложная BI-аналитика.

## Success metrics

| Metric | Target |
|---|---|
| Среднее время первого ответа | меньше 4 рабочих часов |
| Доля заявок без ответственного | меньше 5% |
| Доля просроченных заявок | меньше 10% |
| Видимость статуса для руководителя | 100% заявок имеют статус и ответственного |

## Main risks

| Risk | Impact | Mitigation |
|---|---|---|
| Термины “клиент”, “пользователь” и “аккаунт” смешиваются | ошибки в модели данных и API | вести terminology map |
| Заказчик хочет CRM, но первый scope — service desk | разрастание scope | фиксировать out of scope |
| Нет точных SLA по заявкам | невозможно проверить просрочку | согласовать SLA до реализации дашборда |
```

## 9. `03-scope-and-requirements.md`: scope и требования

Файл:

```text
docs/03-scope-and-requirements.md
```

Назначение: связать бизнес-цели, features и будущие GitHub Issues.

### 9.1. Структура

```md
# Scope and Requirements

## Scope principle

This document describes what the first version must include, what is explicitly excluded, and how requirements map to GitHub Issues.

## Epics

| Epic ID | Name | Business outcome | Priority | Status |
|---|---|---|---|---|
| EPIC-001 | Управление заявками | Менеджеры могут обрабатывать клиентские обращения в одной системе | P1 | Ready |
| EPIC-002 | Управление клиентами | Менеджеры видят карточку клиента и историю обращений | P1 | Ready |
| EPIC-003 | Отчётность руководителя | Руководитель видит просрочки и нагрузку | P2 | Discovery |

## Features

| Feature ID | Epic | Feature | User value | Agent-ready |
|---|---|---|---|---|
| FEAT-001 | EPIC-001 | Создание заявки | Клиент может создать обращение | Yes |
| FEAT-002 | EPIC-001 | Назначение ответственного | Менеджер может взять заявку в работу | Yes |
| FEAT-003 | EPIC-001 | Статусы заявки | Команда видит жизненный цикл заявки | Yes |
| FEAT-004 | EPIC-002 | Карточка клиента | Менеджер видит контекст клиента | No |
| FEAT-005 | EPIC-003 | Дашборд просрочек | Руководитель контролирует SLA | No |

## Requirement details

### REQ-001: Create service request

Business wording:

Клиент может создать заявку, указав тему, описание и контактные данные.

Internal domain wording:

System creates a ServiceRequest linked to a CustomerAccount or anonymous contact.

Acceptance criteria:

- Клиент может отправить заявку через web form.
- Заявка получает статус `new`.
- Заявка получает уникальный номер.
- В системе сохраняются тема, описание, дата создания и контакт.
- Менеджер видит новую заявку в списке.
- Создание заявки покрыто API и service tests.

Validation commands:

```bash
make lint
make typecheck
make test
```

Suggested GitHub issue:

```text
[Agent Task]: Implement service request creation
```

Allowed scope:

```text
app/api/service_requests/
app/services/service_requests/
app/models/service_request.py
tests/service_requests/
```

Forbidden scope:

```text
billing/
infra/
production config
unrelated customer model refactor
```
```

## 10. `04-processes-and-user-journeys.md`: процессы и сценарии

Файл:

```text
docs/04-processes-and-user-journeys.md
```

Назначение: описать не экраны и не код, а реальные процессы.

### 10.1. Минимальный шаблон

```md
# Processes and User Journeys

## Process: Service request lifecycle

### Business description

Клиент создаёт заявку. Менеджер принимает её в работу, уточняет детали, выполняет действие и закрывает заявку. Руководитель видит просроченные заявки.

### States

| State | Customer-facing name | Internal name | Description | Allowed next states |
|---|---|---|---|---|
| Новая | Новая | new | Заявка создана, но ещё не взята в работу | in_progress, cancelled |
| В работе | В работе | in_progress | Менеджер обрабатывает заявку | waiting_for_customer, resolved, cancelled |
| Ожидает клиента | Ожидает ответа клиента | waiting_for_customer | Нужна информация от клиента | in_progress, resolved, cancelled |
| Решена | Решена | resolved | Работа выполнена | closed, reopened |
| Закрыта | Закрыта | closed | Процесс завершён | reopened |
| Отменена | Отменена | cancelled | Заявка отменена | reopened |

### Main journey

1. Клиент создаёт заявку.
2. Система присваивает номер.
3. Заявка получает статус `new`.
4. Менеджер назначает себя ответственным.
5. Заявка переходит в `in_progress`.
6. Менеджер отвечает клиенту.
7. Клиент подтверждает решение.
8. Менеджер закрывает заявку.

### Edge cases

| Case | Expected behavior |
|---|---|
| Клиент не указал контакт | Система не создаёт заявку и показывает ошибку |
| Менеджер закрывает заявку без ответа | Система требует комментарий |
| Заявка просрочена | Система показывает её в списке просрочек |
| Клиент отвечает после закрытия | Система создаёт reopening event |

### Domain invariants

- Закрытая заявка должна иметь ответственного.
- Закрытая заявка должна иметь хотя бы один внутренний или внешний комментарий.
- Заявка не может перейти из `new` сразу в `closed`.
- Просрочка считается от даты создания или последнего ответа клиента.
```

Это особенно полезно для Codex: агент получает не только “сделай endpoint”, а понимает жизненный цикл.

## 11. `05-architecture-and-data.md`: минимальная архитектура и данные

Файл:

```text
docs/05-architecture-and-data.md
```

Назначение: дать технический контекст без избыточного design document.

### 11.1. Минимальное содержание

```md
# Architecture and Data

## Architecture summary

Atlas Service Desk is a web application with API backend, relational database, background notification worker, and web frontend.

## Main components

| Component | Responsibility |
|---|---|
| API backend | Handles HTTP requests, auth, business operations, and validation |
| Database | Stores customers, service requests, comments, users, roles, and audit events |
| Notification worker | Sends email or internal notifications for status changes |
| Web frontend | Provides UI for customers, managers, and leaders |
| Admin module | Manages users, roles, and system settings |

## Domain entities

| Entity | Description | Key fields |
|---|---|---|
| CustomerAccount | Клиентская организация или физическое лицо | id, name, activationStatus, createdAt |
| ManagerUser | Внутренний пользователь системы | id, email, role, isActive |
| ServiceRequest | Клиентская заявка | id, number, customerAccountId, status, subject, description, assigneeId |
| ServiceRequestComment | Комментарий к заявке | id, serviceRequestId, authorId, visibility, body |
| AuditEvent | Событие аудита | id, actorId, action, targetType, targetId, createdAt |

## API naming conventions

| Concept | API resource |
|---|---|
| CustomerAccount | `/customer-accounts` |
| ServiceRequest | `/service-requests` |
| ManagerUser | `/users` |
| AuditEvent | `/audit-events` |

## Data rules

- `ServiceRequest.number` must be unique.
- `ServiceRequest.status` must use the state machine from `docs/04-processes-and-user-journeys.md`.
- `CustomerAccount.activationStatus` controls whether new service requests can be created.
- Audit events are append-only.
- Comments are not physically deleted after publication.

## Integration assumptions

| Integration | Status | Notes |
|---|---|---|
| Email notifications | Planned | First version supports outgoing email only |
| CRM integration | Out of scope | Not included in first release |
| SSO | Discovery | Requires customer identity provider details |

## Technical unknowns

| Question | Impact | Owner |
|---|---|---|
| Нужно ли хранить историю изменения SLA | affects audit model | Product Owner |
| Нужен ли SSO в первой версии | affects auth architecture | Customer IT |
| Какие email templates нужны | affects notification worker | Operations Manager |
```

## 12. `06-quality-security-constraints.md`: качество, безопасность, ограничения

Файл:

```text
docs/06-quality-security-constraints.md
```

Назначение: зафиксировать правила, которые нельзя вывести из feature requirements.

### 12.1. Шаблон

```md
# Quality, Security, and Constraints

## Quality gates

Every pull request must pass:

```bash
make lint
make typecheck
make test
```

## Security rules

- Secrets must not be committed to the repository.
- Customer personal data must not be logged in plain text.
- Admin actions must create audit events.
- Role checks must be tested.
- Production configuration must not be changed by agent tasks without explicit approval.
- External dependencies require explanation in PR.

## Access control

| Role | Permissions |
|---|---|
| Customer | create own requests, view own requests, add own comments |
| Manager | view assigned requests, update status, add comments |
| Leader | view reports and all requests |
| Admin | manage users, roles, and settings |

## Non-functional requirements

| Requirement | Target |
|---|---|
| API response time | p95 under 500ms for normal list/detail operations |
| Availability | business-hours availability for first release |
| Auditability | all admin and status-changing actions are recorded |
| Data retention | payment and request history retained according to contract |
| Testability | core business rules covered by automated tests |

## Agent restrictions

Codex and other coding agents must not:

- edit secrets;
- change production config;
- apply infrastructure changes;
- remove tests to make CI pass;
- introduce dependencies without PR explanation;
- resolve high-risk conflicts in auth, billing, db, infra, security, or CI without human review.
```

## 13. `07-delivery-model.md`: внутренняя менеджерская документация

Файл:

```text
docs/07-delivery-model.md
```

Назначение: связать документацию с delivery-процессом.

### 13.1. Шаблон

```md
# Delivery Model

## Delivery principles

- GitHub Issues are the canonical task contract.
- GitHub Projects is the canonical delivery board.
- One issue maps to one branch, one worktree, and one PR.
- Codex can work only on agent-ready issues.
- Human review is required before merge.
- CI must be green before merge.

## Project statuses

| Status | Meaning |
|---|---|
| Inbox | New item, not triaged |
| Ready | Scope is clear and work can start |
| In Progress | Human or agent is actively working |
| Review | PR is open and needs review |
| Blocked | Waiting for decision, dependency, or conflict resolution |
| Done | Merged or completed |

## Priority

| Priority | Meaning |
|---|---|
| P0 | Production-critical or launch-blocking |
| P1 | Required for first usable version |
| P2 | Important but can ship later |
| P3 | Nice to have |

## Agent readiness

An issue is agent-ready only when:

- objective is clear;
- acceptance criteria are testable;
- allowed scope is defined;
- forbidden scope is defined;
- validation commands are listed;
- risk level is known;
- no secret or production access is required.

## Decision log

| Decision ID | Date | Decision | Reason | Owner |
|---|---|---|---|---|
| DEC-001 | 2026-05-03 | Use CustomerAccount as canonical domain term | Avoid conflict between client, user, and account | Product Owner |
| DEC-002 | 2026-05-03 | First release excludes CRM deal management | Keep first release focused on service requests | Delivery Lead |
```

## 14. `08-customer-facing-summary.md`: бизнес-документ для заказчика

Файл:

```text
docs/08-customer-facing-summary.md
```

Назначение: дать заказчику понятный документ без внутренних деталей.

### 14.1. Шаблон

```md
# Customer-Facing Project Summary

## Цель проекта

Создать единую систему обработки клиентских заявок, чтобы менеджеры видели все обращения в одном месте, руководитель контролировал сроки, а клиенты получали понятный статус по своим обращениям.

## Что будет реализовано в первой версии

- Создание заявки клиентом.
- Просмотр списка заявок менеджером.
- Назначение ответственного.
- Изменение статуса заявки.
- Комментарии по заявке.
- Базовые уведомления.
- Дашборд по статусам и просрочкам.
- Управление пользователями и ролями.

## Что не входит в первую версию

- Полная CRM для сделок.
- Финансовый учёт.
- Интеграция с телефонией.
- Мобильное приложение.
- Автоматические AI-ответы клиентам.
- Расширенная BI-аналитика.

## Критерии успешной приёмки

| Area | Acceptance criteria |
|---|---|
| Заявки | Клиент может создать заявку, менеджер может взять её в работу и закрыть |
| Ответственные | Каждая заявка может иметь ответственного менеджера |
| Статусы | Заявка проходит согласованный жизненный цикл |
| Руководитель | Руководитель видит количество заявок, статусы и просрочки |
| Безопасность | Пользователи видят только разрешённые им данные |

## Термины

| Термин | Значение |
|---|---|
| Клиент | Организация или физическое лицо, которое обращается в компанию |
| Заявка | Обращение клиента, требующее обработки |
| Менеджер | Сотрудник, который обрабатывает заявки |
| Руководитель | Сотрудник, который контролирует процесс обработки |
| Просрочка | Заявка, которая не была обработана в установленный срок |
```

Важно: здесь не должно быть слов вроде `worktree`, `DTO`, `repository`, `agent-ready`, `CI`, `CustomerAccountService`.

## 15. AGENTS.md как слой агентной документации

`AGENTS.md` должен ссылаться на канонические документы.

Минимальная структура:

```md
# AGENTS.md

## Project documentation read order

Before working on a task, read:

1. `docs/01-project-brief.md`
2. `docs/02-terminology-map.md`
3. `docs/03-scope-and-requirements.md`
4. `docs/05-architecture-and-data.md`
5. The linked GitHub Issue

## Terminology rules

- Use canonical domain terms from `docs/02-terminology-map.md`.
- Do not invent new names for existing domain concepts.
- Customer-facing Russian terms must be mapped to English code names through terminology map.
- Code names must follow the Code/API term column.
- Database names must follow the Database term column.

## Work rules

- One issue = one branch = one worktree = one PR.
- Stay within allowed scope from the issue.
- Do not touch forbidden scope.
- Add or update tests for behavior changes.
- Run validation commands before PR.
- Include handoff report in PR.

## Safety rules

- Do not edit secrets.
- Do not change production config.
- Do not add dependencies without explanation.
- Do not remove tests to make CI pass.
- Stop and request human review for auth, billing, database migration, infrastructure, CI, and security-sensitive conflicts.
```

## 16. Как из документации создавать GitHub Issues

После заполнения базовых документов issues создаются не “из головы”, а из связки:

```text
Project Brief
→ Terminology Map
→ Scope and Requirements
→ Processes
→ Architecture
→ Agent Task Issue
```

### 16.1. Пример issue

```md
# [Agent Task]: Implement service request creation

## Objective

Implement creation of ServiceRequest according to REQ-001.

## Business context

Customer can create a request with subject, description, and contact details. Manager must see the new request in the request list.

## Canonical terms

- Customer-facing term: Заявка
- Domain term: ServiceRequest
- API term: serviceRequest
- Database term: service_requests

## Acceptance criteria

- API endpoint creates a new ServiceRequest.
- New ServiceRequest gets status `new`.
- New ServiceRequest gets a unique number.
- Subject, description, contact, and createdAt are saved.
- Manager can see the request in list endpoint.
- Tests cover successful creation and validation errors.

## Allowed scope

- app/api/service_requests/
- app/services/service_requests/
- app/models/service_request.py
- tests/service_requests/

## Forbidden scope

- billing/
- infra/
- production config
- unrelated CustomerAccount refactor
- authentication redesign

## Validation commands

```bash
make lint
make typecheck
make test
```

## Definition of done

- PR is opened and linked to this issue.
- CI is green.
- Tests cover the changed behavior.
- PR includes agent handoff report.
- No terminology inconsistent with `docs/02-terminology-map.md`.
```

## 17. Процесс создания документации для нового проекта

### Шаг 1. Собрать сырые источники

Источники:

```text
интервью с заказчиком
бриф
коммерческое предложение
договор
старые таблицы
старый код
регламенты
скриншоты текущего процесса
описание интеграций
ограничения безопасности
```

Результат:

```text
docs/00-source-index.md
```

### Шаг 2. Вытащить бизнес-термины

Из источников выписать слова заказчика:

```text
клиент
заявка
сделка
платёж
менеджер
статус
просрочка
тариф
договор
акт
```

Результат:

```text
docs/02-terminology-map.md
```

### Шаг 3. Сопоставить бизнес-термины с доменными и кодовыми

Пример:

| Бизнес | Домен | Код | DB |
|---|---|---|---|
| Клиент | CustomerAccount | customerAccount | customer_accounts |
| Заявка | ServiceRequest | serviceRequest | service_requests |
| Платёж | Payment | payment | payments |

Результат: единая naming convention до написания кода.

### Шаг 4. Сформировать project brief

Зафиксировать:

```text
зачем проект нужен
кто пользователи
что входит в первую версию
что не входит
как измеряется успех
какие риски
```

Результат:

```text
docs/01-project-brief.md
```

### Шаг 5. Описать scope и requirements

Каждая feature должна иметь:

```text
business wording
internal domain wording
acceptance criteria
validation commands
allowed scope
forbidden scope
suggested issue title
```

Результат:

```text
docs/03-scope-and-requirements.md
```

### Шаг 6. Описать процессы

Особенно важны:

```text
жизненные циклы
статусы
переходы
краевые случаи
инварианты
```

Результат:

```text
docs/04-processes-and-user-journeys.md
```

### Шаг 7. Описать минимальную архитектуру

Не нужно писать огромный design document. Достаточно:

```text
основные компоненты
доменные сущности
API naming
data rules
интеграции
технические неизвестные
```

Результат:

```text
docs/05-architecture-and-data.md
```

### Шаг 8. Создать AGENTS.md и GitHub templates

Только после этого можно переводить requirements в GitHub Issues.

Результат:

```text
AGENTS.md
.github/ISSUE_TEMPLATE/agent-task.yml
.github/pull_request_template.md
```

## 18. Процесс трансформации существующего проекта

Для существующего проекта порядок другой.

### Шаг 1. Инвентаризация

Собрать:

```text
существующий README
кодовые модели
таблицы базы
API endpoints
старые issues
старые tickets
документацию
комментарии в коде
названия экранов
названия ролей
```

### Шаг 2. Найти терминологические конфликты

Пример конфликтов:

| Conflict | Example | Risk |
|---|---|---|
| Один термин — разные значения | Account = клиент, Account = пользователь | ошибка в auth и бизнес-логике |
| Разные термины — одно значение | Client, Customer, Account | хаос в API и коде |
| Бизнес и код расходятся | заказчик говорит “заявка”, код говорит Ticket | сложно создавать issues |
| Старый термин живёт в API | `/clients`, хотя новая модель CustomerAccount | breaking change risk |

### Шаг 3. Создать terminology map по факту

Не переименовывать всё сразу. Сначала зафиксировать:

```text
как называется сейчас
как должно называться канонически
где используется старое имя
что можно менять
что нельзя менять из-за совместимости
```

### Шаг 4. Создать migration notes

```md
# Terminology Migration Notes

| Legacy term | Canonical term | Where used | Migration approach |
|---|---|---|---|
| Client | CustomerAccount | old API, legacy DB comments | keep API compatibility, use CustomerAccount in new domain code |
| Ticket | ServiceRequest | old frontend labels | rename in UI during service request module refactor |
| Operator | ManagerUser | old admin docs | use ManagerUser in code, show “Менеджер” to customer |
```

### Шаг 5. Только потом запускать Codex

Первый Codex task в существующем проекте должен быть не “перепиши архитектуру”, а:

```text
[Agent Task]: Create project terminology map from existing code and docs
```

Или:

```text
[Agent Task]: Add AGENTS.md and documentation read order
```

## 19. Минимальные слои документации по аудитории

| Аудитория | Документы | Термины | Что им нужно |
|---|---|---|---|
| Заказчик | customer-facing-summary, project brief | бизнес-термины | понять ценность, scope, приёмку |
| Менеджер проекта | delivery-model, scope-and-requirements | epic, feature, priority, risk | управлять сроками, задачами, рисками |
| Product owner / analyst | terminology-map, processes, requirements | доменные термины | переводить бизнес в backlog |
| Разработчик | architecture, data, AGENTS.md | domain + engineering terms | писать код без догадок |
| Codex / AI agent | AGENTS.md, issue, terminology-map, architecture | agent + engineering terms | менять код в границах задачи |
| Reviewer | PR template, requirements, architecture | domain + validation terms | проверять scope, риски и качество |

## 20. Definition of Enough

Документация считается минимально достаточной, если выполняются все пункты:

```text
- Есть список источников.
- Есть project brief.
- Есть terminology map.
- Есть scope первого релиза.
- Есть хотя бы один описанный основной процесс.
- Есть минимальная архитектура.
- Есть правила качества и безопасности.
- Есть AGENTS.md.
- Есть issue template для agent task.
- Есть PR template с handoff report.
- Первый GitHub Issue можно создать без дополнительных устных объяснений.
- Codex может прочитать документацию и составить корректный implementation plan.
- Заказчик может прочитать customer-facing summary и понять, что будет сделано.
```

## 21. Антипаттерны

| Антипаттерн | Почему плохо | Как исправить |
|---|---|---|
| Начинать проект сразу с кода | термины и scope не зафиксированы | сначала brief + terminology map |
| Создавать issues без glossary | агент будет изобретать названия | сделать terminology map |
| Писать один документ для всех | заказчик, менеджер и разработчик говорят на разных языках | разделить слои документации |
| Использовать “user” для всего | пользователь, клиент, менеджер и админ смешиваются | завести role model |
| Держать требования в чате | невозможно проверить источник | source-index + requirements |
| Давать Codex размытый prompt | агент расширит scope | issue с allowed/forbidden scope |
| Переименовывать старые термины без карты миграции | breaking changes | terminology migration notes |
| Документировать только архитектуру | бизнес-смысл теряется | project brief + customer summary |
| Документировать только бизнес | разработка не понимает данные и API | architecture-and-data |
| Делать слишком много документации | никто не читает | держать минимальный пакет |

## 22. Короткий рабочий алгоритм

Для нового проекта:

```text
1. Собрать источники.
2. Создать source index.
3. Выписать бизнес-термины.
4. Создать terminology map.
5. Написать project brief.
6. Описать scope и requirements.
7. Описать основные процессы.
8. Описать минимальную архитектуру.
9. Добавить quality/security constraints.
10. Добавить AGENTS.md.
11. Создать GitHub Issues.
12. Запустить Codex только на agent-ready issues.
```

Для существующего проекта:

```text
1. Инвентаризировать код, README, API, DB, старые задачи.
2. Найти терминологические конфликты.
3. Создать terminology map по текущему состоянию.
4. Зафиксировать legacy terms и canonical terms.
5. Добавить AGENTS.md и read order.
6. Добавить issue/PR templates.
7. Создать первый documentation/governance PR.
8. Только потом запускать агентные задачи по коду.
```

## 23. Главное правило

```text
Документация должна быть не большой, а переводящей.
```

Она должна переводить:

```text
язык заказчика
→ в язык менеджера
→ в язык продукта
→ в язык разработки
→ в язык Codex task
→ в код и тесты
```

Если этот перевод работает, проект можно безопасно создавать или трансформировать через мультиагентный workflow.

