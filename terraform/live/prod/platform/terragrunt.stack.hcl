#
# Terragrunt stack for deploying - prod common dependencies needed before
# Flux to connect and bootstrap operators/controllers with:
#   - storage class
#   - namespaces
#   - various configs
#
# Order of operations:
#   namespaces -> bw_secret_* (BW machine-account tokens)  --+
#   namespace_flux-system -> github_app_secret              --+--> flux_instance
#   namespace_flux-system -> flux_operator (CRDs)           --+
#
# flux_instance is last: once it exists, Flux syncs clusters/prod and deploys
# the BitwardenSecret CRs (which need the BW tokens) and then the apps.
#
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

unit "namespace_csi-proxmox" {
  source = "${get_repo_root()}/terraform/catalog/units/namespace"
  path   = "namespace-csi-proxmox"

  values = {
    name           = "csi-proxmox"
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

unit "bw_secret_csi-proxmox" {
  source = "${get_repo_root()}/terraform/catalog/units/bw-k8s-secret"
  path   = "bw-secret-csi-proxmox"

  values = {
    kube_namespace            = "csi-proxmox"
    namespace_dependency_path = "../namespace-csi-proxmox"
    config_path               = local.common.locals.kubeconfig_path
    config_context            = local.common.locals.kubeconfig_context
  }
}

#
# Flux, via the Flux Operator
#
unit "namespace_flux-system" {
  source = "${get_repo_root()}/terraform/catalog/units/namespace"
  path   = "namespace-flux-system"

  values = {
    name           = "flux-system"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "github_app_secret" {
  source = "${get_repo_root()}/terraform/catalog/units/github-app-k8s-secret"
  path   = "github-app-secret"

  values = {
    secret_name               = "flux-system"
    kube_namespace            = "flux-system"
    namespace_dependency_path = "../namespace-flux-system"
    config_path               = local.common.locals.kubeconfig_path
    config_context            = local.common.locals.kubeconfig_context
  }
}

unit "flux_operator" {
  source = "${get_repo_root()}/terraform/catalog/units/flux-operator"
  path   = "flux-operator"

  values = {
    kube_namespace            = "flux-system"
    chart_version             = "0.62.1"
    namespace_dependency_path = "../namespace-flux-system"
    config_path               = local.common.locals.kubeconfig_path
    config_context            = local.common.locals.kubeconfig_context
  }
}

unit "flux_instance" {
  source = "${get_repo_root()}/terraform/catalog/units/flux-instance"
  path   = "flux-instance"

  values = {
    kube_namespace = "flux-system"
    chart_version  = "0.62.1"
    # renovate: datasource=github-releases depName=fluxcd/flux2
    flux_version      = "2.10.x"
    github_org        = "tinycloud-labs"
    github_repository = "flux"
    branch            = "main"
    path              = "clusters/prod"
    pull_secret       = "flux-system"
    config_path       = local.common.locals.kubeconfig_path
    config_context    = local.common.locals.kubeconfig_context

    # Flux must not start syncing until the operator (CRDs), its Git auth
    # Secret, and every BW token Secret exist. Each BW secret already waits on
    # its namespace, so listing the secrets covers the namespaces too.
    dependency_paths = [
      "../flux-operator",
      "../github-app-secret",
      "../bw-secret-apps",
      "../bw-secret-monitoring",
      "../bw-secret-csi-proxmox",
    ]
  }
}
