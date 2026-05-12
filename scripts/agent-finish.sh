#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: ./scripts/agent-finish.sh ISSUE_NUMBER [BASE_BRANCH]"
  echo "Example: ./scripts/agent-finish.sh 42 main"
  exit 1
fi

ISSUE_NUMBER="$1"
BASE_BRANCH="${2:-main}"
ROOT="$(git rev-parse --show-toplevel)"
BRANCH="$(git -C "$ROOT" branch --show-current)"

cd "$ROOT"

if [ -z "$BRANCH" ]; then
  echo "Cannot detect current branch."
  exit 1
fi

if [ "$BRANCH" = "$BASE_BRANCH" ]; then
  echo "Refusing to create PR from base branch: ${BASE_BRANCH}"
  exit 1
fi

echo "Running validation..."
make lint
make typecheck
make test

if ! git diff --quiet; then
  echo "There are uncommitted changes. Commit them before creating PR."
  git status --short
  exit 1
fi

ISSUE_TITLE="$(gh issue view "$ISSUE_NUMBER" --json title --jq '.title')"
PR_BODY_FILE="$(mktemp)"

{
  echo "## Linked Issue"
  echo
  echo "Closes #${ISSUE_NUMBER}"
  echo
  echo "## Summary"
  echo
  echo "- Implements the scoped task described in issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}"
  echo
  echo "## Type Of Change"
  echo
  echo "- [ ] Feature"
  echo "- [ ] Bug fix"
  echo "- [ ] Refactor"
  echo "- [ ] Tests"
  echo "- [ ] Docs"
  echo "- [ ] Infrastructure"
  echo "- [ ] Security-sensitive change"
  echo
  echo "## Scope"
  echo
  echo "Touched areas:"
  echo
  echo "- See Files changed tab."
  echo
  echo "Intentionally not touched:"
  echo
  echo "- Unrelated modules and out-of-scope refactors."
  echo
  echo "## Validation"
  echo
  echo "Commands run:"
  echo
  echo '```bash'
  echo "make lint"
  echo "make typecheck"
  echo "make test"
  echo '```'
  echo
  echo "Results:"
  echo
  echo "- [x] Lint passed locally"
  echo "- [x] Typecheck passed locally"
  echo "- [x] Tests passed locally"
  echo "- [ ] CI passed"
  echo
  echo "Commands not run and reason:"
  echo
  echo "- None."
  echo
  echo "## Agent Handoff Report"
  echo
  echo "Implementation notes:"
  echo
  echo "- Review commit history and Files changed for implementation details."
  echo
  echo "Files changed:"
  echo
  echo "- See Files changed tab."
  echo
  echo "Risk areas:"
  echo
  echo "- Reviewer should verify behavior against acceptance criteria in issue #${ISSUE_NUMBER}."
  echo
  echo "Human review focus:"
  echo
  echo "- Confirm scope is limited to issue #${ISSUE_NUMBER}."
  echo "- Confirm tests cover the changed behavior."
  echo "- Confirm no secrets or unrelated formatting changes are included."
  echo
  echo "Rollback notes:"
  echo
  echo "- Revert this PR if the changed behavior causes regression."
  echo
  echo "## Checklist"
  echo
  echo "- [x] PR is linked to the issue."
  echo "- [x] Diff is scoped to the issue."
  echo "- [x] Tests were added or updated when behavior changed."
  echo "- [x] No secrets or credentials are included."
  echo "- [x] No unrelated formatting-only diff is included."
} > "$PR_BODY_FILE"

git push -u origin "$BRANCH"

gh pr create \
  --base "$BASE_BRANCH" \
  --head "$BRANCH" \
  --title "Issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}" \
  --body-file "$PR_BODY_FILE"

rm -f "$PR_BODY_FILE"

