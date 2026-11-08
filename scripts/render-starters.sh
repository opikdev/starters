#!/usr/bin/env bash
# Prints the README's starter table from catalog.yaml, or rewrites it in place with --write.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
readme="$root/README.md"
start='<!-- starters:start -->'
end='<!-- starters:end -->'

table() {
  echo '| Name | Type | Version | What you get |'
  echo '|---|---|---|---|'
  yq -r '.starters[] | "| [" + .name + "](" + .repo + ") | " + .type + " | " + (.version // "Unreleased") + " | " + .description + " |"' "$root/catalog.yaml"
}

block() {
  echo "$start"
  table
  echo "$end"
}

current() {
  awk -v start="$start" -v end="$end" '$0 == start { inside = 1 } inside { print } $0 == end { inside = 0 }' "$readme"
}

if [[ ${1:-} == --write ]]; then
  {
    sed "/^$start\$/,\$d" "$readme"
    block
    sed "1,/^$end\$/d" "$readme"
  } >"$readme.tmp"
  mv "$readme.tmp" "$readme"
elif [[ ${1:-} == --check ]]; then
  if [[ $(current) != "$(block)" ]]; then
    echo 'README.md starter table is out of date. Run scripts/render-starters.sh --write' >&2
    exit 1
  fi
else
  table
fi
