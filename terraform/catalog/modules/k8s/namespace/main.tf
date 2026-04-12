resource "kubernetes_namespace_v1" "this" {
  metadata {
    annotations = var.annotations

    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "terraform"
      },
      var.labels
    )

    name = var.name
  }
}
