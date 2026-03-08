include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//generic-helm-release?ref=main"
}

inputs = {
  kube_namespace  = values.kube_namespace
  config_path     = values.config_path
  config_context  = values.config_context
  chart_version   = values.chart_version
  release_name    = values.release_name
  helm_repository = values.helm_repository
  chart           = values.chart
}
