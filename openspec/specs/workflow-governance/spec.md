# workflow-governance Specification

## Purpose

Govern the executable parts of the contribution workflow: PR automation must pass body content literally
and dependency updates must be checked for readiness before merge, so contributors and agents get the same
guardrails whether they run `scripts/pr.sh` by hand or through an agent command.

## Requirements

### Requirement: PR automation preserves literal body content

The PR automation MUST support reading a pull-request body from an explicit file path and MUST pass its
contents literally, including Markdown backticks and OpenSpec change names. Inline body input and file body
input MUST be mutually exclusive. A missing or unreadable body file MUST fail before commit or push.
Implementation work destined for a pull request MUST happen on a feature branch created before that work
begins, not only before PR automation runs. A local commit attempted while the repository's default branch
is checked out MUST fail with a message naming the remedy, rather than succeeding silently.

#### Scenario: Markdown body survives PR automation

- GIVEN a body file contains backticks, shell-looking text, and an OpenSpec change name
- WHEN the contributor runs the PR helper with that body file
- THEN the created pull request receives the exact file contents
- AND the helper does not execute or expand the body contents

#### Scenario: Direct commit to the default branch fails closed

- GIVEN the repository's default branch is checked out
- WHEN a contributor or agent runs `git commit` with the repository's hooks installed
- THEN the commit is rejected with a message naming the feature-branch remedy
- AND no commit is created

#### Scenario: PR automation on an existing feature branch is unaffected

- GIVEN a feature branch was already created before implementation began
- WHEN the contributor runs the PR helper with `--reuse-branch`
- THEN it continues on that branch, stages, checks, commits, and pushes as before

### Requirement: Dependency declarations are executable

Repository checks MUST validate that every active OpenSpec change declares `## Dependencies` with either
`None` or exact existing change names. A dependency MUST be considered ready only when its governing change is
archived and its required tasks and verification evidence are complete. The check MUST NOT crash when the
`openspec/changes/` directory or its `archive/` subdirectory does not yet exist; it MUST treat either
absent directory as containing no entries and report its normal pass or fail result rather than an
unhandled error.

#### Scenario: Unknown dependency fails closed

- GIVEN an active OpenSpec change names a nonexistent dependency
- WHEN the repository dependency check runs
- THEN it reports the exact missing dependency and fails

#### Scenario: Missing archive directory does not crash the check

- GIVEN a fresh checkout where `openspec/changes/archive/` does not exist yet (a fork right after
  clearing inherited history, or a new project generated from this template)
- WHEN the dependency check runs
- THEN it completes with its normal pass or fail result
- AND it does not raise an unhandled error naming an internal file path

### Requirement: Roadmap order reflects dependency readiness

Roadmap checks MUST reject a dependent change listed before an unready predecessor and MUST require `Blocked`
status when a named predecessor is not ready. A milestone MAY be `Pending` or `In progress` only when its
predecessors are ready; `Complete` remains reserved for archived changes with recorded verification.

#### Scenario: Unready predecessor blocks later work

- GIVEN roadmap change B depends on unarchived change A
- AND B appears after A but is marked `Pending`
- WHEN the roadmap dependency check runs
- THEN it reports B as blocked or drifted
- AND it does not accept B as dependency-ready
