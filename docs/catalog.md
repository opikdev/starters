# Catalog format

`catalog.yaml` has one key, `starters`, a list of entries. An entry looks like this:

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
| `name` | string | Folder and repo name: `agent-harness` or `<type>-<stack>-starter`, lowercase kebab-case. Must be unique |
| `repo` | string | `https://github.com/<owner>/<name>` |
| `version` | string or null | Released tag as `vX.Y.Z`, or `null` before the first release |
| `type` | string | `starter` for `*-starter` repos, which `pik new` creates projects from. `addon` for the rest |
| `description` | string | One line, 10–120 characters, shown by `pik list` |

A starter must have a [`pik.yaml`](pik-yaml.md) at the pinned tag, because `pik new` and `scripts/check-starters.sh` read it.

Add an entry once the repo exists, because `scripts/clone-starters.sh` and `scripts/sync-baseline.sh` fail on repos they can't reach. `scripts/validate-catalog.sh` enforces this format.
