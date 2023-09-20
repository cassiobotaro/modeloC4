workspace "Icones" {
    model {
        element "Título 1" "tecnologia" "Descrição de um elemento." "OpenSearch"
        element "Título 2" "tecnologia" "Descrição de um elemento." "AWS S3"
        element "Título 3" "tecnologia" "Descrição de um elemento." "AWS Prometheus"
        element "Título 4" "tecnologia" "Descrição de um elemento." "Grafana"
        element "Título 5" "tecnologia" "Descrição de um elemento." "AWS RDS"
    }

    views {

        custom "Icones" "Exemplos de Ícones" {
            include *
            autolayout
        }

        themes https://raw.githubusercontent.com/cassiobotaro/modeloC4/main/icones/theme.json
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/icons.json
    }
}
