workspace "Imersão Full Cycle" {
    model {
        client = softwaresystem "Cliente" "Sistema que solicita o pagamento." "External"
        user = person "Administradora" "Acompanha as transações de pagamento." "External"
        superadmin = person "Administradora da Gateway" "Acompanha as métricas de transações de pagamento." "Admin"

        full_cycle_gateway = softwareSystem "Full Cycle Gateway" {

            backend = container "Backend" "Sistema que recebe a solicitação de pagamento" "Nest.js") {
                client -> this "Solicita pagamento em" "HTTP/JSON"
            }

            processor = container "Processador de pagamentos" "Processa pagamento: autorizando ou rejeitando" "Go" {
                backend -> this "Envia dados de pagamento para" "Através do Kafka pelo tópico transactions"
                this -> backend "Envia resultado da transação" "Através do Kafka pelo tópico transactions_result"
            }

            mysql_backend = container "RequisicoesTransacoes" "Armazena as requisições de transações de pagamento." "MySQL schema" "Banco de Dados" {
                backend -> this "Recebe dados do pagamento" "MySQL Protocol"
            }
            mysql_processor = container "Transacoes" "Armazena as transações de pagamento." "MySQL schema" "Banco de Dados" {
                processor -> this "Recebe dados do pagamento" "MySQL Protocol"
            }

            prometheus = container "Métricas de pagamento" "Armazena métricas de pagamento" "Prometheus" {
                processor -> this "Consume métricas de pagamento em" "HTTP/TXT"
            }

            grafana = container "Dashboard de métricas" "Exibe métricas de pagamentos" "Grafana" {
                this -> prometheus "Consume métricas de pagamento em" "PromQL"
                superadmin -> this "Consume métricas de pagamento em" "HTTPS"
            }


            frontend = container "Painel de Controle" "Monitora as transações de pagamento e seus status" "Next.js" "Navegador Web" {
                user -> this "Solicita dados das transações em" "HTTPS"
                this -> backend "Recupera informações de pagamento" "HTTPS/JSON"
            }
        }
        deploymentEnvironment "Live" {
            region = deploymentNode "US-East-1" {
                tags "Amazon Web Services - Region"

                deploymentNode "Autoscaling group frontend" {
                    tags "Amazon Web Services - Auto Scaling"

                    deploymentNode "Amazon EC2" {
                        tags "Amazon Web Services - EC2"
                        frontInstance = containerInstance frontend
                    }
                }

                deploymentNode "Autoscaling group backend" {
                    tags "Amazon Web Services - Auto Scaling"

                    deploymentNode "Amazon EC2" {
                        tags "Amazon Web Services - EC2"
                        containerInstance backend
                    }
                }

                deploymentNode "Amazon EC2 - Processor" {
                    tags "Amazon Web Services - EC2"
                    containerInstance processor
                }

                deploymentNode "Managed Grafana" {
                    tags "Amazon Web Services - Managed Grafana"
                    containerInstance grafana
                }

                deploymentNode "Managed Prometheus" {
                    tags "Amazon Web Services - Managed Service for Prometheus"
                    containerInstance prometheus
                }

                deploymentNode "Amazon RDS backend" {
                    tags "Amazon Web Services - RDS"

                    deploymentNode "MySQL" {
                        tags "Amazon Web Services - RDS MySQL instance"
                        containerInstance mysql_backend
                    }
                }

                deploymentNode "Amazon RDS processor" {
                    tags "Amazon Web Services - RDS"

                    deploymentNode "MySQL" {
                        tags "Amazon Web Services - RDS MySQL instance"
                        containerInstance mysql_processor
                    }
                }
            }
        }
    }

    views {
        systemContext full_cycle_gateway "ContextDiagram" {
            include *
            autoLayout
        }

        container full_cycle_gateway "ContainerDiagram" {
            include *
            autoLayout lr
        }

        deployment full_cycle_gateway "Live" "LiveDeployment" {
            include *
            autoLayout lr
        }

        theme "default"
        styles {
            element "Person" {
                background #ffffff
            }
            element "Software System" {
                background #ffffff
                stroke #1168bd
                color #1168bd
            }
            element "Container" {
                background #ffffff
                stroke #438dd5
                color #438dd5
            }
            element "External" {
                stroke #999999
                color #999999
                background #ffffff
            }
            element "Admin" {
                stroke #ffa505
                color #ffa505
                background #ffffff
            }
            element "Banco de Dados" {
                shape Cylinder
            }
            element "Navegador Web" {
                shape WebBrowser
            }
        }
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
    }
}
