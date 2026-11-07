# Repo standards

Every repo in the catalog, and this parent repo, must meet these standards. `.github/scripts/check-repo-standards.sh` enforces the files and the README, and CI runs it on every pull request.

## Required files

| File | Source | Purpose |
|---|---|---|
| `LICENSE` | Baseline | MIT license |
| `SECURITY.md` | Baseline | How to report a vulnerability privately |
| `CONTRIBUTING.md` | Baseline | How to report issues and send changes |
| `CODE_OF_CONDUCT.md` | Baseline | Expected behavior and how to report problems |
| `.editorconfig`, `.gitattributes` | Baseline | Consistent formatting and line endings |
| `.github/CODEOWNERS` | Baseline | Who reviews changes |
| `.github/pull_request_template.md` | Baseline | What each pull request must explain |
| `.github/ISSUE_TEMPLATE/` | Baseline | Bug report and feature request forms |
| `README.md` | Each repo | See below |
| `CHANGELOG.md` | Each repo | Notable changes, with at least one `##` section |
| `.gitignore` | Each repo | Stops build output and secrets from being committed |

Baseline files sync from `base/`. To change one, see [Change the baseline](baseline.md).

## README

A README starts with a `#` title and a sentence saying what the repo is. It has 200–1,500 words, and it has each of these `##` sections, with these exact names:

| Section | What it covers |
|---|---|
| `Features` | What the repo gives you |
| `Quick start` | Prerequisites, then the fewest commands to a working result |
| `Usage` | Common tasks and how to run the checks |
| `Project structure` | The main folders and what lives in each |
| `Contributing` | A link to `CONTRIBUTING.md` |
| `Security` | A link to `SECURITY.md` |
| `License` | The license, with a link to `LICENSE` |

Add other sections where they help, and move long reference material into `docs/`.

## Repo settings

GitHub keeps these outside the repo, so set them by hand when you create one:

- Add a description and topics.
- Turn on **Private vulnerability reporting**, because `SECURITY.md` and `CODE_OF_CONDUCT.md` depend on it.
- Require pull requests and passing checks on `main`.
