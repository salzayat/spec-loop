# agentic-boiler-governance Specification

## MODIFIED Requirements

### Requirement: Governance checks cannot silently disappear in CI

The CI workflow MUST run the same aggregate governance and Nx quality command documented for local use.
Required validation tools MUST be pinned or their absence MUST fail the check instead of silently skipping
the corresponding gate. A gate that degrades to a fallback when its preferred tool is absent MUST use
matching logic that actually detects the case it claims to on every supported platform, and MUST NOT
depend on provider-specific credential names. When a precondition of the Nx quality targets is missing —
such as unlinked workspace packages — the aggregate check MUST fail with an explicit, actionable message
naming the remedy, rather than surfacing a misleading downstream error from a later target.

#### Scenario: Run the CI-equivalent check locally

- **WHEN** a contributor runs `npm run check` after `npm ci`
- **THEN** OpenSpec, harness, documentation, secret, formatting, lint, typecheck, test, and build checks
  either run successfully or report an explicit actionable failure

#### Scenario: Fallback secret scan matches a spaced assignment

- **GIVEN** the preferred secret scanner is not installed and the fallback pattern runs
- **WHEN** a staged change adds a credential assignment with whitespace around `=` on a supported platform
- **THEN** the fallback pattern matches it rather than silently passing

#### Scenario: Unlinked workspace packages fail with an actionable message

- **GIVEN** the workspace package links under `node_modules/` are absent
- **WHEN** a contributor runs the aggregate check
- **THEN** it fails before the Nx quality targets with a message naming the remedy (such as `npm install`)
- **AND** it does not surface a bare module-resolution error as the first symptom
