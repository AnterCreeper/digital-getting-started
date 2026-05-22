# Implementation Report: Standardized PPT & Handout Workflow

## Scope

- Reorganized repository from flat layout to chapter-based layout.
- Added shared style layers for slides and handouts.
- Added reusable templates.
- Added lightweight tooling for lecture scaffolding and style checks.
- Added static-site build pipeline for deployable web publishing.

## Key Decisions

1. Document-first standardization
- The style guide is explicit and reviewable.
- Tooling follows the guide rather than replacing it.

2. Chapter-based content organization
- Matches large teaching projects where chapters and lectures expand over time.
- Keeps slide/handout/figures co-located for each lecture.

3. Shared style files
- Centralized color/layout/code-block behavior to prevent drift.
- Keeps lecture authoring focused on content rather than styling details.

## Files Added

- `STYLE_GUIDE.md`
- `styles/beamer-style.tex`
- `styles/handout-style.tex`
- `templates/slides_template.tex`
- `templates/handout_template.tex`
- `scripts/new_lecture.sh`
- `scripts/check_style.sh`
- `scripts/build_site.py`
- `docs/IMPLEMENTATION_REPORT.md`
- `docs/STATIC_SITE_DEPLOY.md`

## Files Migrated / Updated

- Migrated lecture assets into `chapters/ch03-digital-fundamentals/l01-comb-vs-seq/`
- Updated `README.md`
- Updated `Makefile`

## Operational Commands

- Build all artifacts: `make all`
- Validate folder conventions: `make check-style`
- Build static site: `make site`
- Create a new lecture scaffold: `./scripts/new_lecture.sh ch03-digital-fundamentals l02-fsm-basic`

## Expected Benefits

- Consistent visual identity across all lectures.
- Faster authoring of new content.
- Lower maintenance cost as lecture count grows.
- Easier contribution workflow for collaborators.
