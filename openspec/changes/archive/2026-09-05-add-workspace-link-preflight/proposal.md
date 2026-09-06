# Add Workspace Link Preflight

## Why

When the workspace package symlinks under `node_modules/@agentic-boiler/` are absent, `npm run check`
fails deep inside `npm run typecheck` with `TS2307: Cannot find module '@agentic-boiler/hello'`
(`packages/greeter/src/index.ts:2`). Reproduced in this environment: `node_modules/@agentic-boiler/` was
empty, so `greeter:typecheck` failed with a cryptic module-resolution error that names TypeScript, not the
actual cause (packages were never linked by `npm install`/`npm ci`).

This is exactly the failure mode `agentic-boiler-governance` says the gate must not have: a check should
"report an explicit actionable failure" rather than surface a misleading downstream error. A contributor
seeing `TS2307` reasonably suspects broken code or tsconfig, not an unlinked workspace — and the repo's
own `link-workspace-packages` skill exists precisely because this class of error is easy to misdiagnose.

## What Changes

- Add `scripts/check-workspace-links.sh`: for every `packages/*/package.json` name, confirm the matching
  entry resolves under `node_modules/`. On a missing link it fails with an actionable message naming the
  fix (`npm install`) and the `link-workspace-packages` skill, instead of letting typecheck raise `TS2307`.
- Wire the preflight into `scripts/check.sh` immediately before `npm run typecheck`, so the clear failure
  precedes the cryptic one.
- Extend the `agentic-boiler-governance` "checks cannot silently disappear" requirement to require the
  aggregate check to surface an actionable failure when workspace packages are unlinked.

## Non-Goals

- No automatic `npm install` inside the check — the gate reports and instructs; it does not mutate the
  environment or hide a broken setup.
- No change to how packages declare or resolve their dependencies (`package.json` `exports`, Nx
  `implicitDependencies`, the `@agentic-boiler/source` condition) — only detection of a missing link.
- No change to the existing typecheck/lint/test/build targets or their ordering relative to each other.
