---
name: codex-cli-orchestration
description: Use when the Lead / Orchestrator needs to safely launch and manage Codex CLI subagents, including role assignment, write-owner vs read-only mode, scoped prompts, handoff reports, re-review loops, and final decision requests.
---

# Codex CLI Orchestration

## Purpose

Provide a safe protocol for the Lead / Orchestrator to run bounded Codex CLI subagents.

This skill does not explain every Codex CLI feature. It defines how this project template uses CLI subagents inside the Orchestrator Console Workflow.

## Inputs

- Capability routing result.
- GitHub Issue or task context.
- Required subagent role.
- Allowed and forbidden scope.
- Write-owner decision.
- Validation commands.
- Risk level and escalation notes.
- Current branch/worktree state, if known.

## Procedure

1. Verify that the requested Codex CLI sandbox mode is available before launching the subagent.
   - Use `read-only` for review, QA, security, and docs subagents.
   - Use `workspace-write` only for an Implementer inside the current task worktree and approved scope.
   - If sandbox launch fails in a real repository, do not fall back to `--dangerously-bypass-approvals-and-sandbox`.
   - If the failure is caused by missing `bubblewrap` / `bwrap`, recommend installing Bubblewrap, then stop with `blocked`.
   - Bypass is allowed only in a disposable copy created for a throwaway validation run, never in the real repository.
2. Confirm the subagent role:
   - Implementer;
   - Reviewer;
   - Tester / QA;
   - Security Reviewer;
   - Docs / Terminology.
3. Choose the mode:
   - `write-owner` only for Implementer inside the current task worktree;
   - `read-only` for Reviewer, Tester / QA, Security Reviewer, and Docs / Terminology by default.
4. Define exact scope:
   - allowed files, directories, modules, or docs;
   - forbidden areas;
   - validation commands;
   - expected output.
5. Write the CLI subagent prompt.
6. Require a concise handoff report.
7. Set stop conditions.
8. After the subagent returns, classify the result:
   - accepted;
   - needs scoped fixes;
   - needs re-review;
   - needs human decision;
   - blocked.
9. If fixes are needed, route them back to the Implementer.
10. If blocking findings remain or the action is high-risk, prepare a human decision request.

## Output Format

```md
## CLI Subagent Run Plan

### Subagent role

Implementer | Reviewer | Tester / QA | Security Reviewer | Docs / Terminology

### Mode

write-owner | read-only

### Scope

Allowed:

-

Forbidden:

-

### Prompt to run in Codex CLI

<bounded prompt for the subagent>

### Expected handoff

## Subagent Handoff

### Result

accepted | needs-fixes | needs-re-review | needs-human-decision | blocked

### Findings

-

### Files inspected or changed

-

### Validation

-

### Risks

-

### Recommended next action

-

### Stop conditions

-

### Re-review criteria

-
```

## Role Defaults

| Role | Default mode | Notes |
|---|---|---|
| Implementer | write-owner | May edit only inside the current task scope and worktree |
| Reviewer | read-only | Reviews diff, scope, regressions, PR quality |
| Tester / QA | read-only | Reviews tests, edge cases, reproduction, validation evidence |
| Security Reviewer | read-only | Reviews sensitive risks and escalation needs |
| Docs / Terminology | read-only by default | May edit docs only when explicitly assigned as docs write-owner |

## Stop Conditions

Stop and request a human decision when:

- Codex CLI sandbox is unavailable in a real repository and no safe disposable-copy run is appropriate;
- required scope is missing or contradictory;
- multiple write-owners would be needed in one worktree;
- the subagent needs secrets, production data, production deploys, destructive commands, or infrastructure applies;
- MCP write access would be required;
- the task touches high-risk areas without explicit approval;
- validation cannot be run and the residual risk is material.

## Do Not

- Do not merge pull requests.
- Do not approve high-risk actions.
- Do not run destructive commands.
- Do not expose or request secrets.
- Do not expand scope beyond the issue or task.
- Do not allow read-only reviewers to modify production code.
- Do not use sandbox bypass in a real repository when Codex CLI sandbox is unavailable.
- Do not use this skill as a replacement for human merge or high-risk approval.
