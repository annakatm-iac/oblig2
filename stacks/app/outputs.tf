output "vm_public_ips" {
  description = "Offentlig IP per VM-tjeneste. Åpne http://<ip> for å se boot-id-en."
  value       = { for navn, p in data.azurerm_public_ip.existing : navn => p.ip_address }
}

output "webapp_hostnames" {
  description = "Adresse per web app-tjeneste."
  value       = { for navn, w in data.azurerm_linux_web_app.existing : navn => w.default_hostname }
}
