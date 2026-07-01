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
\let\sa@algorithmicx@algref\algref
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

\definecolor{themegreen}{HTML}{006B4F}
\definecolor{themeblue}{HTML}{0052C7}
\definecolor{themedark}{HTML}{0F6B2A}
\definecolor{paperbg}{HTML}{F0F7F4}
\definecolor{inkfg}{HTML}{1A2E22}
\definecolor{titlefg}{HTML}{1A2E22}
\definecolor{rulecolor}{HTML}{006B4F}
\definecolor{titleframe}{HTML}{BBD8CC}
\definecolor{metabg}{HTML}{E7F2ED}
\definecolor{metalink}{HTML}{006B4F}
\definecolor{LightYellow}{HTML}{FEFBE8}
\definecolor{LightGreen}{HTML}{EAF6EE}
\definecolor{LightRed}{HTML}{FDECEA}
\definecolor{LightCyan}{HTML}{E6F6FA}
\definecolor{LightBlue}{HTML}{EAF1FB}
\definecolor{LightIndigo}{HTML}{EEF0FB}
\definecolor{LightGray}{HTML}{F2F4F7}
\colorlet{accentcolor}{themegreen}

\makeatletter
\newcommand{\sa@sync@linkcolors}{%
  \@ifpackageloaded{hyperref}{%
    \hypersetup{%
      linkcolor=accentcolor,
      citecolor=accentcolor,
      urlcolor=accentcolor
    }%
  }{}%
}
\newcommand{\sa@theme@green}{%
  \definecolor{themegreen}{HTML}{006B4F}%
  \definecolor{themedark}{HTML}{0F6B2A}%
  \definecolor{paperbg}{HTML}{F0F7F4}%
  \definecolor{inkfg}{HTML}{1A2E22}%
  \definecolor{titlefg}{HTML}{1A2E22}%
  \definecolor{rulecolor}{HTML}{006B4F}%
  \definecolor{titleframe}{HTML}{BBD8CC}%
  \definecolor{metabg}{HTML}{E7F2ED}%
  \definecolor{metalink}{HTML}{006B4F}%
  \colorlet{accentcolor}{themegreen}%
  \sa@sync@linkcolors
}
\newcommand{\sa@theme@blue}{%
  \definecolor{themedark}{HTML}{004BB5}%
  \definecolor{paperbg}{HTML}{F1F7FE}%
  \definecolor{inkfg}{HTML}{172B3A}%
  \definecolor{titlefg}{HTML}{172B3A}%
  \definecolor{rulecolor}{HTML}{0052C7}%
  \definecolor{titleframe}{HTML}{BFD8F5}%
  \definecolor{metabg}{HTML}{E7F1FD}%
  \definecolor{metalink}{HTML}{0052C7}%
  \colorlet{accentcolor}{themeblue}%
  \sa@sync@linkcolors
}
\newcommand{\sa@theme@black}{%
  \definecolor{themedark}{HTML}{111111}%
  \definecolor{paperbg}{HTML}{FFFFFF}%
  \definecolor{inkfg}{HTML}{111111}%
  \definecolor{titlefg}{HTML}{111111}%
  \definecolor{rulecolor}{HTML}{111111}%
  \definecolor{metabg}{HTML}{F3F4F6}%
  \definecolor{metalink}{HTML}{111111}%
  \colorlet{accentcolor}{black}%
  \colorlet{titleframe}{black!22}%
  \sa@sync@linkcolors
}
\newcommand{\papertheme}[1]{%
  \@ifundefined{sa@theme@#1}{%
    \PackageError{main}{Unknown paper theme `#1'}{Available themes are green, blue, and black.}%
  }{%
    \csname sa@theme@#1\endcsname
  }%
}
\papertheme{green}
\makeatother

% Links and bibliography
\RequirePackage{url}
\RequirePackage{hyperref}
\RequirePackage[noabbrev,nameinlink]{cleveref}
\RequirePackage[numbers,sort&compress]{natbib}

\hypersetup{
  colorlinks,
  linkcolor=accentcolor,
  citecolor=accentcolor,
  urlcolor=accentcolor
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
  {\Large\sffamily\bfseries\color{accentcolor}}
  {\thesection}
  {0.6em}
  {}

\titleformat{\subsection}
  {\large\sffamily\bfseries\color{accentcolor}}
  {\thesubsection}
  {0.5em}
  {}

\titleformat{\subsubsection}
  {\normalsize\sffamily\bfseries\color{accentcolor}}
  {\thesubsubsection}
  {0.4em}
  {}

\titlespacing*{\section}{0pt}{3.0ex plus .6ex minus .2ex}{1.5ex plus .25ex}
\titlespacing*{\subsection}{0pt}{1.6ex plus .35ex minus .2ex}{1.0ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1.2ex plus .25ex minus .1ex}{0.5ex}

% Captions
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{pipe}{\enspace\textcolor{black}{|}\enspace}
\DeclareCaptionFormat{elegant}{{\sffamily\bfseries\color{black}#1#2}{\small\color{black}#3}}
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
\newcommand{\headbf}[1]{{\sffamily\bfseries\color{accentcolor}#1}}
\newcommand{\paperparagraph}[1]{\par\noindent{\sffamily\bfseries\color{accentcolor}\spaceskip=0.35em #1.}\hspace{0.35em}\ignorespaces}
\providecommand{\figref}[1]{}
\renewcommand{\figref}[1]{Figure~\ref{#1}}
\providecommand{\tabref}[1]{}
\renewcommand{\tabref}[1]{Table~\ref{#1}}
\makeatletter
\renewcommand{\algref}[1]{\@ifnextchar\bgroup{\sa@algline@ref{#1}}{Algorithm~\ref{#1}\xspace}}
\newcommand{\sa@algline@ref}[2]{\sa@algorithmicx@algref{#1}{#2}}
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
\newlength{\sa@keywordsTopSkip}
\setlength{\sa@keywordsTopSkip}{0.22cm}

\newcommand{\sa@sups}[1]{\ifblank{#1}{}{\textsuperscript{\ensuremath{#1}}}}
\newcommand{\sa@authorformat}[2][]{%
  {\sffamily\bfseries\color{titlefg}#2\sa@sups{#1}}%
}
\newcommand{\sa@affiliationformat}[2][]{%
  {\small\color{titlefg}\sa@sups{#1}\ifblank{#1}{}{\ }#2}%
}
\newcommand{\sa@contributionformat}[2][]{%
  {\small\color{titlefg}\sa@sups{#1}\ifblank{#1}{}{\ }\textit{#2}}%
}
\newcommand{\sa@metadataformat}[2][]{%
  {\small\sffamily\color{titlefg}\ifblank{#1}{}{\textbf{#1}\enspace}#2}%
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
    {\gappto\sa@affiliationlist{\enspace\textcolor{titlefg}{\textperiodcentered}\enspace\sa@affiliationformat[#1]{#2}}}%
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
\newcommand{\sa@metadataurl}[1]{\href{#1}{\textcolor{metalink}{\nolinkurl{#1}}}}
\newcommand{\email}[1]{\href{mailto:#1}{\textcolor{metalink}{\texttt{#1}}}}
\newcommand{\code}[1]{\metadata[\saGithubIcon~Code:]{\sa@metadataurl{#1}}}
\newcommand{\demo}[1]{\metadata[\saPlayIcon~Demo:]{\sa@metadataurl{#1}}}
\newcommand{\project}[1]{\metadata[\saGlobeIcon~Project:]{\sa@metadataurl{#1}}}
\newcommand{\dataset}[1]{\metadata[\saDatabaseIcon~Data:]{\sa@metadataurl{#1}}}
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
    {\setstretch{1.35}{\huge\sffamily\bfseries\color{titlefg}\sa@title\par}}
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
      {\setstretch{1.08}\small\color{titlefg}\sa@abstract\par}
    }
    \ifdefempty{\sa@keywords}{}{%
      \vskip \sa@keywordsTopSkip
      {\small\sffamily\textbf{\color{titlefg}Keywords:}\enspace\color{titlefg}\sa@keywords\par}
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
