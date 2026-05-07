workspace "Relacionamentos" {
    model {
        sysa = element "Sistema de Dados Comerciais" "Software System" "Um sistema de dados comerciais."
        sysb = element "Sistema de Risco Financeiro" "Software System" "Um sistema de risco financeiro."
        sysa -> sysb "Dados Comerciais" "" "antes"
        sysa -> sysb "Envia dados comerciais para" "" "depois"

        spa = element "Aplicativo de Página Única" "Container: NestJS" "Fornece acesso a páginas web."
        api = element "Aplicativo API" "Container: Python e FastAPI" "Fornece API de dados."
        spa -> api "Usa" "" "antes"
        spa -> api "Faz chamadas de API utilizando" "" "depois"
    }


    views {

        custom "RelacionamentosAntes" "Relacionamentos Antes"{
            include *
            exclude relationship.tag==depois
            autoLayout lr
        }

        custom "RelacionamentosDepois" "Relacionamentos Depois"{
            include *
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
