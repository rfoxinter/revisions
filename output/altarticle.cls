\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{altarticle}[Modified LaTeX article class]

%%% Parse options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{prefix=altarticle@}
\DeclareStringOption[margin=2.5cm]{geometryargs}
\DeclareStringOption[french]{babellanguage}
\DeclareBoolOption{unslantgreek}
\DeclareBoolOption{defaulttheorems}
\DeclareBoolOption{bibliography}
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*
\PassOptionsToPackage{\altarticle@babellanguage}{babel}
\PassOptionsToPackage{\altarticle@geometryargs}{geometry}

%%% Import packages and options
\LoadClass[a4paper]{article}
\usepackage{ifpdf}
\usepackage[utf8]{inputenc}
\usepackage{babel}
\usepackage[T1]{fontenc}
\usepackage{fix-cm}
\usepackage{geometry}
\usepackage{amsmath, amsfonts, amssymb, stmaryrd}
\SetSymbolFont{stmry}{bold}{U}{stmry}{m}{n}
\PassOptionsToPackage{obeyspaces,hyphens}{url}
\usepackage{hyperref}
\hypersetup{hidelinks,colorlinks=false,linktoc=all}
\let\oldurl\url
\renewcommand{\url}[1]{{\color{blue}\oldurl{#1}}}
\usepackage{etoolbox}
\usepackage{microtype}
\DisableLigatures{encoding = OML}
\usepackage{framed}
\usepackage{graphicx}
\usepackage{csquotes}
\usepackage{enumitem}
\let\propenumerate\relax
\newlist{propenumerate}{enumerate}{10}
\newcommand{\itemnb}[1]{(\oldstylenums{#1})}
\setlist[propenumerate]{leftmargin=0.075\linewidth,topsep=0pt,nosep,label=\itemnb{\arabic*},beginpenalty=999}
\setlist[enumerate]{topsep=0pt,nosep,label=\itemnb{\arabic*}}
\setlist[itemize]{topsep=0pt,nosep,label=$\to$}
\let\prvitemize\relax
\newlist{prvitemize}{itemize}{10}
\setlist[prvitemize]{topsep=0pt,nosep,leftmargin=*,labelsep=0pt,label=$\to{}$}
\usepackage{tabularray}
\SetTblrInner{rowsep=1pt}
\DefTblrTemplate{caption-tag}{default}{}
\DefTblrTemplate{caption-sep}{default}{}
\DefTblrTemplate{caption-text}{default}{}
\DefTblrTemplate{contfoot-text}{default}{}
\DefTblrTemplate{conthead-text}{default}{}
\usepackage{tikz}
%\tikzset{every arrow/.append style={line cap=round}}
\usepackage{tikz-cd}
\tikzcdset{every arrow/.append style={line cap=round}}
\usepackage{pgffor}
\usetikzlibrary{calc}
\usetikzlibrary{arrows}
\usetikzlibrary{arrows.meta}
\usetikzlibrary{matrix}
\usetikzlibrary{fit}
\usetikzlibrary{babel}
\usepackage{tkz-tab}
\tikzset{arrow style/.style={->=latex,shorten >=2pt, shorten <=2pt}}
\setcounter{tocdepth}{6}
\renewcommand{\ttdefault}{cmtl}



%%% Bibliography
\newif\ifaltarticle@bibliographyfiles
\altarticle@bibliographyfilesfalse
\ifaltarticle@bibliography\IfFileExists{unsrt.bbx}{\altarticle@bibliographyfilesfalse}{\altarticle@bibliographyfilestrue}\fi
\ifaltarticle@bibliographyfiles
    \begin{filecontents}{unsrt.bbx}
        \ProvidesFile{unsrt.bbx}[2025/02/02 Unsorted French Bibliography Style]

        \RequireBibliographyStyle{numeric}

        \DeclareBibliographyOption[boolean]{ordrecitation}[true]{% Option to enforce citation order
        \ifstrequal{#1}{true}
            {\ExecuteBibliographyOptions{sorting=none}}
            {}}

        % French localization
        \DefineBibliographyStrings{french}{
        urlseen = {Consulté le},
        pages = {p.},
        editor = {dir.},
        editors = {dirs.},
        byeditor = {sous la direction de},
        edition = {édition},
        volume = {volume},
        number = {n	extdegree},
        in = {Dans},
        }

        % Adjust citation label format to remove brackets
        \DeclareFieldFormat{labelnumber}{#1}

        % Order of bibliography fields
        \DeclareBibliographyDriver{book}{%
        \usebibmacro{bibindex}%
        \usebibmacro{begentry}%
        \printnames{author}%
        \setunit{\addcolon\space}%
        \newblock
        \printfield{title}%
        \setunit{\addcomma\space}%
        \printfield{edition}%
        \setunit{\addcomma\space}%
        \printfield{series}%
        \setunit{\addcomma\space}%
        \printlist{publisher}%
        \setunit{\addcomma\space}%
        \printfield{year}%
        \setunit{\addperiod}%
        \finentry
        }

        \DeclareBibliographyDriver{article}{%
        \usebibmacro{bibindex}%
        \usebibmacro{begentry}%
        \printnames{author}%
        \setunit{\addspace}%
        \newblock
        \printfield{title}%
        \setunit{\addperiod\space}%
        \printfield{journaltitle}%
        \setunit{\addcomma\space}%
        \printfield{volume}%
        \setunit{\addcomma\space}%
        \printfield{number}%
        \setunit{\addcomma\space}%
        \printfield{pages}%
        \setunit{\addcomma\space}%
        \printfield{year}%
        \setunit{\addperiod}%
        \finentry
        }

        \DeclareBibliographyDriver{misc}{%
        \usebibmacro{bibindex}%
        \usebibmacro{begentry}%
        \printnames{author}%
        \setunit{\addcolon\space}%
        \newblock
        \printfield{title}%
        \setunit{\addcomma\space}%
        \printfield{howpublished}%
        \setunit{\addcomma\space}%
        \printfield{note}%
        \setunit{\addcomma\space}%
        \printfield{url}%
        \setunit{\addcomma\space}%
        \printfield{year}%
        \setunit{\addperiod}%
        \finentry
        }
    \end{filecontents}
\fi
\ifaltarticle@bibliography\IfFileExists{unsrt.cbx}{\altarticle@bibliographyfilesfalse}{\altarticle@bibliographyfilestrue}\fi
\ifaltarticle@bibliographyfiles
    \begin{filecontents}{unsrt.cbx}
        \ProvidesFile{unsrt.cbx}[2024/06/05 v0.1 Foad's citation style]

        \RequireCitationStyle{numeric}

        \endinput
    \end{filecontents}
\fi
\ifaltarticle@bibliography
    \usepackage[backend=biber, style=unsrt, sorting=none, maxcitenames=50]{biblatex}
    \setlength{\bibitemsep}{0pt}
    \setlength{\biblabelsep}{0pt}
    \newlength{\newlabelnumberwidth}
    \setlength{\newlabelnumberwidth}{0pt}
    \pretocmd{\printbibliography}{\setlength{\labelnumberwidth}{\newlabelnumberwidth}}{}{}
    \setlength{\biblabelsep}{2.125em}
    \newsavebox{\altarticle@biblbox}
    \newsavebox{\altarticle@bibbox}
    \newsavebox{\altarticle@spacebox}
    \savebox{\altarticle@spacebox}{~}
    \defbibenvironment{bibliography}
    {\list
        {\savebox{\altarticle@bibbox}{\printtext[labelnumberwidth]{%
            \printfield{labelprefix}%
            \printfield{labelnumber}}}%
            \usebox{\altarticle@bibbox}%
            \ifdim\wd\altarticle@bibbox<\dimexpr\biblabelsep-\the\wd\altarticle@spacebox-\the\wd\altarticle@spacebox\relax%
            \kern-\wd\altarticle@bibbox%
            \else%
            \kern-\biblabelsep~~%
            \fi%
        }
        {\setlength{\labelwidth}{\labelnumberwidth}%
        \setlength{\leftmargin}{\labelwidth}%
        \setlength{\labelsep}{\biblabelsep}%
        \addtolength{\leftmargin}{\labelsep}%
        \setlength{\itemsep}{\bibitemsep}%
        \setlength{\parsep}{\bibparsep}}%
        \renewcommand*{\makelabel}[1]{\hss##1}}
    {\endlist}
    {\item}
    \defbibenvironment{shorthand}
    {\list
        {\savebox{\altarticle@bibbox}{\printfield[shorthandwidth]{shorthand}}%
            \usebox{\altarticle@bibbox}%
            \ifdim\wd\altarticle@bibbox<\dimexpr\biblabelsep-\the\wd\altarticle@spacebox-\the\wd\altarticle@spacebox\relax%
            \kern-\wd\altarticle@bibbox%
            \else%
            \kern-\biblabelsep~~%
            \fi%
        }
        {\setlength{\labelwidth}{\shorthandwidth}%
        \setlength{\leftmargin}{\labelwidth}%
        \setlength{\labelsep}{\biblabelsep}%
        \addtolength{\leftmargin}{\labelsep}%
        \setlength{\itemsep}{\bibitemsep}%
        \setlength{\parsep}{\bibparsep}%
        \renewcommand*{\makelabel}[1]{##1\hss}}}
    {\endlist}
    {\item}
\fi



%%% General commands
\newcommand{\gettikzxy}[3]{%
    \tikz@scan@one@point\pgfutil@firstofone#1\relax
    \edef#2{\the\pgf@x}%
    \edef#3{\the\pgf@y}%
}
\DeclareRobustCommand\circled[1]{\tikz[baseline={([yshift=-0.5ex]char.center)}]{\node[shape=circle,draw,inner sep=2pt] (char) {#1};}}
\let\mathunderline\underline
\def\underline#1{% 
   \vphantom{#1}\leavevmode\vbox to0pt{\vss 
        \hrule height.3pt
        \vskip-\baselineskip \kern1pt 
        \hbox{\strut\rlap{\color{white}\pdfliteral{2 Tr 1.1 w}#1\pdfliteral{0 Tr 0 w}}#1} 
}}
\everymath{\def\underline{\mathunderline}}
\title{}
\author{}
\def\refname{Références\phantomsection}



%%% Useful command
\DeclareRobustCommand\altarticle@comparestring[2]{%
    \edef\tempa{#1}%
    \edef\tempb{#2}%
    \ifx\tempa\tempb%
        \expandafter\@firstoftwo%
    \else%
        \expandafter\@secondoftwo%
    \fi%
}
\DeclareRobustCommand\labelcomparestring[2]{%
    \edef\tempa{#1}%
    \edef\tempb{#2}%
    \ifx\tempa\tempb%
        \expandafter\@firstoftwo%
    \else%
        \expandafter\@secondoftwo%
    \fi%
}
\def\altarticle@compareint#1#2{%
    \ifnum#1=#2\relax%
        \expandafter\@firstoftwo%
    \else%
        \expandafter\@secondoftwo%
    \fi%
}
\def\altarticle@toolsfindlist{}
\newcommand{\altarticle@isnotinlist}[2]{%
    \altarticle@comparestring{#2}{}{\def\altarticle@toolsfindlist{}}{%
        \def\altarticle@toolsfindlist{0}%
        \edef\lst{#2}%
        \foreach \i in \lst {\altarticle@comparestring{#1}{\i}{\xdef\altarticle@toolsfindlist{}}{}}%
    }%
}
\def\altarticle@ifinlist#1#2{%
    \altarticle@isnotinlist{#1}{#2}%
    \altarticle@comparestring{\altarticle@toolsfindlist}{}%
}
\def\toggleboldmath{false}
\robustify{\toggleboldmath}
\apptocmd{\boldmath}{\def\toggleboldmath{true}}{}{}
\apptocmd{\unboldmath}{\def\toggleboldmath{false}}{}{}



%%% Sections and title
\renewcommand\section{\@startsection {section}{1}{\z@}%
    {-0.5ex \@plus -0.25ex \@minus -0.25ex}%
    {0.125ex \@plus.062ex \@minus.062ex}%
    {\normalfont\Large\bfseries}%
}
\renewcommand*\l@section{\@dottedtocline{1}{0em}{1.4em}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
    {1sp \@plus 0.0625ex \@minus 0.0625ex}%
    {1sp \@plus 0.0625ex \@minus 0.0625ex}%
    {\normalfont\large\bfseries}%
}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
    {1sp \@plus 0.0625ex \@minus 0.0625ex}%
    {1sp \@plus 0.0625ex \@minus 0.0625ex}%
    {\normalfont\normalsize\bfseries}%
}
\def\@maketitle{%
    \newpage
    \begin{center}%
    \let \footnote \thanks
        \ifdefempty{\@title}{}{{\LARGE \@title \par}}%
        \ifdefempty{\@author}{}{\vskip 1em%
        {\large\@author}}%
        \ifdefempty{\@date}{}{\vskip 1em%
        {\large \@date}}%
    \end{center}%
    \par
}



%%% Math (re)definitions
%% Define l to \ell
\mathcode`l="8000
\begingroup
\lccode`\~=`\l
\DeclareMathSymbol{\lsb@l}{\mathalpha}{letters}{`l}
\lowercase{\gdef~{\ifnum\the\mathgroup=\m@ne \ell \else \lsb@l \fi}}%
\endgroup
%% Delimiters & delimiters spacing
\let\l\relax
\newcommand\l{\left(}
\let\r\relax
\newcommand\r{\right)}
\newcommand{\llb}{\left\llbracket}
\newcommand{\rrb}{\right\rrbracket}
\def\lc{\left[}
\def\rc{\right]}
\def\set#1{\left\{#1\right\}}
\let\oldleft\left
\renewcommand{\left}{\mathopen{}\mathclose\bgroup\oldleft}
\let\oldright\right
\renewcommand{\right}{\aftergroup\egroup\oldright}
%% Square root spacing
\let\oldsqrt\sqrt
\renewcommand{\sqrt}[2][\mkern8mu]{\mkern-4mu\mathop{\oldsqrt[#1]{#2}}{}\mkern-3mu}
%% Fakebold
\newlength\bshft
\bshft=.18pt\relax
\DeclareRobustCommand\fakebold[1]{\setbox0=\hbox{$#1$}#1\kern-\wd0\kern\bshft#1\kern-\wd0\kern\bshft#1}
%% Unslant
\newsavebox{\foobox}
\newcommand{\slantbox}[2][0]{\mbox{%
    \sbox{\foobox}{#2}%
    \hskip\wd\foobox
    \pdfsave
    \pdfsetmatrix{1 0 #1 1}%
    \llap{\usebox{\foobox}}%
    \pdfrestore
}}
\newcommand{\unslant}[2][-.25]{\slantbox[#1]{$#2$}}
%% Double stroke
\def\ds#1{\pdfliteral{1 Tr .335 w}#1\pdfliteral{0 Tr 0 w}}
%% Slant all greek letters
\ifaltarticle@unslantgreek
\else
    \let\upGamma\Gamma
    \let\Gamma\varGamma
    \let\upDelta\Delta
    \let\Delta\varDelta
    \let\upTheta\Theta
    \let\Theta\varTheta
    \let\upLambda\Lambda
    \let\Lambda\varLambda
    \let\upXi\Xi
    \let\Xi\varXi
    \let\upPi\Pi
    \let\Pi\varPi
    \let\upSigma\Sigma
    \let\Sigma\varSigma
    \let\upUpsilon\Upsilon
    \let\Upsilon\varUpsilon
    \let\upPhi\Phi
    \let\Phi\varPhi
    \let\upPsi\Psi
    \let\Psi\varPsi
    \let\upOmega\Omega
    \let\Omega\varOmega
\fi
%% Swap epsilon and phi to var form
\let\oldepsilon\epsilon
\let\epsilon\varepsilon
\let\varepsilon\oldepsilon
\let\oldepsilon\relax
\let\oldphi\phi
\let\phi\varphi
\let\varphi\oldphi
\let\oldphi\relax
%% Circled operators
\let\oplus\varoplus
\let\otimes\varotimes
%% Under/Overbrace
\def\altunderbrace#1#2#3#4{\left#1\vphantom{#2}\smash{\underbrace{#2}_{#3}}\right#4\vphantom{\underbrace{#2}_{#3}}}
\def\altoverbrace#1#2#3#4{\left#1\vphantom{#2}\smash{\overbrace{#2}_{#3}}\right#4\vphantom{\overbrace{#2}_{#3}}}
%% Slanted <= >=
\let\leq\leqslant
\let\le\leqslant
\let\geq\geqslant
\let\ge\geqslant
%% Textstyle align
\newenvironment{tflalign*}
    {\let\olddisplaystyle\displaystyle\let\displaystyle\textstyle\csname flalign*\endcsname}
    {\endflalign}
%% Letter styles
% mathbb
\def\bbA{\mathbb{A}}
\def\bbB{\mathbb{B}}
\def\bbC{\mathbb{C}}
\def\bbD{\mathbb{D}}
\def\bbE{\mathbb{E}}
\def\bbF{\mathbb{F}}
\def\bbG{\mathbb{G}}
\def\bbH{\mathbb{H}}
\def\bbI{\mathbb{I}}
\def\bbJ{\mathbb{J}}
\def\bbK{\mathbb{K}}
\def\bbL{\mathbb{L}}
\def\bbM{\mathbb{M}}
\def\bbN{\mathbb{N}}
\def\bbO{\mathbb{O}}
\def\bbP{\mathbb{P}}
\def\bbQ{\mathbb{Q}}
\def\bbR{\mathbb{R}}
\def\bbS{\mathbb{S}}
\def\bbT{\mathbb{T}}
\def\bbU{\mathbb{U}}
\def\bbV{\mathbb{V}}
\def\bbW{\mathbb{W}}
\def\bbX{\mathbb{X}}
\def\bbY{\mathbb{Y}}
\def\bbZ{\mathbb{Z}}
\def\bba{\mathbb{a}}
\def\bbb{\mathbb{b}}
\def\bbc{\mathbb{c}}
\def\bbd{\mathbb{d}}
\def\bbe{\mathbb{e}}
\def\bbf{\mathbb{f}}
\def\bbg{\mathbb{g}}
\def\bbh{\mathbb{h}}
\def\bbi{\mathbb{i}}
\def\bbj{\mathbb{j}}
\def\bbk{\mathbb{k}}
\def\bbl{\mathbb{l}}
\def\bbm{\mathbb{m}}
\def\bbn{\mathbb{n}}
\def\bbo{\mathbb{o}}
\def\bbp{\mathbb{p}}
\def\bbq{\mathbb{q}}
\def\bbr{\mathbb{r}}
\def\bbs{\mathbb{s}}
\def\bbt{\mathbb{t}}
\def\bbu{\mathbb{u}}
\def\bbv{\mathbb{v}}
\def\bbw{\mathbb{w}}
\def\bbx{\mathbb{x}}
\def\bby{\mathbb{y}}
\def\bbz{\mathbb{z}}
% mathcal
\def\calA{\mathcal{A}}
\def\calB{\mathcal{B}}
\def\calC{\mathcal{C}}
\def\calD{\mathcal{D}}
\def\calE{\mathcal{E}}
\def\calF{\mathcal{F}}
\def\calG{\mathcal{G}}
\def\calH{\mathcal{H}}
\def\calI{\mathcal{I}}
\def\calJ{\mathcal{J}}
\def\calK{\mathcal{K}}
\def\calL{\mathcal{L}}
\def\calM{\mathcal{M}}
\def\calN{\mathcal{N}}
\def\calO{\mathcal{O}}
\def\calP{\mathcal{P}}
\def\calQ{\mathcal{Q}}
\def\calR{\mathcal{R}}
\def\calS{\mathcal{S}}
\def\calT{\mathcal{T}}
\def\calU{\mathcal{U}}
\def\calV{\mathcal{V}}
\def\calW{\mathcal{W}}
\def\calX{\mathcal{X}}
\def\calY{\mathcal{Y}}
\def\calZ{\mathcal{Z}}
% mathfrak
\def\frakA{\mathfrak{A}}
\def\frakB{\mathfrak{B}}
\def\frakC{\mathfrak{C}}
\def\frakD{\mathfrak{D}}
\def\frakE{\mathfrak{E}}
\def\frakF{\mathfrak{F}}
\def\frakG{\mathfrak{G}}
\def\frakH{\mathfrak{H}}
\def\frakI{\mathfrak{I}}
\def\frakJ{\mathfrak{J}}
\def\frakK{\mathfrak{K}}
\def\frakL{\mathfrak{L}}
\def\frakM{\mathfrak{M}}
\def\frakN{\mathfrak{N}}
\def\frakO{\mathfrak{O}}
\def\frakP{\mathfrak{P}}
\def\frakQ{\mathfrak{Q}}
\def\frakR{\mathfrak{R}}
\def\frakS{\mathfrak{S}}
\def\frakT{\mathfrak{T}}
\def\frakU{\mathfrak{U}}
\def\frakV{\mathfrak{V}}
\def\frakW{\mathfrak{W}}
\def\frakX{\mathfrak{X}}
\def\frakY{\mathfrak{Y}}
\def\frakZ{\mathfrak{Z}}
\def\fraka{\mathfrak{a}}
\def\frakb{\mathfrak{b}}
\def\frakc{\mathfrak{c}}
\def\frakd{\mathfrak{d}}
\def\frake{\mathfrak{e}}
\def\frakf{\mathfrak{f}}
\def\frakg{\mathfrak{g}}
\def\frakh{\mathfrak{h}}
\def\fraki{\mathfrak{i}}
\def\frakj{\mathfrak{j}}
\def\frakk{\mathfrak{k}}
\def\frakl{\mathfrak{l}}
\def\frakm{\mathfrak{m}}
\def\frakn{\mathfrak{n}}
\def\frako{\mathfrak{o}}
\def\frakp{\mathfrak{p}}
\def\frakq{\mathfrak{q}}
\def\frakr{\mathfrak{r}}
\def\fraks{\mathfrak{s}}
\def\frakt{\mathfrak{t}}
\def\fraku{\mathfrak{u}}
\def\frakv{\mathfrak{v}}
\def\frakw{\mathfrak{w}}
\def\frakx{\mathfrak{x}}
\def\fraky{\mathfrak{y}}
\def\frakz{\mathfrak{z}}



%%% Theorems
\newcommand{\textref}[1]{\ref{t@#1}}
\newcommand{\thmref}[1]{\ifcsdef{r@t@#1}{\textref{#1}}{\autoref{#1}}}
\newcommand{\thmnameref}[1]{{\def\@displaythmname{true}\ifcsdef{r@t@#1}{\textref{#1}}{\autoref{#1}}}}
\def\@displaythmname{}
\robustify{\@displaythmname}
\newif\ifthmname
\thmnametrue

\newcommand{\incrementcounter}[2]{%
    \altarticle@comparestring{\arabic{#1}}{\arabic{#2}}{\relax}{\refstepcounter{#2}\incrementcounter{#1}{#2}}%
}

\newcommand{\createtheorem}[6]{%
    \@ifundefined{c@thms#5counter}{
        \newcounter{thms#5counter}
    }{}
    \setcounter{thms#5counter}0
    \@ifundefined{c@#1}{%
        \newcounter{#1}%
    }{}%
    \@ifundefined{c@#1star}{%
        \newcounter{#1star}%
    }{}%
    \if\relax\detokenize{#5}\relax%
    \else%
        \counterwithin{thms#5counter}{#5}
        \counterwithin{#1}{#5}%
      \fi%
    \setcounter{#1}{0}%
    \expandafter\let\csname #1autorefname\endcsname\relax%
    \expandafter\let\csname #1starautorefname\endcsname\relax%
    \expandafter\let\csname #1\endcsname\relax%
    \expandafter\let\csname @#1star\endcsname\relax%
    \expandafter\let\csname @#1startmp\endcsname\relax%
    \expandafter\let\csname @#1startmptmp\endcsname\relax%
    \expandafter\let\csname @#1\endcsname\relax%
    \expandafter\let\csname @#1tmp\endcsname\relax%
    \expandafter\let\csname @#1tmptmp\endcsname\relax%
    \expandafter\newcommand\csname #1autorefname\endcsname{#4}%
    \expandafter\newcommand\csname #1starautorefname\endcsname{#4}%
    \expandafter\newcommand\csname #1\endcsname{%
        \@ifstar%
            {\csname @#1startmptmptmp\endcsname}%
            {\csname @#1tmptmptmp\endcsname}%
    }%
    \expandafter\newcommand\csname @#1tmptmptmp\endcsname[1][]{%
        \def\thmoptargI{##1}%
        \csname @#1tmptmp\endcsname%
    }%
    \expandafter\newcommand\csname @#1tmptmp\endcsname[1][]{%
        \def\thmoptargII{##1}%
        \csname @#1tmp\endcsname%
    }%
    \expandafter\newcommand\csname @#1tmp\endcsname[1][]{%
        \def\thmoptargIII{##1}%
        \csname @#1\endcsname%
    }%
    \expandafter\newcommand\csname @#1\endcsname[2][]{%
        \par%
        \ifdefempty{\thmoptargI}{%
            \def\argI{##2}%
        }{%
            \def\argI{\thmoptargI}%
        }%
        \ifdefempty{\thmoptargIII}{%
            \def\tocargII{##2}%
            \def\argII{##2}%
        }{%
            \def\tocargII{\thmoptargIII}%
            \def\argII{\labelcomparestring{\toggleboldmath}{true}{##2}{\thmoptargIII}}%
        }%
        \altarticle@comparestring{#6}{true}{%
            \stepcounter{thms#5counter}%
            \incrementcounter{thms#5counter}{#1}%
        }{%
            \refstepcounter{#1}%
        }%
        \if\relax\detokenize{##2}\relax%
            \textbf{\boldmath#2 \csname the#1\endcsname{}~:}\ifdefempty{\argI}{}{\label{#3 \argI}}{} %
        \else%
            \altarticle@comparestring{##1}{true}{%
                \textbf{\boldmath#2 \csname the#1\endcsname{}\ifthmname{} (\textsl{##2})\fi~:}\ifdefempty{\argI}{}{\label{#3 \argI}}{} %
            }{%
                \textbf{\boldmath#2 \csname the#1\endcsname{}\ifthmname{} (\textsl{##2})\fi~:}\ifdefempty{\argI}{}{\label{#3 \argI}\def\@currentlabel{\altarticle@comparestring{\@displaythmname}{true}{#4 }{}\thmoptargII\argII}\label{t@#3 \argI}}\addcontentsline{to#1}{thm}{\ignorespaces{\noexpand\expandafter\noexpand\MakeUppercase\thmoptargII\tocargII}}{} %
            }%
        \fi%
    }%
    \expandafter\newcommand\csname @#1startmptmptmp\endcsname[1][]{%
        \def\thmoptargI{##1}%
        \csname @#1startmptmp\endcsname%
    }%
    \expandafter\newcommand\csname @#1startmptmp\endcsname[1][]{%
        \def\thmoptargII{##1}%
        \csname @#1startmp\endcsname%
    }%
    \expandafter\newcommand\csname @#1startmp\endcsname[1][]{%
        \def\thmoptargIII{##1}%
        \csname @#1star\endcsname%
    }%
    \expandafter\newcommand\csname @#1star\endcsname[2][]{%
        \par%
        \refstepcounter{#1star}%
        \ifdefempty{\thmoptargI}{%
            \def\argI{##2}
        }{%
            \def\argI{\thmoptargI}%
        }%
        \ifdefempty{\thmoptargIII}{%
            \def\tocargII{##2}
            \def\argII{##2}
        }{%
            \def\tocargII{\thmoptargIII}
            \def\argII{\labelcomparestring{\toggleboldmath}{true}{##2}{\thmoptargIII}}%
        }%
        \if\relax\detokenize{##2}\relax%
            \textbf{\boldmath#2~:}{} %
        \else%
            \altarticle@comparestring{##1}{true}{%
                \textbf{\boldmath#2\ifthmname{} (\textsl{##2})\fi~:}{} %
            }{%
                \textbf{\boldmath#2\ifthmname{} (\textsl{##2})\fi~:}\ifdefempty{\argI}{}{\def\@currentlabel{\thmoptargII\argII}\label{t@#3 \argI}}{}\addcontentsline{to#1}{thm}{\ignorespaces{\noexpand\expandafter\noexpand\MakeUppercase\thmoptargII\tocargII}}{} %
            }%
        \fi%
    }%
}
%% Proof
\newenvironment{preuve}[2][]%
{%
    \par%
    \altarticle@comparestring{#1}{}%
        {\def\argI{\textbf{\boldmath Preuve (\textsl{\thmref{#2}})~:}}}%
        {\def\argI{\textbf{\boldmath Preuve (\textsl{\thmref{#2}}#1)~:}}}%
    \begin{leftbartitle}{\argI}%
        \def\footnotetext{\savefootnote}%
        \small%
        \setlength{\belowdisplayskip}{0pt}\setlength{\belowdisplayshortskip}{0pt}\setlength{\abovedisplayskip}{0pt}\setlength{\abovedisplayshortskip}{0pt}%
        \let\textitemize\itemize%
        \let\itemize\prvitemize%
}{%
    \end{leftbartitle}%
}%
\def\proof{\preuve}
%% Code adapted from framed.sty
\chardef\FrameRestore=\catcode`\| % for debug
\catcode`\|=\catcode`\% % (debug: insert space after backslash)

\OuterFrameSep=-4.5pt
\FrameSep=0pt

\def\AltMakeFramed#1{\par
 % measure added width and height; call result \width and \height
 \fb@sizeofframe\FrameCommand
 \let\width\fb@frw \let\height\fb@frh
 % insert pre-penalties and skips
 \begingroup
 \skip@\lastskip
 \if@nobreak\else 
    \penalty9999 % updates \page parameters
    \ifdim\pagefilstretch=\z@ \ifdim\pagefillstretch=\z@
       % not infinitely stretchable, so encourage a page break here
       \edef\@tempa{\the\skip@}%
       \ifx\@tempa\zero@glue \penalty-30
       \else \vskip-\skip@ \penalty-30 \vskip\skip@
    \fi\fi\fi
    \penalty\z@
    % Give a stretchy breakpoint that will always be taken in preference
    % to the \penalty 9999 used to update page parameters.  The cube root
    % of 10000/100 indicates a multiplier of 0.21545, but the maximum 
    % calculated badness is really 8192, not 10000, so the multiplier
    % is 0.2301. 
    \advance\skip@ \z@ plus-.5\baselineskip
    \advance\skip@ \z@ plus-.231\height
    \advance\skip@ \z@ plus-.231\skip@
    \advance\skip@ \z@ plus-.231\OuterFrameSep
    \vskip-\skip@ \penalty 1800 \vskip\skip@
 \fi
 %\addvspace{\OuterFrameSep}%
 \endgroup
 % clear out pending page break
 \penalty\@M \vskip 2\baselineskip \vskip\height
 \penalty9999 \vskip -2\baselineskip \vskip-\height
 \penalty9999 % updates \pagetotal
|\message{After clearout, \pagetotal=\the\pagetotal, \pagegoal=\the\pagegoal. }%
 \fb@adjheight 
 \setbox\@tempboxa\vbox\bgroup
   #1% Modifications to \hsize (can use \width and \height)
   \textwidth\hsize \columnwidth\hsize
}

\def\endMakeFramed{\par
     \kern\z@
     \hrule\@width\hsize\@height\z@ % possibly bad
     \penalty-100 % (\hrule moves depth into height)
 \egroup
%%%   {\showoutput\showbox\@tempboxa}%
 \begingroup 
   \fb@put@frame\FrameCommand\FirstFrameCommand
 \endgroup
 \@minipagefalse % In case it was set and not cleared
}

% \fb@put@frame takes the contents of \@tempboxa and puts all, or a piece,
% of it on the page with a frame (\FrameCommand, \FirstFrameCommand,
% \MidFrameCommand, or \LastFrameCommand).  It recurses until all of 
% \@tempboxa has been used up. (\@tempboxa must have zero depth.)
% #1 = attempted framing command, if no split
% #2 = framing command if split
% First iteration: Try to fit with \FrameCommand. If it does not fit,
% split for \FirstFrameCommand.
% Later iteration: Try to fit with \LastFrameCommand. If it does not
% fit, split for \MidFrameCommand.
\def\fb@put@frame#1#2{\displayfootnotes\relax
 \ifdim\pagegoal=\maxdimen \pagegoal\vsize \fi
|   \message{=============== Entering putframe ====================^^J
|     \pagegoal=\the\pagegoal,  \pagetotal=\the\pagetotal. }%
 \ifinner
   \fb@putboxa#1%
   \fb@afterframe
 \else
  \dimen@\pagegoal \advance\dimen@-\pagetotal % natural space left on page
  \ifdim\dimen@<2\baselineskip % Too little room on page
|   \message{Page has only \the\dimen@\space room left; eject. }%
    \eject \fb@adjheight \fb@put@frame#1#2%
  \else % there's appreciable room left on the page
     \fb@sizeofframe#1%
|    \message{\string\pagetotal=\the\pagetotal,
|        \string\pagegoal=\the\pagegoal,
|        \string\pagestretch=\the\pagestretch,
|        \string\pageshrink=\the\pageshrink,
|        \string\fb@frh=\the\fb@frh. \space}
|    \message{^^JBox of size \the\ht\@tempboxa\space}%
     \begingroup % temporarily set \dimen@ to be...
     \advance\dimen@.8\pageshrink  % maximum space available on page
     \advance\dimen@-\fb@frh\relax % max space available for frame's contents
%%% LOOKS SUBTRACTED AND ADDED, SO DOUBLE ACCOUNTING!
     \expandafter\endgroup
     % expand \ifdim, then restore \dimen@ to real room left on page
     \ifdim\dimen@>\ht\@tempboxa % whole box does fit
|       \message{fits in \the\dimen@. }%
        % ToDo: Change this to use vsplit anyway to capture the marks
        % MERGE THIS WITH THE else CLAUSE!!!
        \fb@putboxa#1%
        \fb@afterframe
     \else % box must be split
|       \message{must be split to fit in \the\dimen@. }%
        % update frame measurement to use \FirstFrameCommand or \MidFrameCommand
        \fb@sizeofframe#2%
        \setbox\@tempboxa\vbox{% simulate frame and flexiblity of the page:
           \vskip \fb@frh \@plus\pagestretch \@minus.8\pageshrink
           \kern137sp\kern-137sp\penalty-30
           \unvbox\@tempboxa}%
        \edef\fb@resto@set{\boxmaxdepth\the\boxmaxdepth 
                           \splittopskip\the\splittopskip}%
        \boxmaxdepth\z@ \splittopskip\z@
|       \message{^^JPadded box of size \the\ht\@tempboxa\space split to \the\dimen@}%
        % Split box here
        \setbox\tw@\vsplit\@tempboxa to\dimen@
|       \toks99\expandafter{\splitfirstmark}%
|       \toks98\expandafter{\splitbotmark}%
|       \message{Marks are: \the\toks99, \the\toks98. }%
        \setbox\tw@\vbox{\unvbox\tw@}% natural-sized
|       \message{Natural height of split box is \the\ht\tw@, leaving 
|          \the\ht\@tempboxa\space remainder. }%
        % If the split-to size > (\vsize-\topskip), then set box to full size.
        \begingroup
        \advance\dimen@\topskip
        \expandafter\endgroup
        \ifdim\dimen@>\pagegoal
|         \message{Frame is big -- Use up the full column. }%
          \dimen@ii\pagegoal
          \advance\dimen@ii -\topskip
          \advance\dimen@ii \FrameHeightAdjust\relax
        \else  % suspect this is implemented incorrectly:
          % If the split-to size > feasible room_on_page, rebox it smaller.
          \advance\dimen@.8\pageshrink
          \ifdim\ht\tw@>\dimen@
|           \message{Box too tall; rebox it to \the\dimen@. }%
            \dimen@ii\dimen@
          \else % use natural size
            \dimen@ii\ht\tw@
          \fi
        \fi
        % Re-box contents to desired size \dimen@ii
        \advance\dimen@ii -\fb@frh
        \setbox\tw@\vbox to\dimen@ii \bgroup
        % remove simulated frame and page flexibility:
        \vskip -\fb@frh \@plus-\pagestretch \@minus-.8\pageshrink
        \unvbox\tw@ \unpenalty\unpenalty
        \ifdim\lastkern=-137sp % whole box went to next page
|          \message{box split at beginning! }%
           % need work here???
           \egroup \fb@resto@set \eject % (\vskip for frame size was discarded) 
           \fb@adjheight
           \fb@put@frame#1#2% INSERTED ???
        \else % Got material split off at the head
           \egroup \fb@resto@set
           \ifvoid\@tempboxa % it all fit after all
|             \message{box split at end! }%
              \setbox\@tempboxa\box\tw@
              \fb@putboxa#1%
              \fb@afterframe
           \else % it really did split
|             \message{box split as expected. Its reboxed height is \the\ht\tw@. }%
              \ifdim\wd\tw@>\z@
                \wd\tw@\wd\@tempboxa
                \centerline{#2{\box\tw@}}%  ??? \centerline bad idea
              \else
|               \message{Zero width means likely blank. Don't frame it (guess)}%
                \box\tw@
              \fi
              \hrule \@height\z@ \@width\hsize
              \eject
              \fb@adjheight
              \fb@put@frame\LastFrameCommand\MidFrameCommand
  \fi\fi\fi\fi\fi
}

\def\fb@putboxa#1{%
  \ifvoid\@tempboxa
    \PackageWarning{framed}{Boxa is void -- discard it. }%
  \else
|   \message{Frame and place boxa. }%
|   %{\showoutput\showbox\@tempboxa}%
    \centerline{#1{\box\@tempboxa}}%
  \fi
}

\def\fb@afterframe{%
    \nointerlineskip \null %{\showoutput \showlists}
    \penalty-30 \vskip\OuterFrameSep \relax
}

% measure width and height added by frame (#1 = frame command)
% call results \fb@frw and \fb@frh
% todo: a mechanism to handle wide frame titles 
\newdimen\fb@frw
\newdimen\fb@frh
\def\fb@sizeofframe#1{\begingroup
 \setbox\z@\vbox{\vskip-5in \hbox{\hskip-5in 
   #1{\hbox{\vrule \@height 4.7in \@depth.3in \@width 5in}}}%
   \vskip\z@skip}%
|  \message{Measuring frame addition for \string#1 in \@currenvir\space 
|    gives ht \the\ht\z@\space and wd \the\wd\z@. }%
|  %{\showoutput\showbox\z@}%
 \global\fb@frw\wd\z@ \global\fb@frh\ht\z@
 \endgroup
}

\def\fb@adjheight{%
  \vbox to\FrameHeightAdjust{}% get proper baseline skip from above.
  \penalty\@M \nointerlineskip
  \vskip-\FrameHeightAdjust
  \penalty\@M} % useful for tops of pages

\edef\zero@glue{\the\z@skip}

\catcode`\|=\FrameRestore

% Provide configuration commands:
\providecommand\FrameCommand{%
 \setlength\fboxrule{\FrameRule}\setlength\fboxsep{\FrameSep}%
 \fbox}
\@ifundefined{FrameRule}{\newdimen\FrameRule \FrameRule=\fboxrule}{}
\@ifundefined{FrameSep} {\newdimen\FrameSep  \FrameSep =0pt}{}
\providecommand\FirstFrameCommand{\FrameCommand}
\providecommand\MidFrameCommand{\FrameCommand}
\providecommand\LastFrameCommand{\FrameCommand}

% Height of frame above first baseline when frame starts a page:
\providecommand\FrameHeightAdjust{6pt}

% \FrameRestore has parts of \@parboxrestore, performing a similar but 
% less complete restoration of the default layout.  See how it is used in
% the "settings" argument of \MakeFrame.  Though not a parameter, \hsize 
% should be set to the desired total line width available inside the
% frame before invoking \FrameRestore.  
\def\FrameRestore{%
   \let\if@nobreak\iffalse
   \let\if@noskipsec\iffalse
   \let\-\@dischyph
   \let\'\@acci\let\`\@accii\let\=\@acciii
   %  \message{FrameRestore:
   %    \@totalleftmargin=\the \@totalleftmargin,
   %    \rightmargin=\the\rightmargin, 
   %    \@listdepth=\the\@listdepth.  }%
   % Test if we are in a list (or list-like paragraph)
   \ifnum \ifdim\@totalleftmargin>\z@ 1\fi  
          \ifdim\rightmargin>\z@ 1\fi
          \ifnum\@listdepth>\z@ 1\fi 0>\z@
     %     \message{In a list: \linewidth=\the\linewidth, \@totalleftmargin=\the\@totalleftmargin,
     %       \parshape=\the\parshape, \columnwidth=\the\columnwidth, \hsize=\the\hsize, 
     %       \labelwidth=\the\labelwidth. }%
     \@setminipage % snug fit around the item.  I would like this to be non-global.
     % Now try to propageate changes of width from \hsize to list parameters.
     % This is deficient, but a more advanced way to indicate modification to text 
     % dimensions is not (yet) provided; in particular, no separate left/right
     % adjustment.
     \advance\linewidth-\columnwidth \advance\linewidth\hsize
     \parshape\@ne \@totalleftmargin \linewidth
   \else % Not in list
     \linewidth=\hsize
     %\message{No list, set \string\linewidth=\the\hsize. }%
   \fi
   \sloppy
}
%% Environment for proofs
\newlength\prooftitleline%
\setlength{\prooftitleline}{\dimexpr\linewidth-\FrameSep-5.5pt\relax}%
\newcommand\leftbartitleframe[2]{%
    \vbox{\nobreak\vspace{\OuterFrameSep}%
    \hbox to \prooftitleline{\hskip\FrameSep\hbox{\strut{#1}}\hfil}%
    \nobreak \nointerlineskip%
    \hbox{\hskip\FrameSep\hspace{0.04\linewidth}\vline\hspace{0.01\linewidth}%
        {\small#2}%
    \hskip\FrameSep}%
    \vskip\FrameSep%
    }%
}
\newcommand\leftbartitleframecont[1]{%
    \vbox{\nobreak\vspace{\OuterFrameSep}\nointerlineskip%
    \hbox{\hskip\FrameSep\hspace{0.04\linewidth}\vline\hspace{0.01\linewidth}%
        {\small#1}%
    \hskip\FrameSep}%
    \vskip\FrameSep%
    }%
}
\newenvironment{leftbartitle}[1]{%
    \def\FrameCommand{\leftbartitleframe{#1}}%
    \def\FirstFrameCommand{\leftbartitleframe{#1}}%
    \def\MidFrameCommand{\leftbartitleframecont}%
    \def\LastFrameCommand{\leftbartitleframecont}%
    \AltMakeFramed{\advance\hsize-\width \FrameRestore}%
}{\endMakeFramed}
%% Default theorems
\ifaltarticle@defaulttheorems
    \createtheorem{axiome}{Axiome}{axi}{axiome}{section}{true}
    \createtheorem{corollaire}{Corollaire}{cor}{corollaire}{section}{true}
    \createtheorem{definition}{Définition}{def}{définition}{section}{true}
    \createtheorem{lemme}{Lemme}{lm}{lemme}{section}{true}
    \createtheorem{notation}{Notation}{not}{notation}{section}{true}
    \createtheorem{proposition}{Proposition}{prop}{proposition}{section}{true}
    \createtheorem{remarque}{Remarque}{rem}{remarque}{section}{true}
    \createtheorem{theoreme}{Théorème}{thm}{théorème}{section}{true}
\fi
%% Theorem table
\newcommand*\l@thm{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\theoremtable[2]{%
    \section*{#1%
        \@mkboth{%
           \noexpand\expandafter\noexpand\MakeUppercase#1}{\noexpand\expandafter\noexpand\MakeUppercase#1}}%
    \@starttoc{to#2}%
    }



%%% Figures
\altarticle@comparestring\altarticle@babellanguage{french}{
    \renewenvironment{table}
        {\@float{tableau}}
        {\end@float}
    \def\ext@tableau{lot}
    \newcommand*\l@tableau{\@dottedtocline{1}{1.5em}{2.3em}}
}{}
\def\@space{ }
\let\caption\relax
\newcommand{\caption}[2][]{%
    \par%
    \@ifundefined{c@\@captype}{%
        \newcounter{\@captype}%
        \setcounter{\@captype}0%
    }{}%
    \global\expandafter\edef\csname \@captype autorefname\endcsname{\@captype}%
    \if\relax\detokenize{#1}\relax%
        \def\argI{#2}%
    \else%
        \def\argI{#1}%
    \fi%
    \refstepcounter{\@captype}%
    \label{\@captype\@space\argI}\addcontentsline{\csname ext@\@captype\endcsname}{\@captype}{\protect\numberline{\csname the\@captype\endcsname}{\ignorespaces{\expandafter\MakeUppercase\argI}}}\expandafter\MakeUppercase\@captype{} \csname the\@captype\endcsname{} -- \textsl{#2}%
}
\let\subcaption\relax
\newcommand{\subcaption}[2][]{%
    \@ifundefined{l@sub\@captype}{%
        \def\l@sub\@captype{\@dottedtocline{2}{3.8em}{3.2em}}%
    }{}%
    \@ifundefined{c@sub\@captype}{%
        \newcounter{sub\@captype}%
        \counterwithin{sub\@captype}{\@captype}%
        \setcounter{sub\@captype}0%
        \global\expandafter\edef\csname sub\@captype autorefname\endcsname{\@captype}%
    }{}%
    \if\relax\detokenize{#1}\relax%
        \def\argI{ #2}%
    \else%
        \def\argI{ #1}%
    \fi%
    \addtocounter{\@captype}{1}%
    \refstepcounter{sub\@captype}%
    \label{sub\@captype\argI}\addcontentsline{\csname ext@\@captype\endcsname}{sub\@captype}{\protect\numberline{\csname the\@captype\endcsname}{\ignorespaces{\noexpand\expandafter\noexpand\MakeUppercase\argI}}}\expandafter\MakeUppercase\@captype{} \csname thesub\@captype\endcsname{} -- \textsl{#2}%
    \addtocounter{\@captype}{-1}%
}



%%% Footnotes
\let\kernFFN\relax
\newcommand{\kernFFN}{{ }}
\let\insertfootnotemarkFB\relax
\newcommand\insertfootnotemarkFB
  {\rule\z@\footnotesep%
   \makebox[\parindentFFN][l]{\hfill\@thefnmark\dotFFN}%
   \kernFFN
  }

\newcounter{footnotemarkcounter}
\setcounter{footnotemarkcounter}0
\newcounter{footnotetextcounter}
\setcounter{footnotetextcounter}0
\newcommand{\footnotetextcounterautorefname}{note}

\renewcommand{\footnotemark}{\refstepcounter{footnotemarkcounter}\label{footnotemark \thefootnotemarkcounter}{\textsuperscript{\textit{\oldstylenums{\ref{footnotetext \thefootnotemarkcounter}}}}}}
\let\oldfootnotetext\footnotetext
\renewcommand{\footnotetext}[2][]{{\addtocounter{footnotetextcounter}{1}\def\thefootnote{\textit{\oldstylenums{\ref{footnotemark \thefootnotetextcounter}}}}\oldfootnotetext[\thefootnotetextcounter]{\addtocounter{footnotetextcounter}{-1}\refstepcounter{footnotetextcounter}\label{footnotetext \thefootnotetextcounter}\altarticle@comparestring{#1}{}{}{\label{footnote #1}}#2}}}
\renewcommand{\footnote}{\footnotemark\footnotetext}

% Collect notes in environments
\def\savedfootnotes{}%
\def\@savedfootnotes{}%
\newcommand{\savefootnote}[1]{\xdef\savedfootnotes{\expandonce{\savedfootnotes{\noexpand{\ifnum\fpeval{\thepage+1}>\getpagerefnumber{footnotemark \fpeval{\thefootnotetextcounter+1}}\relax\footnotetext{#1}\else\savefootnote{#1}\fi}}}}}
\newcommand{\displayfootnotes}{{\edef\@savedfootnotes{\expandonce{\savedfootnotes}}\xdef\savedfootnotes{}\@savedfootnotes}}




%%% Vectors
%% overarrows.sty
\newif\ifovar@option@oldarrows@
\newif\ifovar@option@esvect@ \ovar@option@esvect@true \PassOptionsToPackage{f}{esvect}
\newif\ifovar@option@tikz@
\newif\ifovar@option@pstarrows@
\newif\ifovar@detectsubscripts@
\newif\ifovar@option@subother@
\newif\ifovar@option@subactive@
\newif\ifovar@option@debug@
\newif\ifovar@option@overrightarrow@
\newif\ifovar@option@underrightarrow@
\newif\ifovar@option@overleftarrow@
\newif\ifovar@option@underleftarrow@
\newif\ifovar@option@overleftrightarrow@
\newif\ifovar@option@underleftrightarrow@
\newif\ifovar@option@overrightharpoonup@
\newif\ifovar@option@underrightharpoonup@
\newif\ifovar@option@overrightharpoondown@
\newif\ifovar@option@underrightharpoondown@
\newif\ifovar@option@overleftharpoonup@
\newif\ifovar@option@underleftharpoonup@
\newif\ifovar@option@overleftharpoondown@
\newif\ifovar@option@underleftharpoondown@
\newif\ifovar@option@overbar@
\newif\ifovar@option@underbar@
\newcommand{\SetOverArrowsSubscriptCommand}[1]{\global\let\ovar@subcmd=#1}
\SetOverArrowsSubscriptCommand{_}
\ifovar@option@subother@
  \begingroup
    \catcode `_=12
    \AddToHook{begindocument/end}{\SetOverArrowsSubscriptCommand{_}}
  \endgroup
\fi
\ifovar@option@subactive@
  \begingroup
    \catcode `_=13
    \AddToHook{begindocument/end}{\SetOverArrowsSubscriptCommand{_}}
  \endgroup
\fi
\RequirePackage{pgfkeys}
\pgfkeys{overarrows/.is family}
\newcommand{\ovar@set}[1]{\pgfqkeys{/overarrows}{#1}}
\NewDocumentCommand{\SetOverArrowsMethod}{ s O{fill} m O{} m }{%
  \IfBooleanTF{#1}{%
    \csgdef{ovar@set@#3}{#4\ovar@set{#5}}%
  }{%
    \csgdef{ovar@set@#3}{#4\ovar@set{%
        no stack macro hook/.code={%
          \ovar@set{stack macro/.expanded={%
              \expandafter\expandonce\csname ovar@stack@#2\endcsname%
              {\expandonce\ovar@length@min}%
              {\expandonce\ovar@before@arrow}{\expandonce\ovar@after@arrow}%
            }}%
        },#5}}%
  }%
}
\SetOverArrowsMethod*{common}[\undef{\ovar@macro@stack}\undef{\ovar@macro@arrow}]{%
  detect subscripts/.is if=ovar@detectsubscripts@,
  stack macro/.store in=\ovar@macro@stack,
  arrow macro/.store in=\ovar@macro@arrow,
  stack macro/.value required,
  arrow macro/.value required,
  no stack macro hook/.code={%
    \PackageError{overarrows}{Undefined stack macro}
    {The requested method is perhaps mispelled}
  },
  no arrow macro hook/.code={%
    \PackageError{overarrows}{Undefined arrow macro}
    {The requested method is perhaps mispelled}
  },
  min length/.store in=\ovar@length@min,
  min length/.value required,
  min length=0,
  before arrow/.store in=\ovar@before@arrow,
  after arrow/.store in=\ovar@after@arrow,
  before arrow/.value required,
  after arrow/.value required,
  before arrow=\empty,
  after arrow=\empty,
  space before arrow/.code=\pgfkeysalso{before arrow={\kern ##1}},
  space after arrow/.code=\pgfkeysalso{after arrow={\kern ##1}},
  shift left/.store in=\ovar@shift@left,
  shift right/.store in=\ovar@shift@right,
  shift left/.value required,
  shift right/.value required,
  shift leftright/.code=\pgfkeysalso{%
    shift left=##1, shift right=##1,
  },
  center arrow/.code=\pgfkeysalso{shift leftright=0},
  shift leftright/.value required,
  center arrow/.value forbidden,
  left arrow/.code=\pgfkeysalso{%
    shift left=0, shift right=##1,
  },
  right arrow/.code=\pgfkeysalso{%
    shift left=##1, shift right=0,
  },
  left arrow/.default=2,
  right arrow/.default=2,
  right arrow,
  arrow under/.is choice,
  arrow under/noconfig/.code={
    \def\ovar@stack@fill{\ovar@stackunder@fill}
    \def\ovar@stack@lens{\ovar@stackunder@lens}
  },
  arrow under/autoconfig/.code={
    \pgfkeysalso{%
      arrow under=noconfig,
      detect subscripts=false,
      before arrow={\kern 1.3\ex@\relax},% like underarrow@ from amsmath
    }
  },
  arrow under/.default=autoconfig,
}
\SetOverArrowsMethod{symb}[\undef{\ovar@macro@arrowfill}]{%
  fill macro/.store in=\ovar@macro@arrowfill,
  fill macro/.value required,
  no arrow macro hook/.code={%
    \ifdef{\ovar@macro@arrowfill}{}{%
      \ovar@set{%
        fill macro/.expanded={%
          \noexpand\ovar@arrow@fill%
          {\expandonce\ovar@shift@left}{\expandonce\ovar@shift@right}%
        }
      }
    }
    \ovar@set{%
      arrow macro/.expanded={%
        \expandonce{\ovar@macro@arrowfill}%
        {\expandonce{\ovar@arrow@start}\expandonce{\ovar@trim@start}}%
        {\expandonce{\ovar@trim@middle}\expandonce{\ovar@arrow@middle}%
          \expandonce{\ovar@trim@middle}}%
        {\expandonce{\ovar@trim@end}\expandonce{\ovar@arrow@end}}%
      }
    }
  },
  start/.store in=\ovar@arrow@start,
  middle/.store in=\ovar@arrow@middle,
  end/.store in=\ovar@arrow@end,
  start/.value required,
  middle/.value required,
  end/.value required,
  trim start/.code={\def\ovar@trim@start{\xjoinrel[##1]}},
  trim middle/.code={\def\ovar@trim@middle{\xjoinrel[##1]}},
  trim end/.code={\def\ovar@trim@end{\xjoinrel[##1]}},
  trim start/.value required,
  trim middle/.value required,
  trim end/.value required,
  trim/.code={\pgfkeysalso{trim start={##1}, trim middle={##1}, trim end={##1}}},
  trim/.value required,
  no trimming/.code={%
    \let\ovar@trim@start\empty
    \let\ovar@trim@middle\empty
    \let\ovar@trim@end\empty
  },
  no trimming/.value forbidden,
  middle config/.is choice,
  middle config/.value required,
  middle config/relbar/.code=\pgfkeysalso{%
    middle={\relbar},
    trim middle={2.5},
  },
  middle config/relbareda/.code={%
    \ifundef{\relbareda}{%
      \PackageWarning{overarrows}{Key 'middle config=relbareda' used,
        \MessageBreak%
        but \protect\relbareda\space is undefined; ignored.
        \MessageBreak%
        Load 'esvect' package, or use 'esvect' option \MessageBreak%
        to remove this warning}
    }{%
      \pgfkeysalso{%
        middle={\relbareda},
        trim middle={1},
      }
    }
  },
  middle config/auto/.code={%
    \ifovar@option@esvect@
    \pgfkeysalso{middle config=relbareda}
    \else
    \pgfkeysalso{middle config=relbar}
    \fi
  },
  amsmath/.is choice,%
  amsmath/mimic/.code=\pgfkeysalso{%
    start={\relbar}, middle={\relbar}, end={\rightarrow},
    trim start=7,
    trim middle=2,
    trim end=7,
    shift leftright=0,
    after arrow={}, before arrow={},
  },
  amsmath/strict/.code=\pgfkeysalso{%
    amsmath=mimic,
    no trimming,
    fill macro={\arrowfill@}, stack macro={\overarrow@},
  },
  amsmath/.default=mimic,
  esvect/.is choice,%
  esvect/mimic/.code=\pgfkeysalso{%
    start={\relbaredd}, middle={\relbareda}, end={\fldr},
    trim start=1.5,
    trim end=1.5,
    trim middle=0,
    right arrow=2,
    space before arrow=-.7pt,
    space after arrow=-.3pt,
  },
  esvect/strict/.code=\pgfkeysalso{%
    esvect=mimic,
    no trimming,
    fill macro={\traitfill@}, stack macro={\overvect@},
  },
  esvect/.default=mimic,
  amsmath, middle config=auto, end=\ovar@rightarrow, right arrow,
}
\SetOverArrowsMethod[lens]{tikz}[\undef{\ovar@tikz@command}]{%
  no arrow macro hook/.code={%
    \ifdef{\ovar@tikz@command}{}{%
      \pgfkeysgetvalue{/overarrows/path options}{\ovar@tikz@pathoptions}
      \ovar@set{%
        tikz command/.expanded={%
          \noexpand\draw[\expandonce\ovar@tikz@pathoptions]\expandonce\ovar@tikz@path;
        }
      }
    }
    \pgfkeysgetvalue{/overarrows/tikz options}{\ovar@tikz@options}
    \ovar@set{%
      arrow macro/.expanded={%
        $\noexpand\mkern \expandonce{\ovar@shift@left} mu\noexpand\relax$%
        \noexpand\tikz[\expandonce{\ovar@tikz@options}]{\expandonce{\ovar@tikz@command}}%
        $\noexpand\mkern \expandonce{\ovar@shift@right} mu\noexpand\relax$%
      }
    }
  },
  tikz command/.store in=\ovar@tikz@command,
  tikz options/.initial={x=\overarrowlength, line width=\overarrowthickness},
  path options/.initial={arrows={-Classical TikZ Rightarrow}, cap=round},
  path/.store in=\ovar@tikz@path,
  path={(0,0)--(1,0)},
  tikz command/.value required,
  tikz options/.value required,
  path options/.value required,
  path/.value required,
  add path options/.code=\pgfkeysalso{%
    path options/.append={, ##1}},%
  add tikz options/.code=\pgfkeysalso{%
    tikz options/.append={, ##1}},%
  arrows/.code=\pgfkeysalso{add path options={arrows={##1}}},%
  line thickness/.code=\pgfkeysalso{add path options={line width=##1}},%
  thinner/.code=\pgfkeysalso{line thickness={\overarrowsmallerthickness}},%
  add path options/.value required,%
  add tikz options/.value required,%
  arrows/.value required,%
  line thickness/.value required,%
  thinner/.value forbidden,%
  shift right=-2,
  min length=12,
}
\SetOverArrowsMethod[lens]{picture}{%
  no arrow macro hook/.code={%
    \ovar@set{%
      arrow macro/.expanded={%
        $\noexpand\mkern \expandonce{\ovar@shift@left} mu\noexpand\relax$%
        \noexpand\begin{picture}\expandonce{\ovar@picture@geometry}%
          \noexpand\linethickness{\expandonce{\ovar@picture@linethickness}}%
          \expandonce{\ovar@picture@command}%
          \noexpand\end{picture}%
        $\noexpand\mkern \expandonce{\ovar@shift@right} mu\noexpand\relax$%
      }
    }
  },
  picture command/.store in=\ovar@picture@command,
  geometry/.store in=\ovar@picture@geometry,
  line thickness/.store in=\ovar@picture@linethickness,
  picture command/.value required,
  geometry/.value required,
  line thickness/.value required,
  thinner/.code=\pgfkeysalso{line thickness={\overarrowsmallerthickness}},
  shift right=-2,
  min length=18,
  geometry={(\overarrowlength,1ex)(0,-0.5ex)},%
  line thickness={\overarrowthickness},%
  picture command={\put(0,0){\vector(1,0){\overarrowlength}}},%
}
\ifdef{\xjoinrel}{%
  \PackageWarning{overarrows}{Command \protect\xjoinrel\space already defined.
    \MessageBreak%
    Previous definition will be overridden}
}{}
\DeclareRobustCommand{\xjoinrel}[1][3.5]{\mathrel{\mkern-#1mu}}
\newcommand*{\smallermathstyle}{%
  \mathchoice{\scriptstyle}{\scriptstyle}{\scriptscriptstyle}{}
}
\def\ovar@arrow@fill#1#2#3#4#5#6{%
  $\m@th\thickmuskip0mu\medmuskip\thickmuskip\thinmuskip\thickmuskip\relax%
  \mkern #1 mu\relax#6#3%
  \cleaders\hbox{$#6#4$}\hfill%
  #5\mkern #2 mu\relax$%
}
\newlength{\overarrowlength}
\newlength{\overarrowthickness}
\newlength{\overarrowsmallerthickness}
\newlength{\ovar@extralength}
\newlength{\ovar@tempdim}
\def\ovar@set@arrowlength#1#2#3{%
  \settowidth{\ovar@tempdim}{$\m@th#2\mskip #1 mu\relax$}%
  \settowidth{\overarrowlength}{$\m@th#2#3$}%
  \ifdim \overarrowlength < \ovar@tempdim \overarrowlength=\ovar@tempdim\fi%
}
\def\ovar@set@arrowthickness#1{% use rule thickness=\fontdimen 8 font family 3
  \if\relax\detokenize{#1}\relax\displaystyle%
    \overarrowthickness =        \fontdimen 8 \textfont 3%
    \overarrowsmallerthickness = \fontdimen 8 \scriptfont 3%
  \else\if\relax\detokenize{#1}\relax\textstyle%
    \overarrowthickness =        \fontdimen 8 \textfont 3%
    \overarrowsmallerthickness = \fontdimen 8 \scriptfont 3%
  \else\if\relax\detokenize{#1}\relax\scriptstyle%
    \overarrowthickness =        \fontdimen 8 \scriptfont 3%
    \overarrowsmallerthickness = \fontdimen 8 \scriptscriptfont 3%
  \else%
    \overarrowthickness =        \fontdimen 8 \scriptscriptfont 3%
    \overarrowsmallerthickness = \overarrowthickness%
  \fi\fi\fi%
}
\def\ovar@stackover@@#1#2#3#4#5#6{\vbox{\ialign{##\crcr%
      $#5\mskip #1 mu\relax$\crcr%
      \noalign{#2\nointerlineskip}#4\crcr%
      \noalign{#3\nointerlineskip}%
      $\m@th\hfil#5#6\hfil$\crcr%
    }%
  }%
}
\def\ovar@stackunder@@#1#2#3#4#5#6{\vtop{\ialign{##\crcr%
      $\m@th\hfil#5#6\hfil$\crcr%
      \noalign{#2\nointerlineskip}#4\crcr%
      \noalign{#3\nointerlineskip}%
      $#5\mskip #1 mu\relax$\crcr%
    }%
  }%
}
\def\ovar@stackover@#1#2#3#4#5{\ovar@stackover@@{0}{#1}{#2}{#3}{#4}{#5}}
\def\ovar@stackunder@#1#2#3#4#5{\ovar@stackunder@@{0}{#1}{#2}{#3}{#4}{#5}}
\def\ovar@stackover@fill#1#2#3#4#5#6{\ovar@stackover@@{#1}{#2}{#3}{#4#5}{#5}{#6}}
\def\ovar@stackunder@fill#1#2#3#4#5#6{\ovar@stackunder@@{#1}{#2}{#3}{#4#5}{#5}{#6}}
\def\ovar@stack@fill{\ovar@stackover@fill}
\def\ovar@stackover@lens#1#2#3#4#5#6{%
  \ovar@set@arrowlength{#1}{#5}{#6}%
  \ovar@set@arrowthickness{#5}%
  \ovar@stackover@{#2}{#3}{#4}{#5}{#6}%
}
\def\ovar@stackunder@lens#1#2#3#4#5#6{%
  \ovar@set@arrowlength{#1}{#5}{#6}%
  \ovar@set@arrowthickness{#5}%
  \ovar@stackunder@{#2}{#3}{#4}{#5}{#6}%
}
\def\ovar@stack@lens{\ovar@stackover@lens}
\NewDocumentCommand{\DeclareOverArrowCommand}{ O{symb} m m }{%
  \begingroup
  \ovar@set@common
  \ifcsdef{ovar@set@#1}{%
    \csuse{ovar@set@#1}
  }{%
    \PackageError{overarrows}{Unknown method #1}
    {Try with 'symb', 'tikz' or 'picture'}
  }
  \ovar@set{#3 }
  \ifdef{\ovar@macro@arrow}{}{%
    \ovar@set{no arrow macro hook}
  }
  \ifdef{\ovar@macro@stack}{}{%
    \ovar@set{no stack macro hook}
  }
  \csxdef{ovar@#2@normal}{%
    \noexpand\mathpalette{%
      \expandonce{\ovar@macro@stack}{\expandonce{\ovar@macro@arrow}}%
    }
  }
  \csxdef{ovar@#2@starred}{%
    \noexpand\mathpalette{%
      \noexpand\ovar@starversion{%
        \expandonce{\ovar@macro@stack}{\expandonce{\ovar@macro@arrow}}%
      }
    }
  }
  \ifovar@detectsubscripts@%
  \csgdef{ovar@#2@auto}##1{%
    \@ifnextchar \ovar@subcmd {%
      \csuse{ovar@#2@starred}{##1}%
    }{%
      \csuse{ovar@#2@normal}{##1}%
    }%
  }
  \csgdef{#2}{%
    \@ifstar{\csuse{ovar@#2@starred}}{\csuse{ovar@#2@auto}}%
  }
  \else
  \csgdef{#2}{%
    \@ifstar{\csuse{ovar@#2@starred}}{\csuse{ovar@#2@normal}}%
  }
  \fi
  \ifovar@option@debug@
  \PackageInfo{overarrows}{%
    Meaning of \protect\ovar@#2@normal\MessageBreak
    used for \@backslashchar#2:\MessageBreak%
      \expandafter\meaning\csname ovar@#2@normal\endcsname}
  \fi
  \endgroup
}
\NewDocumentCommand{\NewOverArrowCommand}{ O{symb} m m }{%
  \ifcsdef{#2}{%
    \PackageError{overarrows}{Command \csname #2\endcsname already defined}%
    {You have used \protect\NewOverArrowCommand\space with a command that
      already has a definition. \MessageBreak%
      Choose another name, or use instead \protect\DeclareOverArrowCommand.}
  }{%
    \DeclareOverArrowCommand[#1]{#2}{#3}
  }
}
\def\ovar@starversion#1#2#3{%
  #1#2{#3}%
  \settowidth{\ovar@extralength}{$\m@th#1#2{#3}$}
  \settowidth{\ovar@tempdim}{$\m@th#2{#3}$}
  \deflength{\ovar@extralength}{0.5\ovar@extralength-0.5\ovar@tempdim}%
  \kern-\ovar@extralength%
}
\newcommand{\ovar@testmathstyles}[2][]{
  \begingroup
  \newcommand*{\ovar@row@teststyle}[1]{%
    $\displaystyle ##1$
    & $\textstyle ##1$
    & $\scriptstyle ##1$
    & $\scriptscriptstyle ##1$
    \\
  }
  \renewcommand*{\arraystretch}{1.5}
  \begin{tabular*}{0.95\linewidth}{@{\extracolsep{\fill}} cccc}
    \hline
    \footnotesize\texttt{\texttt{\textbackslash displaystyle}}
    & \footnotesize\texttt{\texttt{\textbackslash textstyle}}
    & \footnotesize\texttt{\texttt{\textbackslash scriptstyle}}
    & \footnotesize\texttt{\texttt{\textbackslash scriptscriptstyle}}
    \\
    \hline
    \ovar@row@teststyle{\csuse{#2}{v}}
    \ovar@row@teststyle{\csuse{#2}{AB}}
    \ovar@row@teststyle{\csuse{#2}{\mathrm{grad}}}
    \ovar@row@teststyle{\csuse{#2}{my~long~vector}}
    \IfValueT{#1}{\ovar@row@teststyle{\csuse{#2}{#1}}}
    \hline
  \end{tabular*}
  \endgroup
}
\begingroup
\ifovar@option@subother@  \catcode `_=12 \fi
\ifovar@option@subactive@ \catcode `_=13 \fi
\gdef\ovar@testkerning#1{%
  \begin{displaymath}
    #1{t}_{#1{u}_{#1{v}}}
    \qquad
    #1{\imath}_0
    \qquad
    #1{v}
    = #1{v}_x + #1{v}_y + #1{v}_z
    = v_x #1{\imath} + v_y #1{\jmath} + v_z #1{k}
  \end{displaymath}
}
\endgroup
\NewDocumentCommand{\TestOverArrow}{ s o m }{
  \ifcsdef{#3}{}{%
    \PackageWarning{overarrows}{Unknown name '#3' passed to
      \protect\TestOverArrow}
  }
  \IfBooleanTF{#1}{%
    \noindent\framebox{%
      \begin{minipage}{0.95\linewidth}
        \centering
        \noindent\textbf{\large%
          Test of \texttt{\textbackslash#3} and \texttt{\textbackslash#3*} macros}
        \bigskip\par
        \textbf{\texttt{\textbackslash#3} for different math styles}
        \smallskip\par
        \ovar@testmathstyles[#2]{#3}%
        \bigskip\par
        \textbf{\texttt{\textbackslash#3} kerning}
        \ovar@testkerning{\csuse{#3}}
        \textbf{\texttt{\textbackslash#3*} kerning}
        \ovar@testkerning{\csuse{#3}*}
      \end{minipage}%
    }\bigskip\par
  }{%
    \ovar@testmathstyles[#2]{#3}%
  }
}
%% esvect character
\DeclareSymbolFont{esvector}{U}{esvect}{m}{n}
\DeclareMathSymbol{\montraita}{\mathrel}{esvector}{'040}
\def\relbareda{\mathrel{\mathpalette\mathsm@sh\montraita}}
%% Redefine vectors
\NewOverArrowCommand{newarrow}{%
start={\smallermathstyle\relbar},
middle={\smallermathstyle\relbareda},
end={\rightarrow},
space after arrow={0.2ex},
space before arrow={0.2ex},
}
\let\vec\newarrow
\let\overrightarrow\newarrow



%%% Set lenghts
\AtBeginDocument{
    \setlength{\belowdisplayskip}{0pt}
    \setlength{\belowdisplayshortskip}{0pt}
    \setlength{\abovedisplayskip}{0pt}
    \setlength{\abovedisplayshortskip}{0pt}
    \setlength{\parindent}{0pt}
}




%%% New commands
%% Bigoperators
\def\bigopleftp{}
\def\bigoprightp{}
\def\bigoplimits{\limits}
\def\bigopdisplay{\displaystyle}
\newcommand{\togglebigoppar}{\altarticle@comparestring{\bigopleftp}{}{\def\bigopleftp{\l}\def\bigoprightp{\r}}{\def\bigopleftp{}\def\bigoprightp{}}}
\newcommand{\togglebigoplimits}{\altarticle@comparestring{\bigoplimits}{\limits}{\def\bigoplimits{\nolimits}}{\def\bigoplimits{\limits}}}
\newcommand{\autobigoplimits}{\def\bigoplimits{}}
\newcommand{\togglebigopdisplay}{\altarticle@comparestring{\bigopdisplay}{}{\def\bigopdisplay{\displaystyle}}{\def\bigopdisplay{}}}
\newcommand{\autobigopdisplay}{\def\bigopdisplay{}}
\let\oldsum\sum
\renewcommand\sum[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\oldsum\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\let\oldprod\prod
\renewcommand\prod[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\oldprod\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\let\oldcap\bigcap
\renewcommand\bigcap[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\oldcap\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\let\oldcup\bigcup
\renewcommand\bigcup[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\oldcup\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\let\oldbigsqcup\bigsqcup
\renewcommand\bigsqcup[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\oldbigsqcup\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\let\olduplus\biguplus
\renewcommand\biguplus[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\olduplus\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\let\oldbigoplus\bigoplus
\renewcommand\bigoplus[3]{\mathop{}\mkern-3mu
    \if\relax\detokenize{#1}\relax
        \def\opbelow{}
    \else
        \def\opbelow{\bigoplimits_{#1}}
    \fi
    \if\relax\detokenize{#2}\relax
        \def\opabove{}
    \else
        \def\opabove{\bigoplimits^{#2}}
    \fi
    {\bigopdisplay\oldbigoplus\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp#3\bigoprightp}
\DeclareRobustCommand\makebigop[2][1]{\mathop{\vphantom{\oldsum}\mathpalette\bigop@{{#1}{#2}}}\slimits@}
\newcommand{\bigop@}[2]{\bigop@@#1#2}
\newcommand{\bigop@@}[3]{\vcenter{\sbox\z@{$#1\oldsum$}\hbox{\resizebox{#2\dimexpr\ht\z@+\dp\z@}{!}{$\m@th#3$}}}}
\newcommand\makebigopcommand[3][1]{%
    \expandafter\let\csname #3symb\endcsname\relax
    \expandafter\let\csname #3\endcsname\relax
    \expandafter\newcommand\csname #3symb\endcsname{%
        \DOTSB\makebigop[#1]{#2}%
    }%
    \expandafter\newcommand\csname #3\endcsname[3]{\mathop{}\mkern-3mu%
        \if\relax\detokenize{##1}\relax
            \def\opbelow{}
        \else
            \def\opbelow{\bigoplimits_{##1}}
        \fi
        \if\relax\detokenize{##2}\relax
            \def\opabove{}
        \else
            \def\opabove{\bigoplimits^{##2}}
        \fi
        {\bigopdisplay\csname #3symb\endcsname\opbelow\opabove}\mkern-3mu{}\mathop{}\bigopleftp##3\bigoprightp%
    }%
}
\makebigopcommand{\mathcal K}{fracK}
%% Arithmetique
\def\mmod#1{\mathchoice{\ }{\ }{}{}\lc#1\rc}
\newcommand{\cgr}[3]{#1\equiv#2\mmod{#3\right}}
\def\legendre@dash#1#2{\hb@xt@#1{%
  \kern-#2\p@
  \cleaders\hbox{\kern.5\p@
    \vrule\@height.2\p@\@depth.2\p@\@width\p@
    \kern.5\p@}\hfil
  \kern-#2\p@
  }}
\def\@legendre#1#2#3#4#5{\mathopen{}\left(\kern-1.5pt
  \sbox\z@{$\genfrac{}{}{0pt}{#1}{#3#4}{#3#5}$}%
  \dimen@=\wd\z@
  \kern-\p@\vcenter{\box0}\kern-\dimen@\vcenter{\legendre@dash\dimen@{#2}}\kern-\p@
  \kern-1.5pt\right)\mathclose{}}
\newcommand\legendre[2]{\mathchoice
  {\@legendre{0}{1}{}{#1}{#2}}
  {\@legendre{2}{0}{\vphantom{1}}{#1}{#2}}
  {\@legendre{2}{0}{\vphantom{1}}{#1}{#2}}
  {\@legendre{3}{0}{\vphantom{1}}{#1}{#2}}
}
\def\dlegendre{\@legendre{0}{1}{}}
\def\tlegendre{\@legendre{1}{0.5}{\vphantom{1}}}
%% Equivalents
\newcommand{\equivo}[2][]{
    \if\relax\detokenize{#1}\relax
        \def\oargI{\operatorname{o}}
    \else
    \def\oargI{{\underset{\scriptscriptstyle{#1}}{\operatorname{o}}}}
    \fi\oargI\l#2\r
}
\newcommand{\equivO}[2][]{
    \if\relax\detokenize{#1}\relax
        \def\OargI{\operatorname{O}}
    \else
    \def\OargI{{\underset{\scriptscriptstyle{#1}}{\operatorname{O}}}}
    \fi\OargI\l#2\r
}
\newcommand{\equivTh}[2][]{
    \if\relax\detokenize{#1}\relax
        \def\ThargI{\operatorname{\upTheta}}
    \else
    \def\ThargI{{\underset{\scriptscriptstyle{#1}}{\operatorname{\upTheta}}}}
    \fi\ThargI\l#2\r
}
\newcommand{\equivOm}[2][]{
    \if\relax\detokenize{#1}\relax
        \def\OmargI{\operatorname{\upOmega}}
    \else
    \def\OmargI{{\underset{\scriptscriptstyle{#1}}{\operatorname{\upOmega}}}}
    \fi\OmargI\l#2\r
}
\newcommand{\equiveq}[3][]{
    \if\relax\detokenize{#1}\relax
        \def\eqargI{\sim}
    \else
    \def\eqargI{\underset{\scriptscriptstyle{#1}}{\sim}}
    \fi{#2}\eqargI#3
}
\newcommand{\equiveg}[3][]{
    \if\relax\detokenize{#1}\relax
        \def\egargI{=}
    \else
    \def\egargI{\underset{\scriptscriptstyle{#1}}{=}}
    \fi{#2}\egargI#3
}
%% Complexes
\renewcommand{\bar}{\overline}
\DeclareMathOperator{\olde}{e}
\newcommand{\e}{{\olde}}
\DeclareMathOperator{\oldi}{i}
\newcommand{\ii}{{\oldi}}
\DeclareMathSymbol{\tmpiii}{\mathalpha}{letters}{"10}
\DeclareMathOperator{\oldii}{\tmpiii}
\newcommand{\iii}{{\oldii}}
\DeclareMathOperator{\oldj}{j}
\newcommand{\jj}{{\oldj}}
\DeclareMathSymbol{\tmpjjj}{\mathalpha}{letters}{"11}
\DeclareMathOperator{\oldjj}{\tmpjjj}
\newcommand{\jjj}{{\oldjj}}
\let\altoldIm\Im
\newcommand{\altIm}[1]{\altoldIm\l#1\r}
\DeclareMathOperator{\oldIm}{Im}
\renewcommand{\Im}[1]{\oldIm\l#1\r}
\let\altoldRe\Re
\newcommand{\altRe}[1]{\altoldRe\l#1\r}
\DeclareMathOperator{\oldRe}{Re}
\renewcommand{\Re}[1]{\oldRe\l#1\r}
%% Galois
\DeclareMathOperator{\oldgal}{Gal}
\newcommand{\gal}[2]{\oldgal\l#1/#2\r}
\DeclareMathOperator{\dec}{D}
\newcommand\edeg[2]{\left[#1{:}#2\right]}
\newcommand\sdeg[2]{\left[#1{:}#2\right]_{\text{s}}}
\newcommand\ideg[2]{\left[#1{:}#2\right]_{\text{i}}}
\newcommand\ideg[2]{\left[#1{:}#2\right]_{\text{pi}}}
\DeclareMathOperator{\olddegsep}{deg\,sep}
\newcommand{\degsep}[2][]{\olddegsep_{#1}\l#2\r}
\DeclareMathOperator{\olddegins}{deg\,ins}
\newcommand{\degsep}[2][]{\olddegins_{#1}\l#2\r}
%% Hats
\newcommand{\arc}[1]{\mathpalette\arc@arc{#1}\!}
\newcommand{\arc@arc}[2]{
    \sbox0{$\m@th#1#2\ \!$}
    \vbox{
        \hbox{\hspace{-0.05\wd0}\resizebox{1.1\wd0}{\height}{$\frown$}}
        \nointerlineskip
        \vspace{-1pt}
        \box0
    }
}
\renewcommand{\hat}[1]{\mathpalette\hat@hat{#1}\sbox0{$\m@th#1$}\hspace{-0.375\wd0}}
\newcommand{\hat@hat}[2]{
    \sbox0{$\m@th#1#2$}
    \vbox{
        \hbox{\hspace{-0.375\wd0}\resizebox{1.75\wd0}{\height}{$\string^$}}
        \nointerlineskip
        \vspace{-5pt}
        \box0
    }
}
%% Polynomes
\newcommand{\pol}[2]{\mathbb{#1}\left[#2\right]}
\newcommand{\fr}[2]{\mathbb{#1}\l#2\r}
\let\olddeg\deg
\renewcommand{\deg}[1]{\olddeg\l#1\r}
\DeclareMathOperator{\oldval}{val}
\newcommand{\val}[1]{\oldval\l#1\r}
\DeclareMathOperator{\oldcar}{car}
\newcommand{\car}[1]{\oldcar\l#1\r}
\DeclareMathOperator{\oldrac}{rac}
\newcommand{\rac}[2][]{\oldrac_{#1}\l#2\r}
%% Probas
\newcommand\prob[2][]{
    \if\relax\detokenize{#2}\relax
        \def\pargII{}
    \else
        \def\pargII{\l#2\r}
    \fi\mathbb P_{#1}\pargII
}
\newcommand{\sq}{\;\middle|\;}
\newcommand\bor{\mathcal B}
\newcommand{\esp}[1]{\mathbb E\l#1\r}
\newcommand{\var}[1]{\mathbb V\l#1\r}
\newcommand{\ect}[1]{\sigma\l#1\r}
\DeclareMathOperator{\oldcov}{cov}
\newcommand{\cov}[2]{\oldcov\l#1,#2\r}
\newcommand{\indep}{\perp\!\!\!\perp}
\newcommand{\unif}[1]{\mathcal U\l#1\r}
\newcommand{\bin}[2][]{
    \if\relax\detokenize{#1}\relax
        \def\binargI{}
    \else
        \def\binargI{#1,}
    \fi\mathcal B\l\binargI#2\r
}
\newcommand{\geom}[1]{\mathcal G\l#1\r}
\newcommand{\pasc}[2]{\mathcal P\l#1,#2\r}
\newcommand{\nbin}[2]{\mathcal J\l#1,#2\r}
\newcommand{\hypg}[3]{\mathcal H\l#1,#2,#3\r}
\newcommand{\poiss}[1]{\mathcal P\l#1\r}
\newcommand{\expon}[1]{\mathcal E\l#1\r}
\newcommand{\normal}[2]{\mathcal N\l#1,#2\r}
%% Trigo
\let\oldcos\cos
\renewcommand\cos[2][]{\oldcos#1\l#2\r}
\let\oldsin\sin
\renewcommand\sin[2][]{\oldsin#1\l#2\r}
\let\oldtan\tan
\renewcommand\tan[2][]{\oldtan#1\l#2\r}
\let\oldcot\cot
\renewcommand\cot[2][]{\oldcot#1\l#2\r}
\newcommand\acos[2][]{\arccos#1\l#2\r}
\newcommand\asin[2][]{\arcsin#1\l#2\r}
\newcommand\atan[2][]{\arctan#1\l#2\r}
\DeclareMathOperator{\oldch}{ch}
\DeclareMathOperator{\oldsh}{sh}
\DeclareMathOperator{\oldth}{th}
\newcommand\ch[2][]{\oldch#1\l#2\r}
\newcommand\sh[2][]{\oldsh#1\l#2\r}
\renewcommand\th[2][]{\oldth#1\l#2\r}
\DeclareMathOperator{\oldach}{argch}
\DeclareMathOperator{\oldash}{argsh}
\DeclareMathOperator{\oldath}{argth}
\newcommand\ach[2][]{\oldach#1\l#2\r}
\newcommand\ash[2][]{\oldash#1\l#2\r}
\newcommand\ath[2][]{\oldath#1\l#2\r}
%% Usuelles
\def\bornelimits{\nolimits}
\def\limlimits{\limits}
\newcommand{\togglebornelimits}{\altarticle@comparestring{\bornelimits}{\limits}{\def\bornelimits{\nolimits}}{\def\bornelimits{\limits}}}
\newcommand{\autobornelimits}{\def\bornelimits{}}
\newcommand{\togglelimlimits}{\altarticle@comparestring{\limlimits}{\limits}{\def\limlimits{\nolimits}}{\def\limlimits{\limits}}}
\newcommand{\autolimlimits}{\def\limlimits{}}
\let\oldmin\min
\renewcommand\min[2][]{
    \if\relax\detokenize{#1}\relax
        \def\minargI{\oldmin}
    \else
        \def\minargI{\oldmin\bornelimits_{#1}}
    \fi\minargI\l#2\r
}
\let\oldmax\max
\renewcommand\max[2][]{
    \if\relax\detokenize{#1}\relax
        \def\maxargI{\oldmax}
    \else
        \def\maxargI{\oldmax\bornelimits_{#1}}
    \fi\maxargI\l#2\r
}
\let\oldlim\lim
\renewcommand\lim[2][]{
    \if\relax\detokenize{#1}\relax
        \def\limargI{\oldlim}
    \else
        \def\limargI{\oldlim\limlimits_{#1}}
    \fi\limargI\l#2\r
}
\newcommand\limi[2][]{
    \if\relax\detokenize{#1}\relax
        \def\limiargI{\liminf}
    \else
        \def\limiargI{\liminf\limlimits_{#1}}
    \fi\limiargI\l#2\r
}
\newcommand\lims[2][]{
    \if\relax\detokenize{#1}\relax
        \def\limsargI{\limsup}
    \else
        \def\limsargI{\limsup\limlimits_{#1}}
    \fi\limsargI\l#2\r
}
\let\oldexp\exp
\renewcommand\exp[2][]{\oldexp#1\l#2\r}
\let\oldln\ln
\renewcommand\ln[2][]{\oldln#1\l#2\r}
\let\oldinf\inf
\renewcommand\inf[2][]{
    \if\relax\detokenize{#1}\relax
        \def\infargI{\oldinf}
    \else
        \def\infargI{\oldinf\bornelimits_{#1}}
    \fi\infargI\l#2\r
}
\let\oldsup\sup
\renewcommand\sup[2][]{
    \if\relax\detokenize{#1}\relax
        \def\supargI{\oldsup}
    \else
        \def\supargI{\oldsup\bornelimits_{#1}}
    \fi\supargI\l#2\r
}
%% Topologie
\newcommand{\vala}[1]{\left|#1\right|}
\newcommand{\nrm}[2][]{\left\|#2\right\|_{#1}}
\newcommand{\nnrm}[2][]{\left|\kern-0.25ex\left|\kern-0.25ex\left|#2\right|\kern-0.25ex\right|\kern-0.25ex\right|_{#1}}
\DeclareMathOperator{\oldfrt}{fr}
\newcommand{\frt}[1]{\oldfrt\l#1\r}
\newcommand{\psc}[2]{\left\langle#1,#2\right\rangle}
%% Structures
\DeclareMathOperator{\oldhom}{Hom}
\renewcommand{\hom}[2][]{\oldhom_{#1}\l#2\r}
\DeclareMathOperator{\oldaut}{Aut}
\newcommand{\aut}[2][]{\oldaut_{#1}\l#2\r}
\let\oldker\ker
\renewcommand{\ker}[1]{\oldker\l#1\r}
\DeclareMathOperator{\oldim}{im}
\newcommand{\im}[1]{\oldim\l#1\r}
\newcommand{\la}{\left\langle}
\newcommand{\ra}{\right\rangle}
\DeclareMathOperator{\oldord}{ord}
\newcommand{\ord}[2][]{\oldord_{#1}\l#2\r}
%% Tables
\newlength\tblw
\newlength\tblh
\newcommand{\setcolrow}[1][]{
    \if\relax\detokenize{#1}\relax
        \setlength\tblw{10cm}
    \else
        \setlength\tblw{#1}
    \fi\tmpsetcolrow}
\newcommand{\tmpsetcolrow}[3][]{ %\setcolrow{n°col}{n°row}
    \if\relax\detokenize{#1}\relax
        \setlength\tblh{6.5cm}
    \else
        \setlength\tblh{#1}
    \fi
    \tikzset{
        table/.style={
            matrix of nodes,
            row sep=-\pgflinewidth,
            column sep=-\pgflinewidth,
            nodes={
                rectangle,
                draw=black,
                align=center,
                text width = \tblw/#2,
                inner sep = 0pt,
                minimum height = \tblh/#3,
                anchor=south,
            },
            inner sep = 0pt,
            nodes in empty cells,
        }
    }
}
%% Matrices
\newcommand{\mat}[3]{\def\matargII{,#2}\if\relax\detokenize{#2}\relax\def\matargII{}\fi\mathcal{M}_{#1\matargII}\l#3\r}
\newcommand{\sym}[3][]{\mathcal{S}_{#2}^{#1}\l#3\r}
\newcommand{\ant}[2]{\mathcal{A}_{#1}\l#2\r}
\newcommand{\diag}[2]{\mathcal{D}_{#1}\l#2\r}
\newcommand{\ts}[2]{\mathcal{T}_{#1}^+\l#2\r}
\newcommand{\ti}[2]{\mathcal{T}_{#1}^-\l#2\r}
\let\olddet\det
\renewcommand{\det}[2][]{\olddet_{#1}\l#2\r}
\DeclareMathOperator{\oldgl}{GL}
\newcommand{\matgl}[3][]{\oldgl_{#2}^{#1}\l#3\r}
\DeclareMathOperator{\oldcom}{Com}
\newcommand{\com}[1]{\oldcom\l#1\r}
\newcommand{\transp}[1]{{\vphantom{#1}^t}{#1}}
\newlength{\dotsep}
\newlength{\dotlift}
\newlength{\matsep}
\newlength{\matmin}
\makeatletter
\@ifclassloaded{beamer}{
    \setlength{\dotsep}{5.5pt}
    \setlength{\dotlift}{1.5pt}
    \setlength{\matsep}{5pt}
    \setlength{\matmin}{25pt}
}{
    \setlength{\dotsep}{3.5pt}
    \setlength{\dotlift}{0.5pt}
    \setlength{\matsep}{3.5pt}
    \setlength{\matmin}{15pt}
}
\newcommand{\amp}{\detokenize{&}}
\newcommand{\tmatrix}[1][]{\def\tmatargI{#1}\tmptmatrix}
\newcommand{\tmptmatrix}[4][]{
\begin{tikzpicture}[baseline={([yshift=-0.5ex]m.center)}]
    \matrix (m) [
        ampersand replacement=\&,
        nodes={anchor=center},
        matrix of math nodes,
        left delimiter=#2,
        right delimiter=#4,
        anchor=center,
        minimum width=\matmin,
        minimum height=\matmin,
        row sep=\matsep,
        column sep=\matsep,
        inner sep=0pt,
        nodes in empty cells,
        #1
    ] {#3};
    \tmatargI
\end{tikzpicture}}
\def\smalltmatrix{\tmatrix[][minimum height = 0ex, row sep = .5ex, minimum width = 0ex, column sep = 1ex, inner sep = 0ex, nodes={anchor=base, execute at begin node=\scriptstyle},]}
\def\crampedtmatrix{\tmatrix[][minimum height = 0ex, row sep = .5ex, minimum width = 0ex, column sep = 1ex, inner sep = 0ex, nodes={anchor=base},]}
\newcommand{\tcase}[1][]{\def\tmatargI{#1}\tmptcase}
\newcommand{\tmptcase}[2][]{
\kern-.2em\begin{tikzpicture}[every left delimiter/.style={xshift=.2em},every right delimiter/.style={xshift=-.125em},baseline={([yshift=-0.5ex]m.center)}]
    \matrix (m) [
        ampersand replacement=\&,
        nodes={anchor=west, execute at begin node=$\scriptstyle,%
            execute at end node=$%
        },
        matrix of nodes,
        left delimiter=\{,
        right delimiter={.\kern-\nulldelimiterspace},
        anchor=center,
        minimum width=0pt,
        minimum height=0pt,
        row sep=1pt,
        column sep=1ex,
        inner sep=0pt,
        nodes in empty cells,
        #1
    ] {#2};
    \tmatargI
\end{tikzpicture}}
\DeclareMathSymbol{\mcdot}{\mathpunct}{symbols}{"01}
\def\oldmdots{\mathinner{\hbox{$\mcdot$}\hbox{$\mcdot$}\hbox{$\mcdot$}}}
\def\oldddots{\mathinner{\raise2\dotsep\vbox{\hbox{$\mcdot$}}\raise\dotsep\hbox{$\mcdot$}\raise0pt\hbox{$\mcdot$}}}
\def\oldidots{\mathinner{\raise0pt\vbox{\hbox{$\mcdot$}}\raise\dotsep\hbox{$\mcdot$}\raise2\dotsep\hbox{$\mcdot$}}}
\def\oldvdots{\mathinner{\raise2\dotsep\vbox{\hbox{$\mcdot$}}\mkern-5mu\raise\dotsep\hbox{$\mcdot$}\mkern-5mu\raise0pt\hbox{$\mcdot$}}}
\def\oldxdots{\mathinner{\raise2\dotsep\vbox{\hbox{$\mcdot$}}\mkern-5mu\raise0pt\hbox{$\mcdot$}\raise\dotsep\hbox{$\mcdot$}\raise2\dotsep\vbox{\hbox{$\mcdot$}}\mkern-5mu\raise0pt\hbox{$\mcdot$}}}
\def\oldplusdots{\mathinner{\raise\dotsep\hbox{$\mcdot$}\raise2\dotsep\vbox{\hbox{$\mcdot$}}\mkern-5mu\raise\dotsep\hbox{$\mcdot$}\mkern-5mu\raise0pt\hbox{$\mcdot$}\raise\dotsep\hbox{$\mcdot$}}}
\newcommand{\mdots}{\raise\dotlift\hbox{$\oldmdots$}}
\newcommand{\mddots}{\vcenter{\hbox{$\lower1pt\hbox{$\oldddots$}$}}}
\newcommand{\midots}{\vcenter{\hbox{$\lower1pt\hbox{$\oldidots$}$}}}
\newcommand{\mvdots}{\vcenter{\hbox{$\lower1pt\hbox{$\oldvdots$}$}}}
\newcommand{\mxdots}{\vcenter{\hbox{$\lower1pt\hbox{$\oldxdots$}$}}}
\newcommand{\mplusdots}{\vcenter{\hbox{$\lower1pt\hbox{$\oldplusdots$}$}}}
\def\tikz@lib@fit@scan{%
  \pgfutil@ifnextchar\pgf@stop{\pgfutil@gobble}{%
    \pgfutil@ifnextchar\foreach{\tikz@lib@fit@scan@handle@foreach}{%
      \tikz@scan@one@point\tikz@lib@fit@scan@handle}}}
\def\tikz@lib@fit@scan@handle@foreach\foreach#1in#2#3{%
  \foreach #1 in {#2}
  {\tikz@scan@one@point\tikz@lib@fit@scan@handle@foreach@#3}
  \tikz@lib@fit@scan}
\def\tikz@lib@fit@scan@handle@foreach@#1{%
  \iftikz@shapeborder
    \tikz@lib@fit@adjust{%
      \pgfpointanchor{\tikz@shapeborder@name}{west}}%
    \tikz@lib@fit@adjust{%
      \pgfpointanchor{\tikz@shapeborder@name}{east}}%
    \tikz@lib@fit@adjust{%
      \pgfpointanchor{\tikz@shapeborder@name}{north}}%
    \tikz@lib@fit@adjust{%
      \pgfpointanchor{\tikz@shapeborder@name}{south}}%
  \else
    \tikz@lib@fit@adjust{#1}%
  \fi
  \global\pgf@xa=\pgf@xa
  \global\pgf@ya=\pgf@ya
  \global\pgf@xb=\pgf@xb
  \global\pgf@yb=\pgf@yb}
\makeatletter
\newcommand\mtxvline[2]{
    \altarticle@comparestring{#2}{left}{
        \path (m.west) coordinate (X);
    }{
        \altarticle@comparestring{#2}{right}{
            \path (m.east) coordinate (X);
        }{
            \pgfmathparse{int(#2+1)}
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-#2)}] (fit-l) {};
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-\pgfmathresult)}] (fit-r) {};
            \path (fit-l.east) -- (fit-r.west) coordinate[midway] (X);
        }
    }
    \draw[#1] ($(X |- m.north)-(0, \pgflinewidth/2)$) --  ($(X |- m.south)+(0, \pgflinewidth/2)$);
}
\newcommand\mtxhline[2]{
    \altarticle@comparestring{#2}{top}{
        \path (m.north) coordinate (X);
    }{
        \altarticle@comparestring{#2}{bottom}{
            \path (m.south) coordinate (X);
        }{
            \pgfmathparse{int(#2+1)}
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-#2-\x)}] (fit-t) {};
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-\pgfmathresult-\x)}] (fit-b) {};
            \path (fit-t.south) -- (fit-b.north) coordinate[midway] (X);
        }
    }
    \draw[#1] ($(X -| m.west)-(\pgflinewidth/2, 0)$) --  ($(X -| m.east)+(\pgflinewidth/2, 0)$);
}
\newcommand\mtxvpartial[4]{
    \altarticle@comparestring{#2}{left}{
        \path (m.west) coordinate (Xv);
    }{
        \altarticle@comparestring{#2}{right}{
            \path (m.east) coordinate (Xv);
        }{
            \pgfmathparse{int(#2+1)}
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-#2)}] (fit-l) {};
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-\pgfmathresult)}] (fit-r) {};
            \path (fit-l.east) -- (fit-r.west) coordinate[midway] (Xv);
        }
    }
    \altarticle@comparestring{#3}{top}{
        \path (m.north) coordinate (Xt);
    } {
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-#3-\x)}] (fit-t1) {};
        \pgfmathparse{int(#3+1)}
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-\pgfmathresult-\x)}] (fit-t2) {};
        \path (fit-t1.south) -- (fit-t2.north) coordinate[midway] (Xt);
    }
    \altarticle@comparestring{#4}{bottom}{
        \path (m.south) coordinate (Xb);
    } {
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-#4-\x)}] (fit-b1) {};
        \pgfmathparse{int(#4+1)}
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-\pgfmathresult-\x)}] (fit-b2) {};
        \path (fit-b1.south) -- (fit-b2.north) coordinate[midway] (Xb);
    }
    \draw[#1] ($(Xv |- Xt)-(0, \pgflinewidth/2)$) --  ($(Xv |- Xb)+(0, \pgflinewidth/2)$);
}
\newcommand\mtxhpartial[4]{
    \altarticle@comparestring{#2}{top}{
        \path (m.north) coordinate (Xh);
    }{
        \altarticle@comparestring{#2}{bottom}{
            \path (m.south) coordinate (Xh);
        }{
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-#2-\x)}] (fit-t) {};
            \pgfmathparse{int(#2+1)}
            \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentcolumn}{(m-\pgfmathresult-\x)}] (fit-b) {};
            \path (fit-b.north) -- (fit-t.south) coordinate[midway] (Xh);
        }
    }
    \altarticle@comparestring{#3}{left}{
        \path (m.west) coordinate (Xl);
    } {
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-#3)}] (fit-l1) {};
        \pgfmathparse{int(#3+1)}
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-\pgfmathresult)}] (fit-l2) {};
        \path (fit-l1.east) -- (fit-l2.west) coordinate[midway] (Xl);
    }
    \altarticle@comparestring{#4}{right}{
        \path (m.east) coordinate (Xr);
    } {
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-#4)}] (fit-r1) {};
        \pgfmathparse{int(#4+1)}
        \node [fit=\foreach \x in {1,...,\the\pgfmatrixcurrentrow}{(m-\x-\pgfmathresult)}] (fit-r2) {};
        \path (fit-r1.east) -- (fit-r2.west) coordinate[midway] (Xr);
    }
    \draw[#1] ($(Xh -| Xl)-(\pgflinewidth/2, 0)$) --  ($(Xh -| Xr)+(\pgflinewidth/2, 0)$);
}
\newcommand\mtxbox[3]{
    \ifnum#2=1
        \edef\leftcoord{left}
    \else
        \pgfmathparse{int(#2-1)}
        \edef\leftcoord{\pgfmathresult}
    \fi
    \ifnum#3=1
        \edef\topcoord{top}
    \else
        \pgfmathparse{int(#3-1)}
        \edef\topcoord{\pgfmathresult}
    \fi
    \ifnum#2=\the\pgfmatrixcurrentcolumn
        \edef\rightcoord{right}
    \else
        \edef\rightcoord{#2}
    \fi
    \ifnum#3=\the\pgfmatrixcurrentrow
        \edef\bottomcoord{bottom}
    \else
        \edef\bottomcoord{#3}
    \fi
    \mtxhpartial{#1}{\topcoord}{\leftcoord}{\rightcoord}
    \mtxhpartial{#1}{\bottomcoord}{\leftcoord}{\rightcoord}
    \mtxvpartial{#1}{\leftcoord}{\topcoord}{\bottomcoord}
    \mtxvpartial{#1}{\rightcoord}{\topcoord}{\bottomcoord}
}
%% AL
\DeclareMathOperator{\oldvect}{Vect}
\newcommand{\vect}[1]{\oldvect\l#1\r}
\newcommand{\al}[3][]{\def\alargII{,#3}\if\relax\detokenize{#3}\relax\def\alargII{}\fi\mathcal{L}_{#1}\l#2\alargII\r}
\let\oplus\varoplus
\let\otimes\varotimes
\newcommand{\gl}[1]{\oldgl\l#1\r}
\let\olddim\dim
\renewcommand{\dim}[1]{\olddim\l#1\r}
\DeclareMathOperator{\oldrg}{rg}
\newcommand{\rg}[1]{\oldrg\l#1\r}
\DeclareMathOperator{\oldtr}{tr}
\newcommand{\tr}[1]{\oldtr\l#1\r}
\DeclareMathOperator{\oldmat}{Mat}
\newcommand{\almat}[3]{\def\almatargIII{,#3}\if\relax\detokenize{#3}\relax\def\almatargIII{}\fi\oldmat_{#2\almatargIII}\l#1\r}
\DeclareMathOperator{\oldsl}{SL}
\renewcommand{\sl}[2][]{\oldsl_{#1}\l#2\r}
\DeclareMathOperator{\oldorth}{O}
\newcommand{\orth}[2][]{\oldorth_{#1}\l#2\r}
\DeclareMathOperator{\oldso}{SO}
\newcommand{\so}[2][]{\oldso_{#1}\l#2\r}
\DeclareMathOperator{\oldsym}{S}
\newcommand{\alsym}[2][]{\oldsym^{#1}\l#2\r}
\DeclareMathOperator{\oldsp}{sp}
\renewcommand{\sp}[2][]{\oldsp_{#1}\l#2\r}
\DeclareMathOperator{\id}{id}
\DeclareMathOperator{\olddiscr}{discr}
\newcommand{\discr}[2][]{\olddiscr_{#1}\l#2\r}
\newcommand{\appl}[5]{\begin{array}[t]{@{}r@{}r@{}c@{}l@{}}#1\!:\!{}&#2&{}\longrightarrow{}&#3\\&#4&{}\longmapsto{}&#5\end{array}}
\newcommand{\nappl}[4]{\begin{array}[t]{@{}r@{}c@{}l@{}}#1&{}\longrightarrow{}&#2\\#3&{}\longmapsto{}&#4\end{array}}
%% Analyse
\def\analyseleftp{\l}
\def\analyserightp{\r}
\def\analyselimits{}
\def\analysedisplay{\displaystyle}
\newcommand{\toggleanalysepar}{\altarticle@comparestring{\analyseleftp}{}{\def\analyseleftp{\l}\def\analyserightp{\r}}{\def\analyseleftp{}\def\analyserightp{}}}
\newcommand{\toggleanalyselimits}{\altarticle@comparestring{\analyselimits}{\limits}{\def\analyselimits{\nolimits}}{\def\analyselimits{\limits}}}
\newcommand{\autoanalyselimits}{\def\analyselimits{}}
\newcommand{\toggleanalysedisplay}{\altarticle@comparestring{\analysedisplay}{}{\def\analysedisplay{\displaystyle}}{\def\analysedisplay{}}}
\newcommand{\autoanalysedisplay}{\def\analysedisplay{}}
\let\oldderfrac\frac
\newcommand{\derfrac}[2]{{\analysedisplay\oldderfrac{#1}{#2}}}

\let\slantpartial\partial
\ifpdf
    % pdf output
    \newsavebox{\partialbox}
    \newcommand{\displaypartial}{\noexpand{\unslant{\displaystyle\textstyle\slantpartial}}\kern-1.2pt}
    \newcommand{\normalpartial}{\noexpand{\unslant{\textstyle\slantpartial}}\kern-1.2pt}
    \newcommand{\scriptpartial}{\noexpand{\unslant{\scriptstyle\slantpartial}}\kern-1.2pt}
    \newcommand{\scriptscriptpartial}{\noexpand{\unslant{\scriptscriptstyle\slantpartial}}\kern-1.2pt}
    \renewcommand{\partial}{\mathchoice{\displaypartial}{\normalpartial}{\scriptpartial}{\scriptscriptpartial}}
\else
    % other output
    \renewcommand{\partial}{\slantpartial\kern-0.8pt}
\fi
\newcommand{\resetpartial}{\let\partial\slantpartial}


\newcounter{mpdercount}
\def\mpderden{}
\newcounter{mpdervarcount}
\def\prevmpdervar{}
\newcounter{altintvarindex}
\def\altintspacevars{}
\def\altintvars{}
\newcommand{\scanmpderlist}[1]{
    \foreach \elem in {#1}{
        \stepcounter{mpdercount}
        \altarticle@comparestring{\prevmpdervar}{\elem}{
            \stepcounter{mpdervarcount}
        }{
            \altarticle@comparestring{\arabic{mpdervarcount}}{1}{}{\xdef\mpderden{\unexpanded\expandafter{\mpderden}^{\arabic{mpdervarcount}}}}
            \xdef\mpderden{\unexpanded\expandafter{\mpderden}\noexpand\partial\noexpand{\elem}}
            \setcounter{mpdervarcount}{1}
            \xdef\prevmpdervar{\elem}
        }
    }
    \altarticle@comparestring{\arabic{mpdervarcount}}{1}{}{\edef\mpderden{\unexpanded\expandafter{\mpderden}^{\arabic{mpdervarcount}}}}
}
\newcommand{\scanmpder}[1]{
    \setcounter{mpdercount}{0}
    \def\mpderden{}
    \setcounter{mpdervarcount}{1}
    \def\prevmpdervar{}
    \scanmpderlist{#1}
}
\newcommand{\scanaltintlist}[1]{
    \foreach \elem in {#1} {
        \altarticle@comparestring{\arabic{altintvarindex}}{0}{\xdef\altintspacevars{\unexpanded\expandafter{\altintspacevars}\noexpand\intd\noexpand\elem}}{\xdef\altintspacevars{\unexpanded\expandafter{\altintspacevars}\noexpand\dd\noexpand\elem}}
        \xdef\altintvars{\unexpanded\expandafter{\altintvars}\noexpand\dd\noexpand\elem}
        \setcounter{altintvarindex}{1}
    }
}
\newcommand{\scanaltint}[1]{
    \setcounter{altintvarindex}{0}
    \def\altintspacevars{}
    \def\altintvars{}
    \scanaltintlist{#1}
}

\DeclareMathOperator{\oldd}{d}
\newcommand{\dd}{{\oldd}}
\newcommand{\intd}{{{}\oldd}}
\newcommand{\der}[1][]{\def\derargI{#1}\tmpder}
\newcommand{\tmpder}[3][x]{
    \if\relax\detokenize{#3}\relax
        \def\derargIII{}
    \else
        \def\derargIII{\analyseleftp{#3}\analyserightp}
    \fi\derfrac{\dd^{\derargI}{#2}}{\dd#1^{\derargI}}\derargIII}
\newcommand{\pder}[1][]{\def\pderargI{#1}\tmppder}
\newcommand{\tmppder}[3][x]{
    \if\relax\detokenize{#3}\relax
        \def\pderargIII{}
    \else
        \def\pderargIII{\analyseleftp{#3}\analyserightp}
    \fi\derfrac{\partial^{\pderargI}{#2}}{\partial#1^{\pderargI}}\pderargIII}
\newcommand{\mpder}[3][x]{\scanmpder{#1}
    \if\relax\detokenize{#3}\relax
        \def\mpderargIII{}
    \else
        \def\mpderargIII{\analyseleftp{#3}\analyserightp}
    \fi\derfrac{\partial^{\arabic{mpdercount}}{#2}}{\mpderden}\mpderargIII}
\let\oldint\int
\newcommand{\inint}{\mkern-3mu{\analysedisplay\mathchoice{\mkern-4mu}{\mkern-2mu}{}{}}\int}
\renewcommand{\int}[1][]{\def\intvar{#1}
    \if\relax\detokenize{#1}\relax
        \def\intargI{}
    \else
        \def\intargI{{{}\oldd}#1}
    \fi\tmpint
}
\newcommand{\tmpint}[1][]{
    \if\relax\detokenize{#1}\relax
        \def\intargII{}
    \else
        \def\intargII{\analyselimits_{#1}}
    \fi\tmptmpint
}
\newcommand{\tmptmpint}[1][]{
    \if\relax\detokenize{#1}\relax
        \def\intargIII{}
    \else
        \def\intargIII{\analyselimits^{#1}}
    \fi\tmptmptmpint
}
\newcommand{\tmptmptmpint}[2][]{\mathop{}\mkern-3mu{\analysedisplay\oldint\intargII\intargIII}\mkern-3mu{}\mathop{}\analyseleftp{#2}\analyserightp\if\relax\detokenize{#1}\relax\intargI\else{{}\mathop{#1\l\dd\intvar\r}}\fi}
\newcommand{\altint}[1]{\def\altintsymb{#1}\tmpaltint}
\newcommand{\tmpaltint}[1][]{\scanaltint{#1}\tmptmpaltint}
\newcommand{\tmptmpaltint}[1][]{
    \if\relax\detokenize{#1}\relax
        \def\intargII{}
    \else
        \def\intargII{\analyselimits_{#1}}
    \fi\tmptmptmpaltint
}
\newcommand{\tmptmptmpaltint}[1][]{
    \if\relax\detokenize{#1}\relax
        \def\intargIII{}
    \else
        \def\intargIII{\analyselimits^{#1}}
    \fi\tmptmptmptmpaltint
}
\newcommand{\tmptmptmptmpaltint}[2][]{\mathop{}\mkern-3mu{\analysedisplay\altintsymb\intargII\intargIII}\mkern-3mu{}\mathop{}\analyseleftp{#2}\analyserightp\if\relax\detokenize{#1}\relax\altintspacevars\else{{}\mathop{{\let\oldotimes\otimes\def\otimes{{\oldotimes}}#1}\l\altintvars\r}}\fi}
\newcommand{\eval}[1][]{\def\evalargI{#1}\tmpeval}
\newcommand{\tmpeval}[2][]{\left[#2\right]_{\evalargI}^{#1}}
\newcommand{\serie}[1]{\oldsum#1}
\DeclareMathOperator{\oldesc}{Esc}
\newcommand{\esc}[2][]{\oldesc_{#1}\l#2\r}
\DeclareMathOperator{\oldcm}{CM}
\newcommand{\cm}[2][]{\oldcm_{#1}\l#2\r}
\DeclareMathOperator{\oldfnint}{Int}
\newcommand{\fnint}[1]{\oldfnint\l#1\r}
\let\anrm\relax
\newcommand{\anrm}[2][\infty]{\left\|#2\right\|_{#1}}
\DeclareMathOperator{\oldva}{VA}
\newcommand{\va}[1]{\oldva\l#1\r}
\DeclareMathOperator{\oldepi}{Epi}
\newcommand{\epi}[1]{\oldepi\l#1\r}
%% Dsft
\usepackage{dsft}
% \let\star\relax
% \let\square\relax
% \let\triangle\relax
% \pdfmapfile{+dsrm/dsrm.map}
% \newfont{\dsft}{dsrm/dsrm12}
% \DeclareFontFamily{U}{dsrm}{}
% \DeclareFontShape{U}{dsrm}{m}{n}{
%     <-> dsrm/dsrm12
% }{}
% \DeclareSymbolFont{mathds}{U}{dsrm}{m}{n}
% \DeclareMathAlphabet{\mathds}{U}{dsrm}{m}{n}
% \newcommand\ind[1]{\mathds{1}_{#1}}
% \DeclareMathSymbol{\square}{\mathbin}{mathds}{"41}
% \DeclareMathSymbol{\star}{\mathbin}{mathds}{"42}
% \DeclareMathSymbol{\triangle}{\mathbin}{mathds}{"43}
% \newcommand{\filledstar}[1]{%
%     \ifcase#1\relax%
%         \ensuremath{\mathds{B}}%
%     \or\relax%
%         \ensuremath{\mathds{D}}%
%     \or\relax%
%         \ensuremath{\mathds{E}}%
%     \or\relax%
%         \ensuremath{\mathds{F}}%
%     \or\relax%
%         \ensuremath{\mathds{G}}%
%     \or\relax%
%         \ensuremath{\mathds{H}}%
%     \else%
%         \hphantom{\ensuremath{\mathds{1}}}
%     \fi%
% }
% \newcommand{\rmbeta}{\ensuremath{\mathds{b}}}
% \newcommand{\rmepsilon}{\ensuremath{\mathds{e}}}
% \newcommand{\rmphi}{\ensuremath{\mathds{f}}}
% \newcommand{\rmgamma}{\ensuremath{\mathds{g}}}
% \newcommand{\rmiota}{\ensuremath{\mathds{i}}}
% \newcommand{\rmkappa}{\ensuremath{\mathds{k}}}
% \newcommand{\rmmu}{\ensuremath{\mathds{m}}}
% \newcommand{\rmnu}{\ensuremath{\mathds{n}}}
% \newcommand{\rmomicron}{\ensuremath{\mathds{o}}}
% \newcommand{\rmpi}{\ensuremath{\mathds{p}}}
% \newcommand{\rmrho}{\ensuremath{\mathds{r}}}
% \newcommand{\rmtau}{\ensuremath{\mathds{t}}}
% \newcommand{\rmvarsigma}{\ensuremath{\mathds{v}}}