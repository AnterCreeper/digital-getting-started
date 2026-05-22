#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <chapter-slug> <lecture-slug>"
  echo "Example: $0 ch03-digital-fundamentals l02-fsm-basic"
  exit 1
fi

chapter="$1"
lecture="$2"
root_dir="$(cd "$(dirname "$0")/.." && pwd)"
lecture_dir="$root_dir/chapters/$chapter/$lecture"

if [[ -e "$lecture_dir" ]]; then
  echo "Error: $lecture_dir already exists"
  exit 1
fi

mkdir -p "$lecture_dir/figures"
cp "$root_dir/templates/slides_template.tex" "$lecture_dir/slides.tex"
cp "$root_dir/templates/handout_template.tex" "$lecture_dir/handout.tex"
cat > "$lecture_dir/metadata.json" <<META
{
  "chapter_title": "TODO chapter title",
  "title": "TODO lecture title",
  "subtitle": "TODO lecture subtitle",
  "summary": "TODO one-paragraph summary",
  "keywords": ["TODO", "digital-circuit"],
  "difficulty": "本科基础",
  "duration": "90 min",
  "updated": "$(date +%F)"
}
META

cat > "$lecture_dir/README.md" <<README
# $chapter / $lecture

- slides: slides.tex
- handout: handout.tex
- metadata: metadata.json
- figures: figures/
README

echo "Created: $lecture_dir"
