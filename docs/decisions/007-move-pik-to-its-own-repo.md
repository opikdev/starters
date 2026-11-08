# 007. Move pik to its own repo

- **Status**: accepted
- **Context**: pik shared this repo with the catalog and baseline. Its Go module path was `github.com/opikdev/starters/packages/cli`, `go install` needed extra `packages/cli/vX` tags, and this repo's `v` tags meant pik versions. Its issues and releases were mixed in with catalog work.
- **Decision**: Move pik, `create-pik`, and the install script to `opikdev/pik`, with their history. Keep the catalog and baseline here, and list pik under `tools` in `catalog.yaml`, so it gets the baseline sync without appearing in `pik list`.
- **Consequences**:
  - `go install github.com/opikdev/pik/cmd/pik@latest` works with plain tags, and pik has its own issues and releases.
  - The catalog and pik must stay compatible across repos, so both CI pipelines generate every starter, and new catalog fields must be optional.
  - Releases up to v0.1.1 stay on this repo's releases page. The old module path is deprecated, and `install.sh` here forwards to the new script.
  - pik v0.1 rejects unknown entry types, so non-template repos are listed under `tools` rather than as a new `type`.
