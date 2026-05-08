# AGENT.md

本文件是給進入此 workspace 的 agent 使用的操作手冊。

## 1. Agent 角色

在這個 workspace 中，agent 應該像謹慎的 LaTeX 模板維護者：

- 先讀目前檔案，再決定要改什麼。
- 保留使用者既有工作，不回退無關變更。
- 修改範圍緊貼使用者要求。
- 偏好可驗證的小步修改，而不是大範圍重寫。
- 當任務改變專案狀態時，留下有用的交接紀錄。

如果任務涉及論文內容寫作、格式調整或模板維護，先找出該任務相關的具體來源檔，不要猜測使用者的研究內容。

## 2. Workspace 形狀

repo root 是 NTUST thesis LaTeX template：

- `thesis.tex`：LaTeX 主入口。
- `ntust_thesis.cls`：NTUST thesis class。
- `config/`：metadata、options、中文詞彙設定與表格 helper。
- `frontmatter/`：摘要、誌謝、符號表範本。
- `chapters/`：正文章節範本。
- `backmatter/`：附錄範本。
- `bibliography/`：BibLaTeX 設定與範例 references。
- `assets/`：可重用靜態素材、圖檔與簽核頁放置目錄。
- `docs/`：論文格式說明與 LaTeX 環境建置指南。
- `build/`：LaTeX generated output，已由 git ignore。
- `TASK/`：目前階段任務筆記；可保留給後續 agent 交接。

確認目前狀態時，以 workspace 中的實際檔案為準。不要假設舊交接筆記一定比 working tree 更新。

## 3. 安全規則

- 大幅修改前先看目前檔案狀態與目錄結構。
- 不丟棄、不 reset、不覆蓋無關的使用者變更。
- 除非使用者明確要求，不使用 destructive git commands。
- 手動編輯使用 `apply_patch`。
- 除非使用者要求，generated output 不納入交付重點。
- 不捏造 citation、data、result 或個人 metadata。
- 如果缺少必要來源，留下清楚註記或詢問使用者，不要猜。
- `AGENT.md` 與 `TASK/` 是工作交接用途；除非使用者明確要求，不要刪除。

## 4. 搜尋與檢視工具

優先使用：

```bash
rg --files
rg -n "pattern" path
sed -n '1,200p' file
git status --short
git diff -- file
```

能用 `rg` 時先用 `rg`。如果此 workspace 不是 git repo，改用 `find`、`rg --files` 與檔案內容檢查。

常用檢視目標：

- `README.md`：template-level 使用說明。
- `Makefile`：build commands。
- `.latexmkrc`：LaTeX build settings。
- `docs/latex_environment_setup.md`：LaTeX 環境安裝與驗證指南。
- `docs/ntust_thesis_format_spec.md`：台科大論文格式實作規格。
- `build/thesis.log`：build 後的 compile warnings。
- `TASK/`：目前階段任務筆記；內容可能常被更新、替換或清空。

## 5. 編譯與驗證工具

LaTeX template 透過 `make` 編譯：

```bash
make pdf
make
make watch
make clean-aux
make clean
```

主要輸出：

```bash
build/thesis.pdf
```

目前 build 使用 XeLaTeX 與 `latexmk`。本地 `.latexmkrc` 設定：

- output directory：`build`
- auxiliary directory：`build`
- XeLaTeX nonstop mode，並使用 `-halt-on-error`
- bibliography 使用 `biber`

常用 PDF 檢查：

```bash
make check-log
```

若已另外安裝可選工具，可使用 `pdfinfo build/thesis.pdf` 檢查 PDF metadata，或用 `rg` 搜尋 `build/thesis.log`。

若本機沒有 `latexmk`、`xelatex` 或 `biber`，不要假裝已完成編譯；回報缺少工具，並指向 `docs/latex_environment_setup.md`。

## 6. 編輯流程

一般 documentation 或 LaTeX 修改：

1. 檢視相關檔案與目前狀態。
2. 找出最小安全修改範圍。
3. 用 `apply_patch` 修改。
4. 重讀改過的段落。
5. 執行針對性檢查；LaTeX 修改通常跑 `make pdf`。
6. 回報前看差異或至少列出實際變更檔案。

模板維護注意事項：

- 保持範本文字通用，不寫入特定研究成果。
- 不留下私人姓名、學號、簽核影像或未公開資料。
- 若新增章節，必須同步更新 `thesis.tex`。
- 若新增圖檔範例，確認檔案大小合理且授權清楚。
- 若更動 class 行為，確認 `docs/ntust_thesis_format_spec.md` 是否需要同步。

## 7. LaTeX 品質檢查

碰過 thesis files 後，檢查：

- 文件仍可編譯，或清楚回報本機缺少工具。
- 沒有新增 undefined references 或 citations。
- figure paths 存在。
- tables 合理落在頁面內。
- captions 與 labels 存在。
- main-matter language 與專案設定一致。
- 沒有意外留下研究資料、私人資訊或 local debug text。

常用搜尋：

```bash
rg -n "TODO|todo|placeholder|TBD|FIXME|xxx" chapters frontmatter backmatter config bibliography
```

範本文字可以保留「請填入」類提示；正式論文內容則不應留下未完成註記。

## 8. 交接方式

跨 agent 交接以目前使用者要求、實際檔案、相關 diff 與 `TASK/` 內的當前階段筆記為準。不要依賴不存在或過期的 snapshot 檔。

好的 handoff note 或最終回報應包含：

- 改了什麼。
- 驗證了什麼。
- 還有哪些未解問題。
- 下一步最相關的檔案或命令。

`AGENT.md` 應保持穩定。它描述 agent 如何工作，不承載最新 task plan。臨時或階段性的 task spec 放在 `TASK/`，完成或過期後可移除內容，但保留目錄。
