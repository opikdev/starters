#!/usr/bin/env bash
# Requires pull requests and passing checks on main. Admins can still merge a PR in an emergency.
# Usage: scripts/protect-main.sh <owner/repo> <check> [<check> ...]
set -euo pipefail

repo=${1:?Usage: protect-main.sh <owner/repo> <check> [<check> ...]}
shift
(($# > 0)) || {
  echo 'Name at least one required check, such as check' >&2
  exit 1
}

checks=$(printf '%s\n' "$@" | jq -R '{context: ., integration_id: 15368}' | jq -s .)
body=$(jq -n --argjson checks "$checks" '{
  name: "main",
  target: "branch",
  enforcement: "active",
  conditions: {ref_name: {include: ["~DEFAULT_BRANCH"], exclude: []}},
  bypass_actors: [{actor_id: 5, actor_type: "RepositoryRole", bypass_mode: "pull_request"}],
  rules: [
    {type: "deletion"},
    {type: "non_fast_forward"},
    {type: "pull_request", parameters: {
      required_approving_review_count: 0,
      dismiss_stale_reviews_on_push: false,
      require_code_owner_review: false,
      require_last_push_approval: false,
      required_review_thread_resolution: false
    }},
    {type: "required_status_checks", parameters: {
      strict_required_status_checks_policy: false,
      required_status_checks: $checks
    }}
  ]
}')

id=$(gh api "repos/$repo/rulesets" --jq '.[] | select(.name == "main") | .id')
if [[ -n $id ]]; then
  gh api -X PUT "repos/$repo/rulesets/$id" --input - <<<"$body" >/dev/null
else
  gh api -X POST "repos/$repo/rulesets" --input - <<<"$body" >/dev/null
fi
echo "$repo: main requires pull requests and $*"
