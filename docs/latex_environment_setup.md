# Pinned LuaLaTeX environment

本模板只有一個受支援的正式編譯環境：
`tooling/latex/texlive-image.lock` 固定的 Docker image。主機 TeX 與 Overleaf
都不屬於正式建置契約。

## 固定環境

| 項目 | 固定值 |
| --- | --- |
| TeX Live | 2025 `tlnet-final` |
| Container platform | `linux/amd64` |
| Engine | LuaLaTeX |
| Bibliography | biber through latexmk |
| Root input | `main.tex` |
| Output | `build/thesis.pdf` |

Image reference 必須包含完整 `@sha256:` digest。編譯期間不得使用 floating tag、
執行 `tlmgr update`，或切換到主機 TeX binaries。

Apple Silicon 會透過 Docker 的 `linux/amd64` 模擬執行，因此速度可能慢於原生
x86_64 主機，但能與 GitHub Actions 使用相同 TeX binaries。

## 字型

LuaLaTeX 不使用系統 Fontconfig family name，而是直接從 repository-local 路徑
載入五個字型。請從有合法授權的 Windows 安裝複製：

```text
C:\Windows\Fonts\times.ttf
C:\Windows\Fonts\timesbd.ttf
C:\Windows\Fonts\timesi.ttf
C:\Windows\Fonts\timesbi.ttf
C:\Windows\Fonts\kaiu.ttf
```

並放到 [`thesis/assets/fonts/README.md`](../thesis/assets/fonts/README.md) 指定的
固定位置。明文字型、ZIP 與 passphrase 都被 Git 忽略。

## 建置與診斷

```bash
make pdf
make check
make logs
```

`make pdf` 執行順序如下：

1. 驗證 image lock 包含 digest。
2. 驗證五個字型存在。
3. 建立被忽略的 `build/` cache 與 diagnostics。
4. 將 repository bind-mount 到 `/workspace`。
5. 在 container 內執行受 guard 保護的 `make pdf-in-container`。
6. 將 PDF、LaTeX log、recorder 與 console 保留在主機 `build/`。

重要輸出：

| 路徑 | 內容 |
| --- | --- |
| `build/thesis.pdf` | 完整論文 PDF |
| `build/thesis.log` | LuaLaTeX log |
| `build/thesis.fls` | compilation-boundary recorder |
| `build/qa/docker/invocation.txt` | image、platform 與 exit code |
| `build/qa/docker/environment.log` | LuaLaTeX、latexmk、biber 版本 |
| `build/qa/docker/compile-console.log` | 完整 container console |
| `build/qa/log-warnings.txt` | 一般 LaTeX diagnostics |

發生錯誤時先執行 `make logs`。`make pdf-in-container` 是內部介面；在主機直接
執行必須失敗。

## GitHub Actions 字型還原

Tracked repository 只保存：

```text
.github/fonts/thesis-fonts.tar.gz.gpg
.github/fonts/thesis-fonts.sha256
```

本機密碼檔 `.github/fonts/thesis-fonts.passphrase.local` 必須維持權限 `0600`
並由 `.gitignore` 排除。更新封包使用：

```bash
.github/scripts/package-thesis-fonts.sh
```

CI 使用 repository secret `THESIS_FONTS_PASSPHRASE` 解密，核對 archive file list
與每個明文字型的 SHA-256，然後才啟動 Docker。Secret 缺失或 checksum 不符都會
fail closed。

## 非正式 Overleaf 預覽

`main.tex` 與 `thesis/` 形成自包含的 LaTeX input surface，可連同五個授權字型
上傳 Overleaf，使用 LuaLaTeX／TeX Live 2025 預覽。這個路徑不使用 repository
的 pinned image，因此不屬於正式建置，也不保證版面或套件版本一致。
