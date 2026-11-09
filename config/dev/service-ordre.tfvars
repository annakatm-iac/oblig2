service = "ordre"
runtime = "vm"
prefix  = "10.10.0.0/24"

vm_size = "Standard_B2als_v2"
# Samme offentlige noekkel som foer migreringen.
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMQ32gu8mGVI86gkUex5JsBeg7WC58bsUOVuxmeHDJW oblig2-ingen-privat-nokkel"

extra_tcp_rules = {
  allow-tcp-8076 = {
    port     = 8076
    source   = "172.16.53.0/24"
    priority = 110
  }
}
