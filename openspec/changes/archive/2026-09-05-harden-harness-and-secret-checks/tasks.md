# Tasks

## 1. Verify OpenCode-native adapters in the harness check

- [x] 1.1 In `scripts/check-harness.sh`, after the existing symlink loop, add a loop over
      `.opencode/commands/*.md` and `.opencode/agents/*.md` that fails when a file is untracked or lacks
      frontmatter (`description:`, `name:`, or `argument-hint:`).
- [x] 1.2 Confirm the check still passes on the current tree (both existing adapter files are tracked and
      carry frontmatter).

## 2. Fix the fallback secret-scan pattern

- [x] 2.1 In `scripts/check-secrets.sh`, replace `\s*=\s*` with `[[:space:]]*=[[:space:]]*` in both the
      `diff_range` and staged branches.
- [x] 2.2 Remove `DATABENTO_API_KEY` from the alternation, keeping `API_KEY|SECRET|TOKEN|PASSWORD`.

## 3. Remove provider-specific scope residue

- [x] 3.1 Replace the `databento` commit-scope example with a neutral one (`hello`, `greeter`, or
      `packages`) in `scripts/pr.sh`, `.agent/commands/pr.md`, and
      `.agent/skills/pull-request-automation/SKILL.md`.

## 4. Update the contract

- [x] 4.1 Apply the `agentic-boiler-governance` delta: the harness-source requirement names adapter-file
      verification, and the silent-check requirement names portable, provider-neutral secret matching.

## 5. Verification

- [x] 5.1 Reproduce the secret-scan fix in a scratch git repo: a planted `API_KEY = "EXAMPLE-not-a-real-key"`
      (with spaces) is matched by the new `[[:space:]]*` pattern and was not matched by the old `\s*`
      pattern. Record both results in the PR.
- [x] 5.2 Run `./scripts/check-harness.sh` and confirm it passes with the new adapter verification.
- [x] 5.3 Run `openspec validate harden-harness-and-secret-checks` and resolve any errors.
- [x] 5.4 Run `npm run check` and record the result in the PR.
- [x] 5.5 Confirm `.opencode/commands/monitor-ci.md` and `.opencode/agents/ci-monitor-subagent.md` still
      exist and no vendor-specific token remains (`grep -ri databento scripts .agent` returns nothing).
