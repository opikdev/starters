#!/usr/bin/env bash
# Fails when the changes since <base-ref> edit catalog.yaml but not CHANGELOG.md.
# Usage: scripts/check-changelog.sh <base-ref>
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
base=${1:?Usage: check-changelog.sh <base-ref>}

changed=$(git -C "$root" diff --name-only "$base...HEAD" --)
if grep -qx catalog.yaml <<<"$changed" && ! grep -qx CHANGELOG.md <<<"$changed"; then
  echo "catalog.yaml changed since $base, so record the change in CHANGELOG.md" >&2
  exit 1
fi
