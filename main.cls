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
\definecolor{fancybg}{HTML}{F0F7F4}
\definecolor{inkfg}{HTML}{1A2E22}
\definecolor{titlefg}{HTML}{1A2E22}
\definecolor{rulecolor}{HTML}{006B4F}
\definecolor{titleframe}{HTML}{BBD8CC}
\definecolor{metabg}{HTML}{E7F2ED}
\definecolor{metalink}{HTML}{006B4F}
\definecolor{simplebg}{HTML}{F3F6F4}
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
  \definecolor{fancybg}{HTML}{F0F7F4}%
  \definecolor{inkfg}{HTML}{1A2E22}%
  \definecolor{titlefg}{HTML}{1A2E22}%
  \definecolor{rulecolor}{HTML}{006B4F}%
  \definecolor{titleframe}{HTML}{BBD8CC}%
  \definecolor{metabg}{HTML}{E7F2ED}%
  \definecolor{metalink}{HTML}{006B4F}%
  \definecolor{simplebg}{HTML}{F3F6F4}%
  \colorlet{accentcolor}{themegreen}%
  \sa@sync@linkcolors
}
\newcommand{\sa@theme@blue}{%
  \definecolor{themedark}{HTML}{004BB5}%
  \definecolor{fancybg}{HTML}{F1F7FE}%
  \definecolor{inkfg}{HTML}{172B3A}%
  \definecolor{titlefg}{HTML}{172B3A}%
  \definecolor{rulecolor}{HTML}{0052C7}%
  \definecolor{titleframe}{HTML}{BFD8F5}%
  \definecolor{metabg}{HTML}{E7F1FD}%
  \definecolor{metalink}{HTML}{0052C7}%
  \definecolor{simplebg}{HTML}{F3F7FC}%
  \colorlet{accentcolor}{themeblue}%
  \sa@sync@linkcolors
}
\newcommand{\sa@theme@black}{%
  \definecolor{themedark}{HTML}{111111}%
  \definecolor{fancybg}{HTML}{FFFFFF}%
  \definecolor{inkfg}{HTML}{111111}%
  \definecolor{titlefg}{HTML}{111111}%
  \definecolor{rulecolor}{HTML}{111111}%
  \definecolor{metabg}{HTML}{F3F4F6}%
  \definecolor{metalink}{HTML}{111111}%
  \definecolor{simplebg}{HTML}{F1F2F4}%
  \colorlet{accentcolor}{black}%
  \colorlet{titleframe}{black!22}%
  \sa@sync@linkcolors
}
\newcommand{\papercolor}[1]{%
  \@ifundefined{sa@theme@#1}{%
    \PackageError{main}{Unknown paper color `#1'}{Available colors are green, blue, and black.}%
  }{%
    \csname sa@theme@#1\endcsname
  }%
}
\newcommand{\papertheme}[1]{\papercolor{#1}}
\papercolor{green}
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
\newcommand{\parahead}[1]{\par\noindent{\sffamily\bfseries\color{accentcolor}\spaceskip=0.35em #1.}\hspace{0.35em}\ignorespaces}
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
\newcommand{\sa@paperstyle}{fancy}
\newcommand{\sa@authorsep}{,\hspace{0.25em}}
\newcommand{\sa@affiliationsep}{\enspace\textcolor{titlefg}{\textperiodcentered}\enspace}
\newcommand{\sa@contributionsep}{,\enspace}
\newlength{\sa@keywordsTopSkip}
\setlength{\sa@keywordsTopSkip}{0.22cm}

\newcommand{\sa@sups}[1]{\ifblank{#1}{}{\textsuperscript{\ensuremath{#1}}}}
\newcommand{\sa@authorformat}[2][]{%
  {\sffamily\bfseries\color{titlefg}#2\sa@sups{#1}}%
}
\newcommand{\sa@affiliationformat}[2][]{%
  {\small\color{titlefg}\sa@sups{#1}#2}%
}
\newcommand{\sa@contributionformat}[2][]{%
  {\small\color{titlefg}\sa@sups{#1}\textit{#2}}%
}
\newcommand{\sa@metadataformat}[2][]{%
  {\small\sffamily\color{titlefg}\ifblank{#1}{}{\textbf{#1}\enspace}#2}%
}

\renewcommand{\title}[1]{\gdef\sa@title{#1}}
\renewcommand{\author}[2][]{%
  \ifdefempty{\sa@authorlist}
    {\gdef\sa@authorlist{\sa@authorformat[#1]{#2}}}
    {\gappto\sa@authorlist{\sa@authorsep\sa@authorformat[#1]{#2}}}%
}
\newcommand{\affiliation}[2][]{%
  \ifdefempty{\sa@affiliationlist}
    {\gdef\sa@affiliationlist{\sa@affiliationformat[#1]{#2}}}
    {\gappto\sa@affiliationlist{\sa@affiliationsep\sa@affiliationformat[#1]{#2}}}%
}
\newcommand{\contribution}[2][]{%
  \ifdefempty{\sa@contributionlist}
    {\gdef\sa@contributionlist{\sa@contributionformat[#1]{#2}}}
    {\gappto\sa@contributionlist{\sa@contributionsep\sa@contributionformat[#1]{#2}}}%
}
\renewcommand{\abstract}[1]{\gdef\sa@abstract{#1}}
\newcommand{\keywords}[1]{\gdef\sa@keywords{#1}}
\newcommand{\metadata}[2][]{%
  \ifdefempty{\sa@metadatalist}
    {\gdef\sa@metadatalist{\sa@metadataformat[#1]{#2}}}
    {\gappto\sa@metadatalist{\sa@metadatasep\sa@metadataformat[#1]{#2}}}%
}

% Metadata convenience commands
\newcommand{\sa@metalabel}[2]{#1~#2}
\newcommand{\sa@metadataurl}[1]{\href{#1}{\textcolor{metalink}{\nolinkurl{#1}}}}
\newcommand{\email}[1]{\href{mailto:#1}{\textcolor{metalink}{\texttt{#1}}}}
\newcommand{\code}[1]{\metadata[\sa@metalabel{\saGithubIcon}{Code:}]{\sa@metadataurl{#1}}}
\newcommand{\demo}[1]{\metadata[\sa@metalabel{\saPlayIcon}{Demo:}]{\sa@metadataurl{#1}}}
\newcommand{\project}[1]{\metadata[\sa@metalabel{\saGlobeIcon}{Project:}]{\sa@metadataurl{#1}}}
\newcommand{\dataset}[1]{\metadata[\sa@metalabel{\saDatabaseIcon}{Data:}]{\sa@metadataurl{#1}}}
\newcommand{\correspondence}[1]{\metadata[\sa@metalabel{\saEnvelopeIcon}{Contact:}]{#1}}
\newcommand{\paperdate}[1]{\metadata[\sa@metalabel{\saCalendarIcon}{Date:}]{#1}}
\renewcommand{\date}[1]{\paperdate{#1}}

\newcommand{\paperstyle}[1]{%
  \@ifundefined{sa@maketitle@#1}{%
    \PackageError{main}{Unknown paper style `#1'}{Available styles are fancy and simple.}%
  }{%
    \gdef\sa@paperstyle{#1}%
  }%
}

\newcommand{\sa@titleblock@typography}{%
  \renewcommand{\sa@authorformat}[2][]{%
    {\sffamily\bfseries\color{titlefg}##2\sa@sups{##1}}%
  }%
  \renewcommand{\sa@affiliationformat}[2][]{%
    {\normalsize\rmfamily\color{titlefg}\sa@sups{##1}##2}%
  }%
  \renewcommand{\sa@contributionformat}[2][]{%
    {\normalsize\rmfamily\color{titlefg}\sa@sups{##1}\textit{##2}}%
  }%
  \renewcommand{\sa@metadataformat}[2][]{%
    {\normalsize\sffamily\color{titlefg}\ifblank{##1}{}{\textbf{##1}\enspace}##2}%
  }%
  \renewcommand{\sa@authorsep}{,\hspace{0.25em}}%
  \renewcommand{\sa@affiliationsep}{\enspace\textcolor{titlefg}{\textperiodcentered}\enspace}%
  \renewcommand{\sa@contributionsep}{,\enspace}%
  \renewcommand{\sa@metadatasep}{\par\vspace{0.10em}}%
}

\newcommand{\sa@simple@titleblock@typography}{%
  \renewcommand{\sa@authorformat}[2][]{%
    {\sffamily\bfseries\color{titlefg}##2{\normalfont\sa@sups{##1}}}%
  }%
  \renewcommand{\sa@affiliationformat}[2][]{%
    {\normalsize\rmfamily\color{titlefg}\sa@sups{##1}##2}%
  }%
  \renewcommand{\sa@contributionformat}[2][]{%
    {\normalsize\rmfamily\color{titlefg}\sa@sups{##1}##2}%
  }%
  \renewcommand{\sa@metadataformat}[2][]{%
    {\normalsize\color{titlefg}\ifblank{##1}{}{{\sffamily\bfseries ##1}\enspace}{\normalfont\rmfamily ##2}}%
  }%
  \renewcommand{\sa@authorsep}{,\hspace{0.32em}}%
  \renewcommand{\sa@affiliationsep}{,\enspace}%
  \renewcommand{\sa@contributionsep}{,\enspace}%
  \renewcommand{\sa@metadatasep}{\par\vspace{0.10em}}%
}

\newcommand{\sa@fancydivider}{%
  {\color{rulecolor!85}\rule{\linewidth}{0.65pt}}\par\vspace{-\parskip}%
}

\newcommand{\sa@fancymetadivider}{%
  {\color{rulecolor!55}\rule{\linewidth}{0.45pt}}\par\vspace{-\parskip}%
}

\newcommand{\sa@maketitle@fancy}{%
  \begingroup
    \sa@titleblock@typography
    \begin{tcolorbox}[
      enhanced,
      colback=fancybg,
      colframe=titleframe,
      boxrule=0.45pt,
      arc=8pt,
      boxsep=0pt,
      left=0.7cm,
      right=0.7cm,
      top=0.26cm,
      bottom=0.28cm,
      before skip=0pt,
      grow to left by=1pt,
      grow to right by=1pt,
      drop fuzzy shadow={black!10!white}
    ]
      \raggedright
      \nohyphens
      {\setstretch{1.20}{\huge\sffamily\bfseries\color{titlefg}\sa@title\par}}
      \vskip 0.14cm
      {\setstretch{1.12}\large\sa@authorlist\par}
      \ifdefempty{\sa@affiliationlist}{}{%
        \vskip 0.08cm
        {\sa@affiliationlist\par}
      }
      \ifdefempty{\sa@contributionlist}{}{%
        \vskip 0.02cm
        {\sa@contributionlist\par}
      }
      \ifdefempty{\sa@abstract}{}{%
        \vskip 0.08cm
        \sa@fancydivider
        \vskip 0.08cm
        {\setstretch{1.14}\large\rmfamily\color{inkfg}\sa@abstract\par}
      }
      \ifdefempty{\sa@keywords}{}{%
        \vskip 0.20cm
        {\normalsize\sffamily\textbf{\color{titlefg}Keywords:}\enspace\color{titlefg}\sa@keywords\par}
      }
      \ifdefempty{\sa@metadatalist}{}{%
        \vskip 0.03cm
        \sa@fancymetadivider
        \vskip 0.02cm
        \begin{tcolorbox}[
          enhanced,
          frame hidden,
          colback=metabg,
          arc=5pt,
          boxsep=0pt,
          left=0.22cm,
          right=0.22cm,
          top=0.06cm,
          bottom=0.13cm
        ]
          {\setstretch{1.08}\sa@metadatalist\par}
        \end{tcolorbox}
      }
    \end{tcolorbox}
  \endgroup
  \tcbset{reset}
  \FloatBarrier
}

\newcommand{\sa@maketitle@simple}{%
  \begingroup
    \sa@simple@titleblock@typography
    \renewcommand{\sa@metalabel}[2]{##2}%
    \begin{tcolorbox}[
      enhanced,
      frame hidden,
      colback=simplebg,
      arc=10pt,
      boxsep=0pt,
      left=0.7cm,
      right=0.7cm,
      top=0.45cm,
      bottom=0.45cm,
      before skip=0pt,
      grow to left by=1pt,
      grow to right by=1pt
    ]
      \raggedright
      \nohyphens
      {\setstretch{1.20}{\huge\sffamily\bfseries\color{titlefg}\sa@title\par}}
      \vskip 0.20cm
      {\setstretch{1.12}\large\sa@authorlist\par}
      \ifdefempty{\sa@affiliationlist}{}{%
        \vskip 0.18cm
        {\setstretch{1.05}\sa@affiliationlist\par}
      }
      \ifdefempty{\sa@contributionlist}{}{%
        \vskip 0.04cm
        {\setstretch{1.05}\sa@contributionlist\par}
      }
      \ifdefempty{\sa@abstract}{}{%
        \vskip 0.45cm
        {\setstretch{1.14}\large\rmfamily\color{inkfg}\sa@abstract\par}
      }
      \ifdefempty{\sa@keywords}{}{%
        \vskip 0.25cm
        {\normalsize\sffamily\textbf{\color{titlefg}Keywords:}\enspace\color{titlefg}\sa@keywords\par}
      }
      \ifdefempty{\sa@metadatalist}{}{%
        \vskip 0.32cm
        {\setstretch{1.08}\sa@metadatalist\par}
      }
    \end{tcolorbox}
  \endgroup
  \tcbset{reset}
  \FloatBarrier
}

\newcommand{\sa@maketitle}{%
  \csname sa@maketitle@\sa@paperstyle\endcsname
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
