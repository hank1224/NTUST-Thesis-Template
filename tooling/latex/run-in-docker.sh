#!/usr/bin/env bash

set -euo pipefail

repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
lock_file="${repository_root}/tooling/latex/texlive-image.lock"

if [[ ! -f "${lock_file}" ]]; then
  echo "Missing TeX Live image lock: ${lock_file}" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "${lock_file}"

if [[ -z "${THESIS_TEXLIVE_IMAGE:-}" || -z "${THESIS_TEXLIVE_PLATFORM:-}" ]]; then
  echo "The TeX Live image lock is incomplete." >&2
  exit 1
fi

if [[ "${THESIS_TEXLIVE_IMAGE}" != *@sha256:* ]]; then
  echo "The TeX Live image must be pinned by digest: ${THESIS_TEXLIVE_IMAGE}" >&2
  exit 1
fi

required_fonts=(
  thesis/assets/fonts/times/times.ttf
  thesis/assets/fonts/times/timesbd.ttf
  thesis/assets/fonts/times/timesi.ttf
  thesis/assets/fonts/times/timesbi.ttf
  thesis/assets/fonts/cjk/kaiu.ttf
)
missing_fonts=()
for font in "${required_fonts[@]}"; do
  [[ -f "${repository_root}/${font}" ]] || missing_fonts+=("${font}")
done
if (( ${#missing_fonts[@]} > 0 )); then
  echo "Required licensed fonts are missing:" >&2
  printf '  - %s\n' "${missing_fonts[@]}" >&2
  echo "See thesis/assets/fonts/README.md." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. This project does not support host TeX compilation." >&2
  exit 1
fi

cd "${repository_root}"
mkdir -p build/qa/docker build/texmf-var build/docker-home

console_log="build/qa/docker/compile-console.log"
command_log="build/qa/docker/invocation.txt"
environment_log="build/qa/docker/environment.log"
packages_log="build/qa/docker/packages.log"

{
  printf 'image=%s\n' "${THESIS_TEXLIVE_IMAGE}"
  printf 'platform=%s\n' "${THESIS_TEXLIVE_PLATFORM}"
  printf 'release=%s\n' "${THESIS_TEXLIVE_RELEASE:-unknown}"
  printf 'entrypoint=%s\n' "tooling/latex/build-in-container.sh"
} > "${command_log}"

printf 'not generated; container did not start\n' > "${environment_log}"
printf 'not generated; container did not start\n' > "${packages_log}"

set +e
docker run --rm \
  --platform "${THESIS_TEXLIVE_PLATFORM}" \
  --user "$(id -u):$(id -g)" \
  --env HOME=/workspace/build/docker-home \
  --env THESIS_DOCKER_BUILD=1 \
  --env "THESIS_TEXLIVE_IMAGE=${THESIS_TEXLIVE_IMAGE}" \
  --env "THESIS_TEXLIVE_PLATFORM=${THESIS_TEXLIVE_PLATFORM}" \
  --env "THESIS_TEXLIVE_RELEASE=${THESIS_TEXLIVE_RELEASE:-unknown}" \
  --volume "${repository_root}:/workspace" \
  --workdir /workspace \
  "${THESIS_TEXLIVE_IMAGE}" \
  /bin/bash tooling/latex/build-in-container.sh \
  2>&1 | tee "${console_log}"
docker_status=${PIPESTATUS[0]}
set -e

printf 'exit_code=%s\n' "${docker_status}" >> "${command_log}"

if [[ "${docker_status}" -ne 0 ]]; then
  printf 'Docker thesis build failed with exit code %s.\n' "${docker_status}" >&2
  printf 'Container console: %s/%s\n' "${repository_root}" "${console_log}" >&2
  if [[ -f build/thesis.log ]]; then
    printf 'TeX log: %s/build/thesis.log\n' "${repository_root}" >&2
  fi
fi

exit "${docker_status}"
