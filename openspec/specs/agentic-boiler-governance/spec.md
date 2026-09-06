# agentic-boiler-governance Specification

## Purpose

Define the canonical agent harness layout, bounded tooling access, and restart and adapter rules for repository
agents.

## Requirements

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

### Requirement: Agent tools have bounded MCP access

The repository MUST document MCP configuration paths and the capabilities exposed to agents. The default
configuration MUST be read-only for source inspection and bounded Nx task discovery/execution, MUST NOT
contain credentials, and MUST NOT grant unrestricted arbitrary network or shell authority.

#### Scenario: Configure a supported local agent

- **GIVEN** a contributor selects a supported agent integration
- **WHEN** the documented non-interactive setup command is run
- **THEN** the agent can discover the repository guidance and documented MCP configuration without copying
  commands or skills

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

### Requirement: Roadmap status reflects OpenSpec state

The roadmap MUST link each planned capability to its governing OpenSpec change and MUST distinguish pending,
blocked, and complete work. A capability MUST NOT be marked complete while its governing change has unchecked
tasks or lacks documented verification.

#### Scenario: Detect roadmap drift

- **GIVEN** a roadmap row references an active change with incomplete tasks
- **WHEN** the roadmap freshness check runs
- **THEN** it reports the row as pending or drifted rather than accepting an unqualified complete status

### Requirement: The roadmap command reuses prior context when no parameter is supplied

The canonical `/roadmap` command MUST use the immediately preceding user request as its capability context
when invoked without a parameter. Explicit user arguments MUST override prior conversational context. The
command MUST still inspect repository state and ask one concise question when phase position or dependencies
remain genuinely ambiguous.

#### Scenario: Empty roadmap invocation continues the prior request

- GIVEN the preceding user request describes a concrete repository capability
- WHEN the contributor invokes `/roadmap` without a parameter
- THEN the command uses that request as the capability description
- AND it determines phase position and dependencies from the request and repository evidence when possible

#### Scenario: Explicit roadmap arguments override prior context

- GIVEN the preceding conversation discusses one capability
- WHEN the contributor invokes `/roadmap` with a different explicit capability parameter
- THEN the command uses the explicit parameter
- AND it does not silently substitute the earlier conversation
