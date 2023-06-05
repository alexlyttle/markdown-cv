\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cv}[2023/06/04 CV class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage{graphicx}
\RequirePackage{graphbox}
\graphicspath{{./images/}}

%% COMMANDS
\newcommand{\subtitle}[1]{%
  \def\cv@subtitle{#1}}
\newcommand{\location}[1]{%
  \def\cv@location{\includegraphics[align=c,height=1em]{location.pdf} #1}}
\newcommand{\phone}[1]{%
  \def\cv@phone{\href{tel:#1}{\includegraphics[align=c,height=1em]{call.pdf} #1}}}
\newcommand{\email}[1]{%
  \def\cv@email{\href{mailto:#1}{\includegraphics[align=c,height=1em]{mail.pdf} #1}}}
\newcommand{\website}[1]{%
  \def\cv@website{\href{https://#1}{\includegraphics[align=c,height=1em]{home.pdf} #1}}}

%% TITLE
\renewcommand*{\maketitle}{%
  \thispagestyle{empty}
  \vskip 2em
  \begin{center}
    {\LARGE\bfseries \@title \par\vskip 0.3em}%
    \ifdefined\cv@subtitle
    {\normalsize \cv@subtitle \par}%
    \fi
    \normalsize
    \ifdefined\cv@location
      {\cv@location \par}%
    \fi
    \ifdefined\cv@phone\cv@phone~\fi
    \ifdefined\cv@email\cv@email~\fi
    \ifdefined\cv@website\cv@website~\fi
  \end{center}
  \par\vskip 1em
}

%% HEADER AND FOOTER
\RequirePackage{fancyhdr}
\AtBeginDocument{%
  \pagestyle{fancy}
  \fancyhead{} % clear all header fields
  \fancyhead[L]{%
    \ifdefined\@author\@author~\fi
    \ifdefined\cv@phone\cv@phone~\fi
    \ifdefined\cv@email\cv@email~\fi}
  \fancyfoot{} % clear all footer fields
  \fancyfoot[R]{\small Page \thepage}
}
