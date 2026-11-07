# Agent guide

Parent repo for agent-ready starter templates and the `pik` CLI. Starters are separate Git repos checked out here and ignored by this repo.

| Path | Purpose |
|---|---|
| `catalog.yaml` | Every starter, its repo, and its released version. See [docs/catalog.md](docs/catalog.md) |
| `base/` | Files synced into every starter. See [docs/baseline.md](docs/baseline.md) |
| `scripts/` | Clone, sync, and check scripts, with tests in `scripts/tests/` |
| `docs/` | [Architecture](docs/architecture.md) and [decisions](docs/decisions/) |

## Rules

- Run `scripts/check.sh` before calling work done. CI runs the same command.
- Run Git commands from the repo that owns the change. Inside a starter folder, Git acts on that starter.
- Open a starter as its own workspace, because search tools that respect `.gitignore` skip it from here.
- Change baseline files in `base/`, never directly in a starter. CI in the starter fails otherwise.
- Keep each starter runnable. Don't add template placeholders to its source files.
- Record significant decisions as ADRs in `docs/decisions/`.
- Back important rules with a lint rule, hook, or CI check.
- Ask before creating remote repos, pushing, reserving names, or publishing packages.
