#!/usr/bin/env bash

set -uo pipefail

repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${repository_root}"

printf 'Docker invocation: build/qa/docker/invocation.txt\n'
if [[ -f build/qa/docker/invocation.txt ]]; then
  sed -n '1,80p' build/qa/docker/invocation.txt
else
  printf '  not generated\n'
fi

printf '\nDocker environment: build/qa/docker/environment.log\n'
if [[ -f build/qa/docker/environment.log ]]; then
  cat build/qa/docker/environment.log
else
  printf '  not generated\n'
fi

printf '\nQA warning report: build/qa/log-warnings.txt\n'
if [[ -f build/qa/log-warnings.txt ]]; then
  cat build/qa/log-warnings.txt
else
  printf '  not generated; run make check-log\n'
fi

printf '\nTeX diagnostics: build/thesis.log\n'
if [[ -f build/thesis.log ]]; then
  if command -v rg >/dev/null 2>&1; then
    rg -n -i \
      '(^!|(^|[[:space:]])(LaTeX|Package [^ ]+|Class [^ ]+) (Error|Warning):|undefined (citations?|references?)|Undefined control sequence|multiply defined|Missing character|Overfull \\hbox|Infinite glue shrinkage)' \
      build/thesis.log || true
  else
    grep -Eni \
      '(^!|(^|[[:space:]])(LaTeX|Package [^ ]+|Class [^ ]+) (Error|Warning):|undefined (citations?|references?)|Undefined control sequence|multiply defined|Missing character|Overfull \\hbox|Infinite glue shrinkage)' \
      build/thesis.log || true
  fi
else
  printf '  not generated\n'
fi

printf '\nContainer console tail: build/qa/docker/compile-console.log\n'
if [[ -f build/qa/docker/compile-console.log ]]; then
  tail -n 120 build/qa/docker/compile-console.log
else
  printf '  not generated\n'
fi
