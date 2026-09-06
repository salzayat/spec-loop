# Harden Harness And Secret Checks

## Why

Two enforced governance gates do not actually enforce what the specs claim, and one carries cross-project
residue that violates the repository's neutrality rule. All three were found by adversarial review and
reproduced.

1. **Unverified adapter content bypasses the harness gate.** `agentic-boiler-governance` requires agent
   discovery paths to resolve to the canonical `.agent/` tree "through symlinks or an equivalent
   explicitly verified adapter, rather than copied content." But `.opencode/` holds two real, git-tracked,
   non-symlink directories — `.opencode/commands/monitor-ci.md` (which diverges from the canonical
   `.agent/skills/monitor-ci/SKILL.md` frontmatter) and `.opencode/agents/ci-monitor-subagent.md`.
   [`scripts/check-harness.sh`](../../../scripts/check-harness.sh) only checks `.opencode/command`
   (singular) and `.opencode/skills` as symlinks; it never inspects `.opencode/commands` (plural) or
   `.opencode/agents`. Those adapter files are therefore _not_ "explicitly verified" — anything, including
   a secret, could sit there and `npm run check` would still pass.

2. **The fallback secret scanner silently matches nothing on macOS.** [`scripts/check-secrets.sh:45`](../../../scripts/check-secrets.sh)
   and `:47` pass `\s*=\s*` to `git diff -G`. Git's `-G` uses POSIX regex where `\s` is not a whitespace
   class on this repo's platform. Reproduced: a planted `API_KEY = "EXAMPLE-not-a-real-key"` is **not** matched
   by the `\s*` pattern, while the same pattern with `[[:space:]]*` matches it. On any contributor machine
   without `gitleaks` installed, the documented fallback — the weakest link — provides near-zero coverage.
   This violates `agentic-boiler-governance`'s rule that a check must not silently skip its gate.

3. **A provider-specific credential name is baked into "neutral" governance.** `DATABENTO_API_KEY` (a
   market-data vendor key) is hard-coded in the secret regex, and `databento` appears as a commit-scope
   example in [`scripts/pr.sh:12`](../../../scripts/pr.sh), [`.agent/commands/pr.md:24`](../../../.agent/commands/pr.md),
   and [`.agent/skills/pull-request-automation/SKILL.md:46`](../../../.agent/skills/pull-request-automation/SKILL.md).
   The repository states examples must be neutral and credential-free; a specific vendor's key name is
   exactly the hidden cross-project assumption the repo exists to avoid.

## What Changes

- Extend `check-harness.sh` to explicitly verify every file under `.opencode/commands/` and
  `.opencode/agents/` (the OpenCode-native adapters that cannot be symlinks because their frontmatter
  format differs from canonical skills): each must be tracked and carry valid frontmatter, so no
  unverified or divergent content can sit in an adapter directory unnoticed.
- Fix the `check-secrets.sh` fallback pattern to use a portable POSIX whitespace class (`[[:space:]]*`)
  that actually matches spaced assignments, and drop the vendor-specific `DATABENTO_API_KEY` token in
  favor of neutral, generic secret keywords.
- Replace the `databento` commit-scope examples in `scripts/pr.sh`, `.agent/commands/pr.md`, and
  `.agent/skills/pull-request-automation/SKILL.md` with neutral examples drawn from this repo
  (`hello`, `greeter`, `packages`).
- Update the `agentic-boiler-governance` contract so the "explicitly verified adapter" clause and the
  "checks cannot silently disappear" clause name these obligations concretely.

## Non-Goals

- No change to the `gitleaks` primary path — it already works; only the no-gitleaks fallback is fixed.
- No deletion of the OpenCode-native adapter files; they are sanctioned adapters, now verified rather than
  ignored. A reader can confirm `.opencode/commands/monitor-ci.md` and `.opencode/agents/ci-monitor-subagent.md`
  still exist after this change.
- No change to `check.sh` ordering, the CI workflow, or the harness symlink topology itself.
- No new secret-scanning dependency is made mandatory; absence of `gitleaks` still degrades to the
  fallback, which now actually matches.
