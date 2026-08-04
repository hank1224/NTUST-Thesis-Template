#!/usr/bin/env python3
"""Gate fatal LaTeX diagnostics while preserving a warning report."""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys

from tooling.project import repository_path


DIAGNOSTIC = re.compile(
    r"LaTeX (?:Font )?Warning:|Package .* Warning:|Class .* Warning:|"
    r"(?:LaTeX|Package|Class).* Error:|Missing character|"
    r"Overfull \\hbox|Underfull \\hbox",
    re.IGNORECASE,
)
FATAL = (
    re.compile(r"(?:LaTeX|Package|Class).* Error:", re.IGNORECASE),
    re.compile(r"LaTeX Warning:.*(?:undefined|multiply defined|Rerun|rerun|changed)", re.IGNORECASE),
    re.compile(r"Package .* Warning:.*(?:undefined|Please rerun|rerun LaTeX)", re.IGNORECASE),
    re.compile(r"Missing character", re.IGNORECASE),
    re.compile(r"Overfull \\hbox", re.IGNORECASE),
)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--log", type=Path, required=True)
    parser.add_argument("--warnings-output", type=Path, required=True)
    args = parser.parse_args()

    log = repository_path(args.log)
    output = repository_path(args.warnings_output)
    if not log.is_file():
        parser.error(f"log not found: {log}; run make pdf first")

    lines = log.read_text(encoding="utf-8", errors="replace").splitlines()
    diagnostics = [
        f"{number}: {line}" for number, line in enumerate(lines, 1) if DIAGNOSTIC.search(line)
    ]
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\n".join(diagnostics) + ("\n" if diagnostics else ""), encoding="utf-8")

    failures = [
        f"{number}: {line}"
        for number, line in enumerate(lines, 1)
        if any(pattern.search(line) for pattern in FATAL)
    ]
    if failures:
        print("FAIL: fatal build diagnostics found:", file=sys.stderr)
        for failure in failures:
            print(f"  - {failure}", file=sys.stderr)
        print(f"All diagnostics: {output}", file=sys.stderr)
        return 1

    print(
        f"PASS: no errors, unresolved references/citations, missing glyphs, or "
        f"overfull boxes; {len(diagnostics)} non-fatal diagnostic(s) recorded in {output}."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
