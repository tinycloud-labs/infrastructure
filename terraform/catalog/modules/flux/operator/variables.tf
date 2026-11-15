# tflint-ignore: terraform_unused_declarations
variable "config_path" {
  description = "Path to cluster kube config file"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "config_context" {
  description = "The name of the kubeconfig context to use"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Namespace to install the Flux Operator into. Must already exist"
  type        = string
  default     = "flux-system"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "flux-operator"
}

variable "chart_version" {
  description = "flux-operator Helm chart version"
  type        = string
}

variable "values" {
  description = "Helm values for the flux-operator chart"
  type        = any
  default     = {}
}
