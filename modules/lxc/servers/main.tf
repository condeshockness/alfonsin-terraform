terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
  
}


resource "proxmox_lxc" "lxc" {
  target_node     = var.node
  vmid            = var.lxc_id
  hostname        = var.lxc_name
  description     = var.description
  ostemplate      = var.os_template
  ostype          = var.os_type
  unprivileged    = var.unprivileged
  cores           = var.vcpu
  memory          = var.memory
  swap            = var.memory_swap
  password        = var.user_password

  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgXYoz7pCRQ5LcwHRn0andCTvN+lpfmj2mUOD7C2wqg alfonsin.nuvem@gmail.com
  EOT

  rootfs {
    storage = var.disk_storage
    size    = var.disk_size
  }

  dynamic "mountpoint" {
    for_each = (var.mountpoint != null ? var.mountpoint : [])
    content {
      mp      = mountpoint.value.mp
      size    = mountpoint.value.mp_size
      slot    = mountpoint.value.mp_slot
      key     = mountpoint.value.mp_key
      storage = mountpoint.value.mp_storage
      volume  = mountpoint.value.mp_volume
      backup  = mountpoint.value.mp_backup
    }
  }

  network {
    name   = var.vnic_name
    bridge = var.vnic_bridge
    tag    = var.vlan_tag
    ip     = var.ipv4_address
    gw     = var.ipv4_gateway
    hwaddr = var.mac
    ip6    = var.ipv6_address
    gw6    = var.ipv6_gateway
  }
  searchdomain = var.dns_domain
  nameserver   = var.dns_server

  start   = var.start_on_create
  onboot  = var.start_on_boot
  startup = var.startup_options

  features {
        
        nesting           = var.nesting
  }
}
