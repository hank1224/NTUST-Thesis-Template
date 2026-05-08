\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ntust_thesis}[2026/04/23 NTUST thesis class]

\LoadClass[12pt,a4paper,oneside]{report}

\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{ntust_thesis}{This class requires XeLaTeX}{Compile with XeLaTeX.}
\fi

\RequirePackage{geometry}
\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\RequirePackage{setspace}
\RequirePackage{graphicx}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{ragged2e}
\RequirePackage{booktabs}
\RequirePackage{pdfpages}
\RequirePackage{titlesec}
\RequirePackage{indentfirst}
\RequirePackage{caption}
\RequirePackage[chapter]{algorithm}
\RequirePackage{algpseudocode}
\RequirePackage{etoolbox}
\RequirePackage{eso-pic}
\RequirePackage{tikz}
\RequirePackage{xcolor}
\RequirePackage{listings}
\RequirePackage{zhnumber}
\RequirePackage{hyperref}

\geometry{
  a4paper,
  top=3cm,
  bottom=2cm,
  left=3cm,
  right=3cm
}

\setmainfont{Times New Roman}
\setCJKmainfont[AutoFakeBold=2.5]{標楷體}
\setCJKmonofont[AutoFakeBold=2.5]{標楷體}
\XeTeXlinebreaklocale "zh"
\XeTeXlinebreakskip=0pt plus 1pt

\hypersetup{
  colorlinks=false,
  pdfborder={0 0 0},
  hypertexnames=false
}

\makeatletter

\def\ntust@degree{master}
\def\ntust@language{zh}
\def\ntust@bodyfontsize{12}
\def\ntust@bibstyle{apa}
\def\ntust@includesymbols{true}
\def\ntust@appendixnumbering{alpha}
\def\ntust@tocchapterprefix{}

\newif\ifntust@watermarkenabled
\ntust@watermarkenabledtrue

\def\ntust@departmentzh{系所中文名稱}
\def\ntust@departmenten{Department Name}
\def\ntust@schoolzh{國立臺灣科技大學}
\def\ntust@schoolen{National Taiwan University of Science and Technology}
\def\ntust@titlezh{論文中文題目}
\def\ntust@titleen{English Thesis Title}
\def\ntust@authorzh{研究生姓名}
\def\ntust@authoren{Student Name}
\def\ntust@advisorzh{指導教授姓名}
\def\ntust@advisoren{Advisor Name}
\def\ntust@advisortitlezh{教授}
\def\ntust@advisortitleen{Professor}
\def\ntust@coadvisorzh{}
\def\ntust@coadvisoren{}
\def\ntust@coadvisortitlezh{}
\def\ntust@coadvisortitleen{}
\def\ntust@graduationyearroc{一一五}
\def\ntust@graduationyearad{2026}
\def\ntust@graduationmonthzh{六月}
\def\ntust@graduationmonthen{June}
\def\ntust@keywordszh{關鍵詞一、關鍵詞二、關鍵詞三、關鍵詞四、關鍵詞五}
\def\ntust@keywordsen{keyword one, keyword two, keyword three, keyword four, keyword five}
\def\ntust@recommendationfile{}
\def\ntust@approvalfile{}

