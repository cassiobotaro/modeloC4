# Modelo C4 para documentação de arquiteturas

> ⚠️ **Aviso:** Este repositório está em manutenção. Seu conteúdo será substituído por algo mais completo, baseado nas seguintes referências da documentação oficial do Structurizr:
>
> - [Structurizr DSL Cookbook](https://docs.structurizr.com/dsl/cookbook/)
> - [Structurizr DSL Patterns](https://docs.structurizr.com/dsl/patterns/)
> - [Structurizr DSL FAQ](https://docs.structurizr.com/dsl/faq)

Este repositório contém todos os diagramas contidos na [apresentação do modelo C4](slides.pdf).

> ℹ️ **Nota:** Durante a migração, os exemplos abaixo podem estar quebrados.

## Gerando os diagramas

Os diagramas são gerados utilizando a imagem [`structurizr/structurizr`](https://hub.docker.com/r/structurizr/structurizr). As funções abaixo facilitam o uso dos comandos via Docker.

### Rodar localmente

Sobe uma instância local do Structurizr para visualizar e editar os diagramas:

> 💡 **Dica:** Para ver algum exemplo rodando, basta entrar no diretório correspondente (ex.: `cd niveis`) e executar `c4_local`. O resultado estará disponível em [http://localhost:8080](http://localhost:8080).

```bash
# structurizr
function c4_local() {
    docker run --rm -it \
        -p 8080:8080 \
        -u $(id -u):$(id -g) \
        -v "$PWD":/usr/local/structurizr/ \
        -e STRUCTURIZR_AUTOREFRESHINTERVAL=2000 \
        -e STRUCTURIZR_AUTOSAVEINTERVAL=5000 \
        -e STRUCTURIZR_THEMES=/usr/local/structurizr-themes \
        structurizr/structurizr local
}
```

### Exportar diagramas

Exporta os diagramas a partir do `workspace.json` para o diretório `diagrams` no formato escolhido (`plantuml`, `mermaid`, `dot`, `d2`, `json`, `static`, etc.):

```bash
# structurizr export
function c4_export(){
    local format=${1:?"The format must be specified."}
    docker run --rm -it \
        -u $(id -u):$(id -g) \
        -v "$PWD":/usr/local/structurizr/ \
        structurizr/structurizr export -workspace workspace.json -format ${format} -output diagrams
}
```

Invocação:

```bash
c4_export mermaid
```

### Playground

Sobe um playground do Structurizr para experimentações rápidas:

```bash
# structurizr playground
function c4_play() {
    docker run --rm -it \
        -p 8081:8081 \
        -e PORT=8081 \
        -e STRUCTURIZR_THEMES=/usr/local/structurizr-themes \
        structurizr/structurizr playground
}
```
