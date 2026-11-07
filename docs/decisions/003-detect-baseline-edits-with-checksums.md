# 003. Detect baseline edits with checksums

- **Status**: accepted
- **Context**: Baseline-managed files must not be edited by accident in a starter. Marker comments don't fit every format, such as `LICENSE` and JSON, and nothing enforces them.
- **Decision**: The sync writes `.baseline.sha256` into each starter, and a workflow from `base/` fails when `shasum -c` fails against it.
- **Consequences**:
  - Every file type is covered, and the check needs nothing beyond `shasum`.
  - Someone can bypass the check by editing the manifest as well. It stops mistakes, not deliberate changes, and the next sync restores both.
  - Renovate must skip baseline workflows in starters, so `base/` action versions are updated from the parent repo.
