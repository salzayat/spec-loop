# Tasks

## 1. Add the status command

- [x] 1.1 Create `scripts/spec-status.sh` (POSIX `sh` driving a small `python3` block, matching the style of
      `scripts/check-plan-freshness.sh`): read `openspec list --json`, join each active change to the
      capability names under its `specs/` subdirectory, and print `capability :: change
(completed/total)`, one line per capability-change pair, sorted by capability.
- [x] 1.2 Make it executable (`chmod +x`).
- [x] 1.3 Print `No active OpenSpec changes.` when the active list is empty, rather than nothing.

## 2. Point orientation at the command

- [x] 2.1 Add a short "Resuming Work" note to `docs/repository-orientation.md` instructing an agent to run
      `./scripts/spec-status.sh` before reading the roadmap or prior session context, right after the
      Accepted Specification Index.

## 3. Update the contract

- [x] 3.1 Apply the `repository-planning` delta: per-capability progress MUST be derivable from existing
      OpenSpec state, not recorded as separate prose.

## 4. Verification

- [x] 4.1 With no active changes, run `./scripts/spec-status.sh` and confirm it prints the empty-state
      message.
- [x] 4.2 Temporarily scaffold a throwaway active change with a partially checked `tasks.md` and a
      `specs/<capability>/spec.md`, run the script, confirm it reports that capability with the correct
      completed/total count, then remove the scaffold.
- [x] 4.3 Run `openspec validate add-spec-status-command` and resolve any errors.
- [x] 4.4 Run `npm run check` and record the result in the PR.
