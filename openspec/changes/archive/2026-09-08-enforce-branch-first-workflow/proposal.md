# Enforce Branch-First Workflow

## Why

`scripts/pr.sh` itself does the right thing internally: it switches to the PR branch
(`scripts/pr.sh:191`, `git switch -c "$pr_branch"`) before staging (`:194`), running checks (`:207`,
`:210`), committing (`:216`), and pushing (`:218`). The branch is created before any commit, not after.

The actual gap is upstream of the script. Neither `AGENTS.md`'s "Pull Requests" section, nor
`.agent/commands/pr.md`, nor `.agent/skills/pull-request-automation/SKILL.md` says _when_ to create that
branch relative to starting implementation work. In practice, implementation across several recent
changes in this repo happened as edits to `main`'s working tree, with `main` still checked out, and the
feature branch was only created in the final minutes when `scripts/pr.sh` ran — meaning every change sat
as uncommitted work on `main` for its entire implementation and verification phase. That's real risk: if
`main` moves underneath uncommitted work (a pull, a merge, another session touching the same tree), the
work can conflict or be lost, and there is nothing today that would stop a plain `git commit` from landing
directly on `main` — `gh api repos/salzayat/spec-loop/branches/main/protection` returns `404 Branch not
protected`, and `.githooks/pre-commit` (`repo_root=$(git rev-parse --show-toplevel); ./scripts/check.sh`)
runs the quality gate but does not check which branch is checked out.

`AGENTS.md`'s "Pull Requests" section and `CONTRIBUTING.md`'s "Commit And PR Rules" already state "Do not
commit directly to `main`" as prose; there is no check behind it, which is the exact class of gap this
repo has fixed repeatedly this week (duplicated guidance, an unverified adapter directory, a secret regex
that silently matched nothing) — a rule with no mechanism to catch its own violation.

## What Changes

- Add a branch guard to `.githooks/pre-commit`: refuse to commit while `main` is checked out, with a
  message naming the fix (`git switch -c <branch>`). `scripts/pr.sh` is unaffected — it already switches
  away from the start branch before committing.
- Add an explicit rule to `AGENTS.md`'s "Pull Requests" section: create and switch to a feature branch
  before making file changes intended for a pull request, not only before running `scripts/pr.sh`.
- Update `.agent/skills/pull-request-automation/SKILL.md` and `.agent/commands/pr.md` to state that when
  the branch already exists (created before implementation began), `scripts/pr.sh` should be invoked with
  `--reuse-branch`.
- Extend the `workflow-governance` requirement on PR automation to state that implementation work for a
  pull request MUST happen on a feature branch from the start, and that a local commit directly to `main`
  MUST fail with an actionable message.

## Non-Goals

- No change to `scripts/pr.sh`'s own branch-then-commit ordering — it is already correct.
- No GitHub-side branch protection (requiring PR review or status checks before merge on `main`). That is
  a repository settings change on an external platform, not a code change, and needs separate explicit
  authorization; this change only adds the local, in-repo guard.
- No change to how `TEMPLATE.md` or `scripts/rename-project.sh` handle initial fork setup — neither
  commits during setup, so neither is affected by the new guard.
