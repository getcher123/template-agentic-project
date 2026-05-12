# Source Index

## Purpose

Track the sources used to define `<PROJECT_NAME>` so requirements can be traced back to reliable evidence.

## Source Reliability Levels

| Level | Meaning |
|---|---|
| S1 | Contract, signed specification, production behavior, or authoritative repository state |
| S2 | Approved customer message, meeting notes confirmed by owner, accepted design |
| S3 | Working notes, draft, chat discussion, inferred behavior |

## Sources

| ID | Source | Type | Reliability | Key Facts | Open Questions | Affected Docs |
|---|---|---|---|---|---|---|
| SRC-001 | `<source name or link>` | `<interview/spec/code/etc>` | S3 | `<facts>` | `<questions>` | `<docs>` |

## Rules

- Do not create agent-ready issues from untraceable requirements.
- If a source contradicts canonical docs, update the docs or record the conflict before implementation.

