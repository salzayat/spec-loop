# Design

## Context

Three gates run inside `npm run check` (and therefore CI via `.github/workflows/check.yml:36`). Each is
supposed to enforce a stated invariant; adversarial review showed each has a gap between the invariant and
the code.

## Decisions

### Verify adapter directories instead of forbidding them

`.opencode/commands/monitor-ci.md` and `.opencode/agents/ci-monitor-subagent.md` are legitimate
OpenCode-native adapters: OpenCode's command frontmatter (`argument-hint:`) and agent format differ from
this repo's canonical skill frontmatter (`name:`), so they cannot be symlinks to `.agent/skills/`. The
`agentic-boiler-governance` "one canonical source" requirement already anticipates this — it allows "an
equivalent explicitly verified adapter." The defect is that `check-harness.sh` does not verify them, so
they are adapters in name only.

The fix keeps the existing symlink assertions for `.opencode/command`, `.opencode/skills`, `.claude/*`,
`.agents`, and `CLAUDE.md`, and adds a loop that, for each `*.md` under `.opencode/commands/` and
`.opencode/agents/`, requires the file to be git-tracked and to contain frontmatter (`description:`,
`name:`, or `argument-hint:`). This closes the "drop anything here unnoticed" hole without deleting
sanctioned native content. It deliberately does not attempt content-equality with the canonical skill,
because the whole reason these are copies is that the format legitimately differs.

### Portable whitespace class, verified against the platform

`git diff -G` compiles its pattern with the platform regex library. On macOS (this repo's declared
platform) `\s` is not the whitespace class, so `\s*=\s*` fails to match `KEY = "value"`. Reproduced in a
scratch repo: the `\s*` pattern returned no file; `[ ]*` and `[[:space:]]*` returned the file. POSIX
`[[:space:]]` is portable across the BSD and GNU regex engines, so the fallback switches to it. The
verification task re-runs the scratch reproduction to confirm the fixed pattern matches.

### Neutral secret keywords

Dropping `DATABENTO_API_KEY` loses nothing: `API_KEY`, `SECRET`, `TOKEN`, and `PASSWORD` already cover any
`*_API_KEY` assignment because the regex is a substring alternation and `DATABENTO_API_KEY` ends in
`API_KEY`. So removal narrows nothing while removing the cross-project name. The `databento` scope
examples are replaced with `hello`/`greeter`/`packages`, which exist in this repo.

## Risks

- **A future OpenCode adapter file lands without frontmatter.** The new loop fails the harness check with
  an actionable message, which is the intended behavior — it is the gate doing its job, not a regression.
- **The fallback still under-matches exotic secret formats.** True, and out of scope: `gitleaks` remains
  the real scanner. The fix only restores the documented fallback to matching the spaced-assignment case
  it always claimed to catch.
