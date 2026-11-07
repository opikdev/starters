# Starters

Agent-ready starter templates: projects you can clone, run, and customize with coding agents. This parent repo holds the template catalog, the shared baseline, and the tooling that keeps every starter in line.

Starters live in their own Git repos and are checked out inside this folder.

## Set up

Install [`yq`](https://github.com/mikefarah/yq) v4 and clone the repo, then fetch the starters:

```sh
git clone https://github.com/opikdev/starters
cd starters
scripts/clone-starters.sh
```

The script skips any starter that's already checked out.

## Check your work

Install `actionlint` and `shellcheck`, then run the gate CI runs:

```sh
scripts/check.sh
```

## Learn more

- [Architecture](docs/architecture.md)
- [Catalog format](docs/catalog.md)
- [Change the baseline](docs/baseline.md)
- [Decisions](docs/decisions/)

## License

[MIT](LICENSE)
