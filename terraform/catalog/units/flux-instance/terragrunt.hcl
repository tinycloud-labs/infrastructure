#
# FluxInstance: the operator installs Flux and starts syncing the cluster from
# the Flux repository. From here on Flux deploys everything else, so every unit
# that must exist before the first sync goes in values.dependency_paths.
#
# Git auth uses a GitHub App through a Secret created by the
# github-app-k8s-secret unit (values.sync.pull_secret).
#
include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/flux/instance"
}

inputs = {
  kubernetes_namespace = values.kube_namespace
  chart_version        = values.chart_version
  flux_version         = values.flux_version
  sync = {
    url         = "https://github.com/${values.github_org}/${values.github_repository}.git"
    ref         = "refs/heads/${values.branch}"
    path        = values.path
    pull_secret = values.pull_secret
    provider    = "github"
  }
  config_path    = values.config_path
  config_context = values.config_context
}

# Ordering-only dependencies (no outputs consumed): the operator (CRDs), the
# Git auth Secret, and the namespace-scoped BW secrets the apps rely on.
dependencies {
  paths = values.dependency_paths
}
