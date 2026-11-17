#!/usr/bin/env bash
# Installe OntoCast dans un environnement virtuel local (.venv).
#   ./install.sh          -> install légère : fichiers .txt / .json, OpenAI + Anthropic
#   ./install.sh --full   -> ajoute la conversion PDF/DOCX/HTML/MD/images (docling, lourd : ~plusieurs Go)
set -euo pipefail
cd "$(dirname "$0")"

EXTRAS="server,openai,anthropic"
if [[ "${1:-}" == "--full" ]]; then
  EXTRAS="$EXTRAS,doc-processing,semantic-chunking"
fi

if command -v uv >/dev/null 2>&1; then
  uv venv .venv --python 3.12
  uv pip install --python .venv "ontocast[$EXTRAS]"
else
  python3 -m venv .venv
  .venv/bin/pip install --upgrade pip
  .venv/bin/pip install "ontocast[$EXTRAS]"
fi

[[ -f my.env ]] || cp env.example my.env
echo
echo "OK : $(.venv/bin/ontocast --help >/dev/null && echo 'ontocast installé')"
echo "Étape suivante : renseigner LLM_API_KEY dans my.env, puis lancer ./run.sh"
