#Konfiguracja providera dla Proxmoxa
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.cluster_address
  pm_debug = true
  pm_user = var.pm_user_x
  pm_password = var.pm_pass_x
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}