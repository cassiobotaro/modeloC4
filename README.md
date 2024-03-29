# Modelo C4 para documentação de arquiteturas

**Update:** Uma atualização foi feita no repositório e os modelos foram reescritos utilizando a ferramenta [Structurizr Lite](https://structurizr.com/help/lite).

Este repositório contém todos os diagramas contidos na apresentação do modelo C4.

[PlantUML](https://plantuml.com/) foi utilizado em conjunto com [C4-PlantUML](https://github.com/plantuml-stdlib/C4-PlantUML) para gerar os diagramas.

## Gerando os diagramas

### Structurizr lite

Escrevi uma função para facilitar a utilização do comando:

```bash
# structurizr
function structurizr() {
    readonly file=${1:?"The workspace filename must be specified."}
    if [[ "$file" == *.* ]]; then
        echo "The workspace filename should not contains a file extension."
        return 1
    fi
    if [[ !  -f "./structurizr.properties" ]]; then
        echo "structurizr.autoRefreshInterval=2000" > structurizr.properties
    fi
    docker run --rm -it \
        -p 8080:8080 \
        -u $(id -u ${USER}):$(id -g ${USER}) \
        -v "$PWD":/usr/local/structurizr/ \
        -e STRUCTURIZR_WORKSPACE_FILENAME=$file \
            structurizr/lite
}
```

Ela será invocada da seguinte maneira:

```bash
structurizr nome_do_arquivo_sem_extensão
```

Para exportar os arquivos em png ou svg, mantenha a instância do structurizr rodando e utilize a seguinte função descrita abaixo.

```sh
function export_c4(){
    readonly format=${1:?"The format must be specified."}
    [ ! -f export-diagram.js ] && wget https://github.com/cassiobotaro/modeloC4/raw/main/export-diagram.js
    text=$(docker run -i --init --cap-add=SYS_ADMIN --net=host --name=exporter ghcr.io/puppeteer/puppeteer:latest node -e "$(cat export-diagrams.js)"  "" "http://localhost:8080" "$format")
    files=($(echo "$text" | grep -o "\S*\.$format"))
    for file in "${files[@]}"
    do
        docker cp exporter:/home/pptruser/"$file" .
    done
    docker rm exporter
}
```

Ela será invocada da seguinte maneira:

```bash
export_c4 png
```

### PlantUML

O [VS Code](https://code.visualstudio.com/) possui um plugin para PlantUML que pode ser encontrado na marketplace: [PlantUML for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml).

Caso queira rodar localmente será necessário instalar o [Graphviz](https://www.graphviz.org/). No sistema operacional Ubuntu o comando é:

    sudo apt-get install graphviz openjdk-17-jre

Os diagramas também podem ser gerados utilizando o servidor remoto: http://www.plantuml.com/plantuml/uml/.

Abra os arquivos de extensão `.puml` ou copie seu conteúdo para o editor ou navegador.

Caso esteja utilizando a versão online, clique no botão `Render` para gerar a imagem.

Se estiver rodando localmente, aperte `ALT + D` para ter uma pré visualização, ou `CTRL + SHIFT + P` e selecione a opção de exportar a imagem ou pré visualização.
