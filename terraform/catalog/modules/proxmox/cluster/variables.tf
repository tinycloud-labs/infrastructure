# tflint-ignore: terraform_unused_declarations
# ------------------------
# -- Provider vars
# ------------------------
variable "pve_user" {
  type = string
}

variable "pve_pwd" {
  type = string
}

# ------------------------
# -- Module vars
# ------------------------
variable "timezone" {
  type    = string
  default = "America/Los_Angeles"
}

variable "id_rsa_pub" {
  type        = string
  description = "Path to a public key to be added to the VM's authorized_keys"
}

variable "cloud_image_info" {
  type        = list(string)
  description = "Hosted cloud image information; [<image_data_store>, <image_name>]"
}

variable "disk_name" {
  type        = string
  description = "VM backend data store ID/name"
}

variable "description" {
  type        = string
  description = "Description to set for the VM"
  default     = "Managed by Terraform"
}

variable "proxmox_node_name" {
  type        = string
  description = "Name of the Proxmox node to deploy the VM on"
}

variable "cluster" {
  type = list(object({
    name  = string
    size  = string
    count = number
    macs  = optional(list(string), [])
  }))
}

variable "mac_address" {
  type    = string
  default = null
}
