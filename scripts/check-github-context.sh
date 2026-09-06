#!/usr/bin/env bash
set -Eeuo pipefail

: "${AGENT_GITHUB_TOKEN:?Set an explicitly selected target-project token}"
: "${AGENT_GITHUB_ACTOR:?Set the expected target-project actor}"
: "${AGENT_GITHUB_REPOSITORY:?Set the expected owner/repository}"
[[ "$AGENT_GITHUB_ACTOR" =~ ^[A-Za-z0-9-]+$ ]] || {
  echo "GitHub context check failed: invalid actor contract" >&2; exit 1;
}
[[ "$AGENT_GITHUB_REPOSITORY" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || {
  echo "GitHub context check failed: invalid repository contract" >&2; exit 1;
}

ROOT="$(git rev-parse --show-toplevel)"
REMOTE="$(git -C "$ROOT" remote get-url origin)"
case "$REMOTE" in
  git@github.com:*) OBSERVED_REPOSITORY="${REMOTE#git@github.com:}" ;;
  ssh://git@github.com/*) OBSERVED_REPOSITORY="${REMOTE#ssh://git@github.com/}" ;;
  https://github.com/*) OBSERVED_REPOSITORY="${REMOTE#https://github.com/}" ;;
  http://github.com/*) OBSERVED_REPOSITORY="${REMOTE#http://github.com/}" ;;
  *) echo "GitHub context check failed: origin is not github.com" >&2; exit 1 ;;
esac
OBSERVED_REPOSITORY="${OBSERVED_REPOSITORY%.git}"

if [ "$(printf '%s' "$OBSERVED_REPOSITORY" | tr '[:upper:]' '[:lower:]')" != \
     "$(printf '%s' "$AGENT_GITHUB_REPOSITORY" | tr '[:upper:]' '[:lower:]')" ]; then
  echo "GitHub context check failed: repository mismatch" >&2
  exit 1
fi

OBSERVED_ACTOR="$(GH_TOKEN="$AGENT_GITHUB_TOKEN" gh api user --jq .login)"
if [ -z "$OBSERVED_ACTOR" ] || \
   [ "$(printf '%s' "$OBSERVED_ACTOR" | tr '[:upper:]' '[:lower:]')" != \
     "$(printf '%s' "$AGENT_GITHUB_ACTOR" | tr '[:upper:]' '[:lower:]')" ]; then
  echo "GitHub context check failed: actor mismatch" >&2
  exit 1
fi

echo "GitHub context verified for the configured repository and actor."
