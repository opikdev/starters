#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
catalog="$root/catalog.yaml"
pik=${1:?Usage: check-starters.sh <path-to-pik>}
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

"$root/scripts/validate-catalog.sh"

count=$(yq '.starters | length' "$catalog")
for ((i = 0; i < count; i++)); do
  name=$(yq ".starters[$i].name" "$catalog")
  type=$(yq ".starters[$i].type" "$catalog")
  version=$(yq ".starters[$i].version" "$catalog")
  repo=$(yq ".starters[$i].repo" "$catalog")
  if [[ $version == null ]]; then
    echo "$name: skipped, because it has no release yet"
    continue
  fi

  echo "== $name $version"
  if [[ $type == addon ]]; then
    # An add-on goes into an existing repo, so add it to an empty one.
    project="$workdir/with-$name"
    mkdir "$project"
    git -C "$project" init --quiet
    "$pik" add "$name" "$project" --catalog "$catalog" --yes
  else
    # A different folder name makes pik rename the project, so the check covers every replacement.
    project="$workdir/renamed-$name"
    "$pik" new "$name" "$project" --catalog "$catalog" --set owner=check --yes
  fi

  manifest=$(curl -fsSL "https://raw.githubusercontent.com/${repo#https://github.com/}/$version/pik.yaml")
  checks=$(yq '.check | length' <<<"$manifest")
  for ((j = 0; j < checks; j++)); do
    check=$(yq ".check[$j]" <<<"$manifest")
    echo "-- $check"
    (cd "$project" && sh -c "$check")
  done
done
