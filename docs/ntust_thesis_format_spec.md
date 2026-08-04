# 台科大學位論文格式規範（給 CodingAgent 的 LaTeX 實作規格）

> 目的：把「國立臺灣科技大學學位論文撰寫、編排規則及注意事項」整理成一份**可直接拿去做 LaTeX 模板**的規格書。  
> 適用：台科大碩士 / 博士學位論文。  
> 本 repo 的唯一格式規格文件：若其他草稿文件與本文件衝突，以本文件為準。  
> 依據版本：`docs/國立臺灣科技大學學位論文撰寫編排規則及注意事項_113.12.24第218次教務會議通過.pdf`，即 112.03.07 第 211 次教務會議通過、113.12.24 第 218 次教務會議通過版本。  
> 性質：這份文件分成兩層：
> 1. **官方硬規則**：學校文件明確寫出的規定。  
> 2. **實作預設**：學校未講死、但為了讓 CodingAgent 能落地，需要先定下來的實作決策。  

---

## 0. 規格優先序

CodingAgent 實作時，請依照以下優先序處理衝突：

1. **系所 / 學位學程的補充規定**
2. **台科大校級官方規定**
3. **本文件的實作預設**
4. **附錄範例頁的樣式細節**（僅作參考，不得凌駕系所規定）

也就是說：
- 學校有明定的，必須遵守。
- 學校沒明定，但系所有另外要求時，以系所要求為準。
- 學校與系所都沒明定時，採本文件的預設。

---

## 1. CodingAgent 的任務目標

請用固定 Docker TeX Live 2025 中的 **LuaLaTeX** 實作一套台科大論文模板，至少要能完成以下能力：

1. 產出符合台科大基本格式的論文 PDF。
2. 支援 **碩士 / 博士** 切換。
3. 支援 **中文論文 / 英文論文** 的章節編號與頁面標題配置。
4. 支援以下前置頁：
   - 封面
   - 書名頁
   - 指導教授推薦書（可插入 PDF 或外部頁面）
   - 學位考試委員審定書（可插入 PDF 或外部頁面）
   - 中文摘要
   - 英文摘要
   - 誌謝
   - 目錄
   - 符號索引
   - 圖目錄
   - 表目錄
5. 支援正文、參考文獻、附錄。
6. 支援前置頁與正文的**不同頁碼系統切換**。
7. 讓使用者可集中修改 metadata，例如：
   - 論文中英文題目
   - 作者中英文姓名
   - 系所中英文名稱
   - 指導教授中英文姓名 / 職稱 / 學位
   - 畢業年月
   - 關鍵詞
   - 摘要內容
   - 致謝內容
   - 參考文獻格式

---

## 2. 建議技術基線（實作層決策）

這一段不是校方條文，而是為了穩定落地的技術決策。

### 2.0 專案標準結構

本專案以「清楚產出論文 PDF」為目標，採以下標準結構作為實作目標：

- 主檔：`main.tex`
- class：`thesis/template/ntust_thesis.cls`
- class modules：`thesis/template/modules/`
- 主文語言：`thesis/config/document.tex`
- metadata：`thesis/config/metadata.tex`
- 模板選項：`thesis/config/options.tex`
- 中文名詞對照：`thesis/config/terminology_zh.tex`
- 前置頁、正文、附錄與文獻：`thesis/content/`
- 圖片、品牌素材、表單與本機字型：`thesis/assets/`
- 文件與規格：`docs/`
- 編譯輸出：`build/`
- 編譯設定：`.latexmkrc` 管理 LuaLaTeX，`Makefile` 管理 `build/` 與 `thesis` job name
- 編譯流程：`make pdf` 只允許透過固定 digest Docker image 啟動

實作時應以此結構為準；若既有 repo 檔名或目錄不同，需逐步收斂到此結構。

### 2.1 編譯引擎

- **固定使用 LuaLaTeX**。
- 不以 pdfLaTeX 為主要目標。
- 不支援直接使用主機 TeX；正式建置只使用固定 Docker image。
- 原因：需要穩定處理中文、英文字型、字級、頁面配置與 TeX 套件版本。

### 2.2 字型策略

校方原則：
- 中文字型：**標楷體或新細明體**
- 英文字型：**Times New Roman**

LaTeX 實作請採以下策略：

- 中文主字型固定使用：`標楷體`
- 英文主字型固定使用：`Times New Roman`

