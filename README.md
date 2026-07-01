# arXiv TeX Template

A compact arXiv-style LaTeX template extracted and generalized from the X2SAM
paper layouts. The repository now follows the same modular paper organization
used by the ECCV-style project: `main/main.tex` is the entry point, while
sections, figures, tables, algorithms, appendix material, and bibliography data
live in separate files under `main/`.

## Features

- Article-based class with one-column and two-column support.
- Title panel with title, authors, affiliations, contribution notes, abstract,
  keywords, project links, code links, dataset links, date, and contact email.
- Selectable green, blue, and black themes for the title panel, section
  headings, captions, links, lists, tables, and bibliography.
- Common paper helpers: `\paperparagraph`, `\tablestyle`, `\cmark`, `\xmark`,
  compact table column types, `cleveref`, and `natbib`.
- No external font assets. The template uses standard TeX Live fonts to keep
  GitHub and arXiv submissions portable.

## Project Organization

The layout mirrors a larger paper repository while staying small enough for a
starter template:

```text
.
+-- main/                 # Main paper source tree used for local builds
|   +-- main.tex          # Entry point: metadata, global macros, input order
|   +-- main.cls          # Reusable arXiv-style class
|   +-- main.bib          # BibTeX entries
|   +-- appx.tex          # Optional appendix entry
|   +-- secs/             # Main paper section fragments
|   |   +-- 00_abstract.tex
|   |   +-- 01_introduction.tex
|   |   +-- 02_method.tex
|   |   +-- 03_experiments.tex
|   |   +-- 09_conclusion.tex
|   |   +-- 10_results.tex
|   |   +-- 11_reproducibility.tex
|   +-- figs/             # Figure environment wrappers
|   |   +-- 00_teaser.tex
|   |   +-- 10_figure.tex
|   |   +-- srcs/         # Raw PDF/PNG/JPG assets
|   +-- tabs/             # Table environment wrappers
|   |   +-- 00_example.tex
|   |   +-- 10_extra.tex
|   +-- algs/             # Algorithm environment wrappers
|       +-- 00_example.tex
|       +-- 10_procedure.tex
+-- arXiv/                # Generated flattened submission package
+-- .temp/                # Generated build files
+-- .vscode/settings.json # Optional LaTeX Workshop settings
+-- Makefile              # Build commands
```

Recommended convention:

### File naming

All modular files under `main/secs/`, `main/figs/`, `main/tabs/`, and
`main/algs/` (and raw assets under `main/figs/srcs/`) use a two-digit prefix
before the descriptive name:

| Digit | Meaning |
| --- | --- |
| First (`0`, `1`, …) | Paper part: `0` = main body, `1` = appendix |
| Second (`0`, `1`, …) | Order within that part |

Examples:

| Folder | Main body | Appendix |
| --- | --- | --- |
| `main/secs/` | `00_abstract.tex`, `01_introduction.tex` | `10_results.tex` |
| `main/figs/` | `00_teaser.tex`, `01_framework.tex` | `10_figure.tex` |
| `main/figs/srcs/` | `00_teaser.pdf`, `01_framework.pdf` | `10_figure.pdf` |
| `main/tabs/` | `00_main_results.tex` | `10_extra.tex` |
| `main/algs/` | `00_training.tex` | `10_pseudocode.tex` |

Keep wrapper and asset basenames aligned (for example,
`main/figs/00_teaser.tex` points to `main/figs/srcs/00_teaser.pdf`).

### Layout

- Put section fragments in `main/secs/` and include them from
  `main/main.tex`.
- Put figure environments in `main/figs/` and raw assets in
  `main/figs/srcs/`.
- Put long table code in `main/tabs/` and include it with
  `\input{tabs/...}`.
- Put algorithm environments in `main/algs/`.
- Keep project-specific macros in `main/main.tex`; keep reusable presentation
  logic in `main/main.cls`.

### Folder guide

- `main/secs/`: store section fragments and include them from
  `main/main.tex` with
  `\input{secs/...}`. Examples include `00_abstract.tex`,
  `01_introduction.tex`, and `10_results.tex`.
- `main/figs/`: store reusable `\begin{figure}...\end{figure}` blocks and
  include them from section files with `\input{figs/...}`. Examples include
  `00_teaser.tex`, `01_framework.tex`, and `10_figure.tex`.
- `main/figs/srcs/`: store raw figure files such as PDF, PNG, or JPG assets.
  Reference them from figure wrappers with paths such as
  `figs/srcs/00_teaser.pdf`. Use the same basename as the matching wrapper
  when possible.
- `main/tabs/`: store reusable `\begin{table}...\end{table}` blocks and
  include them from section files with `\input{tabs/...}`. Examples include
  `00_main_results.tex` and `10_extra_results.tex`.
- `main/algs/`: store reusable `\begin{algorithm}...\end{algorithm}` blocks and
  include them from section files with `\input{algs/...}`. Examples include
  `00_training.tex` and `10_pseudocode.tex`.

The same two-digit prefix scheme applies to `main/secs/`, `main/figs/`,
`main/figs/srcs/`, `main/tabs/`, and `main/algs/`.

## Quick Start

Compile the example:

```bash
make
```

The default build target writes generated files to `.temp/`:

```text
.temp/main.pdf
```

or run LaTeX directly:

```bash
cd main && latexmk -pdf -outdir=../.temp main.tex
```

Clean generated files:

```bash
make clean
```

Prepare a flattened arXiv source bundle:

