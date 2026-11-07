# 004. Enforce common repo standards

- **Status**: accepted
- **Context**: People and agents should find the same files and README structure in every repo. A written standard drifts across dozens of repos unless something enforces it.
- **Decision**: Sync the community files from `base/`, and have a baseline workflow fail when a required file or README section is missing. READMEs need 200–1,500 words, because a short README doesn't explain a starter well enough.
- **Consequences**:
  - Every repo looks the same to a new reader, and `check-repo-standards.sh` keeps it that way.
  - Each repo writes its own README and changelog, because those can't be synced.
  - The README rule checks structure and length, not quality, so reviewers still judge the content.
  - GitHub settings aren't covered, so they stay a manual step.
