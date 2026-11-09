variable "service" {
  description = "Tjenestenavnet. Brukes i navnet på subnettet og NSG-en."
  type        = string
}

variable "resource_group_name" {
  description = "Ressursgruppa VNet-et står i."
  type        = string
}

variable "location" {
  description = "Azure-regionen."
  type        = string
}

variable "vnet_name" {
  description = "VNet-et subnettet skal ligge i."
  type        = string
}

variable "prefix" {
  description = "Adresseområdet til subnettet, f.eks. 10.10.0.0/24. Må ligge innenfor adresserommet til VNet-et."
  type        = string
}

variable "delegate_web" {
  description = "true hvis subnettet skal delegeres til App Service (for en web app med VNet-integrasjon)."
  type        = bool
  default     = false
}

variable "allow_http_from" {
  description = "Hvem som får nå tjenesten på port 80, som CIDR eller service tag (f.eks. Internet)."
  type        = string
}

variable "tags" {
  description = "Tagger på NSG-en."
  type        = map(string)
  default     = {}
}

variable "extra_tcp_rules" {
  description = "Ekstra innkommende TCP-regler. Tomt kart gir ingen ekstra regler."
  type = map(object({
    port     = number
    source   = string
    priority = number
  }))
  default = {}

  validation {
    condition     = alltrue([for rule in values(var.extra_tcp_rules) : rule.port >= 1 && rule.port <= 65535 && rule.port == floor(rule.port)])
    error_message = "TCP-porten maa vaere et heltall mellom 1 og 65535."
  }

  validation {
    condition     = alltrue([for rule in values(var.extra_tcp_rules) : can(cidrnetmask(rule.source))])
    error_message = "Kilden maa vaere et IPv4-adresseomraade i CIDR-format."
  }

  validation {
    condition     = alltrue([for rule in values(var.extra_tcp_rules) : rule.priority >= 101 && rule.priority <= 4096 && rule.priority == floor(rule.priority)])
    error_message = "Prioriteten maa vaere et heltall fra 101 til 4096. HTTP bruker 100."
  }

  validation {
    condition     = length(distinct([for rule in values(var.extra_tcp_rules) : rule.priority])) == length(var.extra_tcp_rules)
    error_message = "Hver ekstra regel maa ha en unik prioritet."
  }
}
