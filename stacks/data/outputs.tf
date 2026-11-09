output "storage_account_names" {
  description = "Storage account per tjeneste."
  value       = { for navn, s in data.azurerm_storage_account.existing : navn => s.name }
}

output "key_vault_names" {
  description = "Key Vault per tjeneste."
  value       = { for navn, k in data.azurerm_key_vault.existing : navn => k.name }
}