模板不依賴主機安裝字型，也不使用 fontconfig family name。請從有合法授權的
Windows 安裝複製五個檔案，並以固定的小寫檔名放在專案內：

```text
thesis/assets/fonts/
├── times/
│   ├── times.ttf
│   ├── timesbd.ttf
│   ├── timesi.ttf
│   └── timesbi.ttf
└── cjk/
    └── kaiu.ttf
```

Windows 的一般來源是 `C:\Windows\Fonts\times*.ttf` 與
`C:\Windows\Fonts\kaiu.ttf`。LuaLaTeX 透過 `fontspec` 與
`luatexja-fontspec` 直接讀取上述相對路徑，因此 Docker 與非正式 Overleaf
預覽可共用相同目錄。所有明文字型與原始 ZIP 都必須被 Git 忽略；正式 CI
只解密受控的加密封包，不得提交或公開散布明文字型。

### 2.3 文件基底

- 建議使用 `report` 或 `book` 類別。
- 採 **A4、單面（oneside）PDF** 輸出。

---

## 3. 官方硬規則：頁面、字體、版面

### 3.1 頁面

- PDF 頁面尺寸：**A4**（21 cm × 29.7 cm）
- PDF 頁面背景預設白色；除本規格指定之**低透明度置中浮水印**外，不加其他底色或材質

### 3.2 字體與字色

- 全文字色：**黑色**
- 中文字型：**標楷體或新細明體**
- 英文字型：**Times New Roman**

### 3.3 字級

- 論文內頁之論文題目：**24 pt、粗體**
- 摘要等標題：**20 pt、粗體**
- 摘要等頁面標題下方：**空兩行後再開始正文**
- 正文章節標題：**20 pt**
- 小節等標題：**18 pt**
- 內文：**12 pt 或 13 pt**

### 3.4 行距與縮排

- 行距：**1.5 倍行高**
- 中文段落首行縮排：**2 個中文字**
- 英文段落首行縮排：**5 個英文字母**

### 3.5 邊界

- 上：**3 cm**
- 下：**2 cm**
- 左：**3 cm**
- 右：**3 cm**

### 3.6 頁碼

- 每頁頁碼放在：**頁面正下方置中**
- **中文摘要至圖表索引（含）之前置頁**：使用 **大寫羅馬數字**（I, II, III, ...）
- **正文開始**：改用 **阿拉伯數字**（1, 2, 3, ...）

---

## 4. 官方硬規則：論文編排順序

論文整體順序固定如下：

1. 封面
2. 書名頁
3. 指導教授推薦書
4. 學位考試委員審定書
5. 中文摘要與關鍵詞 5–7 個
6. 英文摘要與關鍵詞 5–7 個
7. 誌謝
8. 目錄
9. 符號索引
10. 圖目錄
11. 表目錄
12. 正文
13. 參考文獻
14. 附錄

---

## 5. 官方硬規則：各部分內容要求

### 5.1 封面與書名頁

封面與書名頁都必須包含：

- 論文中文題目
- 論文英文題目
- 研究生姓名
- 指導教授姓名
- 學校名稱
- 系所名稱
- 畢業年月

補充規則：
- 附錄中的封面格式是**參考樣式**，不是唯一不可變版本。
- 若畢業月份為 7 或 8 月，封面年月請印製為該年 6 月。
- 紙本論文書背與裝訂格式，依本校圖書館相關規定辦理：`https://etheses.lib.ntust.edu.tw/zh-hant/help/download/`
- v113 附錄一的英文校名已修正為含 `of` 的正式寫法；模板不得輸出缺少 `of` 的 `National Taiwan University Science And Technology`。

### 5.2 指導教授推薦書

- 論文經指導教授初審後，推薦給論文口試委員會。
- 格式如學校附錄範例。

### 5.3 學位考試委員審定書

- 論文經學位考試委員會審定合格後，須由全體委員簽字確認。
- 格式如學校附錄範例。

### 5.4 中文摘要、英文摘要

摘要應為論文的精簡概要，內容應包含：

- 論述 / 研究重點
- 研究方法或程序
- 研究內容
- 研究結果
- 關鍵詞 **5–7 個**

長度原則：
- **不超過 500 字或 1 頁為原則**

### 5.5 誌謝

- 可對研究提供協助之人或機構表達感謝。

### 5.6 目錄

- 需依論文章節順序列出章節名稱與頁碼。

### 5.7 圖目錄、表目錄

