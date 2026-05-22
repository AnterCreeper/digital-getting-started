# Static Site Deployment Guide

## Goal

Build and publish a fully static course website from this repository, including:

- lecture cards
- slides PDF links
- handout PDF links
- source ZIP downloads

## Build Steps

From repository root:

```bash
make check-style
make all
make site
```

Generated website directory:

- `site/index.html`
- `site/assets/style.css`
- `site/assets/main.js`
- `site/assets/lectures/*`

## Local Preview

```bash
cd site
python -m http.server 8000
```

Open `http://localhost:8000`.

## GitHub Pages Deployment Options

### Option A: Dedicated Website Repository (Recommended)

1. Create a new repository for the website.
2. Copy `site/` contents into that repository root.
3. Enable Pages from `main` branch root.

### Option B: Same Repository + Pages Branch

1. Keep source in current repository.
2. Publish generated `site/` contents to a deployment branch (for example `gh-pages`).
3. Configure Pages to serve from that branch root.

## Update Workflow

When course content changes:

1. update chapter lecture files and metadata
2. run `make all && make site`
3. republish `site/`

## Notes

- The site is self-contained and framework-free.
- `.nojekyll` is generated to avoid Jekyll processing conflicts on Pages.
