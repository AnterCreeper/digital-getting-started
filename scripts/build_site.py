#!/usr/bin/env python3
"""Build a static website from chapter lectures and generated PDFs."""

from __future__ import annotations

import html
import json
import os
import shutil
import zipfile
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CHAPTERS_DIR = ROOT / "chapters"
PDF_DIR = ROOT / "pdf"
SITE_DIR = ROOT / "site"
ASSETS_DIR = SITE_DIR / "assets"
LECTURES_ASSETS = ASSETS_DIR / "lectures"


def title_from_slug(slug: str) -> str:
    if "-" not in slug:
        return slug
    parts = slug.split("-", 1)
    return parts[1].replace("-", " ").title()


def normalize_keywords(raw: object) -> list[str]:
    if isinstance(raw, list):
        return [str(x).strip() for x in raw if str(x).strip()]
    if isinstance(raw, str) and raw.strip():
        return [k.strip() for k in raw.split(",") if k.strip()]
    return []


def load_lectures() -> list[dict]:
    lectures = []
    if not CHAPTERS_DIR.exists():
        return lectures

    for chapter_dir in sorted(CHAPTERS_DIR.iterdir()):
        if not chapter_dir.is_dir():
            continue
        for lecture_dir in sorted(chapter_dir.iterdir()):
            if not lecture_dir.is_dir():
                continue
            if not (lecture_dir / "slides.tex").exists() or not (lecture_dir / "handout.tex").exists():
                continue

            meta_path = lecture_dir / "metadata.json"
            meta = {}
            if meta_path.exists():
                with meta_path.open("r", encoding="utf-8") as f:
                    meta = json.load(f)

            chapter_slug = chapter_dir.name
            lecture_slug = lecture_dir.name
            out_prefix = f"{chapter_slug}_{lecture_slug}"

            slides_pdf = PDF_DIR / f"{out_prefix}_slides.pdf"
            handout_pdf = PDF_DIR / f"{out_prefix}_handout.pdf"
            if not slides_pdf.exists():
                local = lecture_dir / "slides.pdf"
                slides_pdf = local if local.exists() else None
            if not handout_pdf.exists():
                local = lecture_dir / "handout.pdf"
                handout_pdf = local if local.exists() else None

            lectures.append(
                {
                    "chapter_slug": chapter_slug,
                    "chapter_title": meta.get("chapter_title", title_from_slug(chapter_slug)),
                    "lecture_slug": lecture_slug,
                    "title": meta.get("title", title_from_slug(lecture_slug)),
                    "subtitle": meta.get("subtitle", ""),
                    "summary": meta.get("summary", "No summary yet."),
                    "keywords": normalize_keywords(meta.get("keywords", [])),
                    "difficulty": meta.get("difficulty", "本科基础"),
                    "duration": meta.get("duration", "90 min"),
                    "updated": meta.get("updated", ""),
                    "source_dir": lecture_dir,
                    "slides_pdf": slides_pdf,
                    "handout_pdf": handout_pdf,
                    "slug": out_prefix,
                }
            )
    return lectures


