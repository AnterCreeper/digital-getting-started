TEX=xelatex
TEXFLAGS=-interaction=nonstopmode -halt-on-error

.PHONY: all check-style site clean

all:
	@set -e; \
	mkdir -p pdf; \
	for dir in $$(find chapters -mindepth 2 -maxdepth 2 -type d | sort); do \
	  chapter=$$(basename $$(dirname $$dir)); \
	  lecture=$$(basename $$dir); \
	  out_prefix="$${chapter}_$${lecture}"; \
	  if ls $$dir/figures/*.tex >/dev/null 2>&1; then \
	    for f in $$dir/figures/*.tex; do \
	      $(TEX) $(TEXFLAGS) -output-directory=$$dir/figures $$f >/dev/null; \
	      $(TEX) $(TEXFLAGS) -output-directory=$$dir/figures $$f >/dev/null; \
	    done; \
	  fi; \
	  if [ -f $$dir/slides.tex ]; then \
	    (cd $$dir && $(TEX) $(TEXFLAGS) slides.tex >/dev/null && $(TEX) $(TEXFLAGS) slides.tex >/dev/null); \
	    ln -sfn ../$$dir/slides.pdf pdf/$${out_prefix}_slides.pdf; \
	  fi; \
	  if [ -f $$dir/handout.tex ]; then \
	    (cd $$dir && $(TEX) $(TEXFLAGS) handout.tex >/dev/null && $(TEX) $(TEXFLAGS) handout.tex >/dev/null); \
	    ln -sfn ../$$dir/handout.pdf pdf/$${out_prefix}_handout.pdf; \
	  fi; \
	done
	@echo "Build completed."

check-style:
	@./scripts/check_style.sh

site:
	@python3 ./scripts/build_site.py
	@echo "Static site generated at site/"

clean:
	@find chapters -type f \( -name '*.aux' -o -name '*.log' -o -name '*.nav' -o -name '*.out' -o -name '*.snm' -o -name '*.toc' \) -delete
	@echo "Cleaned intermediate LaTeX files."
