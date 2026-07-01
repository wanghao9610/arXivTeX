#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$ROOT/.temp/title-spacing-smoke"

rg -n '\\newlength\{\\sa@keywordsTopSkip\}' "$ROOT/main/main.cls" >/dev/null
rg -n '\\setlength\{\\sa@keywordsTopSkip\}\{0\.14cm\}' "$ROOT/main/main.cls" >/dev/null
rg -n '\\vskip \\sa@keywordsTopSkip' "$ROOT/main/main.cls" >/dev/null
if rg -n '\\ifdefempty\{\\sa@keywords\}\{\}\{[[:space:]]*%?[[:space:]]*\\vskip 0\.08cm' "$ROOT/main/main.cls"; then
  echo "Keywords should use the enlarged named top skip, not the old 0.08cm skip." >&2
  exit 1
fi

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

for theme in green blue black; do
  cat > "$TMP_DIR/${theme}.tex" <<TEX
\documentclass{main}
\papertheme{${theme}}
\title{Title Spacing Smoke Test}
\author{Example Author}
\abstract{The abstract should have a little more breathing room before keywords.}
\keywords{layout, spacing, title panel}
\date{July 1, 2026}
\project{https://example.com/project}
\begin{document}
\maketitle
\end{document}
TEX

  TEXINPUTS="$ROOT/main:" latexmk \
    -pdf \
    -interaction=nonstopmode \
    -halt-on-error \
    -outdir="$TMP_DIR/out-$theme" \
    "$TMP_DIR/${theme}.tex" >/dev/null
done
