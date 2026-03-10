#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v pandoc >/dev/null 2>&1; then
	echo "Error: pandoc is not installed."
	exit 1
fi

if ! command -v lualatex >/dev/null 2>&1; then
	echo "Error: lualatex is not installed."
	echo "Install (Ubuntu/WSL): sudo apt install -y texlive-luatex"
	exit 1
fi

if ! kpsewhich luaotfload-main.lua >/dev/null 2>&1; then
	echo "Error: LuaLaTeX font loader is missing (luaotfload-main.lua)."
	echo "Install (Ubuntu/WSL): sudo apt install -y texlive-luatex lmodern"
	exit 1
fi

pandoc --defaults pandoc-journal.yaml
echo "Built: $(pwd)/paper.pdf"
