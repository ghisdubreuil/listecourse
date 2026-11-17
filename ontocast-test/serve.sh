#!/usr/bin/env bash
# Démarre l'API HTTP OntoCast sur http://127.0.0.1:8999 (graphes en mémoire).
# Exemple d'appel dans un autre terminal :
#   curl -X POST http://127.0.0.1:8999/process -F "file=@samples/recette-crepes.txt" -o out/result.json
set -euo pipefail
cd "$(dirname "$0")"
ONTO_ARGS=()
if [[ "${1:-}" == "--onto" ]]; then ONTO_ARGS=(--ontology-dir ontologies); fi
exec .venv/bin/ontocast --env-file my.env serve ${ONTO_ARGS[@]+"${ONTO_ARGS[@]}"}
