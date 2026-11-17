# Test d'OntoCast

Bac à sable pour essayer [OntoCast](https://github.com/growgraph/ontocast) (v0.9.2) :
il lit des documents et en extrait un graphe de connaissances RDF (une ontologie + des faits, en Turtle).

## 1. Installer (une fois)

Prérequis : Python 3.10+ (et idéalement [uv](https://docs.astral.sh/uv/), plus rapide).

```bash
cd ontocast-test
./install.sh          # léger : fichiers .txt et .json
./install.sh --full   # + PDF, DOCX, HTML, Markdown, images (télécharge torch/docling, plusieurs Go)
```

Le script crée `.venv/` et copie `env.example` en `my.env`.

## 2. Mettre une clé API

Dans `my.env`, renseigner `LLM_API_KEY`. Par défaut c'est OpenAI ; pour Anthropic,
commenter le bloc OpenAI et décommenter le bloc Anthropic. (`my.env` est ignoré par git.)

## 3. Lancer

```bash
./run.sh                       # traite les 3 fichiers de samples/, OntoCast invente l'ontologie
./run.sh --onto                # idem, mais en s'appuyant sur ontologies/courses.ttl
./run.sh mes-docs/rapport.txt  # n'importe quel fichier ou dossier
```

Résultats dans `out/` :
- `<nom>.facts.ttl` — les faits extraits
- `<nom>.ontology.ttl` — l'ontologie utilisée/créée
- `<nom>.run.json` — coût (nombre d'appels LLM), erreurs, validation

Les réponses du modèle sont mises en cache dans `.cache/` : relancer le même fichier est quasi gratuit.

### Variante serveur HTTP

```bash
./serve.sh                     # ou ./serve.sh --onto
curl http://127.0.0.1:8999/health
curl -X POST http://127.0.0.1:8999/process -F "file=@samples/recette-crepes.txt" -o out/result.json
jq -r '.results[0].outcome.data.facts' out/result.json
```

## Contenu

| Chemin | Rôle |
|---|---|
| `samples/` | 3 petits textes : recette, liste de courses, article sur une coopérative |
| `ontologies/courses.ttl` | mini-ontologie (Produit, Magasin, Recette, Ingrédient…) pour le mode `--onto` |
| `env.example` | configuration réglée pour des essais peu coûteux (critique désactivée, 4 requêtes parallèles) |

Doc complète : https://growgraph.github.io/ontocast/
