# Effortless talos HA cluster for your homelab!

## How-to
* Make your PVE credentials be accessible from your enviroment:
```bash
export PM_USER="root@pam"
export PM_PASS="mypass"
```
* Modify .tfvars file according to your needs
* Let the terraform do the rest
```bash
terraform init
terraform apply
```

Note that this template only supports automatic node IP assignment via DHCP for now. Always remember to prevent the expiration of these and exclude your VIP from the
DHCP address pool.
