locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "nfs-storageclass" {
  source = "${get_repo_root()}/terraform/catalog/units/nfs-storageclass"
  path   = "nfs-storageclass"
  values = {
    class_name     = "nfs-client"
    server         = "10.10.50.38"
    share          = "/volume1/k3s-dev"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
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
