terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# Creates the FluxInstance through the flux-instance chart rather than a
# kubernetes_manifest: the FluxInstance CRD comes from the operator release, and
# kubernetes_manifest needs the CRD to exist at plan time on a fresh cluster.
#
# The operator installs the Flux controllers and generates a GitRepository and a
# Kustomization (both named after the namespace, i.e. flux-system) that sync
# var.sync.path from var.sync.url.
resource "helm_release" "this" {
  name      = var.release_name
  namespace = var.kubernetes_namespace

  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-instance"
  version    = var.chart_version

  values = [yamlencode({
    instance = {
      distribution = {
        version  = var.flux_version
        registry = "ghcr.io/fluxcd"
      }
      components = var.components
      cluster = {
        type          = "kubernetes"
        domain        = var.cluster_domain
        networkPolicy = var.network_policy
      }
      sync = {
        kind       = "GitRepository"
        url        = var.sync.url
        ref        = var.sync.ref
        path       = var.sync.path
        interval   = var.sync.interval
        pullSecret = var.sync.pull_secret
        provider   = var.sync.provider
      }
    }
  })]
}
