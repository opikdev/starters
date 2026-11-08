#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL="$sandbox/gitconfig"
export GIT_TERMINAL_PROMPT=0
git config --global user.name test
git config --global user.email test@example.com
git config --global init.defaultBranch main
git config --global url."file://$sandbox/remotes/".insteadOf https://github.com/

workspace="$sandbox/workspace"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

pass() {
  echo "ok - $1"
}

new_workspace() {
  mkdir -p "$workspace"
  cp -R "$root/scripts" "$root/base" "$root/.gitignore" "$workspace/"
  echo 'starters: []' >"$workspace/catalog.yaml"
  git -C "$workspace" init --quiet
  git -C "$workspace" add -A
  git -C "$workspace" commit --quiet -m fixture
}

new_remote() {
  local name=$1
  local remote="$sandbox/remotes/opikdev/$name"
  local seed="$sandbox/seed-$name"

  git init --quiet --bare "$remote"
  git clone --quiet "$remote" "$seed" 2>/dev/null
  echo "$name" >"$seed/README.md"
  git -C "$seed" add README.md
  git -C "$seed" commit --quiet -m seed
  git -C "$seed" push --quiet origin main
}

write_catalog() {
  echo 'starters:' >"$workspace/catalog.yaml"
  for name in "$@"; do
    {
      echo "  - name: $name"
      echo "    repo: https://github.com/opikdev/$name"
      echo '    version: null'
      if [[ $name == *-starter ]]; then echo '    type: starter'; else echo '    type: addon'; fi
      echo '    description: A test entry for the catalog'
    } >>"$workspace/catalog.yaml"
  done
}
