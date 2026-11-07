#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

for tool in actionlint git shasum shellcheck yq; do
  command -v "$tool" >/dev/null || {
    echo "Missing required tool: $tool" >&2
    exit 1
  }
done

shellcheck -x scripts/*.sh scripts/tests/*.sh
actionlint .github/workflows/*.yml base/.github/workflows/*.yml
scripts/validate-catalog.sh

for test in scripts/tests/*.test.sh; do
  echo "== $test"
  "$test"
done
echo "All checks passed"
