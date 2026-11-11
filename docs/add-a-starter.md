# Add a starter

Follow these steps in order. Steps that create or publish something on GitHub need the owner's go-ahead.

## Starter kinds

The kind tells users what they get and whether it runs a server. The README's first sentence says the same in plain words, such as "A single-page app (SPA): React renders in the browser and calls your API."

| Kind | What it is | Runs a server | Rendering |
|---|---|---|---|
| `site` | A website of content pages: marketing, blog, docs | No | Built ahead of time (SSG) |
| `spa` | A browser app that calls a separate API | No | In the browser (CSR) |
| `fullstack` | UI and server in one app | Yes | On the server (SSR), then hydrated in the browser |
| `api` | A backend API with no UI | Yes | None |
| `saas` | A `fullstack` app with auth, billing, and emails | Yes | SSR |
| `cms` | A `site` or `fullstack` app with a content editor | Depends | SSG or SSR |
| `admin` | An internal dashboard, built as an SPA | No | CSR |

Other kinds name the product, such as `mcp-server`, `ai-agent`, `mobile`, `cli`, or `monorepo`. Rendering terms follow [Rendering on the Web](https://web.dev/articles/rendering-on-the-web).

## Build the repo

1. Pick a name: `<kind>-<stack>-starter`, such as `api-hono-starter`, with a kind from [Starter kinds](#starter-kinds). Add-ons and tools use any lowercase kebab-case name.
2. Build it in a folder of that name inside this checkout, where `.gitignore` already ignores it. Run `git init` there, because it's its own repo.
3. Meet the [repo standards](repo-standards.md), including the expectations for its type.
4. Add the agent harness, then fill in its `AGENTS.md` and `docs/architecture.md`:

   ```sh
   pik add agent-harness .
   ```

5. Add `pik.yaml`. Copy one from a starter on the same stack, and keep these parts:
   - `prompts` for `name` and an optional `owner`.
   - `replace` rules for the `opikdev/<name>` clone lines in `README.md`, `@opikdev` in `.github/CODEOWNERS`, and the bare name in each file that has it. Never let two rules touch the same text.
   - `exclude` for `.baseline.sha256` and `.github/workflows/baseline-check.yml`.
   - `setup` that installs dependencies and formats, because renaming changes line lengths.
   - `check` with the commands that prove a generated project works, such as `make verify` and `make e2e`.

   The [pik.yaml reference](https://github.com/opikdev/pik/blob/main/docs/pik-yaml.md) lists every field.

6. Add a `renovate.json` that extends the baseline preset, and a `replace` rule that drops the preset from generated projects:

   ```json
   {
     "$schema": "https://docs.renovatebot.com/renovate-schema.json",
     "extends": ["config:recommended", "github>opikdev/starters//renovate/baseline"]
   }
   ```

   ```yaml
   replace:
     - from: '"extends": ["config:recommended", "github>opikdev/starters//renovate/baseline"]'
       to: '"extends": ["config:recommended"]'
       files: [renovate.json]
   ```

## Publish the repo

1. Create the public repo `opikdev/<name>` and push `main`.
2. Add a description and topics, turn on private vulnerability reporting, and mark it as a template repo, so GitHub shows **Use this template**:

   ```sh
   gh api -X PUT repos/opikdev/<name>/private-vulnerability-reporting
   gh api -X PATCH repos/opikdev/<name> -F is_template=true
   ```

   A repo made from the template is an exact copy: it keeps the starter's name and `opikdev` owner, and skips the setup that `pik new` runs.

3. Add the repo to the `BASELINE_SYNC_TOKEN` token's repository list, as in [Set up the sync token](baseline.md#set-up-the-sync-token).

## Add it to the catalog

1. Add an entry with `version: null` to `catalog.yaml`, as described in the [catalog format](catalog.md).
2. Update the README table, and add a line to `CHANGELOG.md`:

   ```sh
   scripts/render-starters.sh --write
   scripts/check.sh
   ```

3. Open a pull request here, and merge it.
4. Run the `Sync baseline` workflow, because only a change to `base/` starts it. Then merge the `chore/sync-baseline` PR in the new repo.

   ```sh
   gh workflow run sync-baseline.yml --repo opikdev/starters
   ```

5. Require pull requests on `main`. Name every check that runs on each pull request, including `harness`, `baseline`, `standards`, and `gitleaks` from the baseline:

   ```sh
   scripts/protect-main.sh opikdev/<name> check e2e harness baseline standards gitleaks codeql dependencies
   ```

## Release it

1. Tag `v0.1.0` in the new repo, once the owner agrees, because the tag publishes images and packages.
2. Pin the tag in `catalog.yaml`, and add a line to `CHANGELOG.md`.
3. Run the rename check, which generates the starter under a different folder name and runs its `check` commands. The `Starters` workflow runs it on the pull request too.

   ```sh
   scripts/check-starters.sh "$(command -v pik)" <name>
   ```

4. Open a pull request here, and merge it once the `Starters` workflow passes.
