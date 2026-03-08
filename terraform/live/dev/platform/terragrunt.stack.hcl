locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "flux" {
  source = "${get_repo_root()}/terraform/catalog/units/flux"
  path   = "flux"
  values = {
    github_org        = "tinycloud-labs"
    github_repository = "flux"
    # github_token      = ""
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
    path           = "clusters/dev"
  }
}

unit "bw-secrets-manager" {
  source = "${get_repo_root()}/terraform/catalog/units/bw-secrets-manager"
  path   = "bw-secrets-manager"
  values = {
    config_path     = local.common.locals.kubeconfig_path
    config_context  = local.common.locals.kubeconfig_context
    kube_namespace  = "sm-operator-system"
    chart_version   = "2.0.1"
    release_name    = "sm-operator"
    helm_repository = "https://charts.bitwarden.com/"
    chart           = "sm-operator"
  }
}
