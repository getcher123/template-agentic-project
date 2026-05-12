---
name: source-index-builder
description: Use when starting a new project or transforming an existing one to extract raw sources into docs/00-source-index.md, assign reliability, list key facts, and identify open questions. Do not use for code implementation.
---

# Source Index Builder

## Purpose

Create or update the project source index from raw materials before requirements, terminology, or issues are finalized.

## Inputs

Read available sources:

- customer brief;
- interview notes;
- contract excerpts;
- legacy README;
- existing code and API names;
- spreadsheets;
- screenshots;
- operational process notes;
- security or compliance constraints.

## Procedure

1. Identify every source that contains project meaning.
2. Assign a stable `Source ID` using the format `SRC-001`, `SRC-002`, `SRC-003`.
3. Classify source type.
4. Assign reliability:
   - `High`: decision-maker, contract, regulation, production behavior, signed artifact.
   - `Medium`: confirmed by project team but not formally approved.
   - `Low`: hypothesis, informal note, assumption, or unverified legacy knowledge.
5. Extract key facts.
6. Map each fact to affected canonical docs.
7. List open questions.
8. Do not turn assumptions into requirements without marking them.

## Output format

Return a Markdown section suitable for `docs/00-source-index.md`:

```md
| Source ID | Source type | Date | Owner | Reliability | Key facts extracted | Canonical docs affected | Open questions |
|---|---|---|---|---|---|---|---|
| SRC-001 |  |  |  | High |  |  |  |
```

Then return:

```md
## Source risks

- 

## Required follow-up questions

- 

## Recommended next skills

- terminology-map-builder
- requirement-slicing
```

## Do not

- Do not invent dates, owners, or approvals.
- Do not convert low-reliability assumptions into accepted requirements.
- Do not write implementation issues before sources are indexed.
