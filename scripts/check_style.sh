#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

status=0

while IFS= read -r dir; do
  for required in slides.tex handout.tex metadata.json; do
    if [[ ! -f "$dir/$required" ]]; then
      echo "[ERROR] Missing $required in $dir"
      status=1
    fi
  done

  if [[ ! -d "$dir/figures" ]]; then
    echo "[ERROR] Missing figures/ in $dir"
    status=1
  fi

done < <(find chapters -mindepth 2 -maxdepth 2 -type d | sort)

if [[ $status -eq 0 ]]; then
  echo "Style check passed."
fi

exit $status
