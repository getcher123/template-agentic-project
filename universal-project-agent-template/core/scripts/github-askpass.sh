#!/usr/bin/env bash
set -Eeuo pipefail

: "${AGENT_GITHUB_TOKEN:?Set an explicitly selected target-project token}"
: "${AGENT_GITHUB_ACTOR:?Set the expected target-project actor}"

case "${1:-}" in
  *Username*|*username*) printf '%s\n' "$AGENT_GITHUB_ACTOR" ;;
  *Password*|*password*) printf '%s\n' "$AGENT_GITHUB_TOKEN" ;;
  *) echo "Unsupported Git credential prompt" >&2; exit 1 ;;
esac
