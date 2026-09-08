# Tasks

## 1. Add the pre-commit branch guard

- [x] 1.1 In `.githooks/pre-commit`, before running `./scripts/check.sh`, check
      `git branch --show-current`; if it is `main`, fail with a message naming the fix
      (`git switch -c <branch>`).

## 2. Document branch-first sequencing

- [x] 2.1 Add a rule to `AGENTS.md`'s "Pull Requests" section: create and switch to a feature branch
      before making file changes intended for a pull request, not only before running `scripts/pr.sh`.
- [x] 2.2 Update `.agent/skills/pull-request-automation/SKILL.md` to state that when the branch already
      exists, run `scripts/pr.sh` with `--reuse-branch`.
- [x] 2.3 Update `.agent/commands/pr.md` with the same note, consistent with the skill.

## 3. Update the contract

- [x] 3.1 Apply the `workflow-governance` delta: implementation for a pull request MUST happen on a
      feature branch from the start, and a local commit directly to `main` MUST fail with an actionable
      message.

## 4. Verification

- [x] 4.1 Run `./scripts/install-git-hooks.sh` (idempotent if already installed).
- [x] 4.2 Negative test: on `main`, stage a throwaway change and run `git commit`; confirm the hook
      rejects it with the actionable message and no commit is created. Reset the throwaway change after.
- [x] 4.3 Positive test: on a feature branch, stage a real change and run `git commit`; confirm the hook
      runs `check.sh` as before and the commit succeeds.
- [x] 4.4 Confirm `scripts/pr.sh` is unaffected: it already switches off `main` before committing, so its
      existing flow needs no behavior change.
- [x] 4.5 Run `openspec validate enforce-branch-first-workflow` and resolve any errors.
- [x] 4.6 Run `npm run check` and record the result in the PR.