def symlink_file(src: Path, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.unlink(missing_ok=True)
    relative_src = Path(os.path.relpath(src.resolve(), start=dest.parent.resolve()))
    dest.symlink_to(relative_src)


def copy_assets_and_build_zips(lectures: list[dict]) -> None:
    if LECTURES_ASSETS.exists():
        shutil.rmtree(LECTURES_ASSETS)
    LECTURES_ASSETS.mkdir(parents=True, exist_ok=True)

    for lecture in lectures:
        dest = LECTURES_ASSETS / lecture["slug"]
        dest.mkdir(parents=True, exist_ok=True)

        if lecture["slides_pdf"] and Path(lecture["slides_pdf"]).exists():
            slides_name = "slides.pdf"
            symlink_file(Path(lecture["slides_pdf"]), dest / slides_name)
            lecture["slides_url"] = f"assets/lectures/{lecture['slug']}/{slides_name}"
        else:
            lecture["slides_url"] = ""

        if lecture["handout_pdf"] and Path(lecture["handout_pdf"]).exists():
            handout_name = "handout.pdf"
            symlink_file(Path(lecture["handout_pdf"]), dest / handout_name)
            lecture["handout_url"] = f"assets/lectures/{lecture['slug']}/{handout_name}"
        else:
            lecture["handout_url"] = ""

        zip_name = f"{lecture['slug']}-source.zip"
        zip_path = dest / zip_name
        with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
            for filename in ("slides.tex", "handout.tex", "metadata.json"):
                path = lecture["source_dir"] / filename
                if path.exists():
                    zf.write(path, arcname=filename)
            figures = lecture["source_dir"] / "figures"
            if figures.exists():
                for fig in figures.rglob("*"):
                    if fig.is_file():
                        zf.write(fig, arcname=f"figures/{fig.relative_to(figures)}")
        lecture["source_zip_url"] = f"assets/lectures/{lecture['slug']}/{zip_name}"


def render_cards(lectures: list[dict]) -> str:
    cards = []
    for lec in lectures:
        title = html.escape(lec["title"])
        subtitle = html.escape(lec["subtitle"])
        summary = html.escape(lec["summary"])
        chapter = html.escape(lec["chapter_title"])
        difficulty = html.escape(lec["difficulty"])
        duration = html.escape(lec["duration"])
        updated = html.escape(lec["updated"])
        kw = lec["keywords"]
        tag_html = "".join(f"<span class='tag'>{html.escape(k)}</span>" for k in kw)
        kw_blob = " ".join(kw).lower()

        slides_btn = (
            f"<a class='btn btn-primary' href='{lec['slides_url']}' target='_blank' rel='noopener'>Slides PDF</a>"
            if lec["slides_url"]
            else ""
        )
        handout_btn = (
            f"<a class='btn btn-primary' href='{lec['handout_url']}' target='_blank' rel='noopener'>Handout PDF</a>"
            if lec["handout_url"]
            else ""
        )
        src_btn = f"<a class='btn btn-secondary' href='{lec['source_zip_url']}' download>Source ZIP</a>"

        cards.append(
            f"""
<article class="lecture-card" data-chapter="{html.escape(lec['chapter_slug'])}" data-keywords="{html.escape(kw_blob)}">
  <div class="lecture-topline">
    <span class="chapter-pill">{chapter}</span>
    <span class="meta">{difficulty} · {duration}</span>
  </div>
  <h2>{title}</h2>
  <p class="subtitle">{subtitle}</p>
  <p class="summary">{summary}</p>
  <div class="tags">{tag_html}</div>
  <div class="actions">{slides_btn}{handout_btn}{src_btn}</div>
  <p class="updated">{'Updated: ' + updated if updated else ''}</p>
</article>
"""
        )
    return "\n".join(cards)


def build_site(lectures: list[dict]) -> None:
    SITE_DIR.mkdir(parents=True, exist_ok=True)
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)

    chapters = sorted({(l["chapter_slug"], l["chapter_title"]) for l in lectures}, key=lambda x: x[0])
    chapter_options = "\n".join(
        f"<option value='{html.escape(slug)}'>{html.escape(title)}</option>" for slug, title in chapters
    )

    cards = render_cards(lectures)
    today = datetime.now().strftime("%Y-%m-%d")

    html_text = f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Digital Circuit Course Hub</title>
  <meta name="description" content="本科生数字电路课程资料：PPT、讲义、源文件一站式静态站点。">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Source+Serif+4:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <header class="hero">
    <div class="hero-inner">
      <p class="eyebrow">Digital Circuits · Undergraduate</p>
      <h1>Teaching Repository Portal</h1>
      <p class="lead">章节化管理课件、讲义和源码，支持直接部署为静态网页。</p>
    </div>
    <div class="hero-grid" aria-hidden="true"></div>
  </header>

  <main class="container">
    <section class="toolbar">
      <input id="search-input" type="text" placeholder="搜索标题、关键词、章节...">
      <select id="chapter-filter">
        <option value="">全部章节</option>
        {chapter_options}
      </select>
      <span id="result-count">共 {len(lectures)} 讲</span>
    </section>

    <section id="lecture-list" class="lecture-list">
      {cards}
    </section>
  </main>

  <footer class="site-footer">
    <p>Generated on {today} · Build by scripts/build_site.py</p>
  </footer>

  <script src="assets/main.js"></script>
</body>
</html>
"""

    css_text = """\
:root {
  --bg: #f6f5f1;
  --ink: #182029;
  --muted: #5b6674;
  --card: #ffffff;
  --line: #d9dee5;
  --accent: #b44a2f;
  --accent-dark: #8f3a25;
  --brand: #1f4f73;
  --brand-soft: #dfeaf2;
  --shadow: 0 10px 30px rgba(24, 32, 41, 0.08);
}

