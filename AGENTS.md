# Agent guide

Parent repo for agent-ready starter templates and the `pik` CLI. Starters are separate Git repos checked out here and ignored by this repo.

| Path | Purpose |
|---|---|
| `catalog.yaml` | Every starter, its repo, and its released version. See [docs/catalog.md](docs/catalog.md) |
| `base/` | Files synced into every starter. See [docs/baseline.md](docs/baseline.md) |
| `scripts/` | Clone, sync, and check scripts, with tests in `scripts/tests/` |
| `packages/cli/` | `pik`, the Go CLI. See [its README](packages/cli/README.md) |
| `packages/create-pik/` | The npm wrapper behind `npm create pik` |
| `docs/` | [Architecture](docs/architecture.md), [repo standards](docs/repo-standards.md), [pik.yaml](docs/pik-yaml.md), and [decisions](docs/decisions/) |

## Rules

- Run `scripts/check.sh` before calling work done. CI runs the same command.
- After editing `catalog.yaml`, run `scripts/render-starters.sh --write` to update the README's starter table.
- For changes in `packages/cli/`, also run `gofmt -l .`, `golangci-lint run`, and `go test -race ./...` there.
- For changes in `packages/create-pik/`, also run `npm test` there.
- To release `pik`, follow [docs/releasing.md](docs/releasing.md). Never tag without the user's go-ahead, because a tag publishes to npm, Homebrew, and Scoop.
- Run Git commands from the repo that owns the change. Inside a starter folder, Git acts on that starter.
- Open a starter as its own workspace, because search tools that respect `.gitignore` skip it from here.
- Change baseline files in `base/`, never directly in a starter. CI in the starter fails otherwise.
- Every repo must meet the [repo standards](docs/repo-standards.md). CI fails otherwise.
- Keep each starter runnable. Don't add template placeholders to its source files.
- Record significant decisions as ADRs in `docs/decisions/`.
- Back important rules with a lint rule, hook, or CI check.
- Ask before creating remote repos, pushing, reserving names, or publishing packages.
