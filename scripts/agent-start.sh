#!/usr/bin/env bash
set -Eeuo pipefail
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: agent-start.sh ISSUE_NUMBER SLUG [BASE_BRANCH]" >&2
  exit 2
fi
ISSUE_NUMBER="$1"
SLUG="$2"
BASE_BRANCH="${3:-main}"
[[ "$ISSUE_NUMBER" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 2; }
[[ "$SLUG" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Invalid slug" >&2; exit 2; }
git check-ref-format "refs/heads/$BASE_BRANCH" >/dev/null
ROOT="$(git rev-parse --show-toplevel)"
BRANCH="agent/issue-${ISSUE_NUMBER}-${SLUG}"
# Explicit override works on any OS; WSL defaults to the Linux home filesystem.
PARENT="${AGENT_WORKTREE_ROOT:-$HOME/agent-worktrees/$(basename "$ROOT")}"
mkdir -p "$PARENT"
PARENT="$(cd "$PARENT" && pwd)"
WORKTREE_DIR="$PARENT/wt-issue-${ISSUE_NUMBER}-${SLUG}"
if git -C "$ROOT" show-ref --verify --quiet "refs/heads/$BRANCH" || [ -e "$WORKTREE_DIR" ]; then
  echo "Branch or worktree already exists; resume it explicitly." >&2
  exit 1
fi
git -C "$ROOT" fetch origin "$BASE_BRANCH"
BASE_SHA="$(git -C "$ROOT" rev-parse FETCH_HEAD)"
git -C "$ROOT" worktree add "$WORKTREE_DIR" -b "$BRANCH" "$BASE_SHA"
echo "Branch: $BRANCH"
echo "Path: $WORKTREE_DIR"
echo "Baseline: $BASE_SHA"
echo "Skills: $WORKTREE_DIR/.agents/skills"
echo "Start a NEW session: codex -C '$WORKTREE_DIR'"
