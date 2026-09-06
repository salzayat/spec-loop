# Reduce Governance Context Duplication

## Why

The governing facts of this repo — the source-of-truth hierarchy, the contents of `npm run check`, the
"deterministic, local-only, credential-free" example rule, and the Nx task conventions — are restated in
full across four documents that agents load or are told to read every session:

- `AGENTS.md:1` (loads eagerly as `CLAUDE.md` via symlink) carries a hand-written `## Nx Conventions`
  section (`AGENTS.md:88` region) whose generic bullets — use the `nx-workspace` skill, run work through
  `nx` targets, use `nx_docs` instead of guessing flags — are then repeated verbatim by the
  auto-generated `## General Guidelines for working with Nx` block inside the `nx configuration` markers
  (`AGENTS.md:88`–`AGENTS.md:99`). Both blocks load on every agent turn.
- `docs/governance.md:8` ("Sources Of Truth"), `docs/governance.md:21` ("Architecture Boundaries"),
  `docs/governance.md:30` ("Quality And Safety"), and `docs/governance.md:48` ("Documentation Freshness")
  paraphrase the Authority, Repository Design, Safety Boundaries, and Verification sections already in
  `AGENTS.md`.
- `docs/repository-orientation.md` restates the same authority hierarchy a third time in its ownership
  table.

A grep for just three of these phrases (`source of truth`, `npm run check`, `deterministic, local`)
returns 12 hits across `AGENTS.md`, `docs/governance.md`, `docs/repository-orientation.md`, and
`README.md`. The duplication costs tokens on every session and creates drift risk: four copies of one
rule can disagree after a single edit.

The accepted `repository-documentation` spec already requires `AGENTS.md` to state Nx task conventions and
requires `docs/governance.md`/orientation to explain authority — but it does not currently forbid
restating in one document what another already states authoritatively. This change adds that constraint so
the deduplication is enforced and cannot silently regrow.

## What Changes

- Trim the hand-written `## Nx Conventions` section in `AGENTS.md` to the repo-specific rules only —
  "use the `nx-generate` skill before scaffolding" and "preserve explicit `lint`, `typecheck`, `test`,
  `build` targets for every project" — and let the auto-managed `nx configuration` block carry the
  generic guidance it already duplicates. The auto-managed block itself is left untouched (Nx regenerates
  it).
- Reduce `docs/governance.md` to the framing and detail that is unique to it (why governance is kept
  visible and executable, the `check-docs.sh` mechanism), replacing its restated Sources-Of-Truth,
  Boundaries, and Safety prose with a short pointer to `AGENTS.md` and `openspec/specs/` as the authority.
- Add a one-line capability index at the top of `docs/repository-orientation.md` mapping each accepted
  spec under `openspec/specs/` to a one-sentence scope and its file, so an agent loads the single
  governing spec instead of scanning all eight (~20 KB) to find it.
- Add a `repository-documentation` requirement that governance documents state each shared rule
  authoritatively in one place and cross-reference rather than restate it.

## Non-Goals

- No change to the auto-generated `## General Guidelines for working with Nx` block between the
  `nx configuration` markers in `AGENTS.md` — it is tool-managed and regenerates; a reader can confirm it
  is byte-identical before and after.
- No change to any accepted requirement's behavioral meaning: `AGENTS.md` still states Nx task
  conventions, safety boundaries, and verification, so the existing `repository-documentation` scenarios
  still hold.
- No deletion of `docs/governance.md` or `docs/repository-orientation.md` — both remain, with the
  freshness and harness checks still passing.
- No change to `npm run check`, any `scripts/*.sh` gate, or the harness symlink topology.
