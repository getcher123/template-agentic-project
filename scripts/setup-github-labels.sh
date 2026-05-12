#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI is required: https://cli.github.com/" >&2
  exit 1
fi

gh auth status >/dev/null

upsert_label() {
  local name="$1"
  local color="$2"
  local description="$3"

  if gh api "repos/{owner}/{repo}/labels/${name}" --silent >/dev/null 2>&1; then
    gh api --method PATCH "repos/{owner}/{repo}/labels/${name}" \
      -f "color=${color}" \
      -f "description=${description}" \
      --silent
    echo "updated ${name}"
  else
    gh api --method POST "repos/{owner}/{repo}/labels" \
      -f "name=${name}" \
      -f "color=${color}" \
      -f "description=${description}" \
      --silent
    echo "created ${name}"
  fi
}

upsert_label agent-candidate BFDADC "May be suitable for agent work"
upsert_label agent-ready 0E8A16 "Task is sufficiently scoped for agent execution"
upsert_label agent-running 1D76DB "Agent is currently working on this task"
upsert_label needs-triage FBCA04 "Needs human triage"
upsert_label needs-human-input D93F0B "Blocked until a human clarifies something"
upsert_label ready-for-review 5319E7 "PR is ready for human review"
upsert_label blocked B60205 "Blocked by dependency, conflict, or missing decision"
upsert_label risk-low C2E0C6 "Low-risk change"
upsert_label risk-medium FEEDB0 "Medium-risk change"
upsert_label risk-high D93F0B "High-risk change"
upsert_label risk-critical B60205 "Critical-risk change"
upsert_label area-backend 1D76DB "Backend/API/service code"
upsert_label area-frontend 5319E7 "Frontend/UI code"
upsert_label area-data 0E8A16 "Data, analytics, pipelines"
upsert_label area-ai 7057FF "AI/model/prompt/eval code"
upsert_label area-infra D4C5F9 "Infrastructure, CI, deployment"
upsert_label area-tests C5DEF5 "Tests and QA"
upsert_label area-docs 0075CA "Documentation"
upsert_label size-xs C2E0C6 "Very small task"
upsert_label size-s C2E0C6 "Small task"
upsert_label size-m FEEDB0 "Medium task"
upsert_label size-l D93F0B "Large task; should be decomposed"
upsert_label size-xl B60205 "Epic; not agent-ready"
