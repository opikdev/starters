#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
catalog="$root/catalog.yaml"
base="$root/base"
manifest=.baseline.sha256
branch=chore/sync-baseline

"$root/scripts/validate-catalog.sh"

source_sha=$(git -C "$root" rev-parse --short HEAD)
subject="chore(baseline): sync from starters@$source_sha"
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

apply_baseline() {
  local checkout=$1

  if [[ -f $checkout/$manifest ]]; then
    sed -E 's/^[0-9a-f]+  //' "$checkout/$manifest" | (cd "$checkout" && xargs rm -f)
  fi

  git -C "$base" ls-files | while IFS= read -r path; do
    mkdir -p "$(dirname "$checkout/$path")"
    cp "$base/$path" "$checkout/$path"
  done

  (cd "$base" && git ls-files -z | xargs -0 shasum -a 256) >"$checkout/$manifest"
}

sync_starter() {
  local name=$1 repo=$2
  local checkout="$workdir/$name"

  git clone --quiet "$repo" "$checkout"
  apply_baseline "$checkout"
  git -C "$checkout" add -A

  if git -C "$checkout" diff --cached --quiet; then
    echo "$name: up to date"
    return
  fi

  git -C "$checkout" switch --quiet -c "$branch"
  git -C "$checkout" commit --quiet -m "$subject"
  git -C "$checkout" push --quiet --force-with-lease origin "$branch"

  open_prs=$(gh pr list --repo "$repo" --head "$branch" --state open --json number --jq length)
  if [[ $open_prs == 0 ]]; then
    gh pr create --repo "$repo" --head "$branch" --title "$subject" \
      --body "Syncs baseline-managed files from \`base/\` in opikdev/starters."
    echo "$name: opened PR"
  else
    echo "$name: updated open PR"
  fi
}

failed=''
while read -r name repo; do
  # One failing repo must not stop the rest, and calling the function from a condition would turn off set -e inside it.
  set +e
  (set -e; sync_starter "$name" "$repo") </dev/null
  status=$?
  set -e
  if ((status != 0)); then
    echo "$name: sync failed" >&2
    failed+=" $name"
  fi
done < <(yq -r '(.starters[], (.tools // [])[]) | .name + " " + .repo' "$catalog")

if [[ -n $failed ]]; then
  echo "Sync failed for:$failed" >&2
  exit 1
fi
