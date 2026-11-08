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
  if [[ $type != starter ]]; then
    echo "$name: skipped, because add-ons aren't generated with pik new"
    continue
  fi
  if [[ $version == null ]]; then
    echo "$name: skipped, because it has no release yet"
    continue
  fi

  echo "== $name $version"
  "$pik" new "$name" "$workdir/$name" --catalog "$catalog" --set owner=check --yes

  manifest=$(curl -fsSL "https://raw.githubusercontent.com/${repo#https://github.com/}/$version/pik.yaml")
  checks=$(yq '.check | length' <<<"$manifest")
  for ((j = 0; j < checks; j++)); do
    check=$(yq ".check[$j]" <<<"$manifest")
    echo "-- $check"
    (cd "$workdir/$name" && sh -c "$check")
  done
done
