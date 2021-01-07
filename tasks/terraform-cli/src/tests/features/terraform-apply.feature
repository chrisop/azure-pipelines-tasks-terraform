Feature: terraform apply

    terraform apply [options] [dir]

    Scenario: apply without service connection
        Given terraform exists
        And terraform command is "apply"
        And running command "terraform apply -auto-approve" returns successful result
        When the terraform cli task is run
        Then the terraform cli task executed command "terraform apply -auto-approve"
        And the terraform cli task is successful
        And pipeline variable "TERRAFORM_LAST_EXITCODE" is set to "0"

    Scenario: apply with azurerm
        Given terraform exists
        And terraform command is "apply"
        And azurerm service connection "dev" exists as
            | scheme         | ServicePrincipal       |
            | subscriptionId | sub1                   |
            | tenantId       | ten1                   |
            | clientId       | servicePrincipal1      |
            | clientSecret   | servicePrincipalKey123 |
        And running command "terraform apply -auto-approve" returns successful result
        When the terraform cli task is run
        Then the terraform cli task executed command "terraform apply -auto-approve" with the following environment variables
            | ARM_SUBSCRIPTION_ID | sub1                   |
            | ARM_TENANT_ID       | ten1                   |
            | ARM_CLIENT_ID       | servicePrincipal1      |
            | ARM_CLIENT_SECRET   | servicePrincipalKey123 |
        And the terraform cli task is successful
        And pipeline variable "TERRAFORM_LAST_EXITCODE" is set to "0"

    Scenario: apply with azurerm and command options
        Given terraform exists
        And terraform command is "apply" with options "-input=true -lock=false -no-color"
        And azurerm service connection "dev" exists as
            | scheme         | ServicePrincipal       |
            | subscriptionId | sub1                   |
            | tenantId       | ten1                   |
            | clientId       | servicePrincipal1      |
            | clientSecret   | servicePrincipalKey123 |
        And running command "terraform apply -auto-approve -input=true -lock=false -no-color" returns successful result
        When the terraform cli task is run        
        Then the terraform cli task executed command "terraform apply -auto-approve -input=true -lock=false -no-color" with the following environment variables
            | ARM_SUBSCRIPTION_ID | sub1                   |
            | ARM_TENANT_ID       | ten1                   |
            | ARM_CLIENT_ID       | servicePrincipal1      |
            | ARM_CLIENT_SECRET   | servicePrincipalKey123 |
        And the terraform cli task is successful
        And pipeline variable "TERRAFORM_LAST_EXITCODE" is set to "0"

    Scenario: apply with secure var file
        Given terraform exists        
        And terraform command is "apply"
        And azurerm service connection "dev" exists as
            | scheme         | ServicePrincipal       |
            | subscriptionId | sub1                   |
            | tenantId       | ten1                   |
            | clientId       | servicePrincipal1      |
            | clientSecret   | servicePrincipalKey123 |
        And secure file specified with id "6b4ef608-ca4c-4185-92fb-0554b8a2ec72" and name "./src/tests/default.vars"
        And running command "terraform apply -var-file=./src/tests/default.vars -auto-approve" returns successful result
        When the terraform cli task is run
        Then the terraform cli task executed command "terraform apply -var-file=./src/tests/default.vars -auto-approve" with the following environment variables
            | ARM_SUBSCRIPTION_ID | sub1                   |
            | ARM_TENANT_ID       | ten1                   |
            | ARM_CLIENT_ID       | servicePrincipal1      |
            | ARM_CLIENT_SECRET   | servicePrincipalKey123 |
        And the terraform cli task is successful
        And pipeline variable "TERRAFORM_LAST_EXITCODE" is set to "0"

    Scenario: apply with secure env file
        Given terraform exists        
        And terraform command is "apply"
        And azurerm service connection "dev" exists as
            | scheme         | ServicePrincipal       |
            | subscriptionId | sub1                   |
            | tenantId       | ten1                   |
            | clientId       | servicePrincipal1      |
            | clientSecret   | servicePrincipalKey123 |
        And secure file specified with id "6b4ef608-ca4c-4185-92fb-0554b8a2ec72" and name "./src/tests/default.env"
        And running command "terraform apply -auto-approve" returns successful result
        When the terraform cli task is run
        Then the terraform cli task executed command "terraform apply -auto-approve" with the following environment variables
            | ARM_SUBSCRIPTION_ID | sub1                   |
            | ARM_TENANT_ID       | ten1                   |
            | ARM_CLIENT_ID       | servicePrincipal1      |
            | ARM_CLIENT_SECRET   | servicePrincipalKey123 |
            | TF_VAR_app-short-name | tffoo  |
            | TF_VAR_region         | eastus |
            | TF_VAR_env-short-name | dev    |
        And the terraform cli task is successful
        And pipeline variable "TERRAFORM_LAST_EXITCODE" is set to "0"

    Scenario: apply with invalid auth scheme
        Given terraform exists
        And terraform command is "apply"
        And azurerm service connection "dev" exists as
            | scheme         | foo       |
            | subscriptionId | sub1                   |
            | tenantId       | ten1                   |
            | clientId       | servicePrincipal1      |
            | clientSecret   | servicePrincipalKey123 |
        And running command "terraform apply" returns successful result
        When the terraform cli task is run
        Then the terraform cli task fails with message "Terraform only supports service principal authorization for azure"