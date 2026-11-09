output "resource_group_name" {
  description = "Ressursgruppa alle stackene bruker."
  value       = data.azurerm_resource_group.existing.name
}

output "location" {
  description = "Regionen alt står i."
  value       = data.azurerm_resource_group.existing.location
}

output "vnet_name" {
  description = "Navnet på VNet-et."
  value       = data.azurerm_virtual_network.existing.name
}

output "subnet_ids" {
  description = "Subnett-ID per tjeneste."
  value       = { for navn, s in data.azurerm_subnet.existing : navn => s.id }
}
