workspace "Intenções" {

    model {
        a = element "Container A" "Produtor de eventos para a fila." "Python"
        b = element "Container B" "Consumidor de eventos da fila" "Java"
        c = element "Container C" "Produtor de eventos para a fila." "NodeJS"
        d = element "Container D" "Consumidor de eventos da fila" "Go"
        meio = element "Intermediário" "RabbitMQ" "Envia mensagens para seus respectivos consumidores." "antes"

        a -> meio "Envia mensagem para" "amqp" "antes"
        c -> meio "Envia mensagem para" "amqp" "antes"
        meio -> b "Consome mensagem" "amqp" "antes"
        meio -> d "Consome mensagem" "amqp" "antes"

        a -> b "Envia mensagem de criação de usuário" "via RabbitMQ fila CREATE" "depois"
        c -> d "Envia mensagem de atualização de usuário" "via RabbitMQ fila UPDATE" "depois"

    }

    views {

        custom "IntencoesAntes" "Intenções Antes" {
            include *
            exclude relationship.tag==depois
            autoLayout lr
        }

        custom "IntencoesDepois" "Intenções Depois" {
            include *
            exclude element.tag==antes
            exclude relationship.tag==antes
            autoLayout lr
        }

        theme default

        styles {
            element "Element" {
                background #438dd5
                color #ffffff
            }
        }
    }
}
