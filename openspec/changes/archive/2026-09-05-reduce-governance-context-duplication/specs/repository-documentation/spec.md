# Repository Documentation

## MODIFIED Requirements

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

## ADDED Requirements

### Requirement: Orientation indexes the accepted specifications

The repository orientation document MUST provide a capability index that maps each accepted specification
under `openspec/specs/` to a one-sentence scope and its file path, so an agent can open the single
governing specification for a task instead of scanning the full specification set.

#### Scenario: Agent finds the governing spec without scanning all of them

- **GIVEN** an agent needs the accepted contract for one capability before editing
- **WHEN** it reads the capability index in `docs/repository-orientation.md`
- **THEN** it can identify and open the one relevant `openspec/specs/<capability>/spec.md` from its
  one-sentence scope without reading every specification file
