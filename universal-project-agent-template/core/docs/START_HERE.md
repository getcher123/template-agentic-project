# Start here

Read the task and AGENTS.md first. This is a pointer, not a reading checklist.

| Question | Source |
|---|---|
| What is approved / where did work stop? | Linked issue, latest handoff, Project |
| Where did a requirement come from? | [Source index](00-source-index.md) |
| What should the product do? | [Scope](03-scope-and-requirements.md), [journeys](04-processes-and-user-journeys.md) |
| What is the technical contract? | [Architecture](05-architecture-and-data.md) |
| What terms should be used? | [Terminology](02-terminology-map.md), only when relevant |
| How is work delivered? | [Delivery model](07-delivery-model.md) |
| Is a boundary protected? | [Quality/security](06-quality-security-constraints.md) |
| Which skill? | docs/skills-registry.md, if the skills module is installed |

The canonical template sources live in `universal-project-agent-template/`
in the template repository. Its installed/root copies are checked derivatives.

For WSL, prefer new task worktrees on ext4 (for example
`$HOME/project-worktrees/`). Fetch the approved base without checking out or
updating dirty main. Record pwd, full base/checkpoint SHA, owner, and the absolute
`.agents/skills` path. Do not copy secrets or agent-global configuration.

Launch a fresh session with `codex -C <worktree>` (or open that directory in
the IDE). Verify its actual pwd and project-skill path on a read-only request.
Use the installed CLI's help for supported options. Existing sessions/branches
do not automatically adopt a new checkout.
