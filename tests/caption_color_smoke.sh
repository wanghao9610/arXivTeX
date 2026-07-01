#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$ROOT/.temp/caption-color-smoke"

rg -n 'DeclareCaptionLabelSeparator\{pipe\}.*textcolor\{black\}' "$ROOT/main/main.cls" >/dev/null
rg -n 'DeclareCaptionFormat\{elegant\}.*\\color\{black\}#1#2.*\\color\{black\}#3' "$ROOT/main/main.cls" >/dev/null
if rg -n 'DeclareCaption(LabelSeparator|Format).*captionlabel|DeclareCaptionFormat.*inkfg' "$ROOT/main/main.cls"; then
  echo "Caption formatting should not use theme colors." >&2
  exit 1
fi
if rg -n 'captionlabel' "$ROOT/main/main.cls"; then
  echo "Caption theme color definitions should be removed." >&2
  exit 1
fi

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

for theme in green blue black; do
  cat > "$TMP_DIR/${theme}.tex" <<TEX
\documentclass{main}
\papertheme{${theme}}
\title{Caption Color Smoke Test}
\author{Example Author}
\abstract{Caption colors should remain black in every theme.}
\begin{document}
\maketitle
\begin{figure}[h]
  \centering
  \fbox{Figure body}
  \caption{Figure caption should be black.}
\end{figure}
\begin{table}[h]
  \centering
  \caption{Table caption should be black.}
  \begin{tabular}{lc}
    \toprule
    Item & Value \\\\
    \midrule
    A & 1 \\\\
    \bottomrule
  \end{tabular}
\end{table}
\end{document}
TEX

  TEXINPUTS="$ROOT/main:" latexmk \
    -pdf \
    -interaction=nonstopmode \
    -halt-on-error \
    -outdir="$TMP_DIR/out-$theme" \
    "$TMP_DIR/${theme}.tex" >/dev/null
done
