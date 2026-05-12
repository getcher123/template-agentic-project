---
name: terminology-map-builder
description: Use to map customer-facing business terms to internal manager, domain, code/API, and database terms. Trigger when terms like client/user/account/request/ticket/status are ambiguous or before creating a new project domain model.
---

# Terminology Map Builder

## Purpose

Create or update `docs/02-terminology-map.md` so business language, project management language, domain language, and code language stay aligned.

## Inputs

Read:

1. `docs/00-source-index.md`.
2. `docs/01-project-brief.md`.
3. `docs/03-scope-and-requirements.md`, if present.
4. Existing code names, API routes, DB tables, UI labels, and legacy docs.

## Procedure

1. Extract customer-facing terms exactly as customers use them.
2. Identify synonyms and conflicts.
3. Assign one canonical domain term per concept.
4. Derive code/API terms from the canonical domain term.
5. Derive database terms from the canonical domain term.
6. Mark allowed synonyms and forbidden synonyms.
7. Flag legacy terms that must remain for compatibility.
8. Do not rename code directly unless implementation is explicitly requested.

## Output format

```md
## Terminology map updates

| Term ID | Customer-facing term | Manager term | Domain term | Code/API term | Database term | Definition | Allowed synonyms | Forbidden synonyms | Example |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
```

```md
## Ambiguities

- 

## Legacy compatibility notes

- 

## Naming decisions needed

- 
```

## Naming rules

- Customer-facing Russian terms are used in customer documents.
- Domain and code terms are English.
- Code/API term must be derived from the domain term.
- Database term must be predictable and stable.
- New issues must use canonical domain terms from the map.

## Do not

- Do not use `User`, `Client`, `Account`, or `Customer` interchangeably.
- Do not introduce new code terms when a canonical term already exists.
- Do not hide terminology conflicts; list them explicitly.
