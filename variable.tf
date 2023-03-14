variable cluster_address {
  type = string
  default = "https://192.168.1.230:8006/api2/json"
}

# potrzebujemy tablice z informacjami dla terraforma o fqdn / IP / RAM
variable ansible_vm {
  type = list
  description = "Lista FQDN wraz z odpowiadajacymi im adresami IP"
  default = [
    {
       fqdn = "web01.local"
       ip = "192.168.1.101"
       ram = "1024"
    },
    {
      fqdn = "web02.local"
      ip   = "192.168.1.102"
      ram  = "1024"
    },
    {
      fqdn = "web03.local"
      ip   = "192.168.1.103"
      ram  = "1024"
    },
    {
      fqdn = "mysql.local"
      ip   = "192.168.1.104"
      ram  = "2048"
    },
    {
      fqdn = "psql.local"
      ip   = "192.168.1.105"
      ram  = "2048"
    }
  ]
}