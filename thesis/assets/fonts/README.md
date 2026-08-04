# Licensed thesis fonts

The LuaLaTeX template loads five fixed font files from this directory. These
files are licensed assets and are intentionally ignored by Git.

## Required files

Copy the following files from a legally licensed Windows installation and
normalize their names exactly as shown:

```text
thesis/assets/fonts/
├── README.md
├── times/
│   ├── times.ttf
│   ├── timesbd.ttf
│   ├── timesi.ttf
│   └── timesbi.ttf
└── cjk/
    └── kaiu.ttf
```

The usual Windows sources are:

```text
C:\Windows\Fonts\times.ttf
C:\Windows\Fonts\timesbd.ttf
C:\Windows\Fonts\timesi.ttf
C:\Windows\Fonts\timesbi.ttf
C:\Windows\Fonts\kaiu.ttf
```

Do not commit, redistribute, or attach the plaintext files to an issue or pull
request. Run `make pdf` after all five files are present.

## Maintainer-only CI archive

GitHub Actions restores the fonts from the tracked encrypted archive. The
decryption passphrase exists only in the repository secret
`THESIS_FONTS_PASSPHRASE` and the ignored local file
`.github/fonts/thesis-fonts.passphrase.local`.

To create or rotate the local passphrase and encrypted archive:

```bash
umask 077
openssl rand -base64 -out .github/fonts/thesis-fonts.passphrase.local 48
chmod 600 .github/fonts/thesis-fonts.passphrase.local
.github/scripts/package-thesis-fonts.sh
```

Commit only `.github/fonts/thesis-fonts.tar.gz.gpg` and
`.github/fonts/thesis-fonts.sha256`. Never place the passphrase, an encoded
version of it, or instructions that reveal it in repository documentation.
