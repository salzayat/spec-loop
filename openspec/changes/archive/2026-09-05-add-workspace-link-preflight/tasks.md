# Tasks

## 1. Add the preflight script

- [x] 1.1 Create `scripts/check-workspace-links.sh` (POSIX `sh`, `set -eu`) that reads each
      `packages/*/package.json` name and fails with an actionable message (`npm install`, plus the
      `link-workspace-packages` skill) when the matching `node_modules/` entry does not resolve.
- [x] 1.2 Make it executable (`chmod +x`).

## 2. Wire it into the aggregate check

- [x] 2.1 In `scripts/check.sh`, call `./scripts/check-workspace-links.sh` immediately before
      `npm run typecheck`.

## 3. Update the contract

- [x] 3.1 Apply the `agentic-boiler-governance` delta requiring the aggregate check to surface an
      actionable failure when workspace packages are unlinked.

## 4. Verification

- [x] 4.1 Negative test: remove `node_modules/@agentic-boiler`, run `./scripts/check-workspace-links.sh`,
      confirm it fails with the actionable message (not a `TS2307`). Restore with `npm install`.
- [x] 4.2 Positive test: with links present, `./scripts/check-workspace-links.sh` passes.
- [x] 4.3 Run `openspec validate add-workspace-link-preflight` and resolve any errors.
- [x] 4.4 Run `npm run check` and record the result in the PR.
