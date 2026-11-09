output "resource_group_name" {
  description = "Ressursgruppa alle tjenestene bruker."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Felles Azure-region."
  value       = azurerm_resource_group.this.location
}

output "vnet_name" {
  description = "Navnet paa det delte VNet-et."
  value       = module.vnet.name
}

output "vnet_id" {
  description = "ID-en til det delte VNet-et."
  value       = module.vnet.id
}
