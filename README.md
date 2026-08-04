# NTUST Thesis Template

國立臺灣科技大學（NTUST）LuaLaTeX 學位論文模板。預設使用英文主文模式，並可
切換為中文主文。正式 PDF 只能透過固定版本的 Docker TeX Live 2025 編譯。

## 專案結構

| 路徑 | 用途 |
| --- | --- |
| `main.tex` | 唯一的 LaTeX 主入口 |
| `thesis/template/` | NTUST class 與版面模組 |
| `thesis/config/` | 語言、metadata、模板選項與術語 |
| `thesis/content/` | 摘要、誌謝、章節、附錄與參考文獻 |
| `thesis/assets/` | 品牌素材、圖片、簽核頁與本機授權字型 |
| `tooling/latex/` | 固定 Docker image 的建置與診斷腳本 |
| `tooling/qa/` | 編譯輸入邊界與 LaTeX log 檢查 |
| `docs/` | 環境與臺科大格式實作規格 |
| `build/` | 被忽略的 PDF、auxiliary files、log 與診斷輸出 |

LaTeX 編譯面刻意維持為 `main.tex` 與完整的 `thesis/` 目錄；`tooling/`、
`.github/`、`docs/` 與其他 repository 維護檔案不會成為 LaTeX input。

## 必要環境

主機只需要：

- Docker Engine 或 Docker Desktop；
- `linux/amd64` container 支援；
- 五個已合法取得的 Windows 字型檔。

不需要、也不支援使用主機上的 LuaLaTeX、latexmk、biber 或 TeX Live 編譯。
唯一受支援的環境由
[`tooling/latex/texlive-image.lock`](tooling/latex/texlive-image.lock) 固定為
TL2025 `tlnet-final` image digest。

依照 [`thesis/assets/fonts/README.md`](thesis/assets/fonts/README.md)，從有合法
授權的 Windows 安裝取得 Times New Roman 與標楷體，放入：

```text
thesis/assets/fonts/times/times.ttf
thesis/assets/fonts/times/timesbd.ttf
thesis/assets/fonts/times/timesi.ttf
thesis/assets/fonts/times/timesbi.ttf
thesis/assets/fonts/cjk/kaiu.ttf
```

這些明文字型受到 `.gitignore` 保護，不得提交或散布。

## 編譯與檢查

```bash
make pdf
make check
make logs
make clean
```

- `make pdf`：只透過固定 digest Docker image 編譯 `build/thesis.pdf`。
- `make check`：重新編譯，檢查 TeX input boundary 與 LaTeX log。
- `make logs`：顯示 image、工具版本、LaTeX diagnostics 與 container console。
- `make clean`：移除可重建的 `build/`。

`make check` 會拒絕 LaTeX error、未解析引用、缺字與 overfull box。

## 編輯論文

1. 在 `thesis/config/document.tex` 設定主文語言。
2. 在 `thesis/config/metadata.tex` 填入系所、題目、作者、指導教授與畢業年月。
3. 在 `thesis/config/options.tex` 選擇字級、文獻樣式、符號表與附錄編號。
4. 在 `thesis/content/frontmatter/` 撰寫摘要、誌謝與符號表。
5. 在 `thesis/content/chapters/` 撰寫正文；增減章節時修改 `mainmatter.tex`。
6. 在 `thesis/content/bibliography/references.bib` 維護文獻。
7. 將私人簽核頁放入 `thesis/assets/forms/`，並在 metadata 中設定路徑。

簽核頁支援常見圖片與多頁 PDF；留空時會產生 placeholder page。該目錄除
README 外全部忽略，避免誤傳簽名或私人資料。

## 中英文主文

預設為英文：

```tex
\def\NTUSTDocumentLanguage{en}
```

中文主文改為：

```tex
\def\NTUSTDocumentLanguage{zh}
```

只有 `en` 與 `zh` 是有效值。這個設定在 document class 前讀取，分別映射為
PDF 根語言 `en-US` 與 `zh-TW`，並同步控制章節、目錄、圖表及參考文獻標籤。

英文目錄會區分正文的 `Chapter 1` 與附錄的 `Appendix A`。

## GitHub Actions 與預覽 PDF

CI 使用與本機相同的 Docker entry point。成功時會上傳以 commit 短 SHA 命名、
保留 14 天的 PDF artifact；模板不再追蹤 `build/thesis.pdf`。

CI 字型封包以 AES-256 GPG 加密後追蹤。Repository maintainer 必須設定：

```bash
gh secret set THESIS_FONTS_PASSPHRASE \
  < .github/fonts/thesis-fonts.passphrase.local
```

沒有該 secret 的 fork 或新 repository 會在字型還原階段明確失敗。不得把密碼、
編碼密碼或任何可還原密碼的提示放進 README 或其他 tracked files。

## 非正式 Overleaf 搬移

Overleaf 不是受支援的正式建置環境，輸出也不保證與固定 Docker image 相同。
若只需要非正式編輯或預覽，可上傳：

```text
main.tex
thesis/
```

上傳前必須把五個授權字型包含在 `thesis/assets/fonts/`，並在 Overleaf 選擇：

- Main document：`main.tex`
- Compiler：LuaLaTeX
- TeX Live：2025

不需上傳 `tooling/`、`.github/`、`docs/`、`Makefile` 或 `.latexmkrc`。正式交付的
PDF 仍必須由 `make pdf`／`make check` 產生。