- 全文中圖表數量達 **5 個以上（含 5）**，才需要製作圖表目錄。
- 當全文中附圖與附表同時出現時，排序先圖後表。
- 圖表編號形式依章節順序，例如：
  - 第一章第一個圖：`圖1-1`
  - 第二章第三個圖：`圖2-3`

### 5.8 正文

- 正文必須切分成適當章節，並有適當標題。
- 論文標題與章節標題需置中。
- 小節標題靠左。
- 各層次需用縮排與編號區別。

中文編號層次：
1. `一、`
2. `（一）`
3. `1.`
4. `（1）`

英文編號層次：
1. `1.`
2. `1.1`
3. `1.1.1`

正文其他要求：
- 專有名詞或特殊符號，第一次出現時需詳細說明。
- 引用參考文獻時需註明出處。

### 5.9 圖與表

- 圖表需依序編號。
- 每一個圖、表都需有**簡潔標題**。
- 標題不得使用縮寫。
- 內文提及圖表時，需明確寫出編號，例如：
  - `見表1-1`
  - `如圖2-3所示`
- 圖表寬度不應超出正文寬度。
- 若圖表寬度小於正文寬度，應置中。
- 若圖表過大，可改列入附錄。

### 5.10 參考文獻

- 寫法依**系所或指導教授規定**辦理。
- 例如可用 APA、MLA、Chicago 等。
- **整本論文的參考文獻格式必須統一。**

### 5.11 附錄

可放入附錄的內容包括：
- 放在正文會過於冗長瑣碎的圖表
- 珍貴文件影本
- 冗長個案研究
- 技術性附註

---

## 6. 為了落地實作，先定下來的預設

以下不是官方硬規則，而是本次模板先固定的實作決策。

### 6.1 前置頁頁碼起算方式

校方明定「中文摘要至圖表索引（含）之前頁碼以羅馬數字編排」，但未明講封面、書名頁、推薦書、審定書是否印頁碼。

本規格先定為：

- 封面：**不印頁碼**
- 書名頁：**不印頁碼**
- 指導教授推薦書：**不印頁碼**
- 學位考試委員審定書：**不印頁碼**
- 中文摘要開始：**前置頁第 I 頁**
- 正文首頁：**第 1 頁**

也就是說，**前置頁的可見頁碼從中文摘要開始印**。

### 6.2 章節對應到 LaTeX 層級

若論文主要語言為中文，預設用以下對應：

- `\chapter` → `第一章、第二章、...`（置中）
- `\section` → `一、二、三、...`（靠左）
- `\subsection` → `（一）（二）（三）...`（靠左）
- `\subsubsection` → `1. 2. 3. ...`（靠左）
- `\paragraph` → `（1）（2）（3）...`（靠左）

若論文主要語言為英文，預設用以下對應：

- `\chapter` → `Chapter 1, Chapter 2, ...`
- `\section` → `1.1, 1.2, ...`
- `\subsection` → `1.1.1, 1.1.2, ...`
- `\subsubsection` → `1.1.1.1, 1.1.1.2, ...`

### 6.3 標題粗細

校方有明定：
- 論文題目 24 pt 粗體
- 摘要等標題 20 pt 粗體
- 章節標題 20 pt
- 小節標題 18 pt

因校方未對正文章節標題的粗細完全講死，本規格先定為：

- `\chapter`：20 pt、**粗體**、置中
- `\section`：18 pt、**粗體**、靠左
- `\subsection` 以下：12–14 pt、可粗體、靠左

目的：讓版面穩定且接近校方範例閱讀感。

### 6.4 內文字級

校方允許 12 pt 或 13 pt。

本規格先定：
- **預設用 12 pt**
- 若系所另有要求，可切換成 13 pt

### 6.5 圖目錄 / 表目錄的啟用條件

校方文字為「全文中圖表在五個圖表以上（包括五個），才須製作圖表目錄」。

本規格先定：
- 本專案預期全文圖與表合計必定達 **5 個以上（含 5）**。
- 啟用條件採 **圖與表合計數量**，不是分別計算圖與表。
- 模板固定輸出圖目錄與表目錄，不提供 `auto` 或關閉選項。
- 若正文缺少圖或表，視為論文內容尚未完成，不作為模板條件分支處理。

### 6.6 推薦書與審定書的處理方式

這兩頁通常牽涉：
- 校方固定表單
- 簽名
- 可能的條碼 / 浮水印 / 掃描頁

