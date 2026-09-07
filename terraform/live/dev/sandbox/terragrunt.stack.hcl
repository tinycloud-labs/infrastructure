#
# A VMs group for testing. Deployed manually. Share the same terragrun-hook and tf-state.
#
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
        # single vm
        name  = "sandbox"
        size  = "small"
        count = 1
        macs  = ["6e:c4:c8:60:2c:7b"]
      },
    ]
  }
}
