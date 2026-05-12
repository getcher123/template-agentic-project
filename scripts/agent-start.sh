#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: ./scripts/agent-start.sh ISSUE_NUMBER SLUG [BASE_BRANCH]"
  echo "Example: ./scripts/agent-start.sh 42 user-deactivation main"
  exit 1
fi

ISSUE_NUMBER="$1"
SLUG="$2"
BASE_BRANCH="${3:-main}"

CURRENT_ROOT="$(git rev-parse --show-toplevel)"
UMBRELLA_DIR="$(cd "$CURRENT_ROOT/.." && pwd)"
BRANCH="agent/issue-${ISSUE_NUMBER}-${SLUG}"
WORKTREE_DIR="${UMBRELLA_DIR}/wt-issue-${ISSUE_NUMBER}-${SLUG}"

cd "$CURRENT_ROOT"

echo "Fetching origin..."
git fetch origin

echo "Checking out ${BASE_BRANCH}..."
git checkout "$BASE_BRANCH"
git pull --ff-only origin "$BASE_BRANCH"

if git show-ref --verify --quiet "refs/heads/${BRANCH}"; then
  echo "Local branch already exists: ${BRANCH}"
  exit 1
fi

if [ -d "$WORKTREE_DIR" ]; then
  echo "Worktree directory already exists: ${WORKTREE_DIR}"
  exit 1
fi

echo "Creating worktree: ${WORKTREE_DIR}"
git worktree add "$WORKTREE_DIR" -b "$BRANCH" "$BASE_BRANCH"

echo "Worktree created."
echo "Branch: ${BRANCH}"
echo "Path: ${WORKTREE_DIR}"
echo "Next commands:"
echo "  cd ${WORKTREE_DIR}"
echo "  code ."
echo "  codex"

