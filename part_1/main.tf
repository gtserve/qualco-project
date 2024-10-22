
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-kafka-westeu"
  location = "West Europe"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-kafka-westeu"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-kafka-westeu"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create an Azure Event Hubs Namespace
resource "azurerm_eventhub_namespace" "namespace" {
  name                = "evhns-kafka-westeu"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1 # Capacity / Throughput Units

  # Security: Enable encryption and identity-based access
  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_eventhub" "kafka_topics" {
  count               = var.number_of_topics
  name                = "evh-kafka-topic-${count.index + 1}-westeu"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = var.partitions_per_topic
  message_retention   = 1 # Number of days to retain messages.
}

# Configure Private Endpoint for Event Hub
resource "azurerm_private_endpoint" "pep" {
  name                = "pep-kafka"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "event-hub-connection"
    private_connection_resource_id = azurerm_eventhub_namespace.namespace.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}

# Add Network Security Group (NSG) for Access Control
resource "azurerm_network_security_group" "nsg" {
  name                = "kafka-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowKafkaClients"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["9093"]      # Kafka's port
    source_address_prefix      = "10.0.1.0/24" # Limit access to a private range
    destination_address_prefix = "*"
  }
}

# Configure Kafka Client Access via Managed Identity
resource "azurerm_role_assignment" "kafka_role" {
  principal_id         = azurerm_eventhub_namespace.namespace.identity[0].principal_id
  role_definition_name = "Azure Event Hubs Data Owner"
  scope                = azurerm_eventhub_namespace.namespace.id
}
