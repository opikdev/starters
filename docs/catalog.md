# Catalog format

`catalog.yaml` has two keys: `starters`, the templates and add-ons that pik offers, and `tools`, described [below](#tools). A `starters` entry looks like this:

```yaml
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: v1.0.0
    type: starter
    description: TypeScript API with Hono, Drizzle, Postgres, OpenAPI, and auth
```

| Field | Type | Description |
|---|---|---|
| `name` | string | Folder and repo name, in lowercase kebab-case. Starters are named `<type>-<stack>-starter`, and add-ons anything else, such as `agent-harness`. Must be unique |
| `repo` | string | `https://github.com/<owner>/<name>` |
| `version` | string or null | Released tag as `vX.Y.Z`, or `null` before the first release |
| `type` | string | `starter` for `*-starter` repos, which `pik new` creates projects from. `addon` for the rest |
| `description` | string | One line, 10–120 characters, shown by `pik list` |

A starter must have a [`pik.yaml`](https://github.com/opikdev/pik/blob/main/docs/pik-yaml.md) at the pinned tag, because `pik new` and `scripts/check-starters.sh` read it.

After changing `catalog.yaml`, run `scripts/render-starters.sh --write` to update the starter table in the README. `scripts/check.sh` fails until you do. Record the change in `CHANGELOG.md` too, because CI fails a pull request that changes the catalog without it.

Add an entry once the repo exists, because `scripts/clone-starters.sh` and `scripts/sync-baseline.sh` fail on repos they can't reach. `scripts/validate-catalog.sh` enforces this format.

## Tools

Repos that aren't templates, such as pik, go in a separate `tools` list, with only `name` and `repo`. They get the baseline sync and the clone script, but not `pik list`:

```yaml
tools:
  - name: pik
    repo: https://github.com/opikdev/pik
```

pik ignores `tools`, and skips entry types it doesn't know. pik v0.1 rejects unknown entry types, which is why tools aren't a new `type`.
