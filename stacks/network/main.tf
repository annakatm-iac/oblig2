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

data "azurerm_virtual_network" "existing" {
  name                = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_name = data.azurerm_resource_group.existing.name

  lifecycle {
    postcondition {
      condition     = toset(self.address_space) == toset(var.address_space)
      error_message = "VNet-adressene maa vaere uendret under migreringen."
    }
  }
}

data "azurerm_subnet" "existing" {
  for_each = var.tjenester

  name                 = "snet-${each.key}"
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name

  lifecycle {
    postcondition {
      condition     = toset(self.address_prefixes) == toset([each.value.prefix])
      error_message = "Subnettadressene maa vaere uendret under migreringen."
    }
  }
}

removed {
  from = azurerm_resource_group.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.vnet

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.subnet

  lifecycle {
    destroy = false
  }
}
