# Operations Runbook

This manual is designed for "pick up and go next time," preventing repeated trial-and-error and mistakes.

## 1. Daily Commands

```bash
make check-style   # Structure and required file checks
make all           # Build all lecture PDFs
make site          # Generate static website
make clean         # Clean intermediate files
```

## 2. Directory Responsibilities (Do Not Mix)

- `chapters/`: The only editable source for course content
- `styles/`: Global style layer
- `templates/`: Templates for new lectures
- `scripts/`: Automation scripts
- `pdf/`: Aggregated output directory (generated)
- `site/`: Website output directory (generated)

## 3. SOP for Adding a New Lecture

1. Create scaffolding  
   `./scripts/new_lecture.sh <chapter-slug> <lecture-slug>`

2. Fill in content  
   - `slides.tex`
   - `handout.tex`
   - `metadata.json`
   - `figures/*`

3. Quality gate  
   `make check-style && make all && make site`

4. Check results  
   - `pdf/<chapter>_<lecture>_slides.pdf`
   - `pdf/<chapter>_<lecture>_handout.pdf`
   - The lecture card appears on the site homepage

## 3.1 Calibration Steps Before Starting Content

Before actually editing `slides.tex` / `handout.tex`, complete a lightweight calibration to avoid repeated rework later:

1. First, clarify the **single main thread** of this lecture
   - Only one main narrative thread is allowed
   - History, examples, processes, and diagrams must all serve this main thread

2. Write down the **minimum cognitive increment** this lecture delivers to the reader
   - What "judgment framework" is newly added in the reader's mind after reading this lecture?
   - For example: an object hierarchy diagram, a set of analytical questions, a sense of process positioning

3. Clarify whether this lecture is a **first introduction** or a **spiral revisit**
   - First introduction: Establish outline, positioning, and basic intuition first
   - Revisit and deepen: Then supplement definitions, boundaries, counterexamples, and technical details

4. Self-check before starting
   - Will this lecture turn into a compilation of materials?
   - Will there be two or more parallel main threads?
   - Have you clearly thought through "the relationship between this lecture and the preceding/following chapters"?

## 3.2 Recommended Handout Writing Workflow

It is recommended to proceed in the following order, rather than writing the full text all at once:

1. First, write 3–6 lines of chapter introduction, explaining "why this lecture exists"
2. Then write `Learning Objectives` to clarify delivery boundaries
3. Then determine the major section skeleton and order
4. First write the opening sentence of each section: What question does this section answer?
5. Then add diagrams, examples, analogies, `tipbox` / `warnbox`
6. Only at the end do unified polishing and tone compression

The benefits of doing this are:

- Stabilize the skeleton first, then fill in the flesh
- Control structural risks first, then handle stylistic details
- Avoid discovering the main thread has deviated after writing many paragraphs

## 3.3 Acceptance Questions for Self-Study Textbook Orientation

In addition to passing compilation, it is recommended to use the following questions to accept the main text:

1. Can the reader see why this lecture exists?
2. Does the reader know the relationship between this lecture and the preceding/following chapters?
3. Is this lecture "explaining knowledge," or "training an observation method that will be used repeatedly in the future"?
4. Does it make the reader feel lectured, rather than being led forward?
5. Does it provide the hint "First get to know the outline this time, and we will come back to deepen it later"?
6. If half the rhetoric is removed, does the main structure still hold?

## 4. metadata.json Conventions

Each lecture must contain:

```json
{
  "chapter_title": "Chapter Name",
  "title": "Lecture Title",
  "subtitle": "Subtitle",
  "summary": "One-sentence summary",
  "keywords": ["keyword1", "keyword2"],
  "difficulty": "Undergraduate Basic",
  "duration": "90 min",
  "updated": "YYYY-MM-DD"
}
```

## 5. Common Troubleshooting

### 5.1 `make check-style` Failure

Usually missing one of the following files:
- `slides.tex`
- `handout.tex`
- `metadata.json`
- `figures/`

### 5.2 `make all` Failure

Priority checks:
- LaTeX compilation error lines (syntax, packages, paths)
- Whether `\includegraphics` paths are valid within the lecture directory
- Whether image files actually exist

### 5.3 `make site` Failure or Missing Site Content

Check:
- Whether corresponding lecture PDFs exist in `pdf/`
- Whether `metadata.json` format is valid JSON
- Whether the lecture directory satisfies the `chapters/<chapter>/<lecture>/` two-level structure

## 6. Change Boundary Strategy

- Content updates: Only modify `chapters/`
- Global visual updates: Only modify `styles/`
- Workflow automation updates: Only modify `scripts/`
- Deployment logic updates: Prioritize modifying `scripts/build_site.py` and `docs/STATIC_SITE_DEPLOY.md`

Do not mix the above changes in a single commit unless it is an emergency fix.

## 7. Pre-Release Final Checklist

1. `make check-style` passes
2. `make all` passes
3. `make site` passes
4. `site/index.html` preview looks correct locally
5. New lecture button links (Slides/Handout/Source ZIP) are clickable
6. The main text passes a self-check for "main thread / tone / spiral rhythm"

## Chinese and Image Constraints

- Chinese content in this repository is uniformly processed via the `xelatex` route
- Shared style files already import `ctex + fontspec + Noto CJK`
- If using `pdflatex` only, Chinese titles and body text will show missing characters or direct errors
- `webp` should not be fed directly to LaTeX; please convert to `png` first
