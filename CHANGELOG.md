# Changelog

All notable changes to this repo are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Starter catalog with a validator.
- Shared baseline in `base/`, with a checksum check that stops local edits.
- Scripts to clone starters and sync the baseline.
- Repo standards for required files and README sections, enforced in CI.
- `agent-harness` v0.1.0 in the catalog.
- `api-hono-starter` v0.1.1 in the catalog.

### Fixed

- Secret scan now covers full history, so a repo's first push is scanned too.
