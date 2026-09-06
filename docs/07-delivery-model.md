# Delivery model

## One reusable task contract

Keep this card in the existing issue/handoff, not in a new registry:

- Objective and independently observable acceptance criteria.
- Source/context and affected product/technical layer.
- Allowed and forbidden scope.
- Full baseline/checkpoint SHA, branch, worktree and one write-owner.
- Selected local checks, required CI and explicitly unrun checks.
- Existing authority: environment, operations, limits, expiry, stop conditions.
- Current status, decisions/gaps, dependencies and the next useful action.

Statuses: Inbox → Ready → In Progress → Review → Done; Blocked names a concrete
missing input/dependency. Project fields reflect the issue, not a second plan.
On resume compare changed facts only. A commit with recorded validation is a
checkpoint; an uncommitted diff is work in progress.

## Task, batch, program

A task is one bounded change. A batch groups related fixes/waves under an
approved handoff and may use one rollup PR. A program coordinates at least two
related batches with dependencies/shared merge queue, not every single task.

Roles describe responsibility, not mandatory extra agents. One Lead can implement.
For two independent code tasks and four available slots: coordinator + two
implementers in isolated worktrees + one reserve. For one sequential surface:
one implementer plus bounded independent QA/review when useful.

Each wave has an acceptance barrier, affected tests and a checkpoint. Full CI
and exact-head review happen on the final PR, not automatically per checkpoint.
Do not wait for unrelated blocked work or run duplicate research.

## Reviews and merge

Human review and project-required CI remain mandatory. Neither a stronger model
nor another project's approvals grant authority. Separate reviewer identity must
be independently authorized for this repository; never load a source project's
token to obtain target-project approval.
Repository automation verifies an explicitly provided token, actor and
owner/repository with `scripts/check-github-context.sh` before GitHub writes.
It does not select or discover credentials automatically.

A finding states exact SHA, reproduction/evidence, violated criterion and impact.
Review the changed boundary, not unlimited hypothetical variants. Preserve real
blocking criteria; unchanged SHA needs no repeated review without new evidence.
Repeated no-progress findings require a bounded decision/handoff, not silent
acceptance or an endless loop. Changing PR prose alone does not change code SHA.

## Validation and economy

Local docs checks or named affected tests precede PR. Full local tests are an
explicit diagnostic option; CI supplies the authoritative final gate.
Never present template structure checks as passing application tests.
Cancellation of stale runs uses a per-PR group; separate PRs/main remain isolated.
Do not add tiers or deploy classifiers where no expensive suite/deploy exists.

For the next three real tasks, optionally record time to first useful change,
duplicate review/check counts and token usage if available. No synthetic work
or additional gates are required just to collect metrics.

## Rollback and completion

Record rollback, unresolved customer facts and residual risk. Revert the scoped
PR if necessary; never reset someone else's worktree. Done requires the
task's actual acceptance evidence, not merely a generated artifact or a green
mock. No deployment or production-readiness claim is implied.
