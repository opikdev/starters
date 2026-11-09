# Change the baseline

`base/` holds the files every starter shares. Each starter also gets `.baseline.sha256`, a checksum list of those files. Its `Baseline check` workflow fails if a listed file changes outside a sync.

## Update a baseline file

1. Edit the file in `base/`, never in a starter. This repo keeps copies of most baseline files at its root, and `scripts/check.sh` fails until they match. A baseline file this repo shouldn't copy goes in `not_mirrored` in that script.
2. Merge to `main`. The `Sync baseline` workflow runs `scripts/sync-baseline.sh`.
3. Review and merge the `chore/sync-baseline` PR in each starter.

To run a sync by hand, commit your change first, because only tracked files are synced. You need write access to the starter repos and a logged-in `gh`:

```sh
scripts/sync-baseline.sh
```

Reruns are safe: the script updates an open PR, and it skips starters that are already in sync. When one repo fails, the script still syncs the rest, then exits with an error that names the failed ones.

## Remove a baseline file

Delete it from `base/`, and the sync deletes it from each starter. To hand the file over to the starters instead, push each starter's own version to its `chore/sync-baseline` branch before you merge the sync PR. The new `.baseline.sha256` no longer lists the file, so the baseline check passes.

## Keep Renovate off baseline workflows

Renovate in this repo updates the workflows in `base/`, and the sync carries them to the starters. So each starter's own `renovate.json` extends the `github>opikdev/starters//renovate/baseline` preset, from [`renovate/baseline.json`](../renovate/baseline.json), which turns Renovate off for those workflows. A generated project gets no syncs, so the starter's `pik.yaml` drops the preset from it.

## Set up the sync token

The default workflow token can't reach other repos, so the `Sync baseline` workflow fails until this token is set:

1. Create a fine-grained token scoped to the starter repos, with read and write access to **Contents**, **Pull requests**, and **Workflows**.
2. Save it as the `BASELINE_SYNC_TOKEN` repo secret in `opikdev/starters`.
3. When you add a repo to the catalog, add it to the token's repository list too.
