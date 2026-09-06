#!/bin/sh
set -eu

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

[ -d .agent/commands ] || fail "Missing canonical .agent/commands directory"
[ -d .agent/skills ] || fail "Missing canonical .agent/skills directory"

for link in .opencode/command .opencode/skills .claude/commands .claude/skills .agents CLAUDE.md; do
  [ -L "$link" ] || fail "$link must be a symlink to shared harness content"
  [ -e "$link" ] || fail "$link is a dangling symlink"
done

for command in .agent/commands/*.md; do
  grep -q '^description:' "$command" || fail "$command is missing command front matter"
done

for skill in .agent/skills/*; do
  [ -d "$skill" ] || continue
  [ -f "$skill/SKILL.md" ] || fail "$skill is missing SKILL.md"
  grep -q '^name:' "$skill/SKILL.md" || fail "$skill/SKILL.md is missing skill front matter"
done

# OpenCode-native adapter files cannot be symlinks to the canonical skills because their frontmatter
# format differs. They are sanctioned adapters only when explicitly verified: each must be git-tracked
# and carry frontmatter, so no unverified or divergent content can sit in an adapter directory unnoticed.
for adapter in .opencode/commands/*.md .opencode/agents/*.md; do
  [ -e "$adapter" ] || continue
  git ls-files --error-unmatch "$adapter" >/dev/null 2>&1 || fail "$adapter must be tracked to be a verified adapter"
  grep -Eq '^(description|name|argument-hint):' "$adapter" || fail "$adapter is missing adapter front matter"
done

printf '%s\n' "Agent harness check passed"
