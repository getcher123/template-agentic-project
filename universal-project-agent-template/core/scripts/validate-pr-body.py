#!/usr/bin/env python3
"""Validate the canonical PR contract, without evaluating or printing its body."""
import argparse
from pathlib import Path
import re
import sys

REQUIRED = (
    "Linked Issue", "Summary", "Scope", "Validation", "Agent Handoff Report",
    "Human Review Focus", "Rollback Notes", "Decision Request", "Checklist",
)


def sections(text):
    result = {}
    current = None
    fence = None
    for line in text.splitlines():
        marker = re.match(r"^\s{0,3}(`{3,}|~{3,})", line)
        if marker:
            kind = marker[1][0]
            if fence is None:
                fence = (kind, len(marker[1]))
            elif kind == fence[0] and len(marker[1]) >= fence[1]:
                fence = None
            continue
        if fence:
            continue
        heading = re.match(r"^##\s+(.+?)\s*$", line)
        if heading:
            current = heading[1]
            if current in result:
                raise ValueError("Duplicate heading")
            result[current] = []
        elif current:
            result[current].append(line)
    if fence:
        raise ValueError("Unclosed code fence")
    return result


def validate(body, template):
    canonical = sections(template)
    actual = sections(body)
    for heading in REQUIRED:
        if heading not in canonical or heading not in actual:
            raise ValueError("Missing required heading: " + heading)
        content = "\n".join(actual[heading]).strip()
        if not content or not any(
            line.strip() and line.strip() not in {"-", "*"}
            for line in actual[heading]
        ):
            raise ValueError("Empty section: " + heading)
        if actual[heading] == canonical[heading]:
            raise ValueError("Unfilled section: " + heading)
    if not re.search(r"(?i)\b(?:close[sd]?|fix(?:e[sd])?|resolve[sd]?)\s+#\d+\b",
                     "\n".join(actual["Linked Issue"])):
        raise ValueError("Linked Issue requires a closing issue reference")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--body", required=True, type=Path)
    parser.add_argument("--template", type=Path,
                        default=Path(__file__).resolve().parents[1] / ".github/pull_request_template.md")
    args = parser.parse_args()
    try:
        body = sys.stdin.read() if str(args.body) == "-" else args.body.read_text()
        validate(body, args.template.read_text())
    except (OSError, UnicodeError, ValueError) as exc:
        # Never print body, filenames supplied by users, or OS error contents.
        print("PR body validation failed: " + (str(exc) if isinstance(exc, ValueError) else "unreadable input"))
        return 1
    print("PR body validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
