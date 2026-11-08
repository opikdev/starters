# Changelog

All notable changes to this repo are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

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
