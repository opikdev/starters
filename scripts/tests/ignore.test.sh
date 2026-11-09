#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

new_workspace

names=$(yq '(.starters[].name), (.tools // [] | .[].name)' "$root/catalog.yaml")
for name in $names new-addon; do
  git -C "$workspace" check-ignore --quiet "$name/README.md" || fail "$name/ should be ignored"
  pass "ignores $name/"
done

for path in catalog.yaml base/LICENSE base/.github/workflows/secret-scan.yml docs/catalog.md scripts/check.sh \
  scripts/pik/main.go .github/workflows/ci.yml; do
  if git -C "$workspace" check-ignore --quiet "$path"; then
    fail "$path should be tracked"
  fi
  pass "tracks $path"
done

ignored=$(git -C "$root" ls-files --cached --ignored --exclude-standard)
[[ -z $ignored ]] || fail "tracked files match .gitignore: $ignored"
pass 'ignores no tracked file'
