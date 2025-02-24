
output "name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "id" {
  value = azurerm_resource_group.rg.id
}