# Paper build workflow

This folder is configured for writing in Markdown and exporting journal-style PDF using Pandoc + LaTeX.

## Files

- `paper.md`: main manuscript source
- `metadata.yaml`: paper-level metadata for output formatting
- `references.bib`: citation database
- `template-journal.tex`: journal single-column template (default)
- `pandoc-journal.yaml`: journal build defaults (input/output/options)
- `build.sh`: WSL/Linux one-command build
- `build.ps1`: Windows PowerShell one-command build

## Prerequisites

- `pandoc`
- A LaTeX engine (`lualatex`) via TeX Live or MiKTeX

For WSL/Ubuntu, this install set is recommended:

```bash
sudo apt update
sudo apt install -y pandoc texlive-luatex texlive-latex-extra fonts-lmodern
```

If you see this error while building:

`Font \TU/lmr/m/n/... not loadable` or `luaotfload-main not found`

run:

```bash
sudo apt update
sudo apt install -y texlive-luatex lmodern
```

If your Pandoc is older (for example 2.9.x), citations are still supported through bibliography metadata, but `--citeproc` CLI flag behavior may differ by version.

## Build

From this `paper/` directory:

### WSL/Linux

```bash
chmod +x build.sh
./build.sh
```

### PowerShell

```powershell
./build.ps1
```

### Make

```bash
make pdf
```

Output: `paper.pdf`

## Citations

- Add entries to `references.bib`
- Cite in markdown as `[@fama1970]`
