resource "talos_machine_secrets" "machine_secrets" {}

locals {
  control_plane_machine_configs = { for key in keys(proxmox_vm_qemu.ctl-plane) : key => {} }
}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = [for vm in proxmox_vm_qemu.ctl-plane : vm.default_ipv4_address]
  nodes                = [for vm in proxmox_vm_qemu.ctl-plane : vm.default_ipv4_address]
}

data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_vip_endpoint}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

data "talos_machine_configuration" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_vip_endpoint}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  for_each                    = local.control_plane_machine_configs
  depends_on                  = [proxmox_vm_qemu.ctl-plane] # Adjust dependencies as needed
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  node                        = proxmox_vm_qemu.ctl-plane[each.key].default_ipv4_address
  config_patches = [
    templatefile("config/global.yml", {}),
    templatefile("config/controlplane.yml", {
      cluster_vip_endpoint = var.cluster_vip_endpoint
    })
  ]
}

resource "talos_machine_configuration_apply" "worker_config_apply" {
  for_each                    = { for key in keys(proxmox_vm_qemu.workers) : key => {} }
  depends_on                  = [proxmox_vm_qemu.workers, talos_machine_bootstrap.bootstrap]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_worker.machine_configuration
  node                        = proxmox_vm_qemu.workers[each.key].default_ipv4_address
  config_patches = [
    templatefile("config/global.yml", {})
  ]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = proxmox_vm_qemu.ctl-plane[keys(proxmox_vm_qemu.ctl-plane)[0]].default_ipv4_address
}

data "talos_cluster_health" "health" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply, talos_machine_configuration_apply.worker_config_apply]
  client_configuration = data.talos_client_configuration.talosconfig.client_configuration
  control_plane_nodes  = [for vm in proxmox_vm_qemu.ctl-plane : vm.default_ipv4_address]
  worker_nodes         = [for vm in proxmox_vm_qemu.workers : vm.default_ipv4_address]
  endpoints            = data.talos_client_configuration.talosconfig.endpoints
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap, data.talos_cluster_health.health]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = proxmox_vm_qemu.ctl-plane[keys(proxmox_vm_qemu.ctl-plane)[0]].default_ipv4_address
}

output "talosconfig" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}
