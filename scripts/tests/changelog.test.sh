#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

new_workspace
echo '# Changelog' >"$workspace/CHANGELOG.md"
git -C "$workspace" add CHANGELOG.md
git -C "$workspace" commit --quiet -m changelog
git -C "$workspace" branch base

change() {
  git -C "$workspace" switch --quiet --force-create change base
  for file in "$@"; do
    echo change >>"$workspace/$file"
    git -C "$workspace" add "$file"
  done
  git -C "$workspace" commit --quiet -m change
}

change catalog.yaml
if output=$("$workspace/scripts/check-changelog.sh" base 2>&1); then
  fail 'a catalog change without a changelog entry passed'
fi
[[ $output == *'record the change in CHANGELOG.md'* ]] || fail "got \"$output\""
pass 'fails when catalog.yaml changes without CHANGELOG.md'

change catalog.yaml CHANGELOG.md
"$workspace/scripts/check-changelog.sh" base || fail 'a catalog change with a changelog entry failed'
pass 'passes when CHANGELOG.md changes too'

change scripts/check.sh
"$workspace/scripts/check-changelog.sh" base || fail 'a change outside the catalog failed'
pass 'ignores changes that leave catalog.yaml alone'

change scripts/check.sh
git -C "$workspace" switch --quiet base
echo later >>"$workspace/catalog.yaml"
git -C "$workspace" commit --quiet -am 'catalog change on the base branch'
git -C "$workspace" switch --quiet change
"$workspace/scripts/check-changelog.sh" base || fail 'a catalog change on the base branch was blamed on the branch'
pass 'only counts changes made on the branch'
