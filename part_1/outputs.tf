# Output the Event Hubs Namespace connection string
output "eventhub_namespace_connection_string" {
  value     = azurerm_eventhub_namespace.namespace.default_primary_connection_string
  sensitive = true
}
