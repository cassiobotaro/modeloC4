workspace "CMS" {
    model {
        reader = person "Leitor" "Pessoa que consome as notícias do site."
        writer = person "Editor" "Pessoa que escreve conteúdo para o site."

        cms = softwaresystem "CMS" "Sistema de gerenciamento de conteúdo."{
            portal = container "Portal de Notícias" "Site que fornece as notícias e conteúdos. Possui área acessível somente para editores." "Python and Django" "django"
            db = container "Banco de Dados" "Armazena notícias e informações sobre usuários." "Postgresql" "db"
            storage = container "Armazenamento de imagens" "Armazena imagens que serão utilizadas nas notícias e no conteúdo do portal." "Bucket S3" "storage, aws"
            mobile = container "Aplicativo móvel" "Aplicativo que permite o acesso ao conteúdo e às notícias do portal." "Android/iOS" "mobile"
            queue = container "Fila de processamento em segundo plano" "Recebe eventos de criação de imagem para serem consumidos pelo processador." "RabbitMQ" "queue"
            worker = container "Processador de Imagens" "Processa imagens otimizando-as e gerando thumbnails." "Python" "worker"
        }

        reader -> portal "Consome notícias e conteúdo em"
        reader -> mobile "Consome notícias e conteúdo em"
        writer -> portal "Escreve conteúdo em"
        mobile -> portal "Consome notícias e conteúdo em" "HTTPS/JSON"
        portal -> db "Lê de e escreve em" "Postgresql Protocol"
        portal -> storage "Lê de e escreve em" "HTTPS/JSON"
        portal -> queue "Envia evento de adição de nova imagem para" "AMQP"
        worker -> queue "Consome eventos de" "AMQP"
        worker -> storage "Escreve imagens em" "HTTPS/JSON"
        portal -> storage "Consome conteúdo estático de" "HTTPS/JSON"
    }

    views {

        systemcontext cms "SystemContext" {
            include *
            autoLayout
        }

        container cms "Containers" {
            include *
            autoLayout lr
        }

        theme default
        themes https://raw.githubusercontent.com/cassiobotaro/modeloC4/main/cms/theme.json
    }
}
