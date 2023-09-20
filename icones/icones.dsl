workspace "Icones" {
    model {
        element "Título 01" "tecnologia" "Descrição de um elemento." "Dynatrace"
        element "Título 02" "tecnologia" "Descrição de um elemento." "Elastic Logstash"
        element "Título 03" "tecnologia" "Descrição de um elemento." "Filebeat"
        element "Título 04" "tecnologia" "Descrição de um elemento." "Kafka"
        element "Título 05" "tecnologia" "Descrição de um elemento." "New Relic"
        element "Título 06" "tecnologia" "Descrição de um elemento." "Amazon Web Services - Simple Storage Service S3 Standard"
        element "Título 07" "tecnologia" "Descrição de um elemento." "Amazon Web Services - OpenSearch Service"
        element "Título 08" "tecnologia" "Descrição de um elemento." "Jaeger"
        element "Título 09" "tecnologia" "Descrição de um elemento." "Open Telemetry"
        element "Título 10" "tecnologia" "Descrição de um elemento." "OpenSearch"
        element "Título 11" "tecnologia" "Descrição de um elemento." "AWS S3"
        element "Título 12" "tecnologia" "Descrição de um elemento." "AWS Prometheus"
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
