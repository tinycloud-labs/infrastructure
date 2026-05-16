#
# Testing new debain cloud images
#
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "cluster" {
  source = "${get_repo_root()}/terraform/catalog/units/vms"
  path   = "vms"

  values = {
    proxmox_node_name = "pve1"
    disk_name         = "sdc"
    cloud_image_info  = ["sdc", "debian-13-generic-amd64.qcow2.img"]
    description       = "Managed by Terragrunt."
    cluster = [
      {
        # singe vm
        name  = "sandbox"
        size  = "small"
        count = 1
        macs  = ["6e:c4:c8:60:2c:7b"]
      },
    ]
  }
}
