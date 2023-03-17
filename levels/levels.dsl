workspace "Levels" {
    model {
        client = person "Cliente bancário pessoal" "Um cliente do banco, com contas pessoais." "Cliente"
        ib = softwaresystem "Sistema de Internet Banking" "Permite que o cliente visualize informações sobre suas contas bancárias e faça pagamentos." {
            client -> this "Vê os saldos das contas e faz pagamentos usando"
            spa = container "Aplicação de Página Única (SPA)" "Fornece todas as funcionalidades de internet banking aos clientes por meio do navegador da web." "Javascript e Angular"  "Navegador Web" {
                client -> this "Vê os saldos das contas e faz pagamentos usando"
            }
            mobile = container "Aplicativo Móvel" "Fornece um subconjunto limitado da funcionalidade de internet banking aos clientes por meio de seus dispositivos móveis." "Xamarin"  "Aplicativo Móvel" {
                client -> this "Vê os saldos das contas e faz pagamentos usando"
            }
            web = container "Aplicativo Web" "Entrega o conteúdo estático e a aplicação de página única do internet banking." "Java e Spring MVC" {
                client -> this "Visita bigbank.com/ib usando"
                this -> spa "Entrega ao navegador da web do cliente"
            }
            api = container "Aplicativo API" "Fornece funcionalidade de internet banking via API JSON / HTTPS." "Java e Spring MVC" {
                spa -> this "Faz chamadas de API para" "JSON/HTTPS"
                mobile -> this "Faz chamadas de API para" "JSON/HTTPS"

                signin = component "Controlador de Login" "Permite que os usuários façam login no sistema de Internet Banking." "Spring MVC Rest Controller" {
                    spa -> this "Faz chamadas de API para" "JSON/HTTPS"
                    mobile -> this "Faz chamadas de API para" "JSON/HTTPS"
                }
                reset = component "Controlador de Redefinição de Senha" "Permite ao usuário redefinir suas senhas com uma URL de uso único." "Spring MVC Rest Controller" {
                    spa -> this "Faz chamadas de API para" "JSON/HTTPS"
                    mobile -> this "Faz chamadas de API para" "JSON/HTTPS"
                }
                summary = component "Controlador de Resumo de Conta" "Oferece aos clientes um resumo de suas contas bancárias." "Spring MVC Rest Controller" {
                    spa -> this "Faz chamadas de API para" "JSON/HTTPS"
                    mobile -> this "Faz chamadas de API para" "JSON/HTTPS"
                }
                security = component "Componente de Segurança" "Fornece funcionalidades relacionadas a login, alteração de senha etc." "Spring Bean" {
                    signin -> this "Usa"
                    reset -> this "Usa"
                }
                compemail = component "Componente de E-mail" "Envia e-mail para os usuários." "Spring Bean" {
                    reset -> this "Usa"
                }
                facade = component "Facade do Sistema Bancário Mainframe" "Uma fachada para o sistema bancário de mainframe." "Spring Bean" {
                    summary -> this "Usa"
                }
            }
            db = container "Banco de Dados" "Armazena informações de registro do usuário, credenciais autenticadas com hash, registros de acesso etc." "Oracle Database Schema" "Banco de Dados" {
                api -> this "Lê e escreve em"
                security -> this "Lê e escreve em"
            }
        }
        email = softwaresystem "Sistema de E-mail" "O sistema de email interno Microsoft Exchange."  "Sistema Existente" {
            this -> client "Envia e-mail para"
            ib -> this "Envia e-mail usando"
            compemail -> this "Envia e-mail usando" "SMTP"
        }
        mainframe = softwaresystem "Sistema Bancário Mainframe" "Armazena todas as informações bancárias básicas sobre clientes, contas, transações etc." "Sistema Existente" {
            ib -> this "Obtém informações da conta e faz pagamentos usando"
            facade -> this "Faz chamadas de API para" "XML/HTTPS"
        }
    }


    views {

        systemcontext ib "SystemContext" {
            include *
            autoLayout
        }

        container ib "Containers" "Teste"{
            include *
            autoLayout
        }

        component api "Components" {
            include *
            autoLayout
        }

        theme default

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Cliente" {
                background #08427b
            }
            element "Sistema Existente" {
                background #999999
                color #ffffff
            }
            element "Navegador Web" {
                shape WebBrowser
            }
            element "Aplicativo Móvel" {
                shape MobileDeviceLandscape
            }
            element "Banco de Dados" {
                shape Cylinder
            }
        }
    }
}