因此模板預設：
- **不自行重排複刻官方簽名表單**
- 改為提供 `include pdf / image` 的插入機制
- 若未提供檔案，生成 placeholder page（僅供開發測試）

placeholder page 樣式固定如下：

- 頁面使用 `empty` page style，不印頁碼。
- 版面使用與全文一致的 A4 與邊界設定。
- 頁面中央放置 20 pt 粗體標題：
  - 指導教授推薦書 placeholder：`指導教授推薦書`
  - 學位考試委員審定書 placeholder：`學位考試委員審定書`
- 標題下方空兩行，放置 12 pt 置中文字：
  - `本頁為簽名文件預留頁。正式版本請以核定後之 PDF 或影像檔替換。`
- placeholder 不加入目錄，不顯示頁首頁尾，不影響前置頁羅馬頁碼起算。
- 若提供 PDF，使用 `\includepdf` 插入整頁，並強制該頁 `empty` page style。

### 6.7 封面與書名頁版面細節

依附錄一的參考樣式，先定以下預設：

- 封面頁：上留白約 **4 cm**
- 其後各行置中
- 頁底留白約 **3 cm**
- 內容順序建議如下：
  1. 畢業年度
  2. 學校與系所中文名稱
  3. 學校與系所英文名稱
  4. 學位別（碩士論文 / 博士論文；Master Thesis / Doctoral Dissertation）
  5. 中文論文題目
  6. 英文論文題目
  7. 作者中英文姓名
  8. 指導教授中英文姓名與職稱 / 學位
  9. 中華民國年月
  10. 英文 month year

### 6.8 參考文獻系統

校方只要求**整本一致**，不限定格式。

本規格先定：
- 參考文獻系統固定使用 `biblatex` + `biber`。
- 參考文獻資料放在 `thesis/content/bibliography/references.bib`。
- 參考文獻套件與樣式設定放在 `thesis/content/bibliography/bibliography.tex`。
- 預設樣式由 `thesis/config/options.tex` 設定，不寫死在 class 內。
- 本論文採用 IEEE 引用與參考文獻格式；此為本專案統一標注方法，符合校方「整本一致」之要求。
- 可支援樣式：
  - `apa`
  - `mla`
  - `ieee`
  - `chicago`
  - `custom`
- `custom` 由使用者在 `thesis/content/bibliography/bibliography.tex` 中明確指定 `biblatex` options。
- 編譯流程必須能自動執行 `biber`。

### 6.9 附錄編號

校方未明定附錄編號一定要用英文或中文。

本規格先定：
- 中文論文：預設 `附錄 A`, `附錄 B`, ...
- 若使用者要改成 `附錄一`, `附錄二`, ...，需可配置

### 6.10 浮水印

本專案需固定使用台科大浮水印，實作預設如下：

- 浮水印來源：`thesis/assets/branding/ntust_watermark.pdf`
- 浮水印固定啟用，不提供關閉選項。
- 浮水印置於頁面正中央，使用低透明度，不得干擾正文閱讀。
- 浮水印套用於封面、書名頁、簽名文件 placeholder、摘要、目錄、正文、參考文獻與附錄。
- 若推薦書或審定書以外部 PDF 插入，該外部 PDF 頁不另外覆蓋浮水印，以避免影響正式簽章或核定頁。
- 浮水印不視為頁面背景底色或材質。

### 6.11 本專案預設主文語言

本模板預設以英文撰寫主文：

- `thesis/config/document.tex` 設定 `\def\NTUSTDocumentLanguage{en}`
- 目錄標題預設為 `Contents`
- 圖目錄標題預設為 `List of Figures`
- 表目錄標題預設為 `List of Tables`
- 正文章節預設為 `Chapter 1`、`1.1` 這類英文論文格式。
- 前置頁頁碼仍依校方規格使用大寫羅馬數字 `I, II, III, ...`。

若使用者要撰寫中文主文，可在 `thesis/config/document.tex` 改為
`\def\NTUSTDocumentLanguage{zh}`；此設定會在 document class 前同步決定 PDF
根語言，以及章節、圖表與參考文獻標籤。

---

## 7. Metadata 與設定結構

主文語言放在 `thesis/config/document.tex`，可變資料集中放在
`thesis/config/metadata.tex`，模板行為選項放在 `thesis/config/options.tex`。
不得使用 YAML parser；所有設定皆為 LaTeX 巨集或布林值，讓 LuaLaTeX 可直接編譯。

