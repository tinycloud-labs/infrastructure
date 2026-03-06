# tflint-ignore: terraform_unused_declarations
variable "config_path" {
  description = "Path to kubeconfig file relative to where this script will run"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "config_context" {
  description = "The name of the kubeconfig context to use"
  type        = string
}

variable "class_name" {
  description = "StorageClass resource name"
  type        = string
}

variable "server" {
  description = "NFS server IPv4"
  type        = string
}

variable "share" {
  description = "Name of the NFS share"
  type        = string
}