* { box-sizing: border-box; }
body {
  margin: 0;
  color: var(--ink);
  background:
    radial-gradient(circle at 90% -20%, #e7edf3 0%, transparent 45%),
    radial-gradient(circle at -10% 20%, #f1e8df 0%, transparent 35%),
    var(--bg);
  font-family: "Manrope", "Helvetica Neue", sans-serif;
}

.hero {
  position: relative;
  overflow: hidden;
  padding: 4rem 1.25rem 3rem;
  border-bottom: 1px solid var(--line);
}

.hero-inner { max-width: 1080px; margin: 0 auto; position: relative; z-index: 2; }
.hero-grid {
  position: absolute;
  inset: 0;
  background-image: linear-gradient(to right, rgba(31,79,115,0.08) 1px, transparent 1px), linear-gradient(to bottom, rgba(31,79,115,0.08) 1px, transparent 1px);
  background-size: 28px 28px;
  mask-image: linear-gradient(to bottom, rgba(0,0,0,0.9), transparent 80%);
}
.eyebrow { color: var(--brand); font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; font-size: 0.78rem; margin: 0 0 0.5rem; }
h1 { margin: 0; font-size: clamp(2rem, 4vw, 3.3rem); line-height: 1.08; }
.lead { margin: 0.9rem 0 0; max-width: 760px; color: var(--muted); font-size: 1.02rem; }

.container { max-width: 1080px; margin: 0 auto; padding: 1.5rem 1.25rem 3rem; }
.toolbar {
  display: grid;
  grid-template-columns: 1fr 260px auto;
  gap: 0.8rem;
  align-items: center;
  margin-bottom: 1rem;
}

input, select {
  border: 1px solid var(--line);
  background: #fff;
  border-radius: 10px;
  padding: 0.72rem 0.85rem;
  font: inherit;
}
#result-count { color: var(--muted); font-weight: 600; justify-self: end; }

.lecture-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1rem;
}

.lecture-card {
  border: 1px solid var(--line);
  background: var(--card);
  border-radius: 16px;
  padding: 1rem;
  box-shadow: var(--shadow);
  display: flex;
  flex-direction: column;
  gap: 0.72rem;
}

.lecture-topline {
  display: flex;
  justify-content: space-between;
  gap: 0.6rem;
  align-items: center;
}
.chapter-pill {
  background: var(--brand-soft);
  color: var(--brand);
  border-radius: 999px;
  font-size: 0.74rem;
  font-weight: 700;
  padding: 0.3rem 0.6rem;
}
.meta { color: var(--muted); font-size: 0.78rem; }

.lecture-card h2 {
  margin: 0;
  font-size: 1.2rem;
  line-height: 1.3;
  font-family: "Source Serif 4", serif;
}
.subtitle, .summary, .updated { margin: 0; color: var(--muted); }
.subtitle { font-size: 0.88rem; }
.summary { font-size: 0.93rem; min-height: 3.5em; }
.updated { font-size: 0.78rem; }

.tags { display: flex; flex-wrap: wrap; gap: 0.4rem; }
.tag {
  background: #f4f1ed;
  color: #6e5b4a;
  border: 1px solid #e9dfd5;
  border-radius: 999px;
  font-size: 0.74rem;
  padding: 0.2rem 0.55rem;
}

.actions { display: flex; flex-wrap: wrap; gap: 0.45rem; margin-top: auto; }
.btn {
  text-decoration: none;
  border-radius: 10px;
  padding: 0.48rem 0.7rem;
  font-size: 0.82rem;
  font-weight: 700;
  border: 1px solid transparent;
}
.btn-primary { background: var(--brand); color: #fff; }
.btn-primary:hover { background: #183f5c; }
.btn-secondary {
  background: #fff;
  border-color: var(--line);
  color: var(--ink);
}
.btn-secondary:hover { border-color: var(--accent); color: var(--accent); }

.site-footer {
  border-top: 1px solid var(--line);
  color: var(--muted);
  text-align: center;
  padding: 1rem;
  font-size: 0.86rem;
}

@media (max-width: 820px) {
  .toolbar { grid-template-columns: 1fr; }
  #result-count { justify-self: start; }
}
"""

    js_text = """\
const searchInput = document.getElementById("search-input");
const chapterFilter = document.getElementById("chapter-filter");
const cards = Array.from(document.querySelectorAll(".lecture-card"));
const resultCount = document.getElementById("result-count");

function normalize(text) {
  return (text || "").toLowerCase().trim();
}

function applyFilters() {
  const q = normalize(searchInput.value);
  const chapter = normalize(chapterFilter.value);
  let visible = 0;

  for (const card of cards) {
    const cardText = normalize(card.innerText);
    const kws = normalize(card.dataset.keywords);
    const cardChapter = normalize(card.dataset.chapter);

    const matchesSearch = q === "" || cardText.includes(q) || kws.includes(q);
    const matchesChapter = chapter === "" || cardChapter === chapter;
    const show = matchesSearch && matchesChapter;

    card.style.display = show ? "" : "none";
    if (show) visible += 1;
  }

  resultCount.textContent = `共 ${visible} 讲`;
}

searchInput.addEventListener("input", applyFilters);
chapterFilter.addEventListener("change", applyFilters);
"""

    (SITE_DIR / "index.html").write_text(html_text, encoding="utf-8")
    (ASSETS_DIR / "style.css").write_text(css_text, encoding="utf-8")
    (ASSETS_DIR / "main.js").write_text(js_text, encoding="utf-8")
    (SITE_DIR / ".nojekyll").write_text("", encoding="utf-8")


def main() -> None:
    lectures = load_lectures()
    copy_assets_and_build_zips(lectures)
    build_site(lectures)
    print(f"Site generated: {SITE_DIR}")
    print(f"Lectures: {len(lectures)}")


if __name__ == "__main__":
    main()
