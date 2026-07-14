---
name: convert-arxiv
description: Package the arXivTeX paper in main/ into a flattened, submission-ready copy for arXiv (arXiv/main.tex plus assets and MANIFEST.txt). Use when the user asks to run `make convert-arxiv`, prepare an arXiv preprint/submission, flatten the paper, or refresh the arXiv/ output after editing main/.
---

# convert-arxiv

Wraps this repo's `make convert-arxiv` target: flattens `main/main.tex` (via
`latexpand`) into a single-entry-point, submission-ready copy under
`arXiv/`, then verifies the result actually compiles standalone before
handing it back. Unlike `convert-template`, there's no venue-macro
reasoning here — `make convert-arxiv` is a deterministic script; this skill's
job is to run it, catch the failure modes a human would otherwise only
notice after uploading to arXiv, and report clearly. Never modify
`main/` or `main/main.bib`; `arXiv/` is fully regenerated output.

## When to use

Trigger when the user asks to:
- Run `make convert-arxiv`, or "package"/"flatten"/"export the paper for arXiv".
- Prepare an arXiv preprint or submission-ready copy of the paper.
- Refresh `arXiv/` after editing `main/`.

## Inputs to establish before starting

None required by default (`main/main.tex` → `arXiv/`). Only ask if the
user wants non-default overrides:
- `MAIN=<file>` — a different entry point than `main.tex` (e.g. a
  submission-only variant).
- `ARXIV_DIR=<dir>` — a different output directory than `arXiv/` (e.g.
  to keep multiple flattened snapshots side by side).

## Workflow

1. **Check prerequisites.** Confirm `latexpand` and `perl` are on
   `PATH`. `make convert-arxiv` already hard-fails with a clear message if
   `latexpand` is missing — surface that message rather than guessing
   at a fix. Both ship with most TeX Live installs.
2. **Run the target.** From the repo root: `make convert-arxiv` (add
   `MAIN=`/`ARXIV_DIR=` overrides if established above). This wipes
   and regenerates the output directory every time — never treat
   `arXiv/` as something to hand-edit and preserve across runs.
3. **Inspect the manifest.** Read `arXiv/MANIFEST.txt` (the sorted
   file listing the target generates) against what's actually in
   `arXiv/`. Confirm:
   - `main.tex`, the class/style/bib files (`.cls`/`.sty`/`.bst`/
     `.bib`/`.bbx`/`.cbx`), and every asset the flattened `main.tex`
     references under `srcs/` are present.
   - No stray files snuck in (editor swap files, `.DS_Store`,
     `.synctex.gz`, previewer PDFs) — the target's copy step is
     extension-filtered so this should be rare; flag it if it happens.
4. **Verify it actually compiles standalone.** Run `latexmk -pdf
   main.tex` (or `pdflatex`/`bibtex` manually if `latexmk` isn't
   available) inside `arXiv/` itself, not `main/` — the point is
   confirming the flattened copy has no hidden dependency on files
   outside `arXiv/`. Read any errors:
   - Missing package → per this repo's README, that's a
     `main/main.cls` or `main/main.tex` fix (move the feature into the
     paper source or drop it), not something to patch inside `arXiv/`.
   - Missing file/path → check whether `main/figs/srcs/` or
     `main/srcs/` actually contains the asset; if it's genuinely
     missing, that's a `main/` content gap to report, not something to
     fabricate.
   - If no TeX toolchain is available in this environment, say so
     explicitly instead of claiming the copy compiles.
5. **Report.** Tell the user, in plain text:
   - Where the output landed (`arXiv/`, or the overridden
     `$ARXIV_DIR`) and its entry point.
   - Compile result (pass/fail, or "not verified — no TeX toolchain
     here").
   - Anything needing manual attention before upload: absolute paths,
     unusually large assets, non-PDF/PNG/JPG figures, or any manifest
     entry that looks unintentional.

## Guardrails

- Never modify anything under `main/`, including `main/main.bib` — per
  this repo's `AGENTS.md`.
- Never hand-edit files inside `arXiv/` as a "fix" — it is regenerated
  byte-for-byte on every run, so any real fix belongs in `main/`
  followed by re-running `make convert-arxiv`.
- Don't fabricate or guess at missing assets; report the gap instead.
- This only flattens for arXiv. For venue-specific submission
  templates (CVPR/ICCV/NeurIPS/...), use the `convert-template` skill
  instead.
