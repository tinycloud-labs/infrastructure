resource "kubernetes_secret_v1" "this" {
  metadata {
    name        = var.secret_name
    namespace   = var.kube_namespace
    labels      = var.labels
    annotations = var.annotations
  }

  type = "Opaque"
  # make sure to encode the value via base64encode()
  data = var.secret_data
}
