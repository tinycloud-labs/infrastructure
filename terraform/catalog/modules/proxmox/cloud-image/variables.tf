# ------------------------
# -- Provider vars
# ------------------------
# tflint-ignore: terraform_unused_declarations
variable "pve_user" {
  type = string
}

# tflint-ignore: terraform_unused_declarations
variable "pve_pwd" {
  type = string
}

# ------------------------
# -- Module vars
# ------------------------
variable "node_name" {
  type        = string
  description = "Name of the Proxmox node to deploy the VM on"
}

variable "cloud_image_url" {
  type        = string
  description = "URL where the module will pull the image from"
}

variable "datastore_id" {
  type        = string
  description = "Datastore name on PVE where the image will be stored. Ensure it supports ISO Images type"
}
