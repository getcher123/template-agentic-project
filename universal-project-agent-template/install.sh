#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'USAGE'
Usage:
  ./install.sh [--target PATH] [--mode new|existing] [--profile core|recommended|full] [--dry-run|--apply] [--overwrite]

Defaults:
  --target .
  --mode existing
  --profile core
  --dry-run

Examples:
  ./install.sh --target /path/to/repo
  ./install.sh --target /path/to/repo --mode new --profile recommended --apply
  ./install.sh --target /path/to/repo --mode existing --profile full --apply --overwrite
USAGE
}

TEMPLATE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="."
MODE="existing"
PROFILE="core"
ACTION="dry-run"
OVERWRITE="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      TARGET="${2:?--target requires a path}"
      shift 2
      ;;
    --mode)
      MODE="${2:?--mode requires new or existing}"
      shift 2
      ;;
    --profile)
      PROFILE="${2:?--profile requires core, recommended, or full}"
      shift 2
      ;;
    --dry-run)
      ACTION="dry-run"
      shift
      ;;
    --apply)
      ACTION="apply"
      shift
      ;;
    --overwrite)
      OVERWRITE="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

case "$MODE" in
  new|existing) ;;
  *) echo "Invalid --mode: $MODE" >&2; exit 2 ;;
esac

case "$PROFILE" in
  core|recommended|full) ;;
  *) echo "Invalid --profile: $PROFILE" >&2; exit 2 ;;
esac

case "$ACTION" in
  dry-run|apply) ;;
  *) echo "Invalid action: $ACTION" >&2; exit 2 ;;
esac

if [ "$ACTION" = "apply" ]; then
  TARGET="$(mkdir -p "$TARGET" && cd "$TARGET" && pwd)"
else
  if [ -d "$TARGET" ]; then
    TARGET="$(cd "$TARGET" && pwd)"
  else
    TARGET_PARENT="$(dirname "$TARGET")"
    TARGET_BASENAME="$(basename "$TARGET")"
    if [ -d "$TARGET_PARENT" ]; then
      TARGET="$(cd "$TARGET_PARENT" && pwd)/$TARGET_BASENAME"
    fi
  fi
fi

declare -a CONFLICTS=()
declare -a COPIED=()
declare -a PLANNED=()

copy_file() {
  local src="$1"
  local rel="$2"
  local dest="${TARGET}/${rel}"

  if [ -e "$dest" ] && [ "$OVERWRITE" != "true" ]; then
    CONFLICTS+=("$rel")
    return 0
  fi

  if [ "$ACTION" = "dry-run" ]; then
    PLANNED+=("$rel")
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  COPIED+=("$rel")
}

copy_tree() {
  local src_root="$1"
  local dest_prefix="${2:-}"

  if [ ! -d "$src_root" ]; then
    echo "Missing template source directory: $src_root" >&2
    exit 1
  fi

  while IFS= read -r -d '' src; do
    local rel="${src#"$src_root"/}"
    if [ -n "$dest_prefix" ]; then
      rel="${dest_prefix}/${rel}"
    fi
    copy_file "$src" "$rel"
  done < <(find "$src_root" -type f -print0 | sort -z)
}

install_core() {
  copy_tree "$TEMPLATE_ROOT/core"
}

install_recommended() {
  install_core
  copy_tree "$TEMPLATE_ROOT/modules/skills"
  copy_tree "$TEMPLATE_ROOT/modules/mcp"
  copy_tree "$TEMPLATE_ROOT/modules/worktree/scripts" "scripts"
}

install_full() {
  install_recommended
  copy_file "$TEMPLATE_ROOT/modules/github/CODEOWNERS" ".github/CODEOWNERS"
  copy_file "$TEMPLATE_ROOT/modules/github/PROJECT_SETUP.md" "docs/github-project-setup.md"
  copy_file "$TEMPLATE_ROOT/modules/github/labels.sh" "scripts/setup-github-labels.sh"
  copy_tree "$TEMPLATE_ROOT/modules/github/workflows" ".github/workflows"
}

case "$PROFILE" in
  core) install_core ;;
  recommended) install_recommended ;;
  full) install_full ;;
esac

if [ "$ACTION" = "apply" ]; then
  find "$TARGET/scripts" -maxdepth 1 -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
fi

echo "Universal Project Agent Template"
echo "Target:  $TARGET"
echo "Mode:    $MODE"
echo "Profile: $PROFILE"
echo "Action:  $ACTION"
echo "Overwrite existing files: $OVERWRITE"
echo

if [ "${#PLANNED[@]}" -gt 0 ]; then
  echo "Would copy:"
  printf '  + %s\n' "${PLANNED[@]}"
  echo
fi

if [ "${#COPIED[@]}" -gt 0 ]; then
  echo "Copied:"
  printf '  + %s\n' "${COPIED[@]}"
  echo
fi

if [ "${#CONFLICTS[@]}" -gt 0 ]; then
  echo "Conflicts, left unchanged:"
  printf '  ! %s\n' "${CONFLICTS[@]}"
  echo
  echo "Re-run with --overwrite only after reviewing these files."
fi

if [ "$ACTION" = "dry-run" ]; then
  echo "Dry run complete. No files were written."
else
  echo "Install complete."
fi
