# Tasks: Add Project Rename Tooling

## 1. Rename script

- [x] 1.1 Add `scripts/rename-project.sh` that reads current name/owner from `package.json`, accepts a new
      kebab-case name and optional `--owner`/`--title`/`--description` flags, validates the new name is
      kebab-case, and refuses to run with a dirty git worktree.
- [x] 1.2 Rewrite tracked file content: replace the kebab-case name, `@<scope>`, GitHub owner, and
      title-case name across all tracked files except `openspec/changes/archive/**`, `node_modules/`,
      `dist/`, and `.git/`. Archived OpenSpec change ids referenced from live files (e.g.
      `improve-agentic-boiler-governance` in `plans/roadmap.md`) are protected from the substitution so they
      keep pointing at their real, unrenamed archive directory.
- [x] 1.3 Rename tracked files/directories whose basename contains the old kebab-case name, deepest path
      first, via `git mv`.
- [x] 1.4 Run `npm install` at the end of the script to regenerate `package-lock.json` from the rewritten
      manifests.

## 2. Command wiring

- [x] 2.1 Add `"rename": "./scripts/rename-project.sh"` to `package.json`'s `scripts`, invoked as
      `npm run rename -- <new-name> [--owner <owner>] [--title <title>] [--description <description>]`.

## 3. Documentation

- [x] 3.1 Update `TEMPLATE.md` step 1 to describe `npm run rename` instead of the manual table.
- [x] 3.2 Add a "Track upstream template updates" section to `TEMPLATE.md` covering
      `git remote add upstream` and why the rename script keeps future sync diffs localized.

## 4. Apply to this repository

- [x] 4.1 Run `./scripts/rename-project.sh spec-loop` against this repository (owner stays `salzayat`) so
      `package.json`, `TEMPLATE.md`, docs, and `openspec/specs/` agree with `README.md`'s existing "Spec
      Loop" naming. (Invoked the script directly rather than through `npm run rename --` because a nested
      `npm install` inside an `npm run` script hard-errors under this sandbox's script-allowlist config;
      the script's own logic is identical either way.)
- [x] 4.2 Confirm `openspec/specs/agentic-boiler-governance/` is renamed to
      `openspec/specs/spec-loop-governance/` and its content still validates.

## 5. Verification

- [x] 5.1 Re-run `./scripts/rename-project.sh spec-loop` a second time immediately after 4.1 and confirm it
      exits cleanly with no remaining occurrences of `agentic-boiler` outside `openspec/changes/archive/**`
      (proves idempotency).
- [x] 5.2 Run `grep -rn agentic-boiler` (excluding `openspec/changes/archive/**`, `node_modules`, `dist`,
      `.git`) and confirm zero matches.
- [x] 5.3 Run `npm run check` and confirm it passes on the renamed workspace.
