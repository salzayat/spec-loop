# Design

## Context

Two distinct things needed fixing, at two different layers:

1. A **practice** gap: nothing told an agent or contributor to create the feature branch before starting
   implementation, so `scripts/pr.sh` being invoked "at the end" was actually normal — the branch legitimately
   didn't need to exist until then, because nothing said otherwise.
2. A **mechanism** gap: even once the practice is documented, prose alone is exactly the failure mode this
   repo has fixed repeatedly this week. Nothing stops a plain `git commit` on `main` today.

Both are addressed, at the layer each belongs to.

## Decisions

### The pre-commit hook is the enforcement point, not `pr.sh`

`scripts/pr.sh` cannot be the enforcement point for "don't commit to `main`" because it already avoids the
problem structurally — it switches to `$pr_branch` before ever calling `git commit`. Guarding inside
`pr.sh` would protect nothing new. The actual unguarded path is a direct `git commit` run outside `pr.sh`
while `main` is checked out — during implementation, or by habit. `.githooks/pre-commit` is the one place
every local commit passes through regardless of how it was invoked (already true for `check.sh`, which
every commit already runs), so the branch check belongs there.

The guard checks `git branch --show-current` — the same call `scripts/pr.sh` already uses for
`start_branch` — for consistency with how branch detection works elsewhere in this repo's scripts. It
fails with the exact remedy (`git switch -c <branch>`) rather than a bare rejection, matching this repo's
existing "explicit actionable failure" standard from `spec-loop-governance`.

### Hooks are opt-in via `scripts/install-git-hooks.sh`; that is a pre-existing, unrelated gap

`.githooks/pre-commit` only runs for a contributor who has run `./scripts/install-git-hooks.sh` (documented
in `CONTRIBUTING.md`'s "Local Setup"). A contributor who skips that step gets no local guard at all,
hook or otherwise — this is already true of the existing `check.sh` gate the hook runs, and is out of
scope here; CI (`.github/workflows/check.yml`) is the actual backstop for anyone who skips local hooks,
though CI does not currently reject a direct push to `main` either, since GitHub branch protection is not
enabled (`Non-Goals`). This change closes the gap for the common local-agent path, not every path.

### Documentation change: branch creation moves earlier, not `pr.sh`'s own ordering

The `AGENTS.md`, skill, and command edits state a sequencing rule — branch, then implement, then run
`scripts/pr.sh --reuse-branch` — without touching `pr.sh`'s existing `--reuse-branch` flag or its
`git switch -c` / `git switch` branching logic, both of which already support this sequencing (see
`scripts/pr.sh:187`-`191`).

## Risks

- **A contributor without hooks installed still commits to `main` locally.** True and out of scope per the
  decision above; documented as a known gap rather than silently assumed solved.
- **The guard blocks a legitimate one-off maintenance commit to `main`.** `AGENTS.md` and
  `CONTRIBUTING.md` already prohibit this unconditionally; the guard makes the existing prohibition
  mechanical rather than introducing a new one. The documented `--no-verify` exception in `AGENTS.md`'s
  Safety Boundaries remains the escape hatch for a genuinely exceptional, user-authorized case.
