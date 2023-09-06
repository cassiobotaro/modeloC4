workspace "Icones" {
    model {
        element "Título 1" "tecnologia" "Descrição de um elemento." "Android"
        element "Título 2" "tecnologia" "Descrição de um elemento." "Dynatrace"
        element "Título 3" "tecnologia" "Descrição de um elemento." "Elastic Logstash"
        element "Título 4" "tecnologia" "Descrição de um elemento." "Filebeat"
        element "Título 5" "tecnologia" "Descrição de um elemento." "Kafka"
        element "Título 6" "tecnologia" "Descrição de um elemento." "New Relic"
        element "Título 7" "tecnologia" "Descrição de um elemento." "Amazon Web Services - Simple Storage Service S3 Standard"
        element "Título 8" "tecnologia" "Descrição de um elemento." "Amazon Web Services - OpenSearch Service"
    }

    views {

        custom "Icones" "Exemplos de Ícones" {
            include *
            autolayout
        }

        theme default
        themes https://raw.githubusercontent.com/cassiobotaro/modeloC4/main/icones/theme.json
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
    }
}
