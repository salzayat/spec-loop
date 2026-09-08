# Trim Skill Description Overhead

## Why

A skill's `description:` frontmatter field is loaded into every agent session's skill listing regardless
of whether that skill is ever invoked — unlike a skill's body, which loads only on invocation. This
repo's own skill descriptions vary from ~150 to 728 characters with no relationship to how often the
skill is used, so every session pays for the longest ones whether or not it needs them.

`.agent/skills/openspec-change/SKILL.md:2` carries the longest description in the repo at 728 characters.
Its final sentence — "Grounds every claim in the proposal against the actual current codebase rather than
assumption, and actively checks for the invariant, verifiability, and immutability mistakes that have
shown up in this repo's own drafts before." — restates rationale that the skill body already states in
full under "Step 1: Ground it in the actual codebase before writing anything"
(`.agent/skills/openspec-change/SKILL.md`, Step 1 section). The description does not need to carry
elaboration the body already owns; it needs to carry the trigger conditions, which that sentence does not
add to.

`.agent/skills/nx-workspace/SKILL.md:2` (421 characters) lists six quoted example utterances after already
stating its two `USE WHEN` trigger clauses in full sentences. The six examples are redundant restatements
of the same two trigger categories (general workspace questions, and debugging a failed/unclear task) —
three representative examples cover both categories as well as six.

`.agent/skills/link-workspace-packages/SKILL.md:2` (524 characters) carries a real, non-duplicated warning
("DO NOT patch around with tsconfig paths...") that is not restated anywhere in its body, so it stays —
tightened for wording only, not cut for content.

## What Changes

- Trim `openspec-change`'s description to drop the rationale sentence already owned by the skill body,
  keeping every trigger phrase and the file list it scaffolds.
- Trim `nx-workspace`'s description from six example utterances to three representative ones, keeping
  both `USE WHEN` trigger clauses in full.
- Tighten `link-workspace-packages`'s closing warning sentence for wording only; its trigger conditions
  and the warning's content are unchanged.
- Add a `spec-loop-governance` requirement that a skill's `description:` field states only trigger
  conditions and scope, not rationale or elaboration the skill body already carries — so this class of
  duplication does not silently regrow the way the `AGENTS.md` Nx-guidance duplication did.

## Non-Goals

- No change to `monitor-ci`'s description (406 characters): its six trigger phrasings are near-synonyms of
  a single "watch/monitor/track CI" intent rather than the two-different-scenario duplication the other
  three skills have, and cutting them risks losing an exact-phrase match with lower confidence than the
  other three cuts.
- No change to any skill body, including `monitor-ci/SKILL.md`'s 19 KB body — bodies load only on
  invocation and are a separate, lower-priority cost from the always-loaded description field.
- No change to skill behavior, triggering logic, or the set of skills installed.
- No change to `.agent/commands/*.md` frontmatter — already checked and found lean.
