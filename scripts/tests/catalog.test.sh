#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

new_workspace

expect_valid() {
  local label=$1
  cat >"$workspace/catalog.yaml"
  "$workspace/scripts/validate-catalog.sh" || fail "$label: expected valid"
  pass "accepts $label"
}

expect_invalid() {
  local label=$1 message=$2 output
  cat >"$workspace/catalog.yaml"
  if output=$("$workspace/scripts/validate-catalog.sh" 2>&1); then
    fail "$label: expected invalid"
  fi
  [[ $output == *"$message"* ]] || fail "$label: got \"$output\""
  pass "rejects $label"
}

expect_valid 'an empty list' <<'YAML'
starters: []
YAML

expect_valid 'released and unreleased starters' <<'YAML'
starters:
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: v1.2.3
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: null
YAML

expect_invalid 'a missing list' 'must be a list' <<'YAML'
other: []
YAML

expect_invalid 'a name without the suffix' 'must be agent-harness' <<'YAML'
starters:
  - name: api-hono
    repo: https://github.com/opikdev/api-hono
    version: null
YAML

expect_invalid 'a name with a path' 'must be agent-harness' <<'YAML'
starters:
  - name: ../evil-starter
    repo: https://github.com/opikdev/evil-starter
    version: null
YAML

expect_invalid 'a repo that mismatches the name' 'must be https://github.com' <<'YAML'
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/other-starter
    version: null
YAML

expect_invalid 'a missing repo' 'must be https://github.com' <<'YAML'
starters:
  - name: api-hono-starter
    version: null
YAML

expect_invalid 'an unpinned version' 'must be vX.Y.Z or null' <<'YAML'
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: main
YAML

expect_invalid 'a duplicate name' 'duplicate name "agent-harness"' <<'YAML'
starters:
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: null
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: v1.0.0
YAML

expect_invalid 'malformed YAML' 'Error' <<'YAML'
starters: [
YAML

rm "$workspace/catalog.yaml"
if output=$("$workspace/scripts/validate-catalog.sh" 2>&1); then
  fail 'missing file: expected invalid'
fi
[[ $output == *'not found'* ]] || fail "missing file: got \"$output\""
pass 'rejects a missing file'
