# LaTeX Environment Reproduction

本模板使用 XeLaTeX、`latexmk`、`biber`、BibLaTeX、`fontspec` 與 `xeCJK`。Ubuntu 環境建議直接使用 apt 安裝 TeX Live 相關套件，不另外安裝 TUG 官方最新版。

## Target Environment

- Ubuntu 24.04 or compatible Linux environment
- Ubuntu apt repository TeX Live packages
- `Times New Roman`：透過 apt 的 `ttf-mscorefonts-installer` 安裝
- `標楷體`

`標楷體` 請從有授權的 Windows 系統複製 `kaiu.ttf` 到本機使用。不要把 Windows 字型檔提交進此模板 repository，也不要隨模板重新散布。

## Install System Packages

```bash
sudo apt update
sudo apt install \
  latexmk \
  biber \
  ttf-mscorefonts-installer \
  texlive-xetex \
  texlive-luatex \
  texlive-latex-recommended \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-lang-chinese \
  texlive-science \
  fontconfig \
  ripgrep
```

套件用途：

```text
latexmk                         自動編譯 LaTeX
biber                           BibLaTeX 參考文獻
ttf-mscorefonts-installer       Times New Roman 與 Microsoft core fonts
texlive-xetex                   XeLaTeX，方便指定系統字型
texlive-luatex                  LuaLaTeX，需要時可用
texlive-latex-recommended       常見 LaTeX 套件
texlive-latex-extra             額外常見 LaTeX 套件
texlive-fonts-recommended       TeX 常見基本字型支援
texlive-lang-chinese            中文 LaTeX / CJK 相關支援
texlive-science                 algorithm / algpseudocode 等演算法環境支援
fontconfig                      fc-match / fc-cache 字型管理
ripgrep                         rg，快速搜尋 build log 與專案文字
```

可選工具：

```bash
sudo apt install poppler-utils
```

`poppler-utils` 提供 `pdfinfo` 與 `pdftoppm`，方便檢查 PDF。

`ttf-mscorefonts-installer` 位於 Ubuntu multiverse。若 apt 找不到此套件，先確認 multiverse repository 已啟用。

## Do Not Use Chinese Font Packages as Required Fonts

本模板的標楷體來源是 Windows 的 `kaiu.ttf`，因此不要為了替代標楷體而手動安裝下列中文字型套件：

```bash
fonts-noto-cjk
fonts-cns11643-kai
fonts-moe-standard-kai
fonts-arphic-*
```

原因是這些中文字型套件會安裝未指定的替代字型。為了讓輸出與台科大格式需求一致，本模板的英文字型使用 apt 安裝的 `Times New Roman`，中文字型使用 Windows 複製的 `標楷體`。

注意：`texlive-lang-chinese` 在 Ubuntu apt 中會透過相依關係安裝部分 Arphic 字型，桌面版 Ubuntu 也可能已預裝 Noto CJK。這些套件存在本身不構成問題；重點是不要把它們當成此模板的標楷體來源。請仍依下一節複製授權 Windows 字型。

## Copy Kai Font from Windows

在有授權的 Windows 系統中尋找下列檔案，複製到本專案根目錄的 `windows字體/`：

```text
C:\Windows\Fonts\kaiu.ttf
```

字型對應：

```text
kaiu.ttf      標楷體，Fontconfig 常見名稱為 DFKai-SB
```

從 `windows字體/` 安裝到 Ubuntu 的單一使用者字型目錄：

```bash
mkdir -p ~/.local/share/fonts/windows
cp windows字體/kaiu.ttf ~/.local/share/fonts/windows/
fc-cache -fv
```

## Check Fonts

```bash
fc-match 'Times New Roman'
fc-match '標楷體'
fc-match 'DFKai-SB'
```

預期結果會類似：

```text
Times_New_Roman.ttf: "Times New Roman" "Regular"
kaiu.ttf: "DFKai-SB" "Regular"
```

若 `fc-match '標楷體'` 沒有命中 `kaiu.ttf`，但 `fc-match 'DFKai-SB'` 有命中，代表字型已安裝，只是 Fontconfig 沒有把中文名稱對到該字型。這時建立 alias：

```bash
mkdir -p ~/.config/fontconfig

cat > ~/.config/fontconfig/fonts.conf <<'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <alias>
    <family>標楷體</family>
    <prefer>
      <family>DFKai-SB</family>
    </prefer>
  </alias>
</fontconfig>
EOF

fc-cache -fv
fc-match '標楷體'
```

## Check Required Commands

```bash
xelatex --version
lualatex --version
latexmk --version
biber --version
fc-match 'Times New Roman'
fc-match '標楷體'
```

## Build the Thesis

From the repository root:

```bash
make pdf
```

The generated PDF is written to:

```text
build/thesis.pdf
```

Inspect important warnings after a build:

```bash
make check-log
```

## Optional PDF Inspection

Install optional tools first if needed:

```bash
sudo apt install poppler-utils
```

Then inspect the generated PDF:

```bash
pdfinfo build/thesis.pdf
pdftoppm -jpeg -f 1 -singlefile build/thesis.pdf /tmp/thesis-preview
```

The second command creates `/tmp/thesis-preview.jpg` for quick visual inspection of the first page.

## Signed Forms

During drafting, leave the form paths in `config/metadata.tex` empty. The template will render placeholder pages.

For the final version, place signed PDF or image files under `assets/forms/` and set:

```tex
\NTUSTRecommendationFile{assets/forms/advisor_recommendation.pdf}
\NTUSTApprovalFile{assets/forms/approval.pdf}
```

## Troubleshooting

If `xelatex`, `latexmk`, or `biber` is not found, confirm that the tools are installed and available in `PATH`:

```bash
echo "$PATH"
which xelatex lualatex latexmk biber
```

If Chinese text does not render correctly, confirm that `kaiu.ttf` is installed and visible through either `標楷體` or `DFKai-SB`:

```bash
fc-match '標楷體'
fc-match 'DFKai-SB'
```

If `DFKai-SB` works but `標楷體` does not, add the Fontconfig alias in the `Check Fonts` section.
