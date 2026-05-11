#!/usr/bin/env bash
# Migra posts de Zola a PaperMod.
# Uso: ./migrate-from-zola.sh <directorio-zola/content> <directorio-destino>
# Ejemplo: ./migrate-from-zola.sh ../mi-blog-zola/content ./content/posts

set -euo pipefail

SRC="${1:-}"
DST="${2:-./content/posts}"

if [[ -z "$SRC" ]]; then
  echo "Uso: $0 <directorio-fuente-zola> [directorio-destino]"
  exit 1
fi

mkdir -p "$DST"

for file in "$SRC"/*.md; do
  [[ -f "$file" ]] || continue
  filename=$(basename "$file")
  dest="$DST/$filename"

  # Extrae campos del front matter de Zola (formato TOML +++ o YAML ---)
  title=$(grep -m1 '^title' "$file" | sed 's/title\s*=\s*//;s/title:\s*//;s/"//g;s/^[[:space:]]*//')
  date=$(grep -m1 '^date' "$file" | sed 's/date\s*=\s*//;s/date:\s*//;s/"//g;s/^[[:space:]]*//')
  description=$(grep -m1 '^description\|^summary' "$file" | sed 's/description\s*=\s*//;s/description:\s*//;s/summary\s*=\s*//;s/summary:\s*//;s/"//g;s/^[[:space:]]*//')
  draft=$(grep -m1 '^draft' "$file" | sed 's/draft\s*=\s*//;s/draft:\s*//;s/^[[:space:]]*//')
  tags=$(grep -m1 '^taxonomies\|^tags' "$file" -A5 | grep 'tags' | sed 's/.*tags.*=\s*//;s/.*tags:\s*//')

  # Detecta donde termina el front matter (TOML +++ o YAML ---)
  if grep -q '^+++' "$file"; then
    body=$(awk '/^\+\+\+/{c++; if(c==2){found=1; next}} found' "$file")
  else
    body=$(awk '/^---/{c++; if(c==2){found=1; next}} found' "$file")
  fi

  cat > "$dest" <<EOF
---
title: "${title}"
date: ${date}
description: "${description}"
draft: ${draft:-false}
tags: ${tags:-[]}
categories: []
author: "Alberto Paparelli"
showToc: true
TocOpen: false
hidemeta: false
comments: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
---

${body}
EOF

  echo "Migrado: $filename -> $dest"
done

echo "Listo."
