workspace "Show" {

    model {
        userManagementSystem = softwaresystem "User Management System" "Provides functionality to create users and update profile info."{
            a = container "Container A" "Provides functionality to create users." "Python"
            b = container "Container B" "Provides functionality to register users into respective groups." "Java"
            c = container "Container C" "Provides functionality to update user data." "NodeJS"
            d = container "Container D" "Provides functionality to notify friends about user updates." "Go"
        }

        a -> b "Sends user creation messages to" "via RabbitMQ queue create_user"
        c -> d "Sends user profile upates to" "via RabbitMQ queue update_user"
    }

    views {

        container userManagementSystem "Containers" {
            include *
            autoLayout lr
        }

        theme default
    }
}
