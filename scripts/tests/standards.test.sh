#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

repo="$sandbox/repo"
check_standards="$root/base/.github/scripts/check-repo-standards.sh"

filler() {
  local words=$1
  for ((i = 0; i < words; i++)); do printf 'word '; done
  echo
}

write_readme() {
  local words=$1
  {
    echo '# Sample'
    for section in Features 'Quick start' Usage 'Project structure' Contributing Security License; do
      echo "## $section"
    done
    filler "$words"
  } >"$repo/README.md"
}

fresh() {
  cd "$sandbox"
  rm -rf "$repo"
  cp -R "$root/base" "$repo"
  cd "$repo"
  touch .gitignore
  printf '# Changelog\n\n## [Unreleased]\n' >CHANGELOG.md
  write_readme 200
}

expect_pass() {
  local label=$1 mutation=$2
  fresh
  eval "$mutation"
  "$check_standards" >/dev/null || fail "$label: expected pass"
  pass "allows $label"
}

expect_fail() {
  local label=$1 message=$2 mutation=$3 output
  fresh
  eval "$mutation"
  if output=$("$check_standards" 2>&1); then
    fail "$label: expected failure"
  fi
  [[ $output == *"$message"* ]] || fail "$label: got \"$output\""
  pass "catches $label"
}

expect_pass 'a repo with everything' ':'

for file in .editorconfig .gitattributes .github/CODEOWNERS .github/ISSUE_TEMPLATE/bug_report.yml \
  .github/ISSUE_TEMPLATE/feature_request.yml .github/pull_request_template.md .gitignore CHANGELOG.md \
  CODE_OF_CONDUCT.md CONTRIBUTING.md LICENSE README.md SECURITY.md; do
  expect_fail "a missing $file" "$file is missing" "rm $file"
done

for section in Features 'Quick start' Usage 'Project structure' Contributing Security License; do
  expect_fail "a README with no $section section" "no \"## $section\" section" \
    "sed -i.bak '/^## $section\$/d' README.md; rm README.md.bak"
done

expect_fail 'a README with no title' 'must start with a # title' "sed -i.bak '1d' README.md; rm README.md.bak"
expect_fail 'a README that is too short' 'needs at least 200' 'write_readme 100'
expect_pass 'a README of 1,500 words' 'write_readme 1482'
expect_fail 'a README that is too long' 'to reach 1500' 'write_readme 1483'
expect_fail 'a changelog with no sections' 'needs a ## section' 'echo "# Changelog" >CHANGELOG.md'

fresh
rm LICENSE SECURITY.md
output=$("$check_standards" 2>&1) && fail 'expected failure'
[[ $output == *'failed with 2 error(s)'* ]] || fail "got \"$output\""
pass 'reports every error, not just the first'
