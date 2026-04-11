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

variable "secret_name" {
  description = "K8s Secret resource name"
  type        = string
}

variable "kube_namespace" {
  description = "K8s namespace where the resource should be created"
  type        = string
}

variable "labels" {
  description = "Optional resource labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Optional resource annotations"
  type        = map(string)
  default     = {}
}

variable "secret_data" {
  description = "Content of the K8s secret as a key:value pair"
  type        = map(string)
  sensitive   = true
}

variable "type" {
  description = "Type of the K8s Secret. Default to Opauqe"
  type        = string
  default     = "Opaue"
}
