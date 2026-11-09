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

data "azurerm_public_ip" "existing" {
  for_each = { for navn, runtime in var.tjenester : navn => runtime if runtime == "vm" }

  name                = "pip-${each.key}"
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_linux_web_app" "existing" {
  for_each = { for navn, runtime in var.tjenester : navn => runtime if runtime == "webapp" }

  name                = "app-${var.kortnavn}-${each.key}-${var.miljo}"
  resource_group_name = data.azurerm_resource_group.existing.name
}

removed {
  from = module.vm

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.webapp

  lifecycle {
    destroy = false
  }
}
