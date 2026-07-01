# Design: `convert-template` skill

Date: 2026-07-01

## Problem

arXivTeX papers are authored against a custom `main.cls` (title panel,
theme colors, `\parahead`, `\figref`/`\tabref`/`\algref`/`\eqnref`,
`\tablestyle`, compact column types, etc.). Submitting to a venue like
CVPR/ICCV/NeurIPS requires reformatting into that venue's official
LaTeX kit, which is copyrighted, changes yearly, and has its own
title/author macros and formatting rules. This conversion currently has
no tooling and would be redone by hand for every venue and every
submission cycle (anonymous review draft, then camera-ready).

## Goal

A Claude Code Skill and a matching Codex Skill, `convert-template`,
that takes an officially-provided venue template (zip) plus the
existing `main/` content tree and produces a standalone, compilable
submission copy under `submit/<venue>/`, in either anonymous or
camera-ready mode, without ever modifying `main/` or `main/main.bib`.

## Non-goals

- Auto-discovering or downloading venue templates from the web. The
  user always supplies the official zip.
- Keeping `submit/<venue>/` in continuous sync with `main/`. Re-running
  the skill regenerates it; there is no live/bidirectional sync.
- Reproducing every venue's template ourselves. We reuse the officially
  provided class/style/bst files verbatim.

## Architecture

```
templates/<venue>/        # unzipped official kit, as provided (gitignored)
submit/<venue>/           # generated output: one self-contained, compilable copy (gitignored)
  <official>.cls/.sty/.bst   # copied verbatim from templates/<venue>/
  compat.sty                 # shim: arXivTeX-only macros re-implemented on plain LaTeX
  main.tex                    # new entry point, venue-native preamble + \input{secs/...}
  main.bib, secs/, figs/, tabs/, algs/, appx.tex   # copied unmodified from main/
.claude/skills/convert-template/SKILL.md
.codex/skills/convert-template/SKILL.md
```

Both SKILL.md files describe the same operator checklist (adapted for
each tool's naming conventions); neither is a deterministic script,
because mapping arbitrary venue macros requires reasoning, not just
find/replace.

## Workflow (skill checklist)

1. **Unpack.** Extract the user-supplied zip into `templates/<venue>/`.
   Derive `<venue>` from the zip filename unless the user names it
   explicitly; confirm with the user if ambiguous.
2. **Inspect target kit.** Read the kit's sample `.tex`, its
   `.cls`/`.sty`/`.bst` files, and any README/instructions to learn:
   `\documentclass` options, required packages, title/author macro
   signatures, expected bibliography style, and any anonymous-mode
   toggle (e.g. `\iccvfinalcopy`, `\cvprfinalcopy`).
3. **Scaffold output.** Create `submit/<venue>/`. Copy the official
   `.cls`/`.sty`/`.bst` files into it verbatim — never edit official
   files.
4. **Copy content unmodified.** Copy `main/main.bib`, `main/secs/`,
   `main/figs/` (including `srcs/`), `main/tabs/`, `main/algs/`, and
   `main/appx.tex` into `submit/<venue>/` byte-for-byte. `.bib` content
   is never touched, per `CLAUDE.md`.
5. **Generate `compat.sty`.** Re-implement the arXivTeX-only body
   macros used by the content files — `\parahead`, `\figref`,
   `\tabref`, `\algref`, `\eqnref`, `\tablestyle`, `\cmark`, `\xmark`,
   and the `x`/`y`/`z`/`P`/`Y` column types — using primitives available
   under the target class (plain LaTeX / packages it already loads).
   This means `secs/`, `figs/`, `tabs/`, `algs/` never need edits.
6. **Generate `main.tex`.** New entry point using the target's
   `\documentclass` + required packages + `\input{compat.sty}` +
   venue-native title/author calls, populated from values parsed out of
   the existing `main/main.tex` preamble (title, authors, affiliations,
   abstract, keywords). Section include order is copied from the
   original `main/main.tex`.
   - **camera-ready mode:** real author names, affiliations, and
     metadata links (code/project/dataset).
   - **anonymous mode:** authors replaced with placeholders (e.g.
     "Anonymous Author(s)", "Anonymous Institution"), identifying
     links replaced with "Link redacted for review", venue's anonymous
     toggle enabled if one exists.
7. **Build and iterate.** Attempt `latexmk` (or the kit's documented
   build command) inside `submit/<venue>/`. Fix `compat.sty`/`main.tex`
   issues surfaced by compile errors.
8. **Report.** Summarize what was auto-mapped and flag anything needing
   manual attention (page-limit overflow, a venue-mandated format rule
   that couldn't be fully automated, packages missing from the target
   kit). Never silently drop content — always call it out instead.

## Isolation guarantees

- `main/` and `main/main.bib` are never written to by this skill.
- Official venue files are copied verbatim, never patched in place.
- `templates/` and `submit/` are added to `.gitignore` (mirrors the
  existing `.temp/`/`arXiv/` pattern) since official kits are usually
  copyrighted and `submit/` is fully derived/regeneratable.

## Testing / verification

- Manual smoke test: provide a real venue zip (e.g. a CVPR author kit),
  run the skill in both modes, confirm `submit/<venue>/main.tex`
  compiles with `latexmk` and the anonymous variant contains no author
  names, affiliations, or identifying links.
- Confirm re-running after editing `main/secs/01_introduction.tex`
  regenerates `submit/<venue>/` with the new content and does not
  touch `main/`.
