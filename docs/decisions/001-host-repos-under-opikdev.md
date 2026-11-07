# 001. Host repos under the opikdev account

- **Status**: accepted
- **Context**: The catalog, clone script, and sync script need a stable GitHub owner. The account must exist today so that starters can be built and released.
- **Decision**: Host the parent repo and all starters under `opikdev`.
- **Consequences**:
  - Work can start without creating an organization.
  - `gitleaks-action` needs no license key on a personal account. Moving to an organization adds that requirement.
  - Moving later means updating every `repo` URL in `catalog.yaml`.
