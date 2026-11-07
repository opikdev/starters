# Catalog format

`catalog.yaml` has one key, `starters`, a list of entries. An entry looks like this:

```yaml
starters:
  - name: api-hono-starter
    repo: https://github.com/opikdev/api-hono-starter
    version: v1.0.0
```

| Field | Type | Description |
|---|---|---|
| `name` | string | Folder and repo name: `agent-harness` or `<type>-<stack>-starter`, lowercase kebab-case. Must be unique |
| `repo` | string | `https://github.com/<owner>/<name>` |
| `version` | string or null | Released tag as `vX.Y.Z`, or `null` before the first release |

Add an entry once the repo exists, because `scripts/clone-starters.sh` and `scripts/sync-baseline.sh` fail on repos they can't reach. `scripts/validate-catalog.sh` enforces this format.
