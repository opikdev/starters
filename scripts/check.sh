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

shellcheck -x install.sh scripts/*.sh scripts/tests/*.sh base/.github/scripts/*.sh
actionlint .github/workflows/*.yml base/.github/workflows/*.yml
scripts/validate-catalog.sh
yq -p json -e '.packageRules' renovate/baseline.json >/dev/null
scripts/render-starters.sh --check
base/.github/scripts/check-repo-standards.sh

# The parent runs these checks from this script and CI instead.
not_mirrored=(.github/scripts/check-repo-standards.sh .github/workflows/baseline-check.yml .github/workflows/repo-standards.yml)
for file in $(git ls-files base | sed 's|^base/||' | grep -vxF -f <(printf '%s\n' "${not_mirrored[@]}")); do
  cmp "$file" "base/$file" || {
    echo "$file must match base/$file" >&2
    exit 1
  }
done

for test in scripts/tests/*.test.sh; do
  echo "== $test"
  "$test"
done
echo "All checks passed"
