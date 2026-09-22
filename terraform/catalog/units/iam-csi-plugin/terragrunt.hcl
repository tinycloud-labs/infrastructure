#
# Provisions user, role, and token for the CSI Driver plugin
#
include "proxmox" {
  path = "${get_repo_root()}/terraform/catalog/units/proxmox-provider.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/proxmox/iam/csi-plugin"
}
