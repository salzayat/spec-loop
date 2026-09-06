#!/bin/sh
set -eu

fail() {
  printf '%s\n' "$1" >&2
  cat >&2 <<'EOF'

Workspace packages are not linked into node_modules. Run:

  npm install

If linking still fails, use the `link-workspace-packages` skill to repair the
package manager's workspace links rather than editing tsconfig paths by hand.
EOF
  exit 1
}

for manifest in packages/*/package.json; do
  [ -f "$manifest" ] || continue

  name=$(node -e "process.stdout.write(require('./$manifest').name || '')")
  [ -n "$name" ] || continue

  # Check the link exists on disk. A package `exports` map would block a
  # require() probe (ERR_PACKAGE_PATH_NOT_EXPORTED) even when the link is
  # present, so test the node_modules path directly — that is the precondition
  # tsc needs to resolve the import.
  if [ ! -e "node_modules/$name" ]; then
    fail "Missing workspace link: $name (declared in $manifest) does not resolve from node_modules."
  fi
done

printf '%s\n' "Workspace link check passed"
