\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis/template/ntust_thesis}[2026/08/04 NTUST thesis class v2]

\LoadClass[12pt,a4paper,oneside]{report}
\input{thesis/template/modules/core}

\makeatletter

\def\ntust@degree{master}
\def\ntust@language{en}
\def\ntust@bodyfontsize{12}
\def\ntust@bibstyle{apa}
\def\ntust@includesymbols{true}
\def\ntust@appendixnumbering{alpha}

\newif\ifntust@watermarkenabled
\ntust@watermarkenabledtrue
\newif\ifntust@appendix
\ntust@appendixfalse
\newif\ifntust@tocappendix
\ntust@tocappendixfalse

\def\ntust@departmentzh{系所中文名稱}
\def\ntust@departmenten{Department Name}
\def\ntust@schoolzh{國立臺灣科技大學}
\def\ntust@schoolen{National Taiwan University of Science and Technology}
\def\ntust@titlezh{論文中文題目}
\def\ntust@titlezhdisplay{\ntust@titlezh}
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
\newcommand{\NTUSTTitleZhDisplay}[1]{\gdef\ntust@titlezhdisplay{#1}}
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

\input{thesis/template/modules/layout}
\input{thesis/template/modules/captions}
\input{thesis/template/modules/tables}
\input{thesis/template/modules/frontmatter}
\input{thesis/template/modules/matter}

\makeatother
