# Design

## Context

Skill descriptions are an always-loaded, per-session cost distinct from every other governance-context
finding addressed this week (`AGENTS.md`, `docs/governance.md`, `openspec/specs/`), which load only when
an agent reads that specific file. A skill description loads unconditionally into the skill listing every
session carries, whether or not the skill is used. The fix is therefore narrower and higher-precision:
each edit must preserve every trigger condition (the reason the skill is picked at all) while removing
only what is not a trigger condition — rationale, elaboration, or a redundant restatement.

## Decisions

### Cut rationale, never cut a distinct trigger

The three edits are each verified against the skill's own body before cutting anything:

- `openspec-change`: the cut sentence is checked against the body's "Step 1" section
  (`.agent/skills/openspec-change/SKILL.md`) and found to restate it near-verbatim — invariant,
  verifiability, and immutability mistakes are the body's own named failure modes. Removing it from the
  description loses no scope; the trigger phrases ("draft an OpenSpec change for X", etc.) and the
  scaffolded-file list are untouched.
- `nx-workspace`: the six examples were checked against the two `USE WHEN` clauses and found to map onto
  exactly two categories — general workspace/project/target questions, and diagnosing a failed or unclear
  Nx command. Three examples (one general, two diagnostic) preserve both categories; the other three were
  near-duplicates within the same category ('What projects are in this workspace?' /
  'How is project X configured?' / 'What depends on library Y?' all instantiate the same first clause).
- `link-workspace-packages`: the closing sentence was checked against the full body and found to have no
  restatement anywhere — the body's "Workflow" and per-package-manager sections describe _how_ to link,
  never _why not_ to reach for a tsconfig-paths workaround. This sentence is a genuine anti-pattern warning
  with no duplicate, so it is tightened for wording, not cut for content.

### A contract requirement, not just an edit

Without a standing rule, the same drift can recur: a future skill edit could re-add elaboration to a
description because the pattern ("explain why, not just when") reads naturally when writing one. The added
`spec-loop-governance` requirement makes "description states triggers and scope only" a reviewable
property, the same way the doc-duplication requirement added earlier this week made "state each governance
rule once" reviewable.

## Risks

- **A trimmed description under-triggers a skill that used to fire on a cut example phrase.** Mitigated by
  keeping one representative example per trigger category rather than deleting all examples, and by the
  proposal's Non-Goal on `monitor-ci`, where the phrasings are closer to synonyms than distinct
  categories and the cut confidence is lower.
- **Reviewers disagree on what counts as "rationale" versus "scope."** The requirement's scenario below
  gives a concrete test: content is scope if removing it would make the skill fire on fewer genuinely
  different requests; it is rationale if removing it only removes an explanation of _why_ the skill
  behaves the way its body already documents.
