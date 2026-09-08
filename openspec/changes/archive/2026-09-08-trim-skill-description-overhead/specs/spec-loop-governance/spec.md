# spec-loop-governance Specification

## MODIFIED Requirements

### Requirement: The agent harness has one canonical source

The repository MUST store project commands under `.agent/commands/` and project skills under
`.agent/skills/`. Agent-specific discovery paths MUST resolve to those directories through symlinks or an
equivalent explicitly verified adapter, rather than copied content. An adapter file that cannot be a
symlink because its target agent uses a different frontmatter format (such as OpenCode-native command or
agent files) MUST be verified by the harness check: the check MUST fail when such a file is untracked or
lacks required frontmatter, so no unverified or divergent content can sit in an adapter directory
unnoticed. A skill's `description:` frontmatter field, which loads into every agent session regardless of
whether the skill is invoked, MUST state only trigger conditions and scope; it MUST NOT restate rationale
or elaboration that the skill's body already carries.

#### Scenario: Verify shared harness topology

- **GIVEN** a clean checkout
- **WHEN** a contributor runs the harness check
- **THEN** canonical directories, command front matter, skill front matter, and all documented links pass

#### Scenario: Reject unverified adapter content

- **GIVEN** a non-symlink file is placed under an agent adapter directory such as `.opencode/commands/` or
  `.opencode/agents/`
- **WHEN** the harness check runs
- **THEN** the check fails unless that file is tracked and carries valid frontmatter

#### Scenario: Skill description carries scope, not rationale

- **GIVEN** a skill's `description:` field contains a sentence explaining why the skill behaves as it does
- **WHEN** that same explanation already appears in the skill's body
- **THEN** removing the sentence from the description does not reduce which distinct requests trigger the
  skill
- **AND** the description retains every trigger phrase and scope statement needed to distinguish it from
  other skills
