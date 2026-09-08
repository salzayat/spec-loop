#!/bin/sh
set -eu

json_file=$(mktemp)
trap 'rm -f "$json_file"' EXIT
npm exec openspec -- list --json >"$json_file" 2>/dev/null

python3 - "$json_file" <<'PY'
import json
import sys
from pathlib import Path

with open(sys.argv[1], encoding="utf-8") as handle:
    data = json.load(handle)
changes = sorted(data.get("changes", []), key=lambda c: c["name"])

rows = []
for change in changes:
    name = change["name"]
    specs_dir = Path("openspec/changes") / name / "specs"
    if not specs_dir.is_dir():
        continue
    capabilities = sorted(p.name for p in specs_dir.iterdir() if p.is_dir())
    for capability in capabilities:
        rows.append((capability, name, change["completedTasks"], change["totalTasks"]))

if not rows:
    print("No active OpenSpec changes.")
    raise SystemExit(0)

rows.sort(key=lambda r: (r[0], r[1]))
for capability, name, completed, total in rows:
    print(f"{capability} :: {name} ({completed}/{total} tasks)")
PY
