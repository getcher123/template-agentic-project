---
name: requirement-slicing
description: Use to turn project brief, processes, and requirements into epics, features, GitHub Issue drafts, acceptance criteria, dependencies, and validation commands. Trigger before backlog creation or project launch.
---

# Requirement Slicing

## Purpose

Convert project documentation into a backlog that can be executed through GitHub Issues and Codex worktrees.

## Inputs

Read:

1. `docs/01-project-brief.md`.
2. `docs/02-terminology-map.md`.
3. `docs/03-scope-and-requirements.md`.
4. `docs/04-processes-and-user-journeys.md`, if present.
5. `docs/05-architecture-and-data.md`, if present.

## Procedure

1. Identify epics from business outcomes.
2. Break each epic into features.
3. Break features into issue-sized tasks.
4. Classify each task size: XS, S, M, L, XL.
5. Mark `agent-ready` only when scope and validation are clear.
6. Identify dependencies.
7. Create suggested issue titles.
8. For each issue, write objective, context, acceptance criteria, allowed scope, forbidden scope, validation commands, risk, and definition of done.

## Output format

```md
## Epics

| Epic ID | Name | Business outcome | Priority | Status |
|---|---|---|---|---|
| EPIC-001 |  |  | P1 | Ready |
```

```md
## Features

| Feature ID | Epic | Feature | User value | Agent-ready |
|---|---|---|---|---|
| FEAT-001 | EPIC-001 |  |  | Yes |
```

```md
## Suggested GitHub Issues

### [Agent Task]: 

Objective:

Acceptance criteria:

- 

Allowed scope:

- 

Forbidden scope:

- 

Validation commands:

- make lint
- make typecheck
- make test

Risk:

Size:

Dependencies:
```

## Do not

- Do not create one huge issue for an epic.
- Do not mark high-risk or unclear tasks as agent-ready.
- Do not omit validation commands.
- Do not create code tasks before terminology is stable.
