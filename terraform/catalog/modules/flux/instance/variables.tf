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
  description = "Namespace for the FluxInstance and the Flux controllers. Must already exist"
  type        = string
  default     = "flux-system"
}

variable "release_name" {
  description = "Helm release name. The chart names the FluxInstance 'flux' regardless"
  type        = string
  default     = "flux"
}

variable "chart_version" {
  description = "flux-instance Helm chart version"
  type        = string
}

variable "flux_version" {
  description = "Flux distribution version or semver range, e.g. 2.10.x"
  type        = string
}

variable "components" {
  description = "Flux controllers to install"
  type        = list(string)
  default = [
    "source-controller",
    "kustomize-controller",
    "helm-controller",
    "notification-controller",
  ]
}

variable "cluster_domain" {
  description = "Kubernetes cluster DNS domain"
  type        = string
  default     = "cluster.local"
}

variable "network_policy" {
  description = "Install the Flux NetworkPolicies (allow-egress, allow-scraping, allow-webhooks)"
  type        = bool
  default     = true
}

variable "sync" {
  description = "Git source the FluxInstance syncs the cluster from"
  type = object({
    url         = string
    ref         = string
    path        = string
    interval    = optional(string, "1m")
    pull_secret = optional(string, "")
    provider    = optional(string, "")
  })
}
