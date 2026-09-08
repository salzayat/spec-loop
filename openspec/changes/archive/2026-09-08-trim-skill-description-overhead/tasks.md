# Tasks

## 1. Trim `openspec-change`

- [x] 1.1 Remove the trailing rationale sentence from `.agent/skills/openspec-change/SKILL.md`'s
      `description:` field; keep every trigger phrase and the scaffolded-file list.
- [x] 1.2 Confirm the removed sentence's content is still present in the skill body's "Step 1" section
      (nothing is lost, only de-duplicated).

## 2. Trim `nx-workspace`

- [x] 2.1 Reduce the `EXAMPLES:` list in `.agent/skills/nx-workspace/SKILL.md`'s `description:` from six
      quoted utterances to three, keeping one general-question example and two diagnostic/debug examples
      so both `USE WHEN` clauses stay represented.

## 3. Tighten `link-workspace-packages`

- [x] 3.1 Reword the closing "DO NOT patch around..." sentence in
      `.agent/skills/link-workspace-packages/SKILL.md`'s `description:` for brevity, preserving the
      warning's content and all three numbered `USE WHEN` triggers.

## 4. Update the contract

- [x] 4.1 Apply the `spec-loop-governance` delta: skill `description:` fields MUST state trigger
      conditions and scope only, not rationale already carried by the skill body.

## 5. Verification

- [x] 5.1 Run `./scripts/check-harness.sh` and confirm all three edited skills still pass frontmatter
      validation.
- [x] 5.2 Diff each trimmed description against its pre-edit version and confirm every literal trigger
      phrase quoted in the original is still present verbatim in the trimmed version (for `nx-workspace`,
      confirm the three kept examples map to distinct `USE WHEN` categories).
- [x] 5.3 Run `openspec validate trim-skill-description-overhead` and resolve any errors.
- [x] 5.4 Run `npm run check` and record the result in the PR.
