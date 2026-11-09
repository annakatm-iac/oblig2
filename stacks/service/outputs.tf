output "subnet_id" {
  description = "Tjenestens subnett."
  value       = module.subnet.subnet_id
}

output "storage_account_name" {
  description = "Tjenestens storage account."
  value       = module.storage.name
}

output "key_vault_name" {
  description = "Tjenestens Key Vault."
  value       = module.keyvault.name
}

output "vm_public_ip" {
  description = "Offentlig IP for en VM-tjeneste, ellers null."
  value       = try(module.vm[var.service].public_ip, null)
}

output "webapp_hostname" {
  description = "Vertsnavn for en webapp-tjeneste, ellers null."
  value       = try(module.webapp[var.service].hostname, null)
}
