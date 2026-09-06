#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
UMBRELLA_DIR="$(cd "$ROOT/.." && pwd)"
STATE_FILE="${UMBRELLA_DIR}/STATE.md"
PROJECT_NAME="$(basename "$UMBRELLA_DIR")"
NOW_UTC="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
NOTES_FILE="$(mktemp)"
OUTPUT_FILE="$(mktemp "${STATE_FILE}.tmp.XXXXXX")"
trap 'rm -f "$NOTES_FILE" "$OUTPUT_FILE"' EXIT

if [ -L "$STATE_FILE" ]; then
  echo "Refusing to replace a symlinked STATE.md" >&2
  exit 1
fi

HAS_NOTES="false"
if [ -f "$STATE_FILE" ]; then
  BEGIN_COUNT="$(grep -c '^<!-- BEGIN MANUAL NOTES -->$' "$STATE_FILE" || true)"
  END_COUNT="$(grep -c '^<!-- END MANUAL NOTES -->$' "$STATE_FILE" || true)"
  if [ "$BEGIN_COUNT" -gt 0 ] || [ "$END_COUNT" -gt 0 ]; then
    if [ "$BEGIN_COUNT" -ne 1 ] || [ "$END_COUNT" -ne 1 ]; then
      echo "STATE.md has malformed manual-note markers; file was not changed" >&2
      exit 1
    fi
    awk '
      /^<!-- BEGIN MANUAL NOTES -->$/ {
        if (state != 0) exit 1
        state=1
        next
      }
      /^<!-- END MANUAL NOTES -->$/ {
        if (state != 1) exit 1
        state=2
        next
      }
      state == 1 { print }
      END { if (state != 2) exit 1 }
    ' "$STATE_FILE" > "$NOTES_FILE"
    HAS_NOTES="true"
  elif grep -q '^## Local Notes$' "$STATE_FILE"; then
    awk 'seen { print } /^## Local Notes$/ { seen=1 }' "$STATE_FILE" > "$NOTES_FILE"
    HAS_NOTES="true"
  fi
fi

if [ "$HAS_NOTES" = "false" ]; then
  printf '%s\n' \
    '- Add locked areas manually when multiple agents may touch the same subsystem.' \
    '- Add merge order manually when tasks depend on each other.' > "$NOTES_FILE"
fi

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
  echo "<!-- BEGIN MANUAL NOTES -->"
  cat "$NOTES_FILE"
  echo "<!-- END MANUAL NOTES -->"
} > "$OUTPUT_FILE"

mv "$OUTPUT_FILE" "$STATE_FILE"

echo "Updated ${STATE_FILE}"
