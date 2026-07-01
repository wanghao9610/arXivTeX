% arXiv LaTeX template

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{main}[2026/07/01 arXiv LaTeX template]
\LoadClassWithOptions{article}

% Page and typography
\RequirePackage[top=2.25cm,bottom=2.75cm,left=2.5cm,right=2.5cm,columnsep=0.7cm]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{textcomp}
\RequirePackage{lmodern}
\RequirePackage[scaled=0.95]{helvet}
\RequirePackage{microtype}
\RequirePackage{placeins}
\RequirePackage{hyphenat}
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage[english]{babel}
\RequirePackage{etoolbox}

\renewcommand*\ttdefault{cmvtt}
\renewcommand*\sfdefault{phv}
\DisableLigatures[f]{family=sf*}

% Math, figures, tables, and lists
\RequirePackage{amsmath,amsfonts,amssymb,mathtools}
\RequirePackage{bm}
\RequirePackage{xspace}
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{makecell}
\RequirePackage{colortbl}
\RequirePackage{nicematrix}
\RequirePackage{siunitx}
\RequirePackage{enumitem}
\RequirePackage{pifont}
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}
\makeatletter
\let\sysu@algorithmicx@algref\algref
\renewcommand{\theALG@line}{\thealgorithm.\arabic{ALG@line}}
\renewcommand{\theHALG@line}{\thealgorithm.\arabic{ALG@line}}
\makeatother

\setlist[itemize]{leftmargin=*,itemsep=2pt,topsep=3pt}
\setlist[enumerate]{leftmargin=*,itemsep=2pt,topsep=3pt}
\renewcommand{\algorithmicrequire}{\textbf{Input:}}
\renewcommand{\algorithmicensure}{\textbf{Output:}}

% Colors and boxed title panel
\RequirePackage[most]{tcolorbox}
\RequirePackage{xcolor}

\definecolor{sysugreen}{HTML}{006B4F}
\definecolor{accentdark}{HTML}{0F6B2A}
\definecolor{paperbg}{HTML}{F0F7F4}
\definecolor{inkfg}{HTML}{1A2E22}
\definecolor{rulecolor}{HTML}{006B4F}
\definecolor{captionlabel}{HTML}{1A8B3D}
\definecolor{titleframe}{HTML}{BBD8CC}
\definecolor{metabg}{HTML}{E7F2ED}
\definecolor{LightYellow}{HTML}{FEFBE8}
\definecolor{LightGreen}{HTML}{EAF6EE}
\definecolor{LightRed}{HTML}{FDECEA}
\definecolor{LightCyan}{HTML}{E6F6FA}
\definecolor{LightBlue}{HTML}{EAF1FB}
\definecolor{LightIndigo}{HTML}{EEF0FB}
\definecolor{LightGray}{HTML}{F2F4F7}

% Links and bibliography
\RequirePackage{url}
\RequirePackage{hyperref}
\RequirePackage[noabbrev,nameinlink]{cleveref}
\RequirePackage[numbers,sort&compress]{natbib}

\hypersetup{
  colorlinks,
  linkcolor=sysugreen,
  citecolor=sysugreen,
  urlcolor=sysugreen
}

\def\bibfont{\small}

% Optional metadata icons with text fallbacks.
\IfFileExists{fontawesome5.sty}{%
  \RequirePackage{fontawesome5}
  \newcommand{\saGithubIcon}{\faGithub}
  \newcommand{\saPlayIcon}{\faPlay}
  \newcommand{\saGlobeIcon}{\faGlobe}
  \newcommand{\saEnvelopeIcon}{\faEnvelope}
  \newcommand{\saCalendarIcon}{\faCalendar}
  \newcommand{\saDatabaseIcon}{\faDatabase}
}{%
  \newcommand{\saGithubIcon}{}
  \newcommand{\saPlayIcon}{}
  \newcommand{\saGlobeIcon}{}
  \newcommand{\saEnvelopeIcon}{}
  \newcommand{\saCalendarIcon}{}
  \newcommand{\saDatabaseIcon}{}
}

% Headings
\RequirePackage{titlesec}

\titleformat{\section}
  {\Large\sffamily\bfseries\color{sysugreen}}
  {\thesection}
  {0.6em}
  {}

\titleformat{\subsection}
  {\large\sffamily\bfseries\color{sysugreen}}
  {\thesubsection}
  {0.5em}
  {}

