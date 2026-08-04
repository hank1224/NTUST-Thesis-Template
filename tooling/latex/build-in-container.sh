#!/usr/bin/env bash

set -euo pipefail

if [[ "${THESIS_DOCKER_BUILD:-}" != "1" ]]; then
  echo "This script may only run through tooling/latex/run-in-docker.sh." >&2
  exit 1
fi

if [[ ! -f /.dockerenv ]]; then
  echo "The thesis TeX build must run inside the pinned Docker container." >&2
  exit 1
fi

mkdir -p build/qa/docker build/texmf-var build/docker-home

packages=(latex luatexja fontspec biblatex tabularray pdfpages)
tlmgr info --only-installed "${packages[@]}" \
  > build/qa/docker/packages.log 2>&1

{
  printf 'image=%s\n' "${THESIS_TEXLIVE_IMAGE:-unknown}"
  printf 'platform=%s\n' "${THESIS_TEXLIVE_PLATFORM:-unknown}"
  printf 'release=%s\n' "${THESIS_TEXLIVE_RELEASE:-unknown}"
  printf 'machine=%s\n' "$(uname -m)"
  printf 'lualatex=%s\n' "$(lualatex --version | sed -n '1p')"
  printf 'latexmk=%s\n' "$(latexmk --version | sed -n '/[^[:space:]]/p' | head -n 1)"
  printf 'biber='
  biber --version
  printf '\npackages=build/qa/docker/packages.log\n'
} > build/qa/docker/environment.log 2>&1

make pdf-in-container
