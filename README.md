# qualco-project

# Part 1:

> Deploying Managed Kafka Service: \
> Using Terraform, your task is to deploy a 
> managed Kafka service on Azure. The Kafka service should be deployed securely 
> and should meet all functional and non-functional requirements. You need to 
> configure the service with X number of topics/partitions. Ensure that the 
> deployment follows best practices for security, scalability, and availability.

## Summary

Using Terraform, a managed Kafka service is deployed on Azure as an Azure Event
Hub Namespace (the equivalent of a Kafka cluster) along with any other necessary
resources. Azure Event Hubs provide an Apache Kafka endpoint on an event hub, 
which enables users to connect to the event hub using the Kafka protocol.

## Prerequisites

To run the following project you will need to have installed the [azure-cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
tool and [terraform](https://developer.hashicorp.com/terraform/install). \
You will also need a Standard Subscription plan on Azure. (see [Event Hubs pricing](https://azure.microsoft.com/en-us/pricing/details/event-hubs/))

## Setup

1. Clone this repo locally and navigate to directory `part_1`:
   
   ```bash
   $ cd ./qualco-project/part_1
   ```

2. The directory should have the following files:

   ```bash
   ├── main.tf
   ├── outputs.tf
   └── variables.tf
   ```

### Authenticate with Azure:

3. Login on Azure with `azure-cli`:
   
   ```bash
   $ az login
   ```
   Your browser will open and prompt you to enter your Azure login credentials.

   After successful authentication, your terminal will display your subscription information:

   ```bash
    [
        {
            "cloudName": "AzureCloud",
            "homeTenantId": "0envbwi39-home-Tenant-Id",
            "id": "35akss-subscription-id",
            "isDefault": true,
            "managedByTenants": [],
            "name": "Subscription-Name",
            "state": "Enabled",
            "tenantId": "0envbwi39-TenantId",
            "user": {
            "name": "your-username@domain.com",
            "type": "user"
            }
        }
    ]
    ```

    Find the id column for the subscription account you want to use.

4. Once you have chosen the account subscription ID, set the account with the Azure CLI.

    ```bash
    $ az account set --subscription "35akss-subscription-id"
    ```

### Create a Service Principal

5. Update the `<SUBSCRIPTION_ID>` with the subscription ID you specified in the previous step.
   
   ```bash
   $ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
   ```
   ```
    Creating 'Contributor' role assignment under scope '/subscriptions/35akss-subscription-id'
    The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
    {
    "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
    "displayName": "azure-cli-2022-xxxx",
    "password": "xxxxxx~xxxxxx~xxxxx",
    "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
    }
   ```

### Set your Environment Variables

6. In your terminal, set the following environment variables. Be sure to update the variable values
with the values Azure returned in the previous command.

    ```bash
    export ARM_CLIENT_ID="<APPID_VALUE>"
    export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
    export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
    export ARM_TENANT_ID="<TENANT_VALUE>"
    ``` 

## Run

1. Initialize the Terraform project:

    ```bash
    $ terraform init
    ```

2. Apply Terraform configuration:

    ```bash
    $ terraform apply
    ```

    Type `yes` at the confirmation prompt to proceed and wait for the configuration to be applied.

    Once it's done, you can navigate to your Azure Portal and inspect the resources.
    


<!-- # Part 2:

> Deploying Spring Boot Applications with MSSQL and Kafka: \
> Using Terraform, your task is to deploy two Spring Boot applications on Azure Kubernetes Service 
> (AKS). These applications should connect to an MSSQL database and a Kafka cluster. You should use 
> a Gateway API for routing. Your deployment should ensure high availability, performance, and 
> scalability. Provide detailed documentation on the setup, configurations, and any necessary 
> integration steps. -->


# References
* [Terraform | Get Started - Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)
* [Terraform | Azure Provider (Latest) Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Microsoft Azure | Quickstart: Create an event hub using Azure portal](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-create)
* [Microsoft Azure | What is Azure Event Hubs for Apache Kafka](https://learn.microsoft.com/en-us/azure/event-hubs/azure-event-hubs-kafka-overview)
