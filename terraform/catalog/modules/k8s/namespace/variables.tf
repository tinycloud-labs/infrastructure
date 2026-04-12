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

variable "name" {
  description = "K8s namespace resource name"
  type        = string
}

variable "annotations" {
  description = "Resource annotations"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Resource labels"
  type        = map(string)
  default = {
    "app.kubernetes.io/managed-by" = "terraform"
  }
}
