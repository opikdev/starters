#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

mkdir "$sandbox/bin"
cat >"$sandbox/bin/pik" <<'STUB'
#!/usr/bin/env bash
[[ $2 != broken-starter ]] || exit 1
mkdir -p "$3"
STUB
cat >"$sandbox/bin/curl" <<'STUB'
#!/usr/bin/env bash
case "${*: -1}" in
  */failing-starter/*) printf 'check:\n  - "false"\n' ;;
  *) printf 'check:\n  - basename "$PWD" >>"$CHECK_LOG"\n' ;;
esac
STUB
chmod +x "$sandbox/bin/pik" "$sandbox/bin/curl"
export PATH="$sandbox/bin:$PATH"
export CHECK_LOG="$sandbox/checks.log"

new_workspace
cat >"$workspace/catalog.yaml" <<'YAML'
starters:
  - name: some-addon
    repo: https://github.com/opikdev/some-addon
    version: v1.0.0
    type: addon
    description: A test entry for the catalog
  - name: broken-starter
    repo: https://github.com/opikdev/broken-starter
    version: v1.0.0
    type: starter
    description: A test entry for the catalog
  - name: failing-starter
    repo: https://github.com/opikdev/failing-starter
    version: v1.0.0
    type: starter
    description: A test entry for the catalog
  - name: unreleased-starter
    repo: https://github.com/opikdev/unreleased-starter
    version: null
    type: starter
    description: A test entry for the catalog
  - name: good-starter
    repo: https://github.com/opikdev/good-starter
    version: v1.0.0
    type: starter
    description: A test entry for the catalog
YAML

check_starters() {
  rm -f "$CHECK_LOG"
  touch "$CHECK_LOG"
  "$workspace/scripts/check-starters.sh" "$sandbox/bin/pik" >"$sandbox/stdout" 2>"$sandbox/stderr"
}

check_starters && fail 'failing entries passed'
[[ $(<"$sandbox/stderr") == *'Checks failed for: broken-starter failing-starter'* ]] ||
  fail "got \"$(<"$sandbox/stderr")\""
pass 'fails and names every entry that failed to generate or check'

[[ $(<"$CHECK_LOG") == $'with-some-addon\nrenamed-good-starter' ]] || fail "checks ran in: $(<"$CHECK_LOG")"
pass 'runs the checks of the entries after a failed one'

[[ $(<"$sandbox/stdout") == *'unreleased-starter: skipped'* ]] || fail "got \"$(<"$sandbox/stdout")\""
pass 'skips an unreleased entry'
