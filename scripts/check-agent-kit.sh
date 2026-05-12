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
  ".agents/skills/refactoring-plan/SKILL.md"
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

for skill in .agents/skills/*/SKILL.md; do
  if [ ! -f "$skill" ]; then
    continue
  fi

  if ! sed -n '1p' "$skill" | grep -qx -- "---"; then
    echo "Invalid skill frontmatter start: $skill"
    missing=1
  fi
  if ! sed -n '2,8p' "$skill" | grep -q '^name: '; then
    echo "Missing skill name frontmatter: $skill"
    missing=1
  fi
  if ! sed -n '2,8p' "$skill" | grep -q '^description: '; then
    echo "Missing skill description frontmatter: $skill"
    missing=1
  fi

  if ! awk '
    /^```[A-Za-z0-9_-]+[[:space:]]*$/ {
      if (in_fence) {
        printf "%s:%d: nested fenced code block: %s\n", FILENAME, FNR, $0
        bad=1
      } else {
        in_fence=1
      }
      next
    }
    /^```[[:space:]]*$/ {
      if (in_fence) {
        in_fence=0
      }
      next
    }
    END { exit bad }
  ' "$skill"; then
    missing=1
  fi
done

template_skill_root="universal-project-agent-template/modules/skills/.agents/skills"
if [ -d "$template_skill_root" ]; then
  for skill in .agents/skills/*/SKILL.md; do
    skill_name="$(basename "$(dirname "$skill")")"
    template_skill="$template_skill_root/$skill_name/SKILL.md"
    if [ ! -f "$template_skill" ]; then
      echo "Missing template skill copy: $template_skill"
      missing=1
    elif ! cmp -s "$skill" "$template_skill"; then
      echo "Skill drift between root and template: $skill"
      missing=1
    fi
  done
fi

enabled_pattern='enabled = ''true'
if grep -R -n "$enabled_pattern" .codex docs .agents/skills AGENTS.skills-snippet.md 2>/dev/null; then
  echo "MCP config/docs must not enable starter MCP by default."
  missing=1
fi

forbidden_mcp_pattern='Sla''ck|Tea''ms|Fig''ma|Not''ion|Google Dri''ve|Drive M''CP|Database M''CP|Postgres M''CP|MySQL M''CP|Docs/Dri''ve|Docs M''CP'
if grep -R -n -E "$forbidden_mcp_pattern" .codex docs AGENTS.skills-snippet.md .agents/skills 2>/dev/null; then
  echo "Forbidden starter MCP reference found."
  missing=1
fi

stale_mode_pattern='orchestrator-''plus|split-''required'
if grep -R -n -E "$stale_mode_pattern" .agents/skills docs AGENTS.skills-snippet.md 2>/dev/null; then
  echo "Stale orchestration mode name found."
  missing=1
fi

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
