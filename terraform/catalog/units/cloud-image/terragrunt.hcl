#
# Provisions a barebones VM group.
#
include "proxmox" {
  path = "${get_repo_root()}/terraform/catalog/units/proxmox-provider.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  node_name       = values.proxmox_node_name
  cloud_image_url = values.cloud_image_url
  datastore_id    = values.datastore_id
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/proxmox/cloud-image"
}
