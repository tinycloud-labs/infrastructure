locals {
  # TODO: maybe some improvements here? an include + expose?
  # it could be less verbose to handle kube things like this:
  #     kube = {
  #     config_path    = local.common.locals.kubeconfig_path
  #     config_context = local.common.locals.kubeconfig_context
  #   }
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "nfs-storageclass" {
  source = "${get_repo_root()}/terraform/catalog/units/nfs-storageclass"
  path   = "nfs-storageclass"
  values = {
    class_name       = "nfs-client"
    is_default_class = true
    reclaim_policy   = "Retain"
    share            = "/volume1/k3s-main"
    config_path      = local.common.locals.kubeconfig_path
    config_context   = local.common.locals.kubeconfig_context
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
    path           = "clusters/prod"
  }
}

unit "namespace_apps" {
  source = "${get_repo_root()}/terraform/catalog/units/namespace"
  path   = "namespace-apps"

  values = {
    name           = "apps"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "namespace_monitoring" {
  source = "${get_repo_root()}/terraform/catalog/units/namespace"
  path   = "namespace-monitoring"

  values = {
    name           = "monitoring"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

# namespace scoped tokens
unit "bw_secret_apps" {
  source = "${get_repo_root()}/terraform/catalog/units/bw-k8s-secret"
  path   = "bw-secret-apps"

  values = {
    kube_namespace            = "apps"
    namespace_dependency_path = "../namespace-apps"
    config_path               = local.common.locals.kubeconfig_path
    config_context            = local.common.locals.kubeconfig_context
  }
}

unit "bw_secret_monitoring" {
  source = "${get_repo_root()}/terraform/catalog/units/bw-k8s-secret"
  path   = "bw-secret-monitoring"

  values = {
    kube_namespace            = "monitoring"
    namespace_dependency_path = "../namespace-monitoring"
    config_path               = local.common.locals.kubeconfig_path
    config_context            = local.common.locals.kubeconfig_context
  }
}
