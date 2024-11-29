# Proxmox
variable "pm_api_url" {
  type    = string
  default = "https://example.local:8006/api2/json"
  description = "IP address or hostname of the Proxmox server along with the path to the api endpoint"
}

variable "pm_target_node" {
  type    = string
  default = "Homelab"
  description = "Name of the Proxmox node to deploy the cluster on"
}

variable "pm_ctl_nodes_map" {
  type    = map(string)
  default = {
    110 = "Talos-control-1"
    111 = "Talos-control-2"
    112 = "Talos-control-3"
  }
  description = "VM ID -> VM Name map of control nodes"
}

variable "pm_worker_nodes_map" {
  type    = map(string)
  default = {
    115 = "Talos-worker-1"
    116 = "Talos-worker-2"
    117 = "Talos-worker-3"
  }
  description = "VM ID -> VM Name map of worker nodes"
}

variable pm_ctl_vm_cpu_num {
  type = number
  default = 4
  description = "Number of vcpus dedicated to a controlplane VM"
}

variable pm_ctl_vm_ram_size {
  type = number
  default = 4096
  description = "Amount of ram dedicated to a controlplane VM"
}

variable pm_worker_vm_cpu_num {
  type = number
  default = 2
  description = "Number of vcpus dedicated to a worker VM"
}

variable pm_worker_vm_ram_size {
  type = number
  default = 2048
  description = "Amount of ram dedicated to a worker VM"
}

variable "pm_storage_pool" {
  type    = string
  default = "local"
  description = "Name of the storage pool for VMs"
}

variable "pm_vm_disk_size" {
  type    = string
  default = "40G"
  description = "Disk size of the VM"
}

variable "pm_iso_location" {
  type    = string
  default = "local:iso/metal-amd64.iso"
  description = "Path to the Talos iso"
}

variable "pm_network_bridge" {
  type    = string
  default = "vmbr0"
  description = "Name of the network bridge interface for the VM"
}
# Talos
variable "cluster_name" {
  type    = string
  default = "ProxCube"
  description = "Name of the talos cluster"
}

variable "cluster_vip_endpoint" {
  type    = string
  default = "192.168.1.2"
  description = "Virtual ip address for redundant controlpane nodes"
}
