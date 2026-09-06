#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
"$ROOT/scripts/check-github-context.sh" >/dev/null
export GITHUB_PERSONAL_ACCESS_TOKEN="$AGENT_GITHUB_TOKEN"
exec docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN \
  -e GITHUB_TOOLSETS \
  ghcr.io/github/github-mcp-server
