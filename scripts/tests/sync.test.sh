#!/usr/bin/env bash
# shellcheck source=scripts/tests/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

branch=chore/sync-baseline
remote="$sandbox/remotes/opikdev/api-hono-starter"
inspect="$sandbox/inspect"

mkdir "$sandbox/bin"
cat >"$sandbox/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$*" >>"$GH_LOG"
case "$1 $2" in
  'pr list') if [[ -f $GH_OPEN_PR ]]; then echo 1; else echo 0; fi ;;
  'pr create') touch "$GH_OPEN_PR" ;;
esac
STUB
chmod +x "$sandbox/bin/gh"
export PATH="$sandbox/bin:$PATH"
export GH_LOG="$sandbox/gh.log"
export GH_OPEN_PR="$sandbox/open-pr"
touch "$GH_LOG"

pr_count() {
  grep -c '^pr create' "$GH_LOG" || true
}

fetch_branch() {
  rm -rf "$inspect"
  git clone --quiet --branch "$branch" "$remote" "$inspect"
}

merge_branch() {
  git -C "$remote" update-ref refs/heads/main "refs/heads/$branch"
  rm -f "$GH_OPEN_PR"
}

new_workspace
new_remote api-hono-starter
write_catalog api-hono-starter
git -C "$workspace" add catalog.yaml
git -C "$workspace" commit --quiet -m catalog

output=$("$workspace/scripts/sync-baseline.sh")
[[ $output == *'api-hono-starter: opened PR'* ]] || fail "got \"$output\""
[[ $(pr_count) == 1 ]] || fail 'expected one PR'
grep -q "^pr create --repo https://github.com/opikdev/api-hono-starter --head $branch --title chore(baseline): sync from starters@" "$GH_LOG" || fail "bad PR call: $(cat "$GH_LOG")"
pass 'opens a PR for a starter behind the baseline'

fetch_branch
cmp "$root/base/LICENSE" "$inspect/LICENSE" || fail 'LICENSE not synced'
cmp "$root/base/.github/workflows/baseline-check.yml" "$inspect/.github/workflows/baseline-check.yml" || fail 'nested file not synced'
[[ $(cat "$inspect/README.md") == api-hono-starter ]] || fail 'starter-owned file changed'
pass 'copies baseline files and keeps starter files'

(cd "$inspect" && shasum --status -a 256 -c .baseline.sha256) || fail 'fresh sync should pass the baseline check'
pass 'writes a manifest that passes the baseline check'

echo edited >>"$inspect/SECURITY.md"
if (cd "$inspect" && shasum --status -a 256 -c .baseline.sha256 2>/dev/null); then
  fail 'edited baseline file should fail the baseline check'
fi
pass 'baseline check catches an edited file'

rm "$inspect/SECURITY.md"
if (cd "$inspect" && shasum --status -a 256 -c .baseline.sha256 2>/dev/null); then
  fail 'deleted baseline file should fail the baseline check'
fi
pass 'baseline check catches a deleted file'

[[ -z $(git -C "$remote" log main --format=%s -- LICENSE) ]] || fail 'main was pushed directly'
pass 'never pushes to the default branch'

output=$("$workspace/scripts/sync-baseline.sh")
[[ $output == *'api-hono-starter: updated open PR'* ]] || fail "got \"$output\""
[[ $(pr_count) == 1 ]] || fail 'expected no second PR'
pass 'updates an open PR instead of opening another'

merge_branch
output=$("$workspace/scripts/sync-baseline.sh")
[[ $output == *'api-hono-starter: up to date'* ]] || fail "got \"$output\""
[[ $(pr_count) == 1 ]] || fail 'expected no PR when up to date'
pass 'skips a starter already in sync'

git -C "$workspace" rm --quiet base/SECURITY.md
echo '# new' >"$workspace/base/NEW.md"
git -C "$workspace" add base/NEW.md
git -C "$workspace" commit --quiet -m 'change baseline'
"$workspace/scripts/sync-baseline.sh" >/dev/null
[[ $(pr_count) == 2 ]] || fail 'expected a PR for the baseline change'
fetch_branch
[[ ! -e $inspect/SECURITY.md ]] || fail 'removed baseline file was kept'
[[ -f $inspect/NEW.md ]] || fail 'new baseline file was not added'
(cd "$inspect" && shasum --status -a 256 -c .baseline.sha256) || fail 'manifest out of date'
pass 'propagates added and removed baseline files'

touch "$workspace/base/untracked.txt"
merge_branch
"$workspace/scripts/sync-baseline.sh" >/dev/null
[[ $(pr_count) == 2 ]] || fail 'untracked file should not be synced'
pass 'ignores files not tracked in base'

write_catalog missing-starter
if "$workspace/scripts/sync-baseline.sh" 2>/dev/null; then
  fail 'unreachable repo: expected failure'
fi
pass 'fails on an unreachable repo'
