#
# Terragrunt stack for deploying PVE node(s) wide configurations
unit "cloud-image-deb13" {
  source = "${get_repo_root()}/terraform/catalog/units/cloud-image"
  path   = "cloud-image-deb13"
  values = {
    proxmox_node_name = "pve1"
    cloud_image_url   = "https://cloud.debian.org/images/cloud/trixie/20260831-2587/debian-13-generic-amd64-20260831-2587.qcow2"
    datastore_id      = "synology"
  }
}
