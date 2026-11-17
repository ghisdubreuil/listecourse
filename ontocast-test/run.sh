#!/usr/bin/env bash
# Lance OntoCast en mode batch (sans serveur) sur des fichiers locaux.
#   ./run.sh                          -> traite samples/ ; OntoCast construit sa propre ontologie
#   ./run.sh --onto                   -> idem, en partant de l'ontologie ontologies/courses.ttl
#   ./run.sh chemin/fichier.txt       -> traite un fichier (ou un dossier) précis
#   ./run.sh --onto chemin/dossier    -> combinable
# Résultats dans out/ : <nom>.facts.ttl, <nom>.ontology.ttl, <nom>.run.json
set -euo pipefail
cd "$(dirname "$0")"

ONTO_DIR=""
if [[ "${1:-}" == "--onto" ]]; then ONTO_DIR="ontologies"; shift; fi
INPUT="${1:-samples}"

[[ -x .venv/bin/ontocast ]] || { echo "Lance d'abord ./install.sh"; exit 1; }
[[ -f my.env ]] || { echo "Crée my.env (cp env.example my.env) et mets ta clé API"; exit 1; }
grep -q '^LLM_API_KEY=remplace-moi' my.env && { echo "Renseigne LLM_API_KEY dans my.env"; exit 1; }

mkdir -p out
.venv/bin/ontocast --env-file my.env process \
  --input-path "$INPUT" \
  --output-dir out \
  --ontology-dir "$ONTO_DIR"

echo
echo "Fichiers produits :"
ls -1 out
