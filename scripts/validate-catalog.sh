#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
catalog="$root/catalog.yaml"

fail() {
  echo "Invalid catalog: $1" >&2
  exit 1
}

[[ -f $catalog ]] || fail "$catalog not found"
yq '.' "$catalog" >/dev/null
[[ $(yq '.starters | tag' "$catalog") == '!!seq' ]] || fail '"starters" must be a list'

count=$(yq '.starters | length' "$catalog")
for ((i = 0; i < count; i++)); do
  name=$(yq ".starters[$i].name" "$catalog")
  repo=$(yq ".starters[$i].repo" "$catalog")
  version=$(yq ".starters[$i].version" "$catalog")
  type=$(yq ".starters[$i].type" "$catalog")
  description=$(yq ".starters[$i].description" "$catalog")

  if [[ $name != agent-harness && ! $name =~ ^[a-z0-9]+(-[a-z0-9]+)*-starter$ ]]; then
    fail "name \"$name\" must be agent-harness or <type>-<stack>-starter"
  fi
  if [[ ! $repo =~ ^https://github\.com/[A-Za-z0-9-]+/$name$ ]]; then
    fail "$name: repo \"$repo\" must be https://github.com/<owner>/$name"
  fi
  if [[ $version != null && ! $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    fail "$name: version \"$version\" must be vX.Y.Z or null"
  fi
  if [[ $name == *-starter && $type != starter ]] || [[ $name != *-starter && $type != addon ]]; then
    fail "$name: type \"$type\" must be starter for *-starter repos and addon otherwise"
  fi
  if [[ $description == null || ${#description} -lt 10 || ${#description} -gt 120 ]]; then
    fail "$name: description must be 10–120 characters"
  fi
done

duplicate=$(yq '.starters[].name' "$catalog" | sort | uniq -d | head -n 1)
[[ -z $duplicate ]] || fail "duplicate name \"$duplicate\""
