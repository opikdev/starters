# Starters

Agent-ready starter templates you can clone, run, and customize with coding agents. This parent repo holds the catalog, the shared baseline, and the tooling that keeps every starter consistent.

[![CI](https://github.com/opikdev/starters/actions/workflows/ci.yml/badge.svg)](https://github.com/opikdev/starters/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Each starter lives in its own Git repo with its own CI and releases. Checkouts sit inside this folder and are ignored by this repo.

## Features

- **Template catalog:** `catalog.yaml` lists every starter, its repo, and its released version.
- **Shared baseline:** `base/` holds the license, community files, and workflows that every starter shares.
- **Enforced standards:** CI fails when a starter edits a baseline file by hand, or drops a required file or README section.
- **Sync by pull request:** a change to `base/` opens a PR in each starter, so you can review it there.

## Quick start

You need Git, Bash, and [`yq`](https://github.com/mikefarah/yq) v4.

```sh
git clone https://github.com/opikdev/starters
cd starters
scripts/clone-starters.sh
```

The script skips any starter that's already checked out.

## Usage

Run the same checks as CI. They also need `actionlint` and `shellcheck`:

```sh
scripts/check.sh
```

Other common tasks:

- To add a starter, see the [catalog format](docs/catalog.md).
- To change a shared file, follow [Change the baseline](docs/baseline.md).
- To see what every repo must include, read the [repo standards](docs/repo-standards.md).
- To understand how the pieces fit, read the [architecture](docs/architecture.md) and [decisions](docs/decisions/).

## Project structure

| Path | Purpose |
|---|---|
| `catalog.yaml` | Every starter, its repo, and its released version |
| `base/` | Files synced into every starter |
| `scripts/` | Clone, sync, and check scripts, with their tests |
| `docs/` | Architecture, reference pages, and decisions |

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request, and follow the [code of conduct](CODE_OF_CONDUCT.md).

## Security

Report vulnerabilities privately, as described in [SECURITY.md](SECURITY.md).

## License

Released under the [MIT License](LICENSE).
