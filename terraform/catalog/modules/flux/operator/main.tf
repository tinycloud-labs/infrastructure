terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# Installs the Flux Operator and its CRDs (FluxInstance, FluxReport, ResourceSet...).
# It does not install Flux itself; that is done by a FluxInstance (see ../instance).
resource "helm_release" "this" {
  name             = var.release_name
  namespace        = var.kubernetes_namespace
  create_namespace = false

  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-operator"
  version    = var.chart_version

  values = [yamlencode(var.values)]
}
