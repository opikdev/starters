#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

new_workspace

for path in agent-harness/README.md api-hono-starter/package.json mcp-server-ts-starter/src/index.ts; do
  git -C "$workspace" check-ignore --quiet "$path" || fail "$path should be ignored"
  pass "ignores $path"
done

for path in catalog.yaml base/LICENSE scripts/check.sh agent-harness-notes/README.md packages/cli/api-hono-starter/main.go; do
  if git -C "$workspace" check-ignore --quiet "$path"; then
    fail "$path should be tracked"
  fi
  pass "tracks $path"
done
