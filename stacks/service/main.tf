# En instans per config/<miljoe>/service-<navn>.tfvars, med egen state.
# Azure-oppslag leser det delte nettverket uten aa lese andre stackers state.
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "shared" {
  name = "rg-${var.kortnavn}-oblig2-${var.miljo}"

  lifecycle {
    postcondition {
      condition     = self.location == var.location
      error_message = "Tjenesten maa bruke samme region som ressursgruppa."
    }
  }
}

data "azurerm_virtual_network" "shared" {
  name                = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_name = data.azurerm_resource_group.shared.name
}

locals {
  vm_services     = var.runtime == "vm" ? toset([var.service]) : toset([])
  webapp_services = var.runtime == "webapp" ? toset([var.service]) : toset([])
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }
}

module "subnet" {
  source              = "../../modules/subnet"
  service             = var.service
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = var.location
  vnet_name           = data.azurerm_virtual_network.shared.name
  prefix              = var.prefix
  delegate_web        = var.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
}

module "storage" {
  source              = "../../modules/storage"
  service             = var.service
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = var.location
  tags                = local.tags
}

module "keyvault" {
  source              = "../../modules/keyvault"
  service             = var.service
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "vm" {
  source              = "../../modules/vm"
  for_each            = local.vm_services
  service             = each.key
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = var.location
  subnet_id           = module.subnet.subnet_id
  size                = var.vm_size
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "webapp" {
  source              = "../../modules/webapp"
  for_each            = local.webapp_services
  service             = each.key
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = var.location
  subnet_id           = module.subnet.subnet_id
  sku                 = var.webapp_sku
  tags                = local.tags
}
