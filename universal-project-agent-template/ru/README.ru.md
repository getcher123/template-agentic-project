# Универсальный агентный шаблон проекта

Основной язык шаблона — English. Эта папка содержит русские версии ключевых документов для команды.

Шаблон добавляет в новый или существующий репозиторий операционный слой для Codex-native разработки:

```text
GitHub Issue
-> GitHub Project Ready
-> Lead / Orchestrator в VS Code
-> CLI subagents при необходимости
-> отдельная branch
-> отдельная git worktree
-> Codex discovery
-> scoped implementation
-> local validation
-> Pull Request
-> CI
-> human review
-> merge
-> cleanup
```

## Профили установки

| Профиль | Что ставит |
|---|---|
| `core` | `AGENTS.md`, README-шаблон, docs baseline, issue/PR templates, Makefile contract |
| `recommended` | `core` + capability-router, skills, roles, disabled MCP config, worktree scripts |
| `full` | `recommended` + CODEOWNERS, GitHub workflows, labels helper, Project setup guide |

## Новый проект

```bash
/path/to/universal-project-agent-template/install.sh \
  --target . \
  --mode new \
  --profile recommended \
  --apply
```

## Существующий проект

Сначала dry-run:

```bash
/path/to/universal-project-agent-template/install.sh \
  --target /path/to/repo \
  --mode existing \
  --profile core \
  --dry-run
```

Потом apply:

```bash
/path/to/universal-project-agent-template/install.sh \
  --target /path/to/repo \
  --mode existing \
  --profile core \
  --apply
```

Без `--overwrite` существующие файлы не перетираются.

Минимальный MCP starter: только GitHub MCP и Context7 MCP. Browser automation можно добавить позже отдельным UI-расширением, если UI smoke-тесты станут регулярным процессом.

Основная схема работы: человек общается только с Lead / Orchestrator агентом в VS Code. Orchestrator сам запускает CLI-субагентов, принимает отчёты, просит исправления и выводит человеку краткий финальный запрос решения для merge или high-risk approval.
