#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

new_workspace
cat >"$workspace/catalog.yaml" <<'YAML'
starters:
  - name: api-demo-starter
    repo: https://github.com/opikdev/api-demo-starter
    version: null
    type: starter
    description: A demo starter for this test
YAML
printf '# Demo\n\n<!-- starters:start -->\n<!-- starters:end -->\n\n## Next\n' >"$workspace/README.md"

"$workspace/scripts/render-starters.sh" --check 2>/dev/null && fail 'an empty table passed the check'
pass 'fails when the table is out of date'

"$workspace/scripts/render-starters.sh" --write
grep -qF '| [api-demo-starter](https://github.com/opikdev/api-demo-starter) | starter | Unreleased | A demo starter for this test |' "$workspace/README.md" ||
  fail "the table is missing the starter: $(cat "$workspace/README.md")"
grep -q '^## Next$' "$workspace/README.md" || fail 'text after the table was lost'
pass 'writes a linked row for each entry and keeps the rest of the README'

"$workspace/scripts/render-starters.sh" --check || fail 'the check failed right after --write'
pass 'passes after --write'
