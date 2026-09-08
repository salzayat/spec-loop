# Add Spec Status Command

## Why

An agent resuming work today has to reconstruct "what's in progress on this capability" by reading the
conversation, the active change's `tasks.md`, and often the roadmap — full session context. A per-capability
progress marker would let a fresh agent load only the slice it needs, which is a genuine token-economy win
for resumption, but only if it stays derived rather than hand-maintained: `docs/governance.md` and
`docs/repository-orientation.md` already carried four restated copies of the same governance facts before
`2026-09-05-reduce-governance-context-duplication` collapsed them, and `plans/roadmap.md` needs its own
freshness script (`scripts/check-plan-freshness.sh`) because change status written as prose drifts from the
actual `tasks.md` checkbox state. A written "active work" column on the Accepted Specification Index would
be a fifth copy of the same failure mode.

`openspec list --json` already reports `totalTasks`/`completedTasks` per change (used by
`scripts/check-openspec-archive.sh:5`), and each active change under `openspec/changes/<name>/specs/`
already names the capability it touches via its delta-spec subdirectory. Both facts already exist on disk;
nothing needs to be newly recorded.

## What Changes

- Add `scripts/spec-status.sh`: for each active (non-archived) OpenSpec change, resolve the capability it
  touches from its `specs/<capability>/` subdirectory and print `capability :: change (completed/total
tasks)`, sourced live from `openspec list --json` and the change's own directory layout. Nothing is
  written to disk; the command is read-only.
- Add a short "Resuming Work" note to `docs/repository-orientation.md` pointing at
  `./scripts/spec-status.sh` instead of adding a written progress column, so an agent resuming a task runs
  one command instead of loading the full roadmap, session, or every active change's `tasks.md`.
- Extend the `repository-planning` requirement on dependency readiness to state that per-capability progress
  MUST be derivable from existing OpenSpec state, not recorded as separate prose.

## Non-Goals

- No new persistent status file, frontmatter field, or roadmap column — the whole point is to avoid a sixth
  thing that can drift from `tasks.md`.
- No change to `plans/roadmap.md`, `scripts/check-plan-freshness.sh`, or milestone sequencing; this is a
  capability-level view, not a replacement for roadmap ordering.
- No change to how `openspec archive` or `openspec validate` compute task completion.
