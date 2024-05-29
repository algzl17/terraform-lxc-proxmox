terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc2"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_lxc" "basic" {
  target_node = "pve01"
  vmid = "200"
  hostname = "go-terra"
  password = var.ci_password
  ssh_public_keys = file(var.ci_ssh_public_key)
  ostemplate = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }
  cores = 1
  memory = 512
  swap = 512

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "10.10.10.10/23"
    gw = "10.10.10.1"
  }
  
  searchdomain = "google.com"
  nameserver = "8.8.4.4"

  onboot = true
  start = true
}