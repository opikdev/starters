# Changelog

All notable changes to this repo are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `spa-react-starter` v0.1.0 in the catalog.
- [Independent starters](docs/repo-standards.md#independent-starters): starters depend on documented contracts and URL settings, never on another starter.
- [Starter kinds](docs/add-a-starter.md#starter-kinds), which define the name prefixes such as `site`, `spa`, `fullstack`, and `api`.
- [Add a starter](docs/add-a-starter.md), the full checklist from repo to release, and expectations by type in the repo standards.
- `ai-agent-mastra-starter` v0.1.0 in the catalog.
- `api-fastapi-starter` v0.1.0 in the catalog.
- `mcp-server-python-starter` v0.1.0 in the catalog.
- A `tools` list in `catalog.yaml`, for repos that get the baseline sync but aren't templates.
- A starter table in the README, generated from the catalog and checked in CI.
- `scripts/protect-main.sh`, which requires pull requests and passing checks on `main`.
- CI fails a pull request that changes `catalog.yaml` without a `CHANGELOG.md` entry.

### Changed

- Pinned the hardened API releases: `api-hono-starter` v0.5.0, `api-go-starter` v0.4.0, and `api-fastapi-starter` v0.4.0.
- Pinned `api-hono-starter` v0.4.0, `api-go-starter` v0.3.0, and `api-fastapi-starter` v0.3.0, which add cookie sessions for same-origin browser apps.
- `renovate.json` is no longer a baseline file, so each starter can add its own rules. Starters extend the new `renovate/baseline.json` preset to leave baseline workflows to the sync, and drop it from generated projects, which keep getting Renovate updates.
- `CONTRIBUTING.md` only calls files locked when the repo has a `.baseline.sha256`, so it stays true in generated projects.
- The `Sync baseline` workflow fails with a clear error when `BASELINE_SYNC_TOKEN` is unset, instead of falling back to a token that can't push.
- The `Starters` workflow checks each starter in its own job, with tool versions read from the starter, through the reusable `check-starters.yml` workflow that pik's CI can call too. `scripts/check-starters.sh` takes entry names to check only those.
- `scripts/check-starters.sh` keeps checking the other entries when one fails, and retries the `pik.yaml` download.
- `scripts/sync-baseline.sh` keeps syncing the other repos when one fails, then fails with a list of the failed ones.
- `scripts/check.sh` checks every file in `base/` against the root copy, except a short list of files the parent doesn't use.
- The catalog accepts any lowercase kebab-case add-on name, not just `agent-harness`.
- `.gitignore` ignores every top-level folder except this repo's own, so a new catalog checkout can't be committed by mistake.
- The catalog pins `api-hono-starter` v0.2.3, which keeps `X-Request-Id` on error responses.
- The catalog pins `agent-harness` v0.2.0, which `pik add agent-harness` installs.
- The catalog pins `agent-harness` v0.3.0, whose check also guards its own workflow and hook, and the starter releases with the review fixes: `api-hono-starter` v0.3.0, `mcp-server-ts-starter` v0.3.0, `api-go-starter` v0.2.0, `api-fastapi-starter` v0.2.0, `mcp-server-python-starter` v0.2.0, and `ai-agent-mastra-starter` v0.2.0. The API starters replace `TRUST_PROXY` with `TRUST_PROXY_HOPS`.
- `scripts/check-starters.sh` adds each add-on to an empty Git repo with `pik add`, then runs its checks.
- pik, `create-pik`, and the install script moved to [opikdev/pik](https://github.com/opikdev/pik). `install.sh` here forwards to the new script, and the old Go module path is deprecated.
- The `Starters` workflow checks every starter with the latest pik release.
- `scripts/check-starters.sh` generates each starter under a new folder name, so the check covers pik's renames.
- The catalog pins `api-hono-starter` and `mcp-server-ts-starter` v0.2.2, which format projects after renaming, and `api-go-starter` v0.1.1, which fixes a double rename in its e2e test.

## [0.1.1] - 2026-11-08

### Fixed

- `pik --version` reports the release when installed with `go install`, instead of `dev`.

### Changed

- `create-pik` is published with npm trusted publishing, so releases need no npm token.

## [0.1.0] - 2026-11-08

### Added

- Starter catalog with a validator.
- Shared baseline in `base/`, with a checksum check that stops local edits.
- Scripts to clone starters and sync the baseline.
- Repo standards for required files and README sections, enforced in CI.
- `pik` v0.1 with `new`, `list`, and `doctor`, plus a CI job that generates and checks every released starter.
- Releases of `pik` for macOS, Linux, and Windows, through Homebrew, Scoop, an install script, `go install`, and `npm create pik`, with signed checksums.
- `type` and `description` fields in the catalog.
- `agent-harness` v0.1.0 in the catalog.
- `api-hono-starter` v0.2.0 in the catalog.
- `mcp-server-ts-starter` v0.2.0 in the catalog.

### Fixed

- Secret scan now covers full history, so a repo's first push is scanned too.
