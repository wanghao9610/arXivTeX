---
name: convert-template
description: Convert the arXivTeX paper in main/ into a submission copy for an officially-supplied venue LaTeX template (e.g. CVPR, ICCV, NeurIPS). Use when the user provides a venue template zip and asks to convert, reformat, or submit the paper to that venue, in anonymous review or camera-ready mode.
---

# convert-template

Converts the modular arXivTeX paper under `main/` into a standalone,
compilable copy that follows an officially-provided venue LaTeX
template. The user always supplies the official template as a zip —
never fetch, guess, or reconstruct a venue template from memory or the
web. Never modify `main/` or `main/main.bib`; all output goes under
`submit/<venue>/`.

## When to use

Trigger when the user:
- Provides a path to a venue template zip (e.g. a CVPR/ICCV/NeurIPS
  author kit) and asks to convert, reformat, or prepare the paper for
  submission to that venue.
- Asks for an anonymous review draft or a camera-ready version of the
  paper in a specific venue's format.

## Inputs to establish before starting

Ask only what is missing:
1. Path to the venue template zip.
2. Venue name (`<venue>`), if not obvious from the zip filename — used
   as the directory name under `templates/` and `submit/`.
3. Mode: `anonymous` (blind review — no author names, affiliations, or
   identifying links) or `camera-ready` (full author/affiliation/link
   metadata). Ask if not stated.

## Workflow

1. **Unpack.** Extract the zip into `templates/<venue>/`. If a
   directory of that name already exists with different contents,
   confirm with the user before overwriting.
2. **Inspect the target kit.** Read its sample `.tex` file, its
   `.cls`/`.sty`/`.bst` files, and any README/instructions bundled with
   it. Identify:
   - The required `\documentclass` line and options (columns, page
     size).
   - Required packages the kit's own class does not already load.
   - The kit's native title/author/affiliation macros and their exact
     call signatures.
   - The bibliography style the kit expects (bibstyle/bst name).
   - Any anonymous-mode toggle the kit defines (e.g.
     `\iccvfinalcopy`, `\cvprfinalcopy`, a `final` class option).
3. **Scaffold the output directory.** Create `submit/<venue>/`. Copy
   every `.cls`, `.sty`, and `.bst` file from `templates/<venue>/` into
   `submit/<venue>/` byte-for-byte. Never edit an official file's
   contents — if something about it seems wrong, flag it in the final
   report instead of patching it.
4. **Copy paper content unmodified.** Copy, byte-for-byte, into
   `submit/<venue>/`:
   - `main/main.bib`
   - `main/secs/`
   - `main/figs/` (including `main/figs/srcs/`)
   - `main/tabs/`
   - `main/algs/`
   - `main/appx.tex`

   Do not edit any of these files. `.bib` content is never touched,
   per this repo's `CLAUDE.md` — if the venue needs a different
   citation style, that is a `\bibliographystyle{...}` change in the
   generated `main.tex`, not a `.bib` edit.
5. **Generate `submit/<venue>/compat.sty`.** This repo's content files
   use arXivTeX-only macros that the venue class will not define:
   `\parahead`, `\figref`, `\tabref`, `\algref`, `\eqnref`,
   `\tablestyle`, `\cmark`, `\xmark`, and the `x`/`y`/`z`/`P`/`Y`
   compact table column types (all defined in `main/main.cls` — read
   it for exact behavior). Re-implement each one used by the content
   files as plain LaTeX on top of packages the venue class already
   loads (or minimal, widely-available packages like `array`,
   `pifont`, if the venue class doesn't already provide the
   equivalent). This is what lets `secs/`, `figs/`, `tabs/`, `algs/`
   compile unmodified against the new class.
