#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
catalog="$root/catalog.yaml"

"$root/scripts/validate-catalog.sh"

yq -r '(.starters[], (.tools // [])[]) | .name + " " + .repo' "$catalog" | while read -r name repo; do
  if [[ -e $root/$name ]]; then
    echo "$name: already present, skipped"
    continue
  fi
  git clone --quiet "$repo" "$root/$name"
  echo "$name: cloned"
done
