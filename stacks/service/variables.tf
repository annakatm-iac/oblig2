variable "kortnavn" {
  description = "Kortnavnet ditt. Settes i config/felles.tfvars."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.kortnavn))
    error_message = "kortnavn må være 2–10 små bokstaver eller tall. Sett det i config/felles.tfvars."
  }
}

variable "location" {
  description = "Azure-regionen. Settes i config/felles.tfvars."
  type        = string
}

variable "miljo" {
  description = "Miljøet. Settes av scripts/kjor.sh (TF_VAR_miljo), ikke i en .tfvars-fil."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.miljo)
    error_message = "miljo må være dev eller prod."
  }
}

variable "service" {
  description = "Tjenestenavnet. Hver instans har egen config-fil og state."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{1,7}$", var.service))
    error_message = "service maa vaere 2-8 smaa bokstaver eller tall og starte med en bokstav."
  }
}

variable "runtime" {
  description = "Kjoeremiljoe: vm eller webapp."
  type        = string

  validation {
    condition     = contains(["vm", "webapp"], var.runtime)
    error_message = "runtime maa vaere vm eller webapp."
  }
}

variable "prefix" {
  description = "Tjenestens subnett i CIDR-format."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.prefix))
    error_message = "prefix maa vaere et gyldig IPv4-adresseomraade i CIDR-format."
  }
}

variable "allow_http_from" {
  description = "Kilde for den eksisterende HTTP-regelen paa port 80."
  type        = string
  default     = "Internet"
}

variable "vm_size" {
  description = "VM-stoerrelse for runtime vm."
  type        = string
  default     = "Standard_B2als_v2"
}

variable "ssh_public_key" {
  description = "Offentlig SSH-noekkel. Bare paakrevd for runtime vm."
  type        = string
  default     = null

  validation {
    condition     = var.runtime != "vm" || can(regex("^ssh-", var.ssh_public_key))
    error_message = "En VM-tjeneste maa ha en offentlig SSH-noekkel."
  }
}

variable "webapp_sku" {
  description = "App Service-SKU for runtime webapp. Settes i tjenestens config."
  type        = string
  default     = "B1"
}
