#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: ./scripts/agent-clean.sh WORKTREE_PATH BRANCH_NAME"
  echo "Example: ./scripts/agent-clean.sh ../wt-issue-42-user-deactivation agent/issue-42-user-deactivation"
  exit 1
fi

WORKTREE_PATH="$1"
BRANCH_NAME="$2"
ROOT="$(git rev-parse --show-toplevel)"

cd "$ROOT"

echo "Current worktrees:"
git worktree list

echo "Removing worktree: ${WORKTREE_PATH}"
git worktree remove "$WORKTREE_PATH"

echo "Pruning stale worktree metadata..."
git worktree prune

if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
  echo "Deleting local branch: ${BRANCH_NAME}"
  git branch -d "$BRANCH_NAME"
else
  echo "Local branch not found: ${BRANCH_NAME}"
fi

echo "Cleanup done."

