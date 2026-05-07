workspace "CMS" {
  model {
    reader = person "Leitor" "Pessoa que consome as notícias do site."
    writer = person "Editor" "Pessoa que escreve conteúdo para o site."

    cms = softwaresystem "CMS" "Sistema de gerenciamento de conteúdo."{
      portal = container "Portal de Notícias" "Site que fornece as notícias e conteúdos via browser ou api. Possui área administrativa para editores." "Python e Django" "browser"{
        adminNoticia = component "AdminNoticia" "Interface administrativa para criação e publicação de notícias." "Django Admin"
        noticiaAPI = component "NoticiaAPI" "Exposição de notícias em formato JSON para consumo externo." "Django REST Framework"
        noticiaWeb = component "NoticiaWeb" "Exibe notícias em uma interface amigável no navegador." "Django Templates"
        notificacaoPublicacao = component "NotificacaoPublicacao" "Envia notificações quando uma notícia é publicada." "Django Signals"
        publicadorFila = component "PublicadorFila" "Envia eventos para a fila de processamento de imagens." "Dramatiq"
        modeloNoticia = component "ModeloNoticia" "Modelo que representa a notícia no banco de dados." "Django ORM"
      }
      db = container "Banco de Dados" "Armazena notícias e informações sobre usuários." "Postgresql" "db"
      storage = container "Armazenamento de imagens" "Armazena imagens que serão utilizadas nas notícias e no conteúdo do portal." "Object Storage Magalu" "storage"
      mobile = container "Aplicativo móvel" "Aplicativo que permite o acesso ao conteúdo e às notícias do portal." "Android/iOS" "mobile"
      queue = container "Fila de processamento em segundo plano" "Recebe eventos de criação de imagem para serem consumidos pelo processador." "RabbitMQ" "queue"
      worker = container "Processador de Imagens" "Processa imagens otimizando-as e gerando thumbnails." "Python" "worker"
    }
    email = softwaresystem "Gmail" "Serviço utilizado para envio de e-mails." "external"

    reader -> portal "Consome notícias e conteúdo em"
    reader -> mobile "Consome notícias e conteúdo em"
    writer -> portal "Escreve conteúdo em"
    cms -> email "Envia e-mails utilizando"
    mobile -> portal "Consome notícias e conteúdo em" "HTTPS/JSON"
    portal -> db "Lê de e escreve em" "SQL/TCP"
    portal -> storage "Lê de e escreve em" "HTTPS"
    portal -> queue "Envia evento de adição de nova imagem para" "AMQP"
    worker -> queue "Consome eventos de" "AMQP"
    worker -> storage "Lê de e escreve em" "HTTPS/JSON"
    portal -> email "Envia e-mails utilizando" "SMTP"
    email -> reader "Envia e-mails de novidades para"
    worker -> db "Atualiza informações em" "SQL/TCP"

    adminNoticia -> modeloNoticia "Cria e atualiza notícias utilizando"
    adminNoticia -> notificacaoPublicacao "Dispara notificação ao publicar notícia"
    adminNoticia -> publicadorFila "Envia evento para processar imagens em"
    noticiaAPI -> modeloNoticia "Consulta notícias publicadas utilizando"
    noticiaWeb -> modeloNoticia "Exibe notícias armazenadas utilizando"
    notificacaoPublicacao -> email "Envia e-mails de nova publicação para"
    publicadorFila -> queue "Publica mensagens na fila para"
    worker -> modeloNoticia "Atualiza imagens processadas em"
    modeloNoticia -> db "Lê de e escreve em"

prod = deploymentEnvironment "Production" {

    deploymentNode "Magalu Cloud" "Ambiente de produção na Magalu Cloud" "Magalu Cloud Infrastructure" {

        deploymentNode "Região se-1" "Região de hospedagem do CMS" "Magalu Cloud Region" {

            // Load Balancer com Traefik
            traefikLB = infrastructureNode "Load Balancer" {
                technology "Traefik 3.x"
                description "Gerencia e distribui o tráfego para o Portal de Notícias."
            }

            // Quatro instâncias do Portal de Notícias dentro de Gunicorn
            deploymentNode "VM - Portal" "Instâncias do Portal de Notícias" "Ubuntu 16.04 LTS" "" 4 {
                deploymentNode "Gunicorn" "Servidor WSGI que executa a aplicação Django" "Gunicorn 20.x" {
                    portalInstance = containerInstance portal {
                      traefikLB -> this "envia requisições para" "HTTPS"
                    }
                }
            }

            // Worker para processamento de imagens
            deploymentNode "VM - Worker" "Instância que processa imagens" "Ubuntu 22.04 LTS" {
                workerInstance = containerInstance worker
            }

            // Banco de Dados Principal
            deploymentNode "VM - Banco de Dados (Primário)" "Instância principal do banco de dados" "Ubuntu 22.04 LTS" {
                dbPrimaryInstance = containerInstance db
            }

            // Réplica do Banco de Dados
            deploymentNode "VM - Banco de Dados (Réplica)" "Réplica do banco de dados para leitura" "Ubuntu 22.04 LTS" {
                dbReplicaInstance = containerInstance db
            }

            // RabbitMQ para gerenciamento da fila
            deploymentNode "VM - RabbitMQ" "Instância que gerencia a fila de mensagens" "Ubuntu 22.04 LTS" {
                deploymentNode "RabbitMQ" "Servidor RabbitMQ para filas de mensagens" "RabbitMQ 3.x" {
                    queueInstance = containerInstance queue
                }
            }
        }

        // Object Storage da Magalu para armazenar as imagens
        deploymentNode "Object Storage - Magalu" "Armazena as imagens do portal" "Magalu Object Storage" {
            storageInstance = containerInstance storage
        }
    }

    // Aplicativo Móvel Android/iOS
    deploymentNode "Dispositivos Móveis" "Acesso ao Portal via App" "Android/iOS" {
        mobileInstance = containerInstance mobile
    }
}

  }

  views {

    systemcontext cms "SystemContext" {
      include *
      autoLayout lr
    }

    container cms "Containers" {
      include *
    }

    component portal "Components" {
      include *
    }

dynamic portal {
    adminNoticia -> modeloNoticia "Salva a notícia no banco de dados utilizando"
    modeloNoticia -> db "INSERT INTO noticias (...) VALUES (...)"
    db -> modeloNoticia "Confirmação de salvamento"
    modeloNoticia -> adminNoticia "Notícia salva com sucesso"

    adminNoticia -> notificacaoPublicacao "Dispara evento de notificação de nova notícia para"
    notificacaoPublicacao -> email "Envia e-mail de nova publicação para os leitores via"
    email -> reader "Entrega e-mail de nova notícia para"
    email -> notificacaoPublicacao "Confirmação de envio de e-mail"
    notificacaoPublicacao -> adminNoticia "Notificação enviada com sucesso"

}

deployment cms prod {
  include *
}

    theme default
    styles {

# orange
element Person {
  background #8a4600
}
element "Software System" {
  background #b36200
}
element Container {
  background 	#fdba62
}
element Component {
  background #ffe0b3
}

      # tags
      element db {
        shape Cylinder
      }
      element queue {
        shape Pipe
      }
      element mobile {
        shape MobileDevicePortrait
      }
      element storage {
        shape Folder
      }
      element browser {
        shape WebBrowser
      }
      element worker {
        shape Hexagon
      }
      element external {
        background #758990
      }
    }
  }
}
