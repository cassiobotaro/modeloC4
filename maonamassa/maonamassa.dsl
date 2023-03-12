workspace "Mão na Massa CMS" {
    model {
        client = person "Usuário" "Consumidor de conteúdo."
        admin = person "Admin" "Administrador de conteúdo."

        cms = softwareSystem "Mão na Massa CMS" {
            frontweb = container "Plataforma WEB - SPA" "Prover conteúdo para usuarios e acesso administrativo ao CMS." "Vue.js"
            frontmobile = container "Mobile" "Prover conteúdo para usuarios e acesso administrativo ao CMS." "Flutter"
            backapi = container "Backend" "Gerenciar e prover conteúdos da plataforma e controle de acesso." "NestJS, Typescript"
            bd = container "Banco de dados SQL" "Armazenar informações dos usuários e de conteúdo." "PostgreSQL"
        }
        client -> frontweb "Acessa o conteúdo da" "HTTPS"
        client -> frontmobile "Acessa o conteúdo do" "HTTPS"
        admin -> frontweb "Acessa painel administrativo da" "HTTPS"
        admin -> frontmobile "Acessa painel administrativo do" "HTTPS"
        frontweb -> backapi "Realiza chamadas de api no" "HTTPS, JSON"
        frontmobile -> backapi "Realiza chamadas de api no" "HTTPS, JSON"
        backapi -> bd "Lê e escreve no"
    }

    views {
        systemContext cms "ContextDiagram" {
            include *
            autoLayout
        }

        container cms "ContainerDiagram" {
            include *
            autoLayout lr
        }
        theme "default"

    }
}