`thesis/config/metadata.tex` 至少提供以下欄位：

```tex
\NTUSTDegree{master} % master | doctoral

\NTUSTDepartmentZh{}
\NTUSTDepartmentEn{}
\NTUSTSchoolZh{國立臺灣科技大學}
\NTUSTSchoolEn{National Taiwan University of Science and Technology}

\NTUSTTitleZh{}
\NTUSTTitleZhDisplay{}
\NTUSTTitleEn{}
\NTUSTAuthorZh{}
\NTUSTAuthorEn{}

\NTUSTAdvisorZh{}
\NTUSTAdvisorEn{}
\NTUSTAdvisorTitleZh{}
\NTUSTAdvisorTitleEn{}

\NTUSTCoAdvisorZh{}
\NTUSTCoAdvisorEn{}
\NTUSTCoAdvisorTitleZh{}
\NTUSTCoAdvisorTitleEn{}

\NTUSTGraduationYearROC{}
\NTUSTGraduationYearAD{}
\NTUSTGraduationMonthZh{}
\NTUSTGraduationMonthEn{}

\NTUSTKeywordsZh{}
\NTUSTKeywordsEn{}

\NTUSTRecommendationFile{}
\NTUSTApprovalFile{}
```

長篇前置內容放在獨立檔案：

- 中文摘要：`thesis/content/frontmatter/abstract_zh.tex`
- 英文摘要：`thesis/content/frontmatter/abstract_en.tex`
- 誌謝：`thesis/content/frontmatter/acknowledgement.tex`
- 符號索引：`thesis/content/frontmatter/symbols.tex`

`thesis/config/options.tex` 至少提供以下選項：

```tex
\NTUSTBodyFontSize{12} % 12 | 13
\NTUSTBibliographyStyle{ieee} % apa | mla | ieee | chicago | custom
\NTUSTIncludeSymbolsIndex{true} % true | false
\NTUSTAppendixNumbering{alpha} % alpha | chinese
```

字型不放入 options，固定由 class 從 `thesis/assets/fonts/` 載入標楷體與 Times New Roman。

---

## 8. LaTeX 排版要求（給 CodingAgent 的落地條件）

### 8.1 幾何設定

- `geometry` 設為：
  - `a4paper`
  - `top=3cm`
  - `bottom=2cm`
  - `left=3cm`
  - `right=3cm`

### 8.2 行距

- 全文預設 `1.5` 倍行高。
- 可透過 `setspace` 或等效方式實作。

### 8.3 字型套件

- 使用 `fontspec` + `luatexja-fontspec`。
- 英文主字型：Times New Roman
- 中文主字型：標楷體
- 使用 repository-local 固定檔案，而不是系統 Fontconfig family name：

```tex
\setmainfont[Path=thesis/assets/fonts/times/]{times.ttf}
\setmainjfont[Path=thesis/assets/fonts/cjk/]{kaiu.ttf}
```

- 明文字型與 ZIP 不得提交；由有合法授權的 Windows 安裝取得。
- 正式建置前直接檢查五個固定路徑，不提供字型 fallback。

```bash
make pdf
```

### 8.4 頁碼樣式

- 封面、書名頁、推薦書、審定書：`empty` page style
- 中文摘要到表目錄：頁碼置中、羅馬大寫
- 正文開始：頁碼置中、阿拉伯數字

### 8.5 章節樣式

- `\chapter`：置中
- `\section` 以下：靠左
- 中文論文需支援中文章節編號格式
- 英文論文需支援阿拉伯數字階層格式，例如 `Chapter 1`、`1.1`、`1.1.1`

### 8.6 圖表

- caption 需能顯示 `圖1-1`、`表2-3` 這種格式。
- 圖表不可超出正文寬度。
- 預設對小於版心寬度的圖表做置中。
- 需能生成圖目錄 / 表目錄。

### 8.7 前置頁模組化

至少拆成以下邏輯模組：

- `cover`
- `titlepage`
- `recommendation`
- `approval`
- `abstract_zh`
- `abstract_en`
- `acknowledgement`
- `toc`
- `symbols`
- `lof`
- `lot`
- `mainmatter`
- `bibliography`
- `appendix`

### 8.8 可配置覆蓋

所有以下項目都應可由使用者覆蓋：

- 內文字級（12 / 13 pt）
- bibliography style
- 是否顯示符號索引
- 附錄編號方式

---
