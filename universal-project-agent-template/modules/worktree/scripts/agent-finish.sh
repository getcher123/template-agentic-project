#!/usr/bin/env bash
set -Eeuo pipefail
if [ "$#" -lt 1 ]; then
  echo "Usage: agent-finish.sh ISSUE_NUMBER [BASE_BRANCH] --body-file FILE --validation docs|targeted|full" >&2
  exit 2
fi
ISSUE_NUMBER="$1"; shift
[[ "$ISSUE_NUMBER" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 2; }
BASE_BRANCH="main"
if [ "$#" -gt 0 ] && [[ "$1" != --* ]]; then BASE_BRANCH="$1"; shift; fi
BODY_FILE=""
MODE=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --body-file) BODY_FILE="${2:?Missing body file}"; shift 2 ;;
    --validation) MODE="${2:?Missing validation mode}"; shift 2 ;;
    *) echo "Unknown option" >&2; exit 2 ;;
  esac
done
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
BRANCH="$(git branch --show-current)"
if [ -z "$BRANCH" ] || [ "$BRANCH" = "$BASE_BRANCH" ]; then
  echo "Use the task branch, not detached HEAD or base." >&2; exit 1
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "Commit scoped changes first; staged and untracked files also count." >&2; exit 1
fi
if [ -z "$BODY_FILE" ]; then
  echo "Fill .github/pull_request_template.md into a separate file with actual evidence." >&2
  echo "Then pass --body-file FILE and --validation docs|targeted|full." >&2
  exit 2
fi
python3 scripts/validate-pr-body.py --body "$BODY_FILE"
case "$MODE" in
  docs) make validate-docs ;;
  targeted) : "${TARGETED_TESTS:?Name the affected tests}"; make local-validate TARGETED_TESTS="$TARGETED_TESTS" ;;
  full) make lint; make typecheck; make test ;;
  *) echo "Select docs, targeted or full validation explicitly." >&2; exit 2 ;;
esac
git diff --check
if [ -n "$(git status --porcelain)" ]; then
  echo "Validation changed the tree; inspect and commit before PR." >&2; exit 1
fi
"$ROOT/scripts/check-github-context.sh" >/dev/null
ISSUE_TITLE="$(GH_TOKEN="$AGENT_GITHUB_TOKEN" gh issue view "$ISSUE_NUMBER" \
  --repo "$AGENT_GITHUB_REPOSITORY" --json title --jq '.title')"
PUSH_URL="https://github.com/${AGENT_GITHUB_REPOSITORY}.git"
GIT_ASKPASS="$ROOT/scripts/github-askpass.sh" \
GIT_TERMINAL_PROMPT=0 \
git -c credential.helper= push "$PUSH_URL" \
  "refs/heads/${BRANCH}:refs/heads/${BRANCH}"
GH_TOKEN="$AGENT_GITHUB_TOKEN" gh pr create \
  --repo "$AGENT_GITHUB_REPOSITORY" --base "$BASE_BRANCH" --head "$BRANCH" \
  --title "Issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}" --body-file "$BODY_FILE"
