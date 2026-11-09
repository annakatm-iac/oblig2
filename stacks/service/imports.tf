# Midlertidig: samme kode brukes for hver tjeneste og begge miljoeer.
# Fjernes etter vellykket import. Ingen abonnements-ID lagres i koden.
locals {
  import_network_prefix = "${data.azurerm_resource_group.shared.id}/providers/Microsoft.Network"
  import_subnet_id      = "${data.azurerm_virtual_network.shared.id}/subnets/snet-${var.service}"
  import_nsg_id         = "${local.import_network_prefix}/networkSecurityGroups/nsg-${var.service}"
}

import {
  to = module.subnet.azurerm_subnet.this
  id = local.import_subnet_id
}

import {
  to = module.subnet.azurerm_network_security_group.this
  id = local.import_nsg_id
}

import {
  to = module.subnet.azurerm_network_security_rule.http
  id = "${local.import_nsg_id}/securityRules/allow-http"
}

# Denne koblingen importeres med subnettets ID, ikke NSG-ens ID.
import {
  to = module.subnet.azurerm_subnet_network_security_group_association.this
  id = local.import_subnet_id
}

import {
  to = module.storage.azurerm_storage_account.this
  id = "${data.azurerm_resource_group.shared.id}/providers/Microsoft.Storage/storageAccounts/st${var.kortnavn}${var.service}${var.miljo}"
}

import {
  to = module.keyvault.azurerm_key_vault.this
  id = "${data.azurerm_resource_group.shared.id}/providers/Microsoft.KeyVault/vaults/kv-${var.kortnavn}-${var.service}-${var.miljo}"
}

import {
  for_each = local.vm_services
  to       = module.vm[each.key].azurerm_public_ip.this
  id       = "${local.import_network_prefix}/publicIPAddresses/pip-${each.key}"
}

import {
  for_each = local.vm_services
  to       = module.vm[each.key].azurerm_network_interface.this
  id       = "${local.import_network_prefix}/networkInterfaces/nic-${each.key}"
}

import {
  for_each = local.vm_services
  to       = module.vm[each.key].azurerm_linux_virtual_machine.this
  id       = "${data.azurerm_resource_group.shared.id}/providers/Microsoft.Compute/virtualMachines/vm-${each.key}"
}

import {
  for_each = local.webapp_services
  to       = module.webapp[each.key].azurerm_service_plan.this
  id       = "${data.azurerm_resource_group.shared.id}/providers/Microsoft.Web/serverFarms/asp-${each.key}"
}

import {
  for_each = local.webapp_services
  to       = module.webapp[each.key].azurerm_linux_web_app.this
  id       = "${data.azurerm_resource_group.shared.id}/providers/Microsoft.Web/sites/app-${var.kortnavn}-${each.key}-${var.miljo}"
}
