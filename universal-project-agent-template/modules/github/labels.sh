#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI is required: https://cli.github.com/" >&2
  exit 1
fi

gh auth status >/dev/null

gh label create agent-candidate --color BFDADC --description "May be suitable for agent work" || true
gh label create agent-ready --color 0E8A16 --description "Task is sufficiently scoped for agent execution" || true
gh label create agent-running --color 1D76DB --description "Agent is currently working on this task" || true
gh label create needs-triage --color FBCA04 --description "Needs human triage" || true
gh label create needs-human-input --color D93F0B --description "Blocked until a human clarifies something" || true
gh label create ready-for-review --color 5319E7 --description "PR is ready for human review" || true
gh label create blocked --color B60205 --description "Blocked by dependency, conflict, or missing decision" || true
gh label create risk-low --color C2E0C6 --description "Low-risk change" || true
gh label create risk-medium --color FEEDB0 --description "Medium-risk change" || true
gh label create risk-high --color D93F0B --description "High-risk change" || true
gh label create risk-critical --color B60205 --description "Critical-risk change" || true
gh label create area-backend --color 1D76DB --description "Backend/API/service code" || true
gh label create area-frontend --color 5319E7 --description "Frontend/UI code" || true
gh label create area-data --color 0E8A16 --description "Data, analytics, pipelines" || true
gh label create area-ai --color 7057FF --description "AI/model/prompt/eval code" || true
gh label create area-infra --color D4C5F9 --description "Infrastructure, CI, deployment" || true
gh label create area-tests --color C5DEF5 --description "Tests and QA" || true
gh label create area-docs --color 0075CA --description "Documentation" || true
gh label create size-xs --color C2E0C6 --description "Very small task" || true
gh label create size-s --color C2E0C6 --description "Small task" || true
gh label create size-m --color FEEDB0 --description "Medium task" || true
gh label create size-l --color D93F0B --description "Large task; should be decomposed" || true
gh label create size-xl --color B60205 --description "Epic; not agent-ready" || true

