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

shellcheck -x scripts/*.sh scripts/tests/*.sh base/.github/scripts/*.sh
actionlint .github/workflows/*.yml base/.github/workflows/*.yml
scripts/validate-catalog.sh
base/.github/scripts/check-repo-standards.sh

for file in .editorconfig .gitattributes .github/CODEOWNERS .github/ISSUE_TEMPLATE/bug_report.yml \
  .github/ISSUE_TEMPLATE/config.yml .github/ISSUE_TEMPLATE/feature_request.yml \
  .github/pull_request_template.md CODE_OF_CONDUCT.md CONTRIBUTING.md LICENSE SECURITY.md; do
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
