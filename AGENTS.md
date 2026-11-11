# Agent guide

Parent repo for agent-ready starter templates: the catalog, the shared baseline, and the scripts that keep every repo consistent. Starters, and [pik](https://github.com/opikdev/pik), the CLI, are separate Git repos checked out here and ignored by this repo.

| Path | Purpose |
|---|---|
| `catalog.yaml` | Every starter, its repo, and its released version, plus tool repos such as pik. See [docs/catalog.md](docs/catalog.md) |
| `base/` | Files synced into every starter. See [docs/baseline.md](docs/baseline.md) |
| `scripts/` | Clone, sync, and check scripts, with tests in `scripts/tests/` |
| `renovate/` | Renovate preset that starters extend. See [docs/baseline.md](docs/baseline.md) |
| `docs/` | [Architecture](docs/architecture.md), [repo standards](docs/repo-standards.md), [adding a starter](docs/add-a-starter.md), and [decisions](docs/decisions/) |

## Rules

- Run `scripts/check.sh` before calling work done. CI runs the same command.
- After editing `catalog.yaml`, run `scripts/render-starters.sh --write` to update the README's starter table, and record the change in `CHANGELOG.md`. CI fails otherwise.
- Change `pik` in its own checkout, `pik/`, following its `AGENTS.md`. The `pik.yaml` format is documented there, in `docs/pik-yaml.md`.
- Never tag a repo without the user's go-ahead, because tags publish images and packages.
- Run Git commands from the repo that owns the change. Inside a starter folder, Git acts on that starter.
- Open a starter as its own workspace, because search tools that respect `.gitignore` skip it from here.
- `.gitignore` ignores every top-level folder except the ones it lists. Add a new folder of this repo there.
- Change baseline files in `base/`, never directly in a starter. CI in the starter fails otherwise.
- Every repo must meet the [repo standards](docs/repo-standards.md). CI fails otherwise.
- Keep starters independent: one never needs another to build or pass its checks. See [Independent starters](docs/repo-standards.md#independent-starters).
- Keep each starter runnable. Don't add template placeholders to its source files.
- Record significant decisions as ADRs in `docs/decisions/`.
- Back important rules with a lint rule, hook, or CI check.
- Ask before creating remote repos, pushing, reserving names, or publishing packages.
