resource "kubernetes_storage_class_v1" "this" {
  metadata {
    name = var.class_name

    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "terraform"
      },
      var.labels
    )

    annotations = merge(
      var.annotations,
      {
        "storageclass.kubernetes.io/is-default-class" = tostring(var.is_default_class)
      }
    )
  }

  storage_provisioner = var.storage_provisioner
  parameters          = var.parameters

  reclaim_policy         = var.reclaim_policy
  volume_binding_mode    = var.volume_binding_mode
  allow_volume_expansion = var.allow_volume_expansion

  mount_options = var.mount_options
}
