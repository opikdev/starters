# 002. License public repos under MIT

- **Status**: accepted
- **Context**: `base/` syncs a license into every starter, and generated projects inherit it. People need to reuse starter code in their own projects without friction.
- **Decision**: License the parent repo, `pik`, and all public starters under MIT.
- **Consequences**:
  - Generated projects can use any license, as long as they keep the MIT notice.
  - Changing the license means a baseline sync to every starter.
