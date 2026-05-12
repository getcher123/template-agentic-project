#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

required_paths=(
  ".agents/skills/capability-router/SKILL.md"
  ".agents/skills/codex-cli-orchestration/SKILL.md"
  ".agents/skills/source-index-builder/SKILL.md"
  ".agents/skills/terminology-map-builder/SKILL.md"
  ".agents/skills/requirement-slicing/SKILL.md"
  ".agents/skills/issue-agent-readiness/SKILL.md"
  ".agents/skills/orchestration-plan/SKILL.md"
  ".agents/skills/implementation-plan/SKILL.md"
  ".agents/skills/test-gap-review/SKILL.md"
  ".agents/skills/security-review/SKILL.md"
  ".agents/skills/documentation-sync/SKILL.md"
  ".agents/skills/pr-handoff/SKILL.md"
  ".agents/skills/mcp-usage-guard/SKILL.md"
  ".codex/config.toml"
  "docs/skills-registry.md"
  "docs/capability-selection-guide.md"
  "docs/orchestrator-console-workflow.md"
  "docs/role-skill-matrix.md"
  "docs/mcp-registry.md"
  "docs/agent-roles.md"
  "AGENTS.skills-snippet.md"
)

missing=0
for path in "${required_paths[@]}"; do
  if [ ! -f "$path" ]; then
    echo "Missing: $path"
    missing=1
  else
    echo "OK: $path"
  fi
done

if [ "$missing" -ne 0 ]; then
  echo "Agent kit check failed."
  exit 1
fi

echo "Agent kit check passed."

echo
if [ -f ".codex/config.toml" ]; then
  echo "MCP servers configured in .codex/config.toml:"
  grep -E '^\[mcp_servers\.' .codex/config.toml || true
fi