\titleformat{\subsubsection}
  {\normalsize\sffamily\bfseries\color{sysugreen}}
  {\thesubsubsection}
  {0.4em}
  {}

\titlespacing*{\section}{0pt}{3.0ex plus .6ex minus .2ex}{1.5ex plus .25ex}
\titlespacing*{\subsection}{0pt}{1.6ex plus .35ex minus .2ex}{1.0ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1.2ex plus .25ex minus .1ex}{0.5ex}

% Captions
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{pipe}{\enspace\textcolor{inkfg}{|}\enspace}
\DeclareCaptionFormat{elegant}{{\sffamily\bfseries\color{inkfg}#1#2}{\small\color{inkfg}#3}}
\captionsetup{
  singlelinecheck=false,
  format=elegant,
  labelsep=pipe,
  font=small,
  skip=6pt
}
% Small helpers copied out of the paper body into the template layer.
\newcommand{\cmark}{\ding{51}}
\newcommand{\xmark}{\ding{55}}
\newcommand{\headbf}[1]{{\sffamily\bfseries\color{sysugreen}#1}}
\newcommand{\paperparagraph}[1]{\par\noindent{\sffamily\bfseries\color{sysugreen}\spaceskip=0.35em #1.}\hspace{0.35em}\ignorespaces}
\providecommand{\figref}[1]{}
\renewcommand{\figref}[1]{Figure~\ref{#1}}
\providecommand{\tabref}[1]{}
\renewcommand{\tabref}[1]{Table~\ref{#1}}
\makeatletter
\renewcommand{\algref}[1]{\@ifnextchar\bgroup{\sysu@algline@ref{#1}}{Algorithm~\ref{#1}\xspace}}
\newcommand{\sysu@algline@ref}[2]{\sysu@algorithmicx@algref{#1}{#2}}
\makeatother
\providecommand{\eqnref}[1]{}
\renewcommand{\eqnref}[1]{Equation~\eqref{#1}}
\newcommand{\tablestyle}[2]{\setlength{\tabcolsep}{#1}\renewcommand{\arraystretch}{#2}\centering\small}
\newcolumntype{x}[1]{>{\centering\arraybackslash}p{#1pt}}
\newcolumntype{y}[1]{>{\raggedright\arraybackslash}p{#1pt}}
\newcolumntype{z}[1]{>{\raggedleft\arraybackslash}p{#1pt}}
\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{Y}{>{\centering\arraybackslash}X}

\makeatletter

% Title metadata state
\newcommand{\sa@title}{Untitled Paper}
\newcommand{\sa@authorlist}{}
\newcommand{\sa@affiliationlist}{}
\newcommand{\sa@contributionlist}{}
\newcommand{\sa@abstract}{}
\newcommand{\sa@keywords}{}
\newcommand{\sa@metadatalist}{}
\newcommand{\sa@metadatasep}{\par\vspace{0.15em}}

\newcommand{\sa@sups}[1]{\ifblank{#1}{}{\textsuperscript{\ensuremath{#1}}}}
\newcommand{\sa@authorformat}[2][]{%
  {\sffamily\bfseries\color{inkfg}#2\sa@sups{#1}}%
}
\newcommand{\sa@affiliationformat}[2][]{%
  {\small\color{inkfg}\sa@sups{#1}\ifblank{#1}{}{\ }#2}%
}
\newcommand{\sa@contributionformat}[2][]{%
  {\small\color{inkfg}\sa@sups{#1}\ifblank{#1}{}{\ }\textit{#2}}%
}
\newcommand{\sa@metadataformat}[2][]{%
  {\small\sffamily\color{inkfg}\ifblank{#1}{}{\textbf{#1}\enspace}#2}%
}

\renewcommand{\title}[1]{\gdef\sa@title{#1}}
\renewcommand{\author}[2][]{%
  \ifdefempty{\sa@authorlist}
    {\gdef\sa@authorlist{\sa@authorformat[#1]{#2}}}
    {\gappto\sa@authorlist{,\hspace{0.25em}\sa@authorformat[#1]{#2}}}%
}
\newcommand{\affiliation}[2][]{%
  \ifdefempty{\sa@affiliationlist}
    {\gdef\sa@affiliationlist{\sa@affiliationformat[#1]{#2}}}
    {\gappto\sa@affiliationlist{\enspace\textcolor{inkfg}{\textperiodcentered}\enspace\sa@affiliationformat[#1]{#2}}}%
}
\newcommand{\contribution}[2][]{%
  \ifdefempty{\sa@contributionlist}
    {\gdef\sa@contributionlist{\sa@contributionformat[#1]{#2}}}
    {\gappto\sa@contributionlist{,\enspace\sa@contributionformat[#1]{#2}}}%
}
\renewcommand{\abstract}[1]{\gdef\sa@abstract{#1}}
\newcommand{\keywords}[1]{\gdef\sa@keywords{#1}}
\newcommand{\metadata}[2][]{%
  \ifdefempty{\sa@metadatalist}
    {\gdef\sa@metadatalist{\sa@metadataformat[#1]{#2}}}
    {\gappto\sa@metadatalist{\sa@metadatasep\sa@metadataformat[#1]{#2}}}%
}

% Metadata convenience commands
\newcommand{\email}[1]{\href{mailto:#1}{\texttt{#1}}}
\newcommand{\code}[1]{\metadata[\saGithubIcon~Code:]{\url{#1}}}
\newcommand{\demo}[1]{\metadata[\saPlayIcon~Demo:]{\url{#1}}}
\newcommand{\project}[1]{\metadata[\saGlobeIcon~Project:]{\url{#1}}}
\newcommand{\dataset}[1]{\metadata[\saDatabaseIcon~Data:]{\url{#1}}}
\newcommand{\correspondence}[1]{\metadata[\saEnvelopeIcon~Contact:]{#1}}
\newcommand{\paperdate}[1]{\metadata[\saCalendarIcon~Date:]{#1}}
\renewcommand{\date}[1]{\paperdate{#1}}

\newcommand{\sa@maketitle}{%
  \begin{tcolorbox}[
    enhanced,
    colback=paperbg,
    colframe=titleframe,
    boxrule=0.45pt,
    arc=8pt,
    left=0.7cm,
    right=0.7cm,
    top=0.45cm,
    bottom=0.45cm,
    before skip=0pt,
    grow to left by=1pt,
    grow to right by=1pt,
    drop fuzzy shadow={black!10!white}
  ]
    \raggedright
    \nohyphens
    {\setstretch{1.35}{\huge\sffamily\bfseries\color{inkfg}\sa@title\par}}
    \vskip 0.10cm
    {\sa@authorlist\par}
    \ifdefempty{\sa@affiliationlist}{}{%
      \vskip 0.06cm
      {\sa@affiliationlist\par}
    }
    \ifdefempty{\sa@contributionlist}{}{%
      \vskip 0.02cm
      {\sa@contributionlist\par}
    }
    \ifdefempty{\sa@abstract}{}{%
      \vskip 0.10cm
      {\color{rulecolor!85}\rule{\linewidth}{0.65pt}}\par
      \vskip 0.10cm
      {\setstretch{1.08}\small\color{inkfg}\sa@abstract\par}
    }
    \ifdefempty{\sa@keywords}{}{%
      \vskip 0.08cm
      {\small\sffamily\textbf{\color{inkfg}Keywords:}\enspace\color{inkfg}\sa@keywords\par}
    }
    \ifdefempty{\sa@metadatalist}{}{%
      \vskip 0.10cm
      {\color{rulecolor!55}\rule{\linewidth}{0.45pt}}\par
      \vskip 0.10cm
      \begin{tcolorbox}[
        enhanced,
        frame hidden,
        colback=metabg,
        arc=5pt,
        boxsep=0pt,
        left=0.22cm,
        right=0.22cm,
        top=0.09cm,
        bottom=0.09cm
      ]
        {\setstretch{1.05}\sa@metadatalist\par}
      \end{tcolorbox}
    }
  \end{tcolorbox}
  \tcbset{reset}
  \FloatBarrier
}

\renewcommand{\maketitle}{%
  \hypersetup{pdftitle={\sa@title}}%
  \if@twocolumn
    \twocolumn[\sa@maketitle\vskip 0.4cm]%
  \else
    \sa@maketitle
  \fi
}

\newcommand{\beginappendix}{%
  \appendix
  \section*{Appendix}
  \addcontentsline{toc}{section}{Appendix}
}

\makeatother
