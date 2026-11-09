# Midlertidig: fjernes etter vellykket import i baade dev og prod.
# Abonnements-ID-en hentes fra innloggingen, ikke fra Git.
data "azurerm_client_config" "current" {}

locals {
  resource_group_id = join("/", [
    "", "subscriptions", data.azurerm_client_config.current.subscription_id,
    "resourceGroups", local.resource_group_name
  ])
}

import {
  to = azurerm_resource_group.this
  id = local.resource_group_id
}

import {
  to = module.vnet.azurerm_virtual_network.this
  id = "${local.resource_group_id}/providers/Microsoft.Network/virtualNetworks/vnet-${var.kortnavn}-${var.miljo}"
}
