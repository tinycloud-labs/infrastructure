include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//external-secrets?ref=main"
}

# uses the module's default value for the kube-namespace (= external-secrets)
inputs = {
  config_path    = values.config_path
  config_context = values.config_context
}
