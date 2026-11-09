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

Reruns are safe: the script updates an open PR, and it skips starters that are already in sync.

## Set up the sync token

The default workflow token can't reach other repos, so add a token before the catalog lists a starter:

1. Create a fine-grained token scoped to the starter repos, with read and write access to **Contents**, **Pull requests**, and **Workflows**.
2. Save it as the `BASELINE_SYNC_TOKEN` repo secret in `opikdev/starters`.

Until then, the workflow passes only while the catalog is empty.
