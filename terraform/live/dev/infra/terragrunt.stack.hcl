#
# Terragrunt stack for deploying - dev environment with:
#   - Proxmox VMs + K3s Ansible playbook as a post-hook trigger
#
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "cluster" {
  source = "${get_repo_root()}/terraform/catalog/units/cluster"
  path   = "cluster"

  values = {
    proxmox_node_name = "pve1"
    disk_name         = "sdd"
    cloud_image_info  = ["sdc", "debian-12-generic-amd64.qcow2.img"]
    description       = "Managed by Terragrunt."
    env               = "dev" # for pulling the correct inventory file
    cluster = [
      {
        # Control plane
        name  = "dev-ctrl"
        size  = "medium"
        count = 1
        macs  = ["32:fe:ce:8c:3b:a8"]
      },
      {
        # Node group - small
        name  = "dev-small-w"
        size  = "small"
        count = 2
        macs = [
          "32:63:71:b2:58:c8",
          "f6:24:d1:06:56:46",
        ]
      },
    ]
  }
}
