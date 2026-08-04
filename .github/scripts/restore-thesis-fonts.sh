#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_dir}/../.." && pwd)"
encrypted_archive="${repository_root}/.github/fonts/thesis-fonts.tar.gz.gpg"
manifest="${repository_root}/.github/fonts/thesis-fonts.sha256"

if [[ -z "${THESIS_FONTS_PASSPHRASE:-}" ]]; then
  echo "THESIS_FONTS_PASSPHRASE is required to restore the licensed thesis fonts." >&2
  exit 1
fi

for required_command in gpg gpgconf tar install awk sort cmp diff mktemp; do
  if ! command -v "${required_command}" >/dev/null 2>&1; then
    echo "Required command not found: ${required_command}" >&2
    exit 1
  fi
done

if [[ ! -s "${encrypted_archive}" ]]; then
  echo "Encrypted font archive not found: ${encrypted_archive}" >&2
  exit 1
fi
if [[ ! -s "${manifest}" ]]; then
  echo "Font checksum manifest not found: ${manifest}" >&2
  exit 1
fi

temporary_root="$(mktemp -d "${TMPDIR:-/tmp}/ntust-fonts.XXXXXX")"
umask 077
export GNUPGHOME="${temporary_root}/gnupg"
install -d -m 0700 "${GNUPGHOME}"

cleanup() {
  gpgconf --kill gpg-agent >/dev/null 2>&1 || true
  rm -rf "${temporary_root}"
}
trap cleanup EXIT

decrypted_archive="${temporary_root}/thesis-fonts.tar.gz"
printf '%s' "${THESIS_FONTS_PASSPHRASE}" | gpg \
  --quiet \
  --batch \
  --yes \
  --pinentry-mode loopback \
  --passphrase-fd 0 \
  --output "${decrypted_archive}" \
  --decrypt "${encrypted_archive}"
unset THESIS_FONTS_PASSPHRASE

tar -tzf "${decrypted_archive}" | LC_ALL=C sort > "${temporary_root}/archive-files.txt"
awk '{print $2}' "${manifest}" | LC_ALL=C sort > "${temporary_root}/expected-files.txt"

if ! cmp -s "${temporary_root}/expected-files.txt" "${temporary_root}/archive-files.txt"; then
  echo "Encrypted font archive contains missing, duplicate, or unexpected paths." >&2
  diff -u "${temporary_root}/expected-files.txt" "${temporary_root}/archive-files.txt" >&2 || true
  exit 1
fi

extract_root="${temporary_root}/extracted"
install -d -m 0700 "${extract_root}"
tar -xzf "${decrypted_archive}" -C "${extract_root}"

while read -r _ font_file; do
  if [[ ! -f "${extract_root}/${font_file}" || -L "${extract_root}/${font_file}" ]]; then
    echo "Font archive entry is not a regular file: ${font_file}" >&2
    exit 1
  fi
done < "${manifest}"

if command -v sha256sum >/dev/null 2>&1; then
  (cd "${extract_root}" && sha256sum --check "${manifest}")
elif command -v shasum >/dev/null 2>&1; then
  (cd "${extract_root}" && shasum -a 256 --check "${manifest}")
else
  echo "Neither sha256sum nor shasum is available." >&2
  exit 1
fi

while read -r _ font_file; do
  install -d -m 0755 "${repository_root}/$(dirname "${font_file}")"
  install -m 0644 "${extract_root}/${font_file}" "${repository_root}/${font_file}"
done < "${manifest}"

echo "Restored and verified five licensed thesis font files."
