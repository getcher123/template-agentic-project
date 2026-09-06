#!/usr/bin/env python3
"""Local structural checks; no reading or echoing of user agent configuration."""
from pathlib import Path
import re
import sys
import importlib.util

ROOT = Path(__file__).resolve().parents[1]


def check(root):
    errors = []
    for rel in ("AGENTS.md", "docs/START_HERE.md", "docs/07-delivery-model.md",
                ".github/pull_request_template.md", "scripts/validate-pr-body.py",
                "scripts/check-github-context.sh"):
        if not (root / rel).is_file():
            errors.append("Missing: " + rel)
    for skill in sorted((root / ".agents/skills").glob("*/SKILL.md")):
        text = skill.read_text()
        parts = re.split(r"(?m)^---[ \t]*$", text, maxsplit=2)
        if len(parts) != 3 or parts[0] != "":
            errors.append("Incomplete frontmatter: " + str(skill.relative_to(root)))
            continue
        fields = {}
        for line in parts[1].splitlines():
            match = re.match(r"^(name|description):\s*(.+)$", line)
            if match:
                value = match[2].strip()
                if match[1] in fields or (not value.startswith(('"', "'")) and ": " in value):
                    errors.append("Invalid scalar frontmatter: " + str(skill.relative_to(root)))
                fields[match[1]] = value.strip('"\'')
        if fields.get("name") != skill.parent.name or not fields.get("description"):
            errors.append("Invalid name/description: " + str(skill.relative_to(root)))
        fence = None
        for line in parts[2].splitlines():
            marker = re.match(r"^\s{0,3}(`{3,}|~{3,})", line)
            if marker:
                if fence is None:
                    fence = (marker[1][0], len(marker[1]))
                elif marker[1][0] == fence[0] and len(marker[1]) >= fence[1]:
                    fence = None
            if fence is None:
                for target in re.findall(r"\]\(([^)]+)\)", line):
                    target = target.split("#", 1)[0]
                    if target and not re.match(r"[a-z]+:", target) and not (skill.parent / target).exists():
                        errors.append("Broken skill link: " + str(skill.relative_to(root)))
        if fence:
            errors.append("Unclosed skill fence: " + str(skill.relative_to(root)))

    # In the template source repository validate only the distributable starter
    # configuration. An installed project's .codex/config.toml is user-owned.
    starter_mcp = root / "universal-project-agent-template/modules/mcp/.codex/config.toml"
    if starter_mcp.is_file():
        try:
            # Deliberately bounded to the starter's plain named tables; no
            # broad text scan and no dependency on an application's TOML parser.
            tables = re.split(r"(?m)^\[([^\]\n]+)\][ \t]*(?:#.*)?$", starter_mcp.read_text())
            servers = [tables[i + 1] for i in range(1, len(tables), 2)
                       if tables[i].startswith("mcp_servers.")]
            if not servers or any(
                re.findall(r"(?m)^\s*enabled\s*=\s*([^#\n]+)", body) != ["false"]
                for body in servers
            ):
                errors.append("Starter MCP servers must be explicitly disabled")
        except (OSError, UnicodeError):
            errors.append("Invalid starter MCP configuration")
    return errors


def main():
    errors = check(ROOT)
    validator = ROOT / "scripts/validate-pr-body.py"
    if validator.exists():
        spec = importlib.util.spec_from_file_location("pr_body", validator)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        try:
            headings = module.sections((ROOT / ".github/pull_request_template.md").read_text())
            if any(heading not in headings for heading in module.REQUIRED):
                errors.append("Canonical PR template lacks required headings")
        except (ValueError, OSError):
            errors.append("Invalid canonical PR template")
    for error in errors:
        print(error)
    print("Agent kit check " + ("failed." if errors else "passed."))
    return bool(errors)


if __name__ == "__main__":
    sys.exit(main())
