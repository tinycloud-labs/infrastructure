#
# Flux Operator: installs the operator and its CRDs into an existing namespace.
# Flux itself is installed by the flux-instance unit.
#
include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/flux/operator"
}

inputs = {
  kubernetes_namespace = values.kube_namespace
  chart_version        = values.chart_version
  values               = try(values.helm_values, {})
  config_path          = values.config_path
  config_context       = values.config_context
}

dependency "namespace" {
  config_path = values.namespace_dependency_path
  mock_outputs = {
    namespace_output = "mock-namespace-output"
  }
}
