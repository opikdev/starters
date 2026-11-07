#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
catalog="$root/catalog.yaml"

"$root/scripts/validate-catalog.sh"

count=$(yq '.starters | length' "$catalog")
for ((i = 0; i < count; i++)); do
  name=$(yq ".starters[$i].name" "$catalog")
  repo=$(yq ".starters[$i].repo" "$catalog")

  if [[ -e $root/$name ]]; then
    echo "$name: already present, skipped"
    continue
  fi
  git clone --quiet "$repo" "$root/$name"
  echo "$name: cloned"
done
