resource "proxmox_vm_qemu" "ctl-plane" {
  for_each    = var.pm_ctl_nodes_map
  agent       = 1
  name        = each.value
  vmid        = each.key
  scsihw      = "virtio-scsi-single"
  target_node = var.pm_target_node
  vm_state    = "started"
  cpu_type    = "x86-64-v2"
  cores       = 4
  memory      = 4096
  skip_ipv6   = true

  network {
    id = 0
    model = "e1000"
    bridge = var.pm_network_bridge
  }

  disks {
    scsi {
      scsi0 {
        disk {
            storage = var.pm_storage_pool
            size = var.pm_vm_disk_size
        }
      }
      scsi1 {
        cdrom {
            iso = var.pm_iso_location
        }
      }
    }
  }
}

resource "proxmox_vm_qemu" "workers" {
  for_each    = var.pm_worker_nodes_map
  agent       = 1
  name        = each.value
  vmid        = each.key
  scsihw      = "virtio-scsi-single"
  target_node = var.pm_target_node
  vm_state    = "started"
  cpu_type    = "x86-64-v2"
  cores       = 2
  memory      = 2048
  skip_ipv6   = true

  network {
    id = 0
    model = "e1000"
    bridge = var.pm_network_bridge
  }

  disks {
    scsi {
      scsi0 {
        disk {
            storage = var.pm_storage_pool
            size = var.pm_vm_disk_size
        }
      }
      scsi1 {
        cdrom {
            iso = var.pm_iso_location
        }
      }
    }
  }
}
