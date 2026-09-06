#!/usr/bin/env python3
"""Canonical package -> root example mirrors. Never copy private configuration."""
import argparse
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]
PACKAGE = ROOT / "universal-project-agent-template"
IDENTITY = {
    "<PROJECT_NAME>": "Template Agentic Project",
    "<ORG_OR_USER>/<REPO_NAME>": "getcher123/template-agentic-project",
    "<DEFAULT_BRANCH>": "main",
    "<PRIMARY_OWNER>": "@getcher123",
}


def pairs():
    for directory, target in (
        ("core/docs", "docs"), ("core/scripts", "scripts"),
        ("core/.github", ".github"), ("modules/skills", "."),
        ("modules/mcp/docs", "docs"), ("modules/mcp/scripts", "scripts"),
        ("modules/worktree/scripts", "scripts"),
        ("modules/github/workflows", ".github/workflows"),
    ):
        for source in sorted((PACKAGE / directory).rglob("*")):
            if source.is_file() and "__pycache__" not in source.parts:
                yield source, ROOT / target / source.relative_to(PACKAGE / directory)
    yield PACKAGE / "modules/github/CODEOWNERS", ROOT / ".github/CODEOWNERS"
    yield PACKAGE / "modules/github/PROJECT_SETUP.md", ROOT / "docs/github-project-setup.md"
    yield PACKAGE / "modules/github/labels.sh", ROOT / "scripts/setup-github-labels.sh"
    yield PACKAGE / "core/AGENTS.md", ROOT / "AGENTS.md"


def expected(source, target):
    data = source.read_bytes()
    if (source.is_relative_to(PACKAGE / "core")
            or source.is_relative_to(PACKAGE / "modules/github")):
        text = data.decode()
        for old, new in IDENTITY.items():
            text = text.replace(old, new)
        data = text.encode()
    return data


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    drift = []
    destinations = set()
    for source, target in pairs():
        if target in destinations:
            raise SystemExit("Overlapping mirror sources: " + str(target.relative_to(ROOT)))
        destinations.add(target)
        data = expected(source, target)
        mode_drift = (target.is_file()
                      and (source.stat().st_mode & 0o111) != (target.stat().st_mode & 0o111))
        if not target.is_file() or target.read_bytes() != data or mode_drift:
            drift.append(str(target.relative_to(ROOT)))
            if not args.check:
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
                shutil.copymode(source, target)
    # Also detect root-only skills/resources; no automatic deletions.
    for target in (ROOT / ".agents/skills").rglob("*"):
        if target.is_file() and "__pycache__" not in target.parts and target not in destinations:
            drift.append("orphan: " + str(target.relative_to(ROOT)))
    if args.check and drift:
        print("\n".join(drift))
        return 1
    print("Template mirrors " + ("verified." if args.check else "synchronized."))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
