# NTUST Thesis Template

國立臺灣科技大學（NTUST）學位論文 XeLaTeX 模板，預設使用中文主文模式。

預覽模板：[build/thesis.pdf](build/thesis.pdf)

## 內容

- `thesis.tex`：論文主入口，定義封面、前置頁、章節、參考文獻與附錄順序。
- `ntust_thesis.cls`：台科大論文版面、封面、浮水印、章節、圖表與前置頁格式。
- `config/`：metadata、語言、字級、參考文獻樣式與共用表格設定。
- `frontmatter/`：中文摘要、英文摘要、誌謝與符號表範本。
- `chapters/`：五章式論文範本章節。
- `backmatter/`：附錄範本。
- `bibliography/`：BibLaTeX 設定與範例 `.bib`。
- `assets/`：台科大 logo、浮水印、圖檔與簽核頁放置目錄。
- `docs/`：LaTeX 環境建置與台科大格式實作規格。
- `AGENT.md`：給 coding agent 的專案操作手冊。
- `TASK/`：階段性任務筆記與交接目錄。

## 建置需求

使用 Ubuntu apt 安裝的 XeLaTeX、`latexmk`、`biber` 與 BibLaTeX。必要字型：

- `Times New Roman`
- `標楷體`

環境建置細節見 `docs/latex_environment_setup.md`。`Times New Roman` 透過 apt 的 `ttf-mscorefonts-installer` 安裝；`標楷體` 請從有授權的 Windows 系統複製 `kaiu.ttf` 到本機使用。

## 編譯

```bash
make
```

輸出檔案：

```text
build/thesis.pdf
```

常用指令：

```bash
make pdf
make check-log
make watch
make clean-aux
make clean
```

## 使用方式

1. 編輯 `config/metadata.tex`，填入系所、題目、作者、指導教授、畢業年月與關鍵詞。
2. 編輯 `config/options.tex`，選擇字級、參考文獻樣式、符號表與附錄編號方式。
3. 在 `config/metadata.tex` 設定主文語言：`\NTUSTThesisLanguage{zh}` 或 `\NTUSTThesisLanguage{en}`。
4. 將正式推薦書與審定書放入 `assets/forms/`，再於 `config/metadata.tex` 指定檔案路徑；若留空，模板會產生預留頁。
5. 在 `frontmatter/` 撰寫摘要、誌謝與符號表。
6. 在 `chapters/` 撰寫正文；如需增減章節，同步修改 `thesis.tex`。
7. 在 `bibliography/references.bib` 加入文獻，正文以 `\cite{...}` 引用。
8. 執行 `make pdf`，再執行 `make check-log` 檢查警告。

## 語言設定

本模板預設為中文模式，設定在 `config/metadata.tex`：

```tex
\NTUSTThesisLanguage{zh}
```

可改為：

```tex
\NTUSTThesisLanguage{en}
```

`zh` 會使用中文章節與圖表標籤格式；`en` 會使用 English chapter, section, figure, table, and references labels。切換語言後，請自行調整章節標題與正文內容。
