# repository-planning Specification

## MODIFIED Requirements

### Requirement: OpenSpec changes declare dependencies and readiness

An OpenSpec change that depends on another change MUST include a `## Dependencies` section in its proposal or
design. Each dependency MUST name the governing change and state the concrete readiness condition. A change
with no dependency MUST state `None` so that absence is intentional and reviewable. Per-capability progress
toward resuming or continuing a change MUST be derivable from existing OpenSpec state (task completion and
the change's declared capability) rather than recorded as separate prose that requires its own freshness
check.

#### Scenario: Reviewer can determine whether a change may start

- GIVEN a contributor reviews an OpenSpec proposal
- WHEN the contributor reads its Dependencies section
- THEN the contributor can identify predecessor changes and their readiness conditions
- AND cannot infer readiness solely from roadmap prose

#### Scenario: Agent resumes a capability without full session context

- GIVEN an active OpenSpec change touches a capability under `openspec/specs/`
- WHEN an agent runs the repository's spec status command instead of reading prior session context
- THEN it reports the active change and its task completion for that capability without requiring a
  hand-maintained progress document
