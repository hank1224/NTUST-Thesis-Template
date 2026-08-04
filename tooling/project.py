"""Shared repository paths for tooling modules."""

from __future__ import annotations

from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]


def repository_path(path: Path) -> Path:
    """Return an absolute path, resolving relative values from the repository root."""
    return path if path.is_absolute() else REPO_ROOT / path
