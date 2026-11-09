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
    type: addon
    description: A test entry for the catalog
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: null
    type: starter
    description: A test entry for the catalog
YAML

expect_invalid 'a missing list' 'must be a list' <<'YAML'
other: []
YAML

expect_valid 'a second add-on' <<'YAML'
starters:
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: null
    type: addon
    description: A test entry for the catalog
  - name: ci-kit
    repo: https://github.com/opikdev/ci-kit
    version: null
    type: addon
    description: A test entry for the catalog
YAML

expect_invalid 'a starter type without the suffix' 'type "starter" must be starter for *-starter repos' <<'YAML'
starters:
  - name: api-hono
    repo: https://github.com/opikdev/api-hono
    version: null
    type: starter
    description: A test entry for the catalog
YAML

expect_invalid 'an uppercase name' 'must be lowercase kebab-case' <<'YAML'
starters:
  - name: Ci-Kit
    repo: https://github.com/opikdev/Ci-Kit
    version: null
    type: addon
    description: A test entry for the catalog
YAML

expect_invalid 'a name with a path' 'must be lowercase kebab-case' <<'YAML'
starters:
  - name: ../evil-starter
    repo: https://github.com/opikdev/evil-starter
    version: null
    type: starter
    description: A test entry for the catalog
YAML

expect_invalid 'a repo that mismatches the name' 'must be https://github.com' <<'YAML'
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/other-starter
    version: null
    type: starter
    description: A test entry for the catalog
YAML

expect_invalid 'a missing repo' 'must be https://github.com' <<'YAML'
starters:
  - name: api-hono-starter
    version: null
    type: starter
    description: A test entry for the catalog
YAML

expect_invalid 'an unpinned version' 'must be vX.Y.Z or null' <<'YAML'
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: main
    type: starter
    description: A test entry for the catalog
YAML

expect_invalid 'a wrong type' 'type "addon" must be starter' <<'YAML'
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: null
    type: addon
    description: A test entry for the catalog
YAML

expect_invalid 'a missing description' 'description must be 10–120 characters' <<'YAML'
starters:
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: null
    type: addon
YAML

expect_invalid 'a duplicate name' 'duplicate name "agent-harness"' <<'YAML'
starters:
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: null
    type: addon
    description: A test entry for the catalog
  - name: agent-harness
    repo: https://github.com/opikdev/agent-harness
    version: v1.0.0
    type: addon
    description: A test entry for the catalog
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

expect_valid 'a tool list' <<'YAML'
starters: []
tools:
  - name: pik
    repo: https://github.com/opikdev/pik
YAML

expect_invalid 'a tool whose repo name differs' 'must be https://github.com/<owner>/pik' <<'YAML'
starters: []
tools:
  - name: pik
    repo: https://github.com/opikdev/other
YAML

expect_invalid 'a tool named like a starter' 'duplicate name "api-x-starter"' <<'YAML'
starters:
  - name: api-x-starter
    repo: https://github.com/opikdev/api-x-starter
    version: null
    type: starter
    description: A starter used in this test
tools:
  - name: api-x-starter
    repo: https://github.com/opikdev/api-x-starter
YAML
