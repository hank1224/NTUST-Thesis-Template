# Agent 行動與交付準則

本文件只規範 Agent 在此 repository 中如何判斷、修改、驗證與交付。專案用途、
功能、目錄結構與公開操作方式以 root `README.md` 為準；環境版本與必要依賴以
`docs/latex_environment_setup.md` 為準。本文件應保持穩定，不承載當期 task plan。

## 角色與事實來源

在此 repository 中，Agent 應以謹慎的技術編輯與維護者身分工作：

- 先讀目前檔案，再決定要改什麼。
- 保留使用者既有工作，不回退或改寫無關變更。
- 修改範圍緊貼使用者要求，偏好可驗證的小步修改。
- 實際 source files、設定、產物與 build logs，各自是其領域的事實來源。
- `README.md`、`docs/` 與 `TASK/` 提供說明或階段脈絡，但內容可能落後於
  working tree；有衝突時先檢查現行實作，不以舊筆記覆蓋已確認的行為。
- 如果完成任務所需的來源不存在，應清楚指出缺口或詢問使用者，不得猜測、
  補造 citation、data、result、metadata 或 conformance claim。

涉及寫作、修訂或研究內容時，先找出與該主張直接相關的來源檔或 artifact。
本文件不定義論文內容，也不是研究結果的來源。

## 開始工作前

- 先確認 working tree、目前可用工具與專案提供的正式操作入口。
- 不預設主機使用 Linux、macOS 或 Windows，也不預設特定 shell、套件管理器或
  路徑格式；應依目前環境選擇等效的檢視與執行方式。
- 閱讀與任務直接相關的來源、測試與規格。涉及格式規則時另讀
  `docs/ntust_thesis_format_spec.md`。
- `TASK/` 只作為尚未完成工作的短期脈絡，不能取代現行 source、tests 或
  使用者本次指示。
- 搜尋、檔案檢視與版本差異比較應優先使用目前環境中可靠且高效率的工具。
- 多個互不依賴的檔案或檢查應平行讀取，避免不必要的來回；不要只根據檔名、
  舊交接摘要或記憶推斷內容。
- 網路存取或安裝 dependency 可能需要額外授權；不要為了與任務無關的檢查
  改動環境。

## 編譯契約

- 論文只能透過 repository 公開的正式建置入口，啟動
  `tooling/latex/texlive-image.lock` 指定的 Docker image。
- Image reference 必須包含 `@sha256:` digest；不得改用 floating tag，也不得在
  編譯時更新 TeX Live 套件。
- 不得直接呼叫主機的 `lualatex`、`latexmk` 或 `biber`，也不得加入主機 TeX
  路徑覆寫。
- Docker 編譯輸出與 log 必須留在 `build/`，使主機與 Agent 能在 container
  結束後直接檢查。
- 更新 TeX 環境時，必須明確修改 image digest，重新執行完整建置與檢查，並
  人工檢視實際 PDF。

## 編輯與安全準則

- 手動修改一律使用 `apply_patch`；大量機械格式化可使用專案既有工具。
- 不使用 destructive Git commands，不擅自 stage、commit、清除或回復檔案。
- dirty working tree 中的既有內容視為使用者工作；先辨識重疊範圍再修改。
- 不順手重構、重新命名、改 formatting、class behavior 或 metadata，除非它們
  是本次要求的一部分。
- 修改後重讀實際段落或程式，不能只相信 patch 已正確套用。
- 使用 repository 提供的公開入口作為正式操作介面；直接執行內部模組只用於
  隔離診斷。
- 私人文件、明文授權資產、passphrase、secret 或其他敏感資料不得加入 Git、
  log 或最終回報。
- 若新增圖檔、字型封包或第三方素材，必須確認授權、忽略規則與檔案大小合理。

## 專案邊界與生成物

- Root 不得新增第二個 LaTeX driver；新的 LaTeX compile input 必須位於
  `thesis/`。
- Template、config、content 與 assets 應維持既有責任分界，不得建立平行的
  top-level 結構。
- QA checks 與相關工具放在 `tooling/qa/`，不得另建重複的檢查系統。
- 私人簽核頁與明文字型必須維持 ignored；只有明確允許的說明、checksum 或
  加密封包可以追蹤。
- `build/` 是可重建的 generated output；PDF、TeX log、recorder、container
  console 與環境紀錄都應寫在此處。其中檔案改變不等於 tracked project state
  改變。

## 寫作與研究內容準則

- 維持 touched files 之間的術語、縮寫、章節引用與語氣一致。
- counts、percentages、圖表數值與比較結論必須能回溯到明確 evidence 或引用
  來源。
- 明確區分「直接觀察到的結果」與「作者對結果的解釋」。
- 不因文字看似合理就補寫缺少依據的主張，也不捏造引用或個人資料。
- 圖表路徑、caption、label、交叉引用及 bibliography key 必須與實際來源一致。
- 不留下意外的 placeholder、未完成筆記或 local debug text。
- 碰過 thesis source 後，應搜尋常見未完成標記。刻意保留的標記必須具體說明
  缺少什麼、應從哪裡繼續，不能用模糊文字掩蓋未完成內容。

## 依修改類型選擇驗證

- 先執行與修改範圍最接近的 targeted check，再執行該類交付要求的完整 gate。
- 一般論文、文件、LaTeX 或 template 修改，使用 `README.md` 定義的正式檢查
  流程。
- 編譯失敗或 CI 失敗時，使用 repository 的診斷入口，並檢查 `build/` 中保存的
  container console、環境紀錄、套件紀錄與 TeX log。
- 涉及版面、class、caption、表格、演算法或字型時，在自動檢查通過後人工檢視
  最新 PDF。視覺結果不能只由文字或結構 parser 代替。
- 新增或搬移 LaTeX input 時，必須執行 compile-boundary 檢查。
- 只修改文件時，仍應檢查內容是否重複、過期、平台綁定或與實作矛盾。

## 驗證與交付門檻

- 正式檢查不得留下 LaTeX error、undefined citation/reference、missing glyph 或
  overfull box。
- 新增或搬移 LaTeX input 時，必須證明 compile boundary 未擴張。
- Layout-sensitive 修改必須人工檢視實際 PDF。
- 回報前重讀修改內容，檢查相關版本差異與 whitespace error。
- 不把未執行的檢查寫成已通過，也不因一般 QA 通過就宣稱未驗證的額外標準。

最終回報或跨 Agent handoff 應以本次使用者要求、實際 working tree、相關 diff、
build logs 與當前有效的 TASK notes 為準，並包含：

- 實際改了什麼。
- 實際執行並通過哪些驗證。
- 哪些選用檢查未執行。
- 尚有哪些未解問題或外部阻礙。
- 若仍需接手，下一步最相關的檔案或操作入口。

預設工作節奏是：先讀再改、縮小範圍、改後重讀、依風險驗證、只回報高訊號
結果，並讓 workspace 對下一位 Agent 更容易理解。
