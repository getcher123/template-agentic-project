#!/usr/bin/env python3
"""Reproducible distributable built only from tracked template files."""
import argparse
from pathlib import Path
import subprocess
import zipfile
import io

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / "universal-project-agent-template.zip"


def build():
    entries = subprocess.check_output(
        ["git", "ls-files", "-z", "--", "universal-project-agent-template"], cwd=ROOT
    ).decode().split("\0")
    output = io.BytesIO()
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for name in sorted(filter(None, entries)):
            path = ROOT / name
            info = zipfile.ZipInfo(name, date_time=(2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o100755 if path.stat().st_mode & 0o111 else 0o100644) << 16
            archive.writestr(info, path.read_bytes())
    return output.getvalue()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = build()
    if args.check:
        if not ARCHIVE.is_file() or ARCHIVE.read_bytes() != data:
            raise SystemExit("Archive drift: stage new package files, then make package")
        print("Template archive verified.")
    else:
        ARCHIVE.write_bytes(data)
        print("Template archive rebuilt (tracked files only).")


if __name__ == "__main__":
    main()
