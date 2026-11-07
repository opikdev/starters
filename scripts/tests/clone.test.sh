#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

new_workspace
new_remote agent-harness
new_remote api-hono-starter

[[ -z $("$workspace/scripts/clone-starters.sh") ]] || fail 'empty catalog should print nothing'
pass 'does nothing for an empty catalog'

mkdir "$workspace/api-hono-starter"
echo local >"$workspace/api-hono-starter/work.txt"
write_catalog agent-harness api-hono-starter

output=$("$workspace/scripts/clone-starters.sh")
[[ $output == *'agent-harness: cloned'* ]] || fail "got \"$output\""
[[ $(cat "$workspace/agent-harness/README.md") == agent-harness ]] || fail 'agent-harness not cloned'
[[ -d $workspace/agent-harness/.git ]] || fail 'agent-harness is not its own repo'
pass 'clones a missing starter'

[[ $output == *'api-hono-starter: already present, skipped'* ]] || fail "got \"$output\""
[[ $(cat "$workspace/api-hono-starter/work.txt") == local ]] || fail 'existing checkout was changed'
[[ ! -e $workspace/api-hono-starter/README.md ]] || fail 'existing checkout was overwritten'
pass 'leaves an existing checkout alone'

[[ -z $(git -C "$workspace" status --porcelain -- agent-harness api-hono-starter) ]] || fail 'checkouts leak into the parent'
pass 'keeps checkouts out of the parent repo'

write_catalog agent-harness missing-starter
if "$workspace/scripts/clone-starters.sh" 2>/dev/null; then
  fail 'unreachable repo: expected failure'
fi
pass 'fails on an unreachable repo'

echo 'starters: nope' >"$workspace/catalog.yaml"
if "$workspace/scripts/clone-starters.sh" 2>/dev/null; then
  fail 'invalid catalog: expected failure'
fi
pass 'refuses an invalid catalog'
