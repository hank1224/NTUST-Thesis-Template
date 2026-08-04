#!/usr/bin/env python3
"""Enforce the root entry point and self-contained thesis input boundary."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys

from tooling.project import REPO_ROOT, repository_path


ALLOWED_ROOT_TEX = {"main.tex"}
ALLOWED_INPUT_ROOTS = {"thesis", "build"}


def repository_inputs(fls: Path) -> set[Path]:
    inputs: set[Path] = set()
    for line in fls.read_text(encoding="utf-8", errors="replace").splitlines():
        if not line.startswith("INPUT "):
            continue
        raw = Path(line[6:])
        absolute = raw if raw.is_absolute() else REPO_ROOT / raw
        resolved = absolute.resolve(strict=False)
        try:
            inputs.add(resolved.relative_to(REPO_ROOT))
        except ValueError:
            continue
    return inputs


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fls", type=Path, default=Path("build/thesis.fls"))
    args = parser.parse_args()

    failures: list[str] = []
    root_tex = {path.name for path in REPO_ROOT.glob("*.tex")}
    if root_tex != ALLOWED_ROOT_TEX:
        failures.append(
            f"root TeX files must be exactly {sorted(ALLOWED_ROOT_TEX)}; "
            f"found {sorted(root_tex)}"
        )
    root_classes = sorted(path.name for path in REPO_ROOT.glob("*.cls"))
    if root_classes:
        failures.append(f"root must not contain class files: {root_classes}")

    fls = repository_path(args.fls)
    if not fls.is_file():
        failures.append(f"latexmk recorder file not found: {fls}; run make pdf first")
    else:
        for path in sorted(repository_inputs(fls)):
            if path == Path("main.tex"):
                continue
            if path.parts and path.parts[0] in ALLOWED_INPUT_ROOTS:
                continue
            failures.append(f"compile input crosses the thesis boundary: {path}")

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}", file=sys.stderr)
        return 1
    print("PASS: root entry point and thesis compile-input boundary are valid.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
