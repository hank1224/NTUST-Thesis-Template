#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_dir}/../.." && pwd)"
passphrase_file="${1:-${repository_root}/.github/fonts/thesis-fonts.passphrase.local}"
encrypted_archive="${repository_root}/.github/fonts/thesis-fonts.tar.gz.gpg"
manifest="${repository_root}/.github/fonts/thesis-fonts.sha256"

font_files=(
  "thesis/assets/fonts/times/times.ttf"
  "thesis/assets/fonts/times/timesbd.ttf"
  "thesis/assets/fonts/times/timesi.ttf"
  "thesis/assets/fonts/times/timesbi.ttf"
  "thesis/assets/fonts/cjk/kaiu.ttf"
)

if [[ ! -s "${passphrase_file}" ]]; then
  echo "Passphrase file not found or empty: ${passphrase_file}" >&2
  exit 1
fi

for required_command in gpg gpgconf tar install mktemp; do
  if ! command -v "${required_command}" >/dev/null 2>&1; then
    echo "Required command not found: ${required_command}" >&2
    exit 1
  fi
done

for font_file in "${font_files[@]}"; do
  if [[ ! -s "${repository_root}/${font_file}" ]]; then
    echo "Licensed font file not found or empty: ${font_file}" >&2
    exit 1
  fi
done

temporary_root="$(mktemp -d "${TMPDIR:-/tmp}/ntust-font-package.XXXXXX")"
umask 077
export GNUPGHOME="${temporary_root}/gnupg"
install -d -m 0700 "${GNUPGHOME}"

cleanup() {
  gpgconf --kill gpg-agent >/dev/null 2>&1 || true
  rm -rf "${temporary_root}"
}
trap cleanup EXIT

: > "${temporary_root}/thesis-fonts.sha256"
for font_file in "${font_files[@]}"; do
  if command -v sha256sum >/dev/null 2>&1; then
    (cd "${repository_root}" && sha256sum "${font_file}") >> "${temporary_root}/thesis-fonts.sha256"
  elif command -v shasum >/dev/null 2>&1; then
    (cd "${repository_root}" && shasum -a 256 "${font_file}") >> "${temporary_root}/thesis-fonts.sha256"
  else
    echo "Neither sha256sum nor shasum is available." >&2
    exit 1
  fi
done

# Prevent macOS copyfile metadata and AppleDouble `._*` entries from entering
# the portable archive consumed by Linux CI.
(cd "${repository_root}" && COPYFILE_DISABLE=1 tar -czf "${temporary_root}/thesis-fonts.tar.gz" "${font_files[@]}")
gpg \
  --quiet \
  --batch \
  --yes \
  --pinentry-mode loopback \
  --passphrase-file "${passphrase_file}" \
  --symmetric \
  --cipher-algo AES256 \
  --output "${temporary_root}/thesis-fonts.tar.gz.gpg" \
  "${temporary_root}/thesis-fonts.tar.gz"

install -m 0644 "${temporary_root}/thesis-fonts.sha256" "${manifest}"
install -m 0644 "${temporary_root}/thesis-fonts.tar.gz.gpg" "${encrypted_archive}"

echo "Updated encrypted font archive and SHA-256 manifest."
