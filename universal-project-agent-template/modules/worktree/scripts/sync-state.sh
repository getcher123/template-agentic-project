#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
UMBRELLA_DIR="$(cd "$ROOT/.." && pwd)"
STATE_FILE="${UMBRELLA_DIR}/STATE.md"
PROJECT_NAME="$(basename "$UMBRELLA_DIR")"
NOW_UTC="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

{
  echo "# STATE.md"
  echo
  echo "Project: ${PROJECT_NAME}"
  echo "Generated: ${NOW_UTC}"
  echo
  echo "This file is a local operational dashboard. GitHub Issues, GitHub Projects, Pull Requests, and CI are canonical."
  echo
  echo "## Active worktrees"
  echo
  git -C "$ROOT" worktree list --porcelain | awk '
    /^worktree / { path=$2 }
    /^branch / { branch=$2; gsub("refs/heads/", "", branch); print "- " path " -> " branch }
    /^detached / { print "- " path " -> detached HEAD" }
  '
  echo
  echo "## Local Notes"
  echo
  echo "- Add locked areas manually when multiple agents may touch the same subsystem."
  echo "- Add merge order manually when tasks depend on each other."
} > "$STATE_FILE"

echo "Updated ${STATE_FILE}"

