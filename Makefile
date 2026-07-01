LATEXMK ?= latexmk
MAIN_DIR ?= main
MAIN ?= main.tex
OUT_DIR ?= .temp
ARXIV_DIR ?= arXiv

.PHONY: all arxiv

all:
	mkdir -p $(OUT_DIR)
	cd $(MAIN_DIR) && $(LATEXMK) -pdf -outdir=$(abspath $(OUT_DIR)) $(MAIN)

arxiv:
	@command -v latexpand >/dev/null 2>&1 || { printf 'latexpand is required. Install TeX Live/MacTeX or add latexpand to PATH.\n' >&2; exit 1; }
	@test -f $(MAIN_DIR)/$(MAIN) || { printf 'entry file not found: $(MAIN_DIR)/$(MAIN)\n' >&2; exit 1; }
	mkdir -p $(ARXIV_DIR)
	find $(ARXIV_DIR) -mindepth 1 -maxdepth 1 -exec rm -rf {} +
	cd $(MAIN_DIR) && latexpand $(MAIN) > $(abspath $(ARXIV_DIR)/main.tex)
	@perl -0pi -e 's#figs/srcs/#srcs/#g; s#figs/srcs#srcs#g' $(ARXIV_DIR)/main.tex
	@for file in $(MAIN_DIR)/*.cls $(MAIN_DIR)/*.sty $(MAIN_DIR)/*.bst $(MAIN_DIR)/*.bib $(MAIN_DIR)/*.bbx $(MAIN_DIR)/*.cbx; do \
		[ -f "$$file" ] || continue; \
		cp -p "$$file" "$(ARXIV_DIR)/$$(basename "$$file")"; \
	done
	@if [ -d $(MAIN_DIR)/figs/srcs ]; then \
		find $(MAIN_DIR)/figs/srcs -type f \( -iname '*.pdf' -o -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.eps' -o -iname '*.ps' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.pdf_tex' -o -iname '*.pdf_t' -o -iname '*.pstex_t' -o -iname '*.svg' \) -exec sh -c 'for file do rel=$${file#$(MAIN_DIR)/figs/srcs/}; mkdir -p "$(ARXIV_DIR)/srcs/$$(dirname "$$rel")"; cp -p "$$file" "$(ARXIV_DIR)/srcs/$$rel"; done' sh {} +; \
	fi
	@if [ -d $(MAIN_DIR)/srcs ]; then \
		find $(MAIN_DIR)/srcs -type f \( -iname '*.pdf' -o -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.eps' -o -iname '*.ps' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.pdf_tex' -o -iname '*.pdf_t' -o -iname '*.pstex_t' -o -iname '*.svg' \) -exec sh -c 'for file do rel=$${file#$(MAIN_DIR)/}; mkdir -p "$(ARXIV_DIR)/$$(dirname "$$rel")"; cp -p "$$file" "$(ARXIV_DIR)/$$rel"; done' sh {} +; \
	fi
	@cd $(ARXIV_DIR) && find . -type f | sed 's#^\./##' | sort > MANIFEST.txt
