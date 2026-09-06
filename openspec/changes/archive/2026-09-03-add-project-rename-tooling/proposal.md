# Add Project Rename Tooling

## Why

`TEMPLATE.md`'s step 1 ("Rename the identity strings") was a manual, four-row table the fork owner had to
apply by hand across `package.json` (`TEMPLATE.md:12-17`, before this change). In practice it was
incomplete: the identity string `agentic-boiler` (this repository's name before this change) and the npm
scope `@agentic-boiler/*` also appeared in `tsconfig.base.json:19`, `docs/repository-orientation.md:70-75`,
`openspec/config.yaml:1`, `packages/hello/package.json`, `packages/greeter/package.json`,
`packages/greeter/project.json:31`, `plans/agent-harness.md:35`, `plans/roadmap.md:14`, `SUPPORT.md:7-9`,
and the live capability directory `openspec/specs/agentic-boiler-governance/`, none of which `TEMPLATE.md`
mentioned. A fork owner who followed the documented checklist verbatim would have ended up with a
workspace where `@agentic-boiler/hello` still resolved (because the scope wasn't renamed) but the
project's public identity was inconsistent.

This repository was itself proof of the gap: `README.md:1` already introduced the project as "Spec Loop"
(commit 97bc804), while `package.json:2`, `TEMPLATE.md`, `docs/repository-orientation.md`, and
`openspec/specs/agentic-boiler-governance/spec.md` still read `agentic-boiler` / `salzayat/agentic-boiler`.

## What Changes

- Add `scripts/rename-project.sh`, a script that renames every tracked identity string (kebab-case project
  name, npm scope, GitHub owner, repository URLs, title-case name) and every tracked file/directory name
  containing the old kebab-case project name, reading the current identity from `package.json` rather than
  hard-coding it so the script is safe to re-run after a previous rename.
- Exclude `openspec/changes/archive/**`, `node_modules/`, `dist/`, and `.git/` from both the content and
  filename rewrite so historical OpenSpec records stay immutable (`AGENTS.md`'s "Archive an OpenSpec change
  only after every task and verification requirement is complete" implies archived records aren't rewritten
  later).
- After rewriting `package.json` and every `packages/*/package.json`, run `npm install` to regenerate
  `package-lock.json` instead of pattern-matching the lockfile, so workspace resolution is verified rather
  than assumed.
- Add an `npm run rename` script in `package.json` that forwards arguments to
  `scripts/rename-project.sh`.
- Update `TEMPLATE.md` step 1 to point at `npm run rename` instead of the manual table, and add a short
  section on tracking the upstream template repository (`git remote add upstream`) noting that the rename
  script only touches identity-string lines, keeping future upstream-sync diffs small and localized.
- Apply the script to this repository itself (name `spec-loop`, owner unchanged at `salzayat`) so
  `package.json`, `TEMPLATE.md`, docs, and the OpenSpec specs agree with what `README.md` already says.

## Non-Goals

- No GitHub API calls (renaming the actual GitHub repository, transferring the "Template repository"
  setting, or updating branch protection) — the script only edits the local working tree.
- No support for renaming to a name that collides with an existing published npm package under the new
  scope; the script does not query the npm registry.
- Does not touch `openspec/changes/archive/**` content or directory names — those stay exactly as archived.
- Does not add or require `yarn`; the repository stays on the single `packageManager: npm@11.5.2` pinned in
  `package.json`.

## Dependencies

None.
