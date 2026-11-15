#
# GitHub App credentials for Flux's GitRepository (provider: github).
# Key names follow the source-controller GitHub App secret format.
# Values are injected by the GitHub Action workflows as TF_VAR_github_app_*.
#
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
  secret_name    = values.secret_name
  kube_namespace = values.kube_namespace
  secret_data = {
    "githubAppID"             = trimspace(get_env("TF_VAR_github_app_id"))
    "githubAppInstallationID" = trimspace(get_env("TF_VAR_github_app_installation_id"))
    "githubAppPrivateKey"     = get_env("TF_VAR_github_app_private_key")
  }
  config_path    = values.config_path
  config_context = values.config_context
}

dependency "namespace" {
  config_path = values.namespace_dependency_path
  mock_outputs = {
    namespace_output = "mock-namespace-output"
  }
}
