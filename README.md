# NTUST Thesis Template

English | [繁體中文](README_zh.md)

A LuaLaTeX thesis template for National Taiwan University of Science and Technology (NTUST). The sample thesis uses English main matter by default and can be switched to Chinese. Formal PDFs must be compiled with the digest-pinned Docker TeX Live 2025 environment.

[View the latest template preview PDF](https://github.com/hank1224/NTUST-Thesis-Template/releases/latest/download/ntust-thesis-template-preview.pdf)

## Project structure

| Path | Purpose |
| --- | --- |
| `main.tex` | The only LaTeX root document |
| `thesis/template/` | NTUST class and layout modules |
| `thesis/config/` | Language, metadata, template options, and terminology |
| `thesis/content/` | Front matter, chapters, appendices, and bibliography |
| `thesis/assets/` | Branding, figures, approval pages, and local licensed fonts |
| `tooling/latex/` | Pinned Docker image build and diagnostic scripts |
| `tooling/qa/` | Compile-input boundary and LaTeX log checks |
| `docs/` | Environment and NTUST format specifications |
| `build/` | Ignored PDFs, auxiliary files, logs, and diagnostics |

The LaTeX compile surface intentionally consists only of `main.tex` and the complete `thesis/` directory. Repository maintenance files under `tooling/`, `.github/`, and `docs/` are not LaTeX inputs.

## Requirements

The host only needs:

- Docker Engine or Docker Desktop;
- support for `linux/amd64` containers;
- five legally obtained Windows font files.

Host installations of LuaLaTeX, latexmk, biber, or TeX Live are neither required nor supported. The only supported environment is the TL2025 `tlnet-final` image digest recorded in [`tooling/latex/texlive-image.lock`](tooling/latex/texlive-image.lock).

Following [`thesis/assets/fonts/README.md`](thesis/assets/fonts/README.md), copy Times New Roman and DFKai-SB from a legally licensed Windows installation to:

```text
thesis/assets/fonts/times/times.ttf
thesis/assets/fonts/times/timesbd.ttf
thesis/assets/fonts/times/timesi.ttf
thesis/assets/fonts/times/timesbi.ttf
thesis/assets/fonts/cjk/kaiu.ttf
```

The plaintext font files are protected by `.gitignore` and must not be committed or redistributed.

## Build and verification

```bash
make pdf
make check
make logs
make clean
```

- `make pdf` compiles `build/thesis.pdf` exclusively through the digest-pinned Docker image.
- `make check` recompiles the thesis and checks the TeX input boundary and LaTeX log.
- `make logs` displays the image, tool versions, LaTeX diagnostics, and container console.
- `make clean` removes the reproducible `build/` directory.

The check fails on LaTeX errors, unresolved references or citations, missing glyphs, and overfull boxes.

## Editing the thesis

1. Select the main document language in `thesis/config/document.tex`.
2. Enter the department, title, author, advisor, and graduation date in `thesis/config/metadata.tex`.
3. Configure the body font size, bibliography style, symbols list, and appendix numbering in `thesis/config/options.tex`.
4. Write the abstracts, acknowledgements, and symbols list under `thesis/content/frontmatter/`.
5. Write the main matter under `thesis/content/chapters/`; update `mainmatter.tex` when adding or removing chapters.
6. Maintain references in `thesis/content/bibliography/references.bib`.
7. Put private recommendation or approval pages under `thesis/assets/forms/` and configure their paths in the metadata file.

Approval pages may be common image formats or multipage PDFs. Empty paths produce placeholder pages. Everything in that directory except its README is ignored to prevent accidental publication of signatures or private information.

## English and Chinese theses

English is the default:

```tex
\def\NTUSTDocumentLanguage{en}
```

For Chinese main matter, use:

```tex
\def\NTUSTDocumentLanguage{zh}
```

Only `en` and `zh` are valid. This setting is read before the document class and maps to the PDF root languages `en-US` and `zh-TW`. It also controls chapter, contents, figure, table, bibliography, acknowledgements, and symbols-list labels.

The English table of contents distinguishes main-matter entries such as `Chapter 1` from appendix entries such as `Appendix A`.

## GitHub Actions and preview PDF

The latest GitHub Release provides a stable preview PDF URL, so readers do not need to navigate the CI page. CI still uses the same Docker entry point as local builds and uploads a commit-specific PDF artifact retained for 14 days. The repository does not track `build/thesis.pdf`.

The CI font archive is tracked after AES-256 GPG encryption. Repository maintainers must configure:

```bash
gh secret set THESIS_FONTS_PASSPHRASE \
  < .github/fonts/thesis-fonts.passphrase.local
```

A fork or new repository without this secret fails explicitly during font restoration. Never place the passphrase, an encoded passphrase, or recoverable hints in tracked files.

## Informal Overleaf preview

Overleaf is not a supported formal build environment, and its output is not guaranteed to match the pinned Docker image. For informal editing or preview, upload only:

```text
main.tex
thesis/
```

Include the five licensed fonts under `thesis/assets/fonts/`, then select:

- Main document: `main.tex`
- Compiler: LuaLaTeX
- TeX Live: 2025

You do not need to upload `tooling/`, `.github/`, `docs/`, `Makefile`, or `.latexmkrc`. PDFs submitted as formal output must still be produced through the repository build or check entry point.
