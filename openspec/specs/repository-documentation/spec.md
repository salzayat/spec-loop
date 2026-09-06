# repository-documentation Specification

## Purpose

Define the documentation and agent guidance needed to explain repository intent, authority boundaries, and safe
contribution workflows.

## Requirements

### Requirement: Documentation explains repository intent and authority

The repository documentation MUST explain that the project is a teaching-oriented Nx foundation for
agentic software, MUST describe the boundary between implementation, governance, and specifications, and
MUST identify accepted OpenSpec requirements as the behavioral authority.

#### Scenario: Orient a new engineer

- **WHEN** a new engineer reads the README and linked contributor documentation
- **THEN** they can identify the repository purpose, current example, intended Nx layout, source-of-truth
  boundaries, and standard verification command without inferring them from implementation details

### Requirement: Agent guidance is actionable and bounded

`AGENTS.md` MUST state the implementation workflow, repository safety boundaries, Nx task conventions,
and required verification commands. It MUST NOT grant agents unrestricted credentials, network access, or
authority to treat plans or prose as behavioral requirements. Each shared governance rule — the
source-of-truth hierarchy, the meaning of `npm run check`, the example-safety rule, and generic Nx task
guidance — MUST be stated authoritatively in one place; other repository documents MUST cross-reference
that statement rather than restate it, and `AGENTS.md` MUST NOT duplicate guidance already carried by the
auto-managed `nx configuration` block within the same file.

#### Scenario: Agent starts a repository task

- **WHEN** an agent reads `AGENTS.md` before editing
- **THEN** it knows which specs and active change to read, where implementation belongs, how to run checks,
  and which actions require explicit user authority

#### Scenario: Governance rule appears once

- **GIVEN** the generic Nx task guidance carried by the auto-managed `nx configuration` block in `AGENTS.md`
- **WHEN** a contributor reads the hand-written `Nx Conventions` section of `AGENTS.md`
- **THEN** that section states only repo-specific rules not already carried by the auto-managed block
- **AND** `docs/governance.md` cross-references `AGENTS.md` and `openspec/specs/` for the source-of-truth
  hierarchy and safety boundaries instead of restating them

### Requirement: Repository orientation documents agent-facing structure

The repository MUST provide a linked orientation document that identifies the responsibility and authority
boundary of implementation, Nx configuration, governance, OpenSpec, plans, automation, and agent harness
paths. It MUST identify the current `hello` project and distinguish tracked source from generated or ignored
output.

#### Scenario: Agent locates the right repository area

- GIVEN an agent starts a task in a clean checkout
- WHEN it reads the README and follows the repository orientation link
- THEN it can locate implementation, accepted requirements, active changes, checks, and canonical harness
  content without inferring ownership from generated files

### Requirement: Agent orientation documents bounded MCP use

The orientation MUST identify the project MCP configuration path and document that the default local Nx MCP
server is for repository inspection, Nx graph and target discovery, and bounded Nx task execution. It MUST
state that MCP configuration contains no credentials or remote servers and does not authorize deployment,
publishing, external mutation, arbitrary shell, or unrestricted network operations.

#### Scenario: Contributor configures an agent without expanding authority

- GIVEN a contributor uses the documented project agent configuration
- WHEN the contributor starts an agent in the repository
- THEN the agent can discover repository guidance and the local Nx MCP adapter
- AND the configuration does not add credentials, remote MCP endpoints, or unrestricted authority

### Requirement: Orientation indexes the accepted specifications

The repository orientation document MUST provide a capability index that maps each accepted specification
under `openspec/specs/` to a one-sentence scope and its file path, so an agent can open the single
governing specification for a task instead of scanning the full specification set.

#### Scenario: Agent finds the governing spec without scanning all of them

- **GIVEN** an agent needs the accepted contract for one capability before editing
- **WHEN** it reads the capability index in `docs/repository-orientation.md`
- **THEN** it can identify and open the one relevant `openspec/specs/<capability>/spec.md` from its
  one-sentence scope without reading every specification file
