# Modelo C4 para documentação de arquiteturas

Este repositório contém todos os diagramas contidos na apresentação do modelo C4.

[PlantUML](https://plantuml.com/) foi utilizado em conjunto com [C4-PlantUML](https://github.com/plantuml-stdlib/C4-PlantUML) para gerar os diagramas.


## Gerando os diagramas

O [VS Code](https://code.visualstudio.com/) possui um plugin para PlantUML que pode ser encontrado na marketplace: [PlantUML for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml).

Caso queira rodar localmente será necessário instalar o [Graphviz](https://www.graphviz.org/). No sistema operacional ubuntu o comando é:

    sudo apt-get install graphviz openjdk-17-jre

Os diagramas também podem ser gerados utilizando o servidor remoto: http://www.plantuml.com/plantuml/uml/.

Abra os arquivos de extensão `.puml` ou copie seu conteúdo para o editor ou navegador.

Caso esteja utilizando a versão online, clique no botão `Render` para gerar a imagem.

Se estiver rodando localmente, aperte `ALT + D` para ter uma pré visualização, ou `CTRL + SHIFT + P` e selecione a opção de exportar a imagem ou pré visualização. 