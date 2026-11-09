# Midlertidige lesekilder mens ressursene flyttes mellom state-filer.
# Ingen ressurser opprettes, oppdateres eller slettes av denne stacken.
data "azurerm_resource_group" "existing" {
  name = "rg-${var.kortnavn}-oblig2-${var.miljo}"

  lifecycle {
    postcondition {
      condition     = self.location == var.location
      error_message = "Ressursgruppa maa bli i samme region under migreringen."
    }
  }
}

data "azurerm_storage_account" "existing" {
  for_each = var.tjenester

  name                = "st${var.kortnavn}${each.key}${var.miljo}"
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_key_vault" "existing" {
  for_each = var.tjenester

  name                = "kv-${var.kortnavn}-${each.key}-${var.miljo}"
  resource_group_name = data.azurerm_resource_group.existing.name
}

removed {
  from = module.storage

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.keyvault

  lifecycle {
    destroy = false
  }
}