```bash
make arxiv
```

This writes the flattened upload entry file directly to `arXiv/main.tex`.

## Minimal Example

```tex
\documentclass[twocolumn]{main}

\papertheme{green}

\title{Your Paper Title}
\author[1]{First Author}
\author[1,2]{Second Author}
\affiliation[1]{Example University}
\affiliation[2]{Example Research Lab}

\abstract{Write a concise summary of the paper.}
\keywords{keyword one, keyword two}
\date{\today}
\code{https://github.com/your-name/your-project}
\project{https://your-name.github.io/your-project}
\correspondence{\email{name@example.com}}

\input{secs/00_abstract.tex}

\begin{document}
\maketitle

\section{Introduction}
Your paper starts here.
\input{figs/00_teaser.tex}

\bibliographystyle{unsrtnat}
\bibliography{main}
\end{document}
```

## Adding Content

Add a new section:

```tex
% main/main.tex
\input{secs/04_more_experiments.tex}
```

Add a new figure:

```tex
% main/figs/01_framework.tex
\begin{figure}[t]
  \centering
  \includegraphics[width=\linewidth]{figs/srcs/01_framework.pdf}
  \caption{Overview of the proposed framework.}
  \label{fig:framework}
\end{figure}
```

Add a new table:

```tex
% main/tabs/01_main_results.tex
\begin{table}[t]
  \tablestyle{4pt}{1.1}
  \caption{Main results.}
  \label{tab:main_results}
  \begin{tabular}{lcc}
    \toprule
    Method & Score & Speed \\
    \midrule
    Baseline & 82.1 & 1.0x \\
    Ours & 85.4 & 1.1x \\
    \bottomrule
  \end{tabular}
\end{table}
```

The starter paper includes the appendix through this line near the end of
`main/main.tex`:

```tex
\input{appx.tex}
```

The appendix entry file is `main/appx.tex`. It starts the appendix and then
includes appendix-specific modules:

```tex
\clearpage
\beginappendix

\input{secs/10_results.tex}
\input{secs/11_reproducibility.tex}
```

Appendix-specific figures, tables, and algorithms should use the same prefix
range:

- `main/figs/10_figure.tex`
- `main/tabs/10_extra.tex`
- `main/algs/10_procedure.tex`

Comment this line when drafting a main-body-only paper. Keep it enabled when you
want the example PDF to include the appendix pages.

## Class API

Use these commands before `\begin{document}`:

| Command | Purpose |
| --- | --- |
| `\papertheme{green}` | Selects a theme. Available themes: `green`, `blue`, `black`. |
| `\title{...}` | Paper title shown in the title panel. |
| `\author[1,2]{Name}` | Adds an author with optional affiliation markers. |
| `\affiliation[1]{Institution}` | Adds an affiliation. |
| `\contribution[\dagger]{Text}` | Adds contribution or equal-contribution notes. |
| `\abstract{...}` | Adds the abstract to the title panel. |
| `\keywords{...}` | Adds keywords below the abstract. |
| `\code{URL}` | Adds a code link. |
| `\project{URL}` | Adds a project-page link. |
| `\dataset{URL}` | Adds a dataset link. |
| `\demo{URL}` | Adds a demo link. |
| `\correspondence{...}` | Adds contact information. |
| `\metadata[Label:]{Value}` | Adds a custom metadata row. |

Use these commands in the paper body:

| Command | Purpose |
| --- | --- |
| `\paperparagraph{Title}` | Inline theme-colored sans-serif bold paragraph heading. |
| `\figref{fig:label}` | Figure reference styled as `Figure 1`. |
| `\tabref{tab:label}` | Table reference styled as `Table 1`. |
| `\algref{alg:label}` | Algorithm reference styled as `Algorithm 1`. |
| `\eqnref{eq:label}` | Equation reference styled as `Equation (1)`. |
| `\tablestyle{4pt}{1.1}` | Sets table column spacing and row stretch. |
| `\cmark`, `\xmark` | Check and cross symbols for comparison tables. |
| `x`, `y`, `z`, `P`, `Y` column types | Compact table column helpers. |

## Repository Layout

See [Project Organization](#project-organization).

## arXiv Notes

- For a modular working tree, run `make arxiv` after editing. The command runs
  `latexpand main.tex > ../arXiv/main.tex` from `main/`, then prepares the
  rest of `arXiv/` with the local class, bibliography, and figure assets.
- Submit the contents of `arXiv/`. The package entry point is
  `arXiv/main.tex`.
- The automation copies `main/*.cls`, `main/*.sty`, `main/*.bst`,
  `main/*.bib`, `main/*.bbx`, and `main/*.cbx` files. It copies source-tree
  assets from `main/figs/srcs/` into `arXiv/srcs/` and rewrites the flattened
  `arXiv/main.tex` paths accordingly. It also copies `main/srcs/` and
  `main/asts/` when present, matching the
  flatter X2SAM-style source tree.
- Keep project-specific macros in `main/main.tex`, not in
  `main/main.cls`.
- Prefer PDF, PNG, or JPG figures and avoid absolute file paths.
- Do not submit `.temp/`, editor settings, SyncTeX files, logs, or local preview
  PDFs.
- If arXiv reports a missing package, move that feature from the class into the
  paper source or remove it before submission.

Advanced usage:

```bash
MAIN=submission.tex ARXIV_DIR=submission-arXiv make arxiv
```

## License

This template is released under the MIT License. Update the license if your
paper or institution requires a different policy.
