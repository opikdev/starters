# Starters

Agent-ready starter templates you can clone, run, and customize with coding agents. This parent repo holds the catalog, the shared baseline, and the tooling that keeps every starter consistent.

[![CI](https://github.com/opikdev/starters/actions/workflows/ci.yml/badge.svg)](https://github.com/opikdev/starters/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Starters

Each is a separate repo with its own CI and releases. Create a project from a starter with `pik new <name>`, or clone any repo directly.

<!-- starters:start -->
| Name | Type | Version | What you get |
|---|---|---|---|
| [agent-harness](https://github.com/opikdev/agent-harness) | addon | v0.1.0 | Project map, agent skills, and enforced checks for any repo |
| [api-hono-starter](https://github.com/opikdev/api-hono-starter) | starter | v0.2.1 | TypeScript API with Hono, Drizzle, Postgres, OpenAPI, and auth |
| [mcp-server-ts-starter](https://github.com/opikdev/mcp-server-ts-starter) | starter | v0.2.1 | MCP server in TypeScript with stdio, HTTP, OAuth, and tool tests |
| [api-go-starter](https://github.com/opikdev/api-go-starter) | starter | v0.1.0 | Go API with net/http, contract-first OpenAPI, sqlc, Postgres, and auth |
<!-- starters:end -->

Add-ons go into an existing repo, as each one's README describes. `pik list` always shows the latest catalog, and `pik list --json` gives agents and scripts the same list as JSON.

## Features

- **Template catalog:** `catalog.yaml` lists every starter, its repo, and its released version.
- **Shared baseline:** `base/` holds the license, community files, and workflows that every starter shares.
- **Enforced standards:** CI fails when a starter edits a baseline file by hand, or drops a required file or README section.
- **Sync by pull request:** a change to `base/` opens a PR in each starter, so you can review it there.
- **`pik` CLI:** `pik new` creates a project from a pinned starter release. See [packages/cli](packages/cli/README.md).
- **Every starter is proven:** CI generates each released starter with `pik` and runs its checks.

## Quick start

To create a project from a starter, install `pik`:

```sh
brew install opikdev/tap/pik
pik new api-hono-starter my-api
```

Or run it without installing, with `npm create pik@latest`. [packages/cli](packages/cli/README.md) lists every install method.

To work on the starters themselves, you need Git, Bash, and [`yq`](https://github.com/mikefarah/yq) v4.

```sh
git clone https://github.com/opikdev/starters
cd starters
scripts/clone-starters.sh
```

Each starter is checked out inside this folder and ignored by this repo. The script skips any that are already there.

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
- To ship a new version of `pik`, follow [Release pik](docs/releasing.md).

## Project structure

| Path | Purpose |
|---|---|
| `catalog.yaml` | Every starter, its repo, and its released version |
| `base/` | Files synced into every starter |
| `scripts/` | Clone, sync, and check scripts, with their tests |
| `packages/cli/` | `pik`, written in Go |
| `packages/create-pik/` | The npm package behind `npm create pik` |
| `install.sh` | The install script for macOS and Linux |
| `docs/` | Architecture, reference pages, and decisions |

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request, and follow the [code of conduct](CODE_OF_CONDUCT.md).

## Security

Report vulnerabilities privately, as described in [SECURITY.md](SECURITY.md).

## License

Released under the [MIT License](LICENSE).
