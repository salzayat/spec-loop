# Tasks

## 1. Trim duplicated Nx guidance in AGENTS.md

- [x] 1.1 In `AGENTS.md`, reduce the hand-written `## Nx Conventions` section to only the two
      repo-specific bullets (use `nx-generate` before scaffolding; preserve explicit `lint`, `typecheck`,
      `test`, `build` targets), removing the generic bullets already carried by the auto-managed
      `nx configuration` block.
- [x] 1.2 Confirm the auto-managed block between `<!-- nx configuration start-->` and
      `<!-- nx configuration end-->` is unchanged (byte-identical) after the edit.

## 2. Deduplicate docs/governance.md

- [x] 2.1 Replace the restated "Sources Of Truth", "Architecture Boundaries", and "Quality And Safety"
      prose with a short pointer to `AGENTS.md` and `openspec/specs/` as authority.
- [x] 2.2 Keep the unique purpose framing and the `check-docs.sh` documentation-freshness detail intact.

## 3. Add the capability index to orientation

- [x] 3.1 Add a one-line-per-capability index at the top of `docs/repository-orientation.md` mapping each
      `openspec/specs/<capability>/spec.md` to a one-sentence scope, so agents open one spec instead of
      scanning all eight.

## 4. Update the contract

- [x] 4.1 Apply the `repository-documentation` delta: modify "Agent guidance is actionable and bounded" to
      require each shared governance rule be stated authoritatively once and cross-referenced, not
      restated.

## 5. Verification

- [x] 5.1 Run `openspec validate reduce-governance-context-duplication` and resolve any errors.
- [x] 5.2 Run `npm run check` and record the result in the PR (strict OpenSpec validation, harness
      topology, doc freshness, formatting, lint, types, tests, builds).
- [x] 5.3 Run `git diff -- AGENTS.md` and confirm only the hand-written `## Nx Conventions` bullets
      changed and the `nx configuration` block is untouched.
- [x] 5.4 Reread the finished draft against the code for the three OpenSpec failure modes (untrue
      invariant, non-existent verification mechanism, new required field on an immutable artifact) and
      confirm none apply.
