# Effortless talos HA cluster for your homelab!

## How-to
* Push the Talos installer iso to your server. Note that you need the image with qemu guest agent 
support.
* Make your PVE credentials accessible from your enviroment:
```bash
export PM_USER="root@pam"
export PM_PASS="mypass"
```
* Modify .tfvars file according to your needs (see the Configuration values section below)
* Let the terraform do the rest
```bash
terraform init
terraform apply
```
* Grab your Talos and Kubernetes configs
```bash
terraform output -raw talosconfig > talosconfig
terraform output -raw kubeconfig > kubeconfig
```

## Configuration values

* Proxmox:
  * `pm_api_url` - Proxmox API URL (replace `example.local` with your hostname accordingly)
  * `pm_target_node` - Proxmox node name
  * `pm_ctl_nodes_map` - Control plane nodes VM id to VM name mappings
  * `pm_worker_nodes_map` - Worker nodes VM id to VM name mappings
  * `pm_ctl_vm_cpu_num` - Control plane nodes CPU cores count (default: `4`)
  * `pm_ctl_vm_ram_size` - Control plane nodes RAM size (default: `4096`)
  * `pm_worker_vm_cpu_num` - Worker nodes CPU cores count (default: `2`)
  * `pm_worker_vm_ram_size` - Worker nodes RAM size (default: `2048`)
  * `pm_storage_pool` - Proxmox storage pool name
  * `pm_vm_disk_size` - VM disk size (applies to all VMs, default: `40G`)
  * `pm_iso_location` - Path to the Talos installer iso on Proxmox server (default: `local:iso/metal-amd64.iso`)
  * `pm_network_bridge` - Name of the network bridge interface for the VM (default: `vmbr0`)

* Talos
  * `cluster_name` - Name for your cluster (default: `ProxCube`)
  * `cluster_vip_endpoint` - Control plane Virtual IP address (default: `192.168.1.2`)

## Notes
* This template only supports automatic node IP assignment via DHCP for now. Always remember to 
prevent the expiration of these addresses and exclude your VIP from the DHCP address pool.
