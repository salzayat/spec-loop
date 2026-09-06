# Design

## Context

`npm run check` runs `scripts/check.sh`, which ends with `npm run typecheck` / `lint` / `test` / `build`
(`scripts/check.sh:14`). Those Nx targets resolve `@agentic-boiler/*` imports through the workspace links
that `npm install`/`npm ci` create under `node_modules/`. When those links are absent, the first symptom
is a TypeScript `TS2307` in a consuming package (`greeter` imports `hello`), which points at the wrong
layer.

## Decisions

### A dedicated preflight script, not an inline snippet

The detection lives in `scripts/check-workspace-links.sh` so it matches every other gate's shape (a small
POSIX `sh` script with `set -eu` and a `fail()` message) and can be run standalone while debugging. It
derives the expected package names from `packages/*/package.json` rather than hard-coding
`@agentic-boiler/hello` and `@agentic-boiler/greeter`, so adding a package needs no edit to the check. It
uses `node -e` to read each `name` (Node is already a required tool for the workspace) and tests that
`require.resolve`-equivalent path exists via `node -e "require('<name>/package.json')"`, which succeeds
only when the link resolves.

### Placed just before typecheck

`check.sh` runs cheap governance gates first, then the Nx quality targets. The preflight is inserted
immediately before `npm run typecheck` (the first target that consumes the links) so its clear message
appears before the cryptic `TS2307`, while the fast governance checks still run first. It is not placed at
the very top because the governance gates do not need the links and should still run in a partially
set-up tree.

### Report, never repair

The script does not run `npm install`. Auto-installing would mask a broken or partial environment and
could pull unexpected changes into a check that is supposed to be read-only. The message instead names the
exact remedy and the `link-workspace-packages` skill, consistent with the repo's "explicit actionable
failure" rule.

## Risks

- **A package intentionally has no runtime name/export.** Low: every package under `packages/` here is a
  named workspace library with an `exports` map; if a future package is nameless the loop should skip it.
  The script guards by skipping a `package.json` whose `name` is empty.
- **Node resolution differs from tsc resolution.** The `require('<name>/package.json')` probe confirms the
  `node_modules` link exists, which is the precondition tsc also needs; it does not attempt to replicate
  tsc's full resolution, only to catch the missing-link case that produced `TS2307`.
