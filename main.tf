terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.6.1"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_tls_insecure = true # By default Proxmox Virtual Environment uses self-signed certificates.
}
