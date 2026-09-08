# workflow-governance Specification

## MODIFIED Requirements

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
