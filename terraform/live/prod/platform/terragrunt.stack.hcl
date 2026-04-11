locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "loadbalancer" {
  source = "${get_repo_root()}/terraform/catalog/units/loadbalancer"
  path   = "loadbalancer"
  values = {
    metallb_namespace = "metallb-system"
    create_namespace  = true
    config_path       = local.common.locals.kubeconfig_path
    config_context    = local.common.locals.kubeconfig_context
  }
}

unit "csi-driver" {
  source = "${get_repo_root()}/terraform/catalog/units/csi-driver-nfs"
  path   = "csi-driver"
  values = {
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "nfs-storageclass" {
  source = "${get_repo_root()}/terraform/catalog/units/nfs-storageclass"
  path   = "nfs-storageclass"
  values = {
    class_name     = "nfs-client"
    server         = "10.10.50.38"
    share          = "/volume1/k3s-main"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "metallb-cr" {
  source = "${get_repo_root()}/terraform/catalog/units/metallb-cr"
  path   = "metallb-cr"
  values = {
    metallb_namespace      = "metallb-system"
    ipv4_address_pool_name = "default-pool"
    ipv4_address_pools     = ["10.10.50.95-10.10.50.97"]
    config_path            = local.common.locals.kubeconfig_path
    config_context         = local.common.locals.kubeconfig_context
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

# TODO: Chicken and egg stuff is going on here. Namespaces need to be pre-created
# before creating these resources, so namespace creation needs to be moved out of Flux and placed here :(
unit "bw_secret_apps" {
  source = "${get_repo_root()}/terraform/catalog/units/bw-k8s-secret"
  path   = "bw-k8s-secret"

  values = {
    kube_namespace = "apps"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "bw_secret_monitoring" {
  source = "${get_repo_root()}/terraform/catalog/units/bw-k8s-secret"
  path   = "bw-k8s-secret"

  values = {
    kube_namespace = "monitoring"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}