\newcommand{\NTUSTDegree}[1]{\gdef\ntust@degree{#1}}
\newcommand{\NTUSTThesisLanguage}[1]{\gdef\ntust@language{#1}}
\newcommand{\NTUSTBodyFontSize}[1]{\gdef\ntust@bodyfontsize{#1}}
\newcommand{\NTUSTBibliographyStyle}[1]{\gdef\ntust@bibstyle{#1}}
\newcommand{\NTUSTIncludeSymbolsIndex}[1]{\gdef\ntust@includesymbols{#1}}
\newcommand{\NTUSTAppendixNumbering}[1]{\gdef\ntust@appendixnumbering{#1}}

\newcommand{\NTUSTDepartmentZh}[1]{\gdef\ntust@departmentzh{#1}}
\newcommand{\NTUSTDepartmentEn}[1]{\gdef\ntust@departmenten{#1}}
\newcommand{\NTUSTSchoolZh}[1]{\gdef\ntust@schoolzh{#1}}
\newcommand{\NTUSTSchoolEn}[1]{\gdef\ntust@schoolen{#1}}
\newcommand{\NTUSTTitleZh}[1]{\gdef\ntust@titlezh{#1}}
\newcommand{\NTUSTTitleEn}[1]{\gdef\ntust@titleen{#1}}
\newcommand{\NTUSTAuthorZh}[1]{\gdef\ntust@authorzh{#1}}
\newcommand{\NTUSTAuthorEn}[1]{\gdef\ntust@authoren{#1}}
\newcommand{\NTUSTAdvisorZh}[1]{\gdef\ntust@advisorzh{#1}}
\newcommand{\NTUSTAdvisorEn}[1]{\gdef\ntust@advisoren{#1}}
\newcommand{\NTUSTAdvisorTitleZh}[1]{\gdef\ntust@advisortitlezh{#1}}
\newcommand{\NTUSTAdvisorTitleEn}[1]{\gdef\ntust@advisortitleen{#1}}
\newcommand{\NTUSTCoAdvisorZh}[1]{\gdef\ntust@coadvisorzh{#1}}
\newcommand{\NTUSTCoAdvisorEn}[1]{\gdef\ntust@coadvisoren{#1}}
\newcommand{\NTUSTCoAdvisorTitleZh}[1]{\gdef\ntust@coadvisortitlezh{#1}}
\newcommand{\NTUSTCoAdvisorTitleEn}[1]{\gdef\ntust@coadvisortitleen{#1}}
\newcommand{\NTUSTGraduationYearROC}[1]{\gdef\ntust@graduationyearroc{#1}}
\newcommand{\NTUSTGraduationYearAD}[1]{\gdef\ntust@graduationyearad{#1}}
\newcommand{\NTUSTGraduationMonthZh}[1]{\gdef\ntust@graduationmonthzh{#1}}
\newcommand{\NTUSTGraduationMonthEn}[1]{\gdef\ntust@graduationmonthen{#1}}
\newcommand{\NTUSTKeywordsZh}[1]{\gdef\ntust@keywordszh{#1}}
\newcommand{\NTUSTKeywordsEn}[1]{\gdef\ntust@keywordsen{#1}}
\newcommand{\NTUSTRecommendationFile}[1]{\gdef\ntust@recommendationfile{#1}}
\newcommand{\NTUSTApprovalFile}[1]{\gdef\ntust@approvalfile{#1}}

\newcommand{\ntust@bodyfont}{%
  \ifdefstring{\ntust@bodyfontsize}{13}
    {\fontsize{13pt}{19.5pt}\selectfont}
    {\fontsize{12pt}{18pt}\selectfont}%
}

\renewcommand{\ps@plain}{%
  \let\@oddhead\@empty
  \let\@evenhead\@empty
  \def\@oddfoot{\hfil\thepage\hfil}%
  \def\@evenfoot{\hfil\thepage\hfil}%
}
\pagestyle{plain}

\renewcommand{\@pnumwidth}{2em}
\renewcommand{\@tocrmarg}{3em}

\newcommand{\ntust@degreezh}{%
  \ifdefstring{\ntust@degree}{doctoral}{博士論文}{碩士論文}%
}
\newcommand{\ntust@degreeen}{%
  \ifdefstring{\ntust@degree}{doctoral}{Doctoral Dissertation}{Master Thesis}%
}

\newcommand{\ntust@applylanguage}{%
  \ifdefstring{\ntust@language}{zh}{%
    \gdef\ntust@tocchapterprefix{}%
    \renewcommand{\contentsname}{目錄}%
    \renewcommand{\listfigurename}{圖目錄}%
    \renewcommand{\listtablename}{表目錄}%
    \renewcommand{\figurename}{圖}%
    \renewcommand{\tablename}{表}%
    \renewcommand{\chaptername}{第}%
    \renewcommand{\bibname}{參考文獻}%
    \renewcommand{\appendixname}{附錄}%
    \renewcommand{\thechapter}{\arabic{chapter}}%
    \renewcommand{\thesection}{\zhnumber{\arabic{section}}、}%
    \renewcommand{\thesubsection}{（\zhnumber{\arabic{subsection}}）}%
    \renewcommand{\thesubsubsection}{\arabic{subsubsection}.}%
    \renewcommand{\theparagraph}{（\arabic{paragraph}）}%
    \titleformat{\chapter}[block]
      {\centering\fontsize{20pt}{30pt}\bfseries}
      {第\zhnumber{\arabic{chapter}}章}{1em}{}%
    \titleformat{\section}
      {\fontsize{18pt}{27pt}\bfseries}
      {\thesection}{0.5em}{}%
    \titleformat{\subsection}
      {\fontsize{14pt}{21pt}\bfseries}
      {\thesubsection}{0.5em}{}%
    \titleformat{\subsubsection}
      {\fontsize{12pt}{18pt}\bfseries}
      {\thesubsubsection}{0.5em}{}%
    \titleformat{\paragraph}[block]
      {\fontsize{12pt}{18pt}\bfseries}
      {\theparagraph}{0.5em}{}%
    \captionsetup{labelformat=ntustzh,labelsep=space,justification=centering}%
    \setlength{\parindent}{2em}%
    \setlength{\parskip}{0.2\baselineskip plus 0.05\baselineskip minus 0.03\baselineskip}%
  }{%
    \gdef\ntust@tocchapterprefix{Chapter }%
    \renewcommand{\contentsname}{Contents}%
    \renewcommand{\listfigurename}{List of Figures}%
    \renewcommand{\listtablename}{List of Tables}%
    \renewcommand{\figurename}{Figure}%
    \renewcommand{\tablename}{Table}%
    \renewcommand{\chaptername}{Chapter}%
    \renewcommand{\bibname}{References}%
    \renewcommand{\appendixname}{Appendix}%
    \renewcommand{\thechapter}{\arabic{chapter}}%
    \renewcommand{\thesection}{\thechapter.\arabic{section}}%
    \renewcommand{\thesubsection}{\thesection.\arabic{subsection}}%
    \renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}%
    \renewcommand{\theparagraph}{\thesubsubsection.\arabic{paragraph}}%
    \titleformat{\chapter}[block]
      {\centering\fontsize{20pt}{30pt}\bfseries}
      {Chapter \thechapter}{1em}{}%
    \titleformat{\section}
      {\fontsize{18pt}{27pt}\bfseries}
      {\thesection}{0.5em}{}%
    \titleformat{\subsection}
      {\fontsize{14pt}{21pt}\bfseries}
      {\thesubsection}{0.5em}{}%
    \titleformat{\subsubsection}
      {\fontsize{12pt}{18pt}\bfseries}
      {\thesubsubsection}{0.5em}{}%
    \titleformat{\paragraph}[block]
      {\fontsize{12pt}{18pt}\bfseries}
      {\theparagraph}{0.5em}{}%
    \captionsetup{labelformat=ntusten,labelsep=space,justification=centering}%
    \setlength{\parindent}{2.5em}%
    \setlength{\parskip}{0.2\baselineskip plus 0.05\baselineskip minus 0.03\baselineskip}%
  }%
  \renewcommand{\thefigure}{\thechapter-\arabic{figure}}%
  \renewcommand{\thetable}{\thechapter-\arabic{table}}%
  \renewcommand{\thealgorithm}{\thechapter-\arabic{algorithm}}%
}

\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
    \refstepcounter{chapter}%
    \typeout{\@chapapp\space\thechapter.}%
    \ifdefstring{\ntust@language}{en}
      {\addcontentsline{toc}{chapter}{\ntust@tocchapterprefix\thechapter\space #1}}%
      {%
        \ifdefempty{\ntust@tocchapterprefix}
          {\addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}}%
          {\addcontentsline{toc}{chapter}{\ntust@tocchapterprefix\thechapter\space #1}}%
      }%
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi
}

\renewcommand*\l@chapter[2]{%
  \ifdefstring{\ntust@language}{en}
    {\@dottedtocline{0}{0em}{1.5em}{#1}{#2}}
    {\@dottedtocline{0}{0em}{2.5em}{#1}{#2}}%
}

\DeclareCaptionLabelFormat{ntustzh}{#1#2}
\DeclareCaptionLabelFormat{ntusten}{#1~#2}
\captionsetup{font=normalsize}

\newcolumntype{L}[1]{>{\RaggedRight\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\Centering\arraybackslash}p{#1}}
\newcolumntype{Y}{>{\RaggedRight\arraybackslash}X}
\newcolumntype{T}[1]{>{\ttfamily\RaggedRight\arraybackslash}p{#1}}

\titlespacing*{\chapter}{0pt}{0pt}{20pt}
\titlespacing*{\section}{0pt}{2.5ex plus 1ex minus .2ex}{1.5ex plus .2ex}
\titlespacing*{\subsection}{0pt}{2ex plus 1ex minus .2ex}{1ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1.5ex plus 1ex minus .2ex}{1ex plus .2ex}
\titlespacing*{\paragraph}{0pt}{1.5ex plus 1ex minus .2ex}{1ex plus .2ex}

\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{4}

\newcommand{\ntust@applypdfmetadata}{%
  \ifdefstring{\ntust@language}{zh}{%
    \hypersetup{
      pdftitle={\ntust@titlezh},
      pdfauthor={\ntust@authorzh},
      pdfsubject={\ntust@schoolzh{} 學位論文},
      pdfkeywords={\ntust@keywordszh},
      pdfcreator={LaTeX with hyperref},
      pdfproducer={XeLaTeX}
    }%
  }{%
    \hypersetup{
      pdftitle={\ntust@titleen},
      pdfauthor={\ntust@authoren},
      pdfsubject={\ntust@schoolen{} thesis},
      pdfkeywords={\ntust@keywordsen},
      pdfcreator={LaTeX with hyperref},
      pdfproducer={XeLaTeX}
    }%
  }%
}

\AtBeginDocument{%
  \color{black}%
  \ntust@bodyfont
  \ntust@applylanguage
  \ntust@applypdfmetadata
  \AddToShipoutPictureBG{\ntust@placewatermark}%
}

\newcommand{\ntust@placewatermark}{%
  \ifntust@watermarkenabled
    \IfFileExists{assets/ntust_watermark.pdf}{%
      \begin{tikzpicture}[remember picture,overlay]
        \node[inner sep=0pt,opacity=0.35] at (current page.center)
          {\includegraphics[width=\paperwidth,height=\paperheight]{assets/ntust_watermark.pdf}};
      \end{tikzpicture}%
    }{}%
  \fi
}

\newcommand{\ntust@coadvisorlinezh}{%
  \ifdefempty{\ntust@coadvisorzh}{}{\\共同指導教授：\ntust@coadvisorzh\quad \ntust@coadvisortitlezh}%
}
\newcommand{\ntust@coadvisorlineen}{%
  \ifdefempty{\ntust@coadvisoren}{}{\\Co-advisor: \ntust@coadvisoren\quad \ntust@coadvisortitleen}%
}

\newcommand{\NTUSTMakeCover}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \centering
    \vspace*{1cm}
    \IfFileExists{assets/ntust_logo.png}{%
      \includegraphics[width=2.2cm]{assets/ntust_logo.png}\par
      \vspace{0.45cm}
    }{}%
    {\fontsize{18pt}{27pt}\selectfont \ntust@schoolzh\par}
    \vspace{0.45cm}
    {\fontsize{16pt}{24pt}\selectfont \ntust@departmentzh\par}
    \vspace{0.18cm}
    {\fontsize{16pt}{24pt}\selectfont \ntust@degreezh\par}
    \vfill
    {\fontsize{24pt}{28pt}\bfseries \ntust@titlezh\par}
    \vspace{0.55cm}
    {\fontsize{21pt}{26pt}\bfseries \ntust@titleen\par}
    \vfill
    {\fontsize{16pt}{24pt}\selectfont
      研究生：\ntust@authorzh\par
    }
    \vspace{0.45cm}
    {\fontsize{16pt}{24pt}\selectfont
      指導教授：\ntust@advisorzh\quad \ntust@advisortitlezh\par
      \ifdefempty{\ntust@coadvisorzh}{}{共同指導教授﹕\ntust@coadvisorzh\quad \ntust@coadvisortitlezh\par}
    }
    \vspace{1.2cm}
    {\fontsize{16pt}{24pt}\selectfont 中華民國 \ntust@graduationyearroc 年 \ntust@graduationmonthzh\par}
    \vspace*{1cm}
  \end{titlepage}
}

\newcommand{\NTUSTMakeTitlePage}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \centering
    \vspace*{1.2cm}
      \begin{minipage}{0.92\textwidth}
        \centering
        {\fontsize{24pt}{32pt}\bfseries \ntust@titlezh\par}
      \end{minipage}\par
      \vspace{1.15cm}
      \begin{minipage}{0.92\textwidth}
        \centering
        {\fontsize{24pt}{32pt}\bfseries \ntust@titleen\par}
      \end{minipage}\par
      \vfill
    {\fontsize{14pt}{21pt}\selectfont
      \ntust@authorzh\quad \ntust@authoren\par
      \vspace{0.65cm}
      指導教授：\ntust@advisorzh\quad \ntust@advisortitlezh\par
      \vspace{0.15cm}
      Advisor: \ntust@advisoren\quad \ntust@advisortitleen\par
      \ifdefempty{\ntust@coadvisorzh}{}{共同指導教授：\ntust@coadvisorzh\quad \ntust@coadvisortitlezh\par}
      \ifdefempty{\ntust@coadvisoren}{}{Co-advisor: \ntust@coadvisoren\quad \ntust@coadvisortitleen\par}
    }
    \vfill
    {\fontsize{14pt}{21pt}\selectfont
      \ntust@schoolzh\par
      \vspace{0.12cm}
      \ntust@departmentzh\par
      \vspace{0.12cm}
      \ntust@degreezh\par
      \vspace{0.65cm}
      \ntust@schoolen\par
      \vspace{0.12cm}
      \ntust@departmenten\par
      \vspace{0.12cm}
      \ntust@degreeen\par
      \vspace{0.75cm}
      中華民國\ntust@graduationyearroc 年\ntust@graduationmonthzh\par
      \vspace{0.12cm}
      \ntust@graduationmonthen\ \ntust@graduationyearad\par
    }
    \vspace*{1.0cm}
  \end{titlepage}
}

\newcommand{\ntust@includeimagepage}[1]{%
  \thispagestyle{empty}%
  \AddToShipoutPictureBG*{%
    \AtPageCenter{%
      \makebox[0pt][c]{%
        \raisebox{-.5\height}{%
          \includegraphics[width=\paperwidth,height=\paperheight,keepaspectratio]{#1}%
        }%
      }%
    }%
  }%
  \null
  \clearpage
}

\newcommand{\ntust@includeexternalpage}[1]{%
  \begingroup
  \ntust@watermarkenabledfalse
  \filename@parse{#1}%
  \edef\ntust@fileext{\filename@ext}%
  \ifdefstring{\ntust@fileext}{pdf}
    {\includepdf[pages=-,pagecommand={\thispagestyle{empty}}]{#1}}
    {\ntust@includeimagepage{#1}}%
  \endgroup
}

\newcommand{\ntust@signaturepage}[2]{%
  \clearpage
  \thispagestyle{empty}
  \ifdefempty{#2}{%
    \vspace*{\fill}
    \begin{center}
      {\fontsize{20pt}{30pt}\bfseries #1\par}
      \vspace{2\baselineskip}
      {\fontsize{12pt}{18pt}\selectfont 本頁為簽名文件預留頁。正式版本請以核定後之 PDF 或影像檔替換。\par}
    \end{center}
    \vspace*{\fill}
    \clearpage
  }{%
    \IfFileExists{#2}
      {%
        \ntust@includeexternalpage{#2}%
      }
      {%
        \vspace*{\fill}
        \begin{center}
          {\fontsize{20pt}{30pt}\bfseries #1\par}
          \vspace{2\baselineskip}
          {\fontsize{12pt}{18pt}\selectfont 找不到指定檔案：\texttt{#2}\par}
        \end{center}
        \vspace*{\fill}
        \clearpage
      }%
  }%
}

\newcommand{\NTUSTMakeRecommendation}{%
  \ntust@signaturepage{指導教授推薦書}{\ntust@recommendationfile}%
}
\newcommand{\NTUSTMakeApproval}{%
  \ntust@signaturepage{學位考試委員審定書}{\ntust@approvalfile}%
}

\newcommand{\NTUSTBeginFrontMatter}{%
  \clearpage
  \pagenumbering{Roman}
  \setcounter{page}{1}
  \pagestyle{plain}
}

\newcommand{\ntust@fronttitle}[1]{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{#1}
  \begin{center}
    {\fontsize{20pt}{30pt}\bfseries #1\par}
  \end{center}
  \vspace{2\baselineskip}
  \ntust@bodyfont
}

\newcommand{\NTUSTMakeAbstractZh}[1]{%
  \ntust@fronttitle{中文摘要}
  \noindent\hspace*{\parindent}\input{#1}
  \par\vspace{\baselineskip}
  \noindent\textbf{關鍵詞：}\ntust@keywordszh
}
\newcommand{\NTUSTMakeAbstractEn}[1]{%
  \ntust@fronttitle{Abstract}
  \noindent\hspace*{\parindent}\input{#1}
  \par\vspace{\baselineskip}
  \noindent\textbf{Keywords: }\ntust@keywordsen
}
\newcommand{\NTUSTMakeAcknowledgement}[1]{%
  \ntust@fronttitle{誌謝}
  \noindent\hspace*{\parindent}\input{#1}
}
\newcommand{\NTUSTMakeTableOfContents}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\contentsname}
  \setcounter{tocdepth}{2}%
  \tableofcontents
}
\newcommand{\NTUSTMakeSymbolsIndex}[1]{%
  \ifdefstring{\ntust@includesymbols}{true}{%
    \ntust@fronttitle{符號索引}
    \input{#1}
  }{}%
}
\newcommand{\NTUSTMakeListOfFigures}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\listfigurename}
  \begingroup
    \ifdefstring{\ntust@language}{zh}
      {\renewcommand{\numberline}[1]{圖##1\hspace*{1em}}}
      {\renewcommand{\numberline}[1]{Figure~##1\hspace*{1em}}}%
    \listoffigures
  \endgroup
}
\newcommand{\NTUSTMakeListOfTables}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\listtablename}
  \begingroup
    \ifdefstring{\ntust@language}{zh}
      {\renewcommand{\numberline}[1]{表##1\hspace*{1em}}}
      {\renewcommand{\numberline}[1]{Table~##1\hspace*{1em}}}%
    \listoftables
  \endgroup
}

\newcommand{\NTUSTBeginMainMatter}{%
  \clearpage
  \pagenumbering{arabic}
  \setcounter{page}{1}
  \ntust@applylanguage
  \ntust@bodyfont
}

\newcommand{\NTUSTBeginAppendices}{%
  \clearpage
  \appendix
  \ifdefstring{\ntust@appendixnumbering}{chinese}
    {\renewcommand{\thechapter}{\zhnumber{\arabic{chapter}}}}
    {\renewcommand{\thechapter}{\Alph{chapter}}}%
  \setcounter{table}{0}%
  \setcounter{figure}{0}%
  \setcounter{algorithm}{0}%
  \renewcommand{\thetable}{\thechapter-\arabic{table}}%
  \renewcommand{\thefigure}{\thechapter-\arabic{figure}}%
  \renewcommand{\thealgorithm}{\thechapter-\arabic{algorithm}}%
  \ifdefstring{\ntust@language}{zh}{%
    \gdef\ntust@tocchapterprefix{附錄 }%
    \titleformat{\chapter}[block]
      {\centering\fontsize{20pt}{30pt}\bfseries}
      {附錄 \thechapter}{1em}{}%
  }{%
    \gdef\ntust@tocchapterprefix{Appendix }%
    \titleformat{\chapter}[block]
      {\centering\fontsize{20pt}{30pt}\bfseries}
      {Appendix \thechapter}{1em}{}%
  }%
}

\makeatother