6. **Generate `submit/<venue>/main.tex`.** New entry point built from:
   - The venue's own `\documentclass` line, required packages, and
     `\input{compat.sty}`.
   - Title, author, affiliation, abstract, and keyword values parsed
     out of the existing `main/main.tex` preamble (its
     `\title`/`\author`/`\affiliation`/`\abstract`/`\keywords` calls).
     These calls are not always made directly in `main.tex` — e.g. this
     repo's `main/main.tex` preamble does
     `\input{secs/00_abstract.tex}`, and the `\abstract{...}`/
     `\keywords{...}` calls actually live inside that file. Follow any
     `\input` chains reachable from the `main/main.tex` preamble (before
     `\begin{document}`) to find where these values are really set —
     do not assume they're all literally in `main.tex`.
   - Re-emit the extracted title/author/affiliation/abstract/keyword
     text using the venue's own native macros from step 2. In
     particular, the abstract and keywords text pulled from
     `secs/00_abstract.tex`'s `\abstract{...}`/`\keywords{...}` is
     extracted and re-emitted through the venue's native
     abstract/keywords mechanism (e.g. an `abstract` environment,
     `\begin{abstract}...\end{abstract}`, or the venue's own
     `\keywords{...}` macro) — `secs/00_abstract.tex` itself is NOT
     `\input`-ed verbatim as a preamble call in the new `main.tex`,
     since the venue class won't define arXivTeX's `\abstract`/
     `\keywords` macros (or will define incompatible ones), causing a
     compile error or silently wrong output. This applies only to that
     title-metadata file; the rest of `secs/` (body sections such as
     `01_introduction.tex`) is still `\input` normally inside
     `\begin{document}`, unchanged from below.
   - Any paper-specific `\newcommand`/`\renewcommand` definitions from
     `main/main.tex`'s own preamble (e.g. this repo's
     `\newcommand{\method}{MethodName\xspace}`) — these aren't
     arXivTeX-framework macros, so they won't be in `compat.sty`, but
     the body content still relies on them. Carry them over into the
     generated `main.tex`'s preamble as-is.
   - The same `\input{secs/...}` order as `main/main.tex`, plus
     `\input{appx.tex}` if the original includes it.
   - `\bibliographystyle{...}` set to whatever the venue kit expects,
     and `\bibliography{main}` pointing at the copied `main.bib`.

   Mode-specific handling:
   - **camera-ready:** real author names, affiliations, and metadata
     links (`\code`, `\project`, `\dataset` values from `main/main.tex`).
   - **anonymous:** replace every author with "Anonymous Author(s)" and
     every affiliation with "Anonymous Institution"; replace
     `\code`/`\project`/`\dataset`/`\demo` URLs with the literal text
     "Link redacted for review"; enable the venue's anonymous-mode
     toggle found in step 2 if one exists.
7. **Build and iterate.** Run `latexmk -pdf` (or the kit's documented
   build command, if different) inside `submit/<venue>/`. Read
   compile errors and fix `compat.sty`/`main.tex` — never patch the
   venue's own `.cls`/`.sty`/`.bst` files to work around an error.
8. **Report.** Tell the user, in plain text:
   - What was auto-mapped (title/author fields, bib style, column
     macros).
   - Anything needing manual attention: page-limit overflow, a
     venue-mandated formatting rule not fully automated, a package the
     venue kit doesn't provide that the content relies on, or any
     content that could not be mapped 1:1.
   - Never silently drop content to make it compile — call out the
     gap instead.

## Guardrails

- Never modify anything under `main/`, including `main/main.bib`.
- Never modify the official venue `.cls`/`.sty`/`.bst` files copied
  into `submit/<venue>/` — if the official files seem to need a
  change, that means `compat.sty` or `main.tex` needs to change
  instead, or the issue belongs in the final report.
- Never fetch a venue template from the web or reconstruct one from
  memory. The user-supplied zip is the only source of truth.
- Re-running this skill after the user edits `main/` fully regenerates
  `submit/<venue>/` (byte-for-byte content, regenerated `main.tex`/
  `compat.sty`). There is no incremental/live sync — say so if asked.
