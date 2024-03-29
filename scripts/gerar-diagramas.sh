#!/usr/bin/env bash

function _gerar_markdown() {
	arquivo_mmd="$1"
	conteudo_mmd=$(cat "$arquivo_mmd")

	arquivo_sem_extensao="${arquivo_mmd%.*}"
	echo "## ${arquivo_sem_extensao##*-}"
	echo ""
	echo "\`\`\`mermaid"
	echo "$conteudo_mmd"
	echo "\`\`\`"
	echo ""
}

lista=(relacionamentos icones cms imersaofc intencoes maonamassa niveis)
for nome in "${lista[@]}"; do
	/usr/local/structurizr-cli/structurizr.sh export \
		-format mermaid \
		-workspace "$nome"/"$nome".dsl

	[ -f "$nome"/diagramas.md ] && rm "$nome"/diagramas.md
	for arquivo_mmd in "$nome"/*.mmd; do
		_gerar_markdown "$arquivo_mmd" >>"$nome"/diagramas.md
	done
done
