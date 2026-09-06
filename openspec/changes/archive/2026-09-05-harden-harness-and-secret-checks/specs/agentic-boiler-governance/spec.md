# agentic-boiler-governance Specification

## MODIFIED Requirements

### Requirement: The agent harness has one canonical source

The repository MUST store project commands under `.agent/commands/` and project skills under
`.agent/skills/`. Agent-specific discovery paths MUST resolve to those directories through symlinks or an
equivalent explicitly verified adapter, rather than copied content. An adapter file that cannot be a
symlink because its target agent uses a different frontmatter format (such as OpenCode-native command or
agent files) MUST be verified by the harness check: the check MUST fail when such a file is untracked or
lacks required frontmatter, so no unverified or divergent content can sit in an adapter directory
unnoticed.

#### Scenario: Verify shared harness topology

- **GIVEN** a clean checkout
- **WHEN** a contributor runs the harness check
- **THEN** canonical directories, command front matter, skill front matter, and all documented links pass

#### Scenario: Reject unverified adapter content

- **GIVEN** a non-symlink file is placed under an agent adapter directory such as `.opencode/commands/` or
  `.opencode/agents/`
- **WHEN** the harness check runs
- **THEN** the check fails unless that file is tracked and carries valid frontmatter

### Requirement: Governance checks cannot silently disappear in CI

The CI workflow MUST run the same aggregate governance and Nx quality command documented for local use.
Required validation tools MUST be pinned or their absence MUST fail the check instead of silently skipping
the corresponding gate. A gate that degrades to a fallback when its preferred tool is absent MUST use
matching logic that actually detects the case it claims to on every supported platform, and MUST NOT
depend on provider-specific credential names.

#### Scenario: Run the CI-equivalent check locally

- **WHEN** a contributor runs `npm run check` after `npm ci`
- **THEN** OpenSpec, harness, documentation, secret, formatting, lint, typecheck, test, and build checks
  either run successfully or report an explicit actionable failure

#### Scenario: Fallback secret scan matches a spaced assignment

- **GIVEN** the preferred secret scanner is not installed and the fallback pattern runs
- **WHEN** a staged change adds a credential assignment with whitespace around `=` on a supported platform
- **THEN** the fallback pattern matches it rather than silently passing
