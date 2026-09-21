module "cloud-image" {
  source            = "git::https://github.com/shakir85/terraform_modules.git//proxmox/cloud-img-download?ref=1.0.0"
  proxmox_node_name = var.node_name
  cloud_image_url   = var.cloud_image_url
  storage_pool      = var.datastore_id
}
