# Repository Governance

## Purpose

This repository is a reusable starting point and a worked lesson in engineering discipline. Governance is
kept visible and executable so a future project can copy the structure without copying hidden assumptions.

## Sources Of Truth And Boundaries

The source-of-truth hierarchy, architecture boundaries, safety rules, and the meaning of `npm run check`
are stated authoritatively in [`AGENTS.md`](../AGENTS.md) and the accepted contracts under
`openspec/specs/`. This page does not restate them; consult those when the layers disagree, and update the
governing contract first rather than resolving behavioral ambiguity in an implementation. The
[repository orientation](repository-orientation.md) maps each area to its owning authority and indexes the
accepted specifications.

## Change And Review Standard

Every behavior or workflow change needs a governing OpenSpec change or a documented rationale appropriate
to a documentation-only edit. Reviewers should ask whether the code, design, tasks, docs, and verification
agree. Pull requests must identify exact commands, skipped checks, and generated-output impact.

## Documentation Freshness

`./scripts/check-docs.sh` compares staged files locally or the `CHECK_DIFF_RANGE` in CI. Changes to code,
scripts, hooks, CI, dependencies, Nx configuration, project layout, or commands should update the relevant
README, docs, agent guidance, or OpenSpec in the same change.
