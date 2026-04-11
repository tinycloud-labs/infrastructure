include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/k8s/secrets"
}

inputs = {
  secret_name    = "bw-auth-token"
  kube_namespace = values.kube_namespace
  secret_data = {
    "token" = get_env("TF_VAR_bw_token")
  }
  config_path    = values.config_path
  config_context = values.config_context
}
